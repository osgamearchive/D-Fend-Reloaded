unit DosBoxUnit;
interface

uses Classes, GameDBUnit;

Procedure RunGame(const Game : TGame; const RunSetup : Boolean = False; const DosBoxCommandLine : String ='');
Procedure RunExtraFile(const Game : TGame; const ExtraFile : Integer);
Procedure RunCommand(const Game : TGame; const Command : String; const DisableFullscreen : Boolean = False);
Procedure RunWithCommandline(const Game : TGame; const CommandLine : String; const DisableFullscreen : Boolean = False);

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer = -1) : TStringList;
Function BuildAutoexec(const Game : TGame; const RunSetup : Boolean; const St : TStringList; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const WarnIfWindowsExe : Boolean) : Boolean;

Function IsWindowsExe(const FileName : String) : Boolean;
Function IsDOSExe(const FileName : String) : Boolean;

var MinimizedAtDOSBoxStart : Boolean = False;

Function ShortName(const LongName : String) : String;
Function LongPath(const ShortPath : String) : String; overload;
Function LongPath(const Root, ShortPath : String) : String; overload;

implementation

uses Windows, SysUtils, ShellAPI, Forms, Dialogs, Math,
     CommonTools, PrgSetupUnit, PrgConsts, LanguageSetupUnit, GameDBToolsUnit,
     ZipManagerUnit, ScreensaverControlUnit, FullscreenInfoFormUnit,
     DOSBoxCountUnit, DOSBoxShortNameUnit, RunPrgManagerUnit;

Function BoolToStr(const B : Boolean) : String;
begin
  If B then result:='true' else result:='false';
end;

Function ShortName(const LongName : String) : String;
begin
  If PrgSetup.UseShortFolderNames then begin
    SetLength(result,MAX_PATH+10);
    if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
      then result:=LongName
      else SetLength(result,StrLen(PChar(result)));
  end else begin
    result:=LongName;
  end;
end;

Function LongPath(const ShortPath : String) : String;
Var S,T : String;
    I : Integer;
begin
  result:=Copy(ShortPath,1,3);
  S:=ExcludeTrailingPathDelimiter(Copy(ShortPath,4,MaxInt));
  while S<>'' do begin
    I:=Pos('\',S);
    If I=0 then begin T:=S; S:=''; end else begin T:=Copy(S,1,I-1); S:=Copy(S,I+1,MaxInt); end;
    result:=result+LongPath(result,T)+'\';
  end;
end;

Function LongPath(const Root, ShortPath : String) : String;
Var Rec : TSearchRec;
    I : Integer;
    LongRoot, ShortRoot : String;
begin
  LongRoot:=IncludeTrailingPathDelimiter(Root);
  ShortRoot:=ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(LongRoot)));

  result:=ShortPath;

  I:=FindFirst(LongRoot+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      I:=FindNext(Rec);
      If ExtUpperCase(ShortName(LongRoot+Rec.Name))=ShortRoot+ExtUpperCase(ShortPath) then begin
        result:=Rec.Name; exit;
      end;
    end;
  finally
    FindClose(Rec);
  end;
end;

Function AllSameDir(const St : TStringList) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  If St.Count<2 then exit; {No benefit if less than 2 files to mount}
  S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(St[0]))));
  For I:=1 to St.Count-1 do if S<>Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ExtractFilePath(St[I])))) then exit;
  result:=True;
end;

Function MakeDOSBoxPath(Part, Root : String) : String;
Var S : String;
    I : Integer;
begin
  Root:=IncludeTrailingPathDelimiter(Root);
  result:='';
  Part:=ExcludeTrailingPathDelimiter(Part);
  If (Part<>'') and (Part[1]='\') then Part:=Copy(Part,2,MaxInt);

  while Part<>'' do begin
    I:=Pos('\',Part);
    If I=0 then begin S:=Part; Part:=''; end else begin S:=Copy(Part,1,I-1); Part:=Copy(Part,I+1,MaxInt); end;
    S:=LongPath(Root,S);
    result:=result+'\'+DOSBoxShortName(Root,S);
    Root:=Root+S+'\';
  end;

  If result='' then result:='\';
end;

Function SpecialMultiImgMount(const DriveLetter : String; const Imgs : TStringList; const FreeDriveLetters : String; const MountCommandAdd : String) : String;
Var I : Integer;
    TempDrive : Char;
    Path,S : String;
begin
  TempDrive:='Y';
  For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
  {There must be free drive letters, because there are only 10 mounts}

  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])));

  S:='"'+TempDrive+':\'+DOSBoxShortName(ExtractFilePath(Imgs[0]),ExtractFileName(Imgs[0]))+'"';
  For I:=1 to Imgs.Count-1 do S:=S+' "'+TempDrive+':\'+DOSBoxShortName(ExtractFilePath(Imgs[I]),ExtractFileName(Imgs[I]))+'"';

  result:=
    'mount '+TempDrive+' "'+UnmapDrive(Path,ptMount)+'"'+#13+
    'imgmount '+DriveLetter+' '+S+' '+MountCommandAdd+#13+
    'mount -u '+TempDrive;
end;


Function BuildMountData(const ProfString : String; var FreeDriveLetters : String) : String;
Procedure MarkDriveUsed(S : String);
begin
  S:=Trim(ExtUpperCase(S)); If length(S)<>1 then exit;
  If (S[1]<'A') or (S[1]>'Z') then exit;
  FreeDriveLetters[Ord(S[1])-Ord('A')+1]:='-';
end;
Var St,St2 : TStringList;
    S,T,U : String;
    I : Integer;
begin
  result:='';

  St:=ValueToList(ProfString);
  St2:=TStringList.Create;
  try
    S:=Trim(St[0]);
    I:=Pos('$',S);
    While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
    St2.Add(S);
    For I:=0 to St2.Count-1 do St2[I]:=MakeAbsPath(St2[I],PrgSetup.BaseDir);
    S:=St2[0];

    {general: RealFolder;Type;Letter;IO;Label;FreeSpace}
    If St.Count<3 then exit;
    If St.Count=3 then St.Add('false');
    If St.Count=4 then St.Add('');
    If St.Count=5 then St.Add('');

    T:=Trim(ExtUpperCase(St[1]));

    If T='DRIVE' then begin
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      MarkDriveUsed(St[2]);
      result:='mount '+St[2]+' "'+UnmapDrive(ShortName(S),ptMount)+'"';
      If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
    end;

    If T='FLOPPY' then begin
      {RealFolder;FLOPPY;Letter;False;;}
      MarkDriveUsed(St[2]);
      result:='mount '+St[2]+' "'+UnmapDrive(ShortName(S),ptMount)+'" -t floppy';
    end;

    If T='CDROM' then begin
      {RealFolder;CDROM;Letter;IO;Label;}
      MarkDriveUsed(St[2]);
      result:='mount '+St[2]+' "'+UnmapDrive(ShortName(S),ptMount)+'" -t cdrom';
      If Trim(UpperCase(St[3]))='TRUE' then result:=result+' -IOCTL';
      If Trim(UpperCase(St[3]))='NOIOCTL' then result:=result+' -NOIOCTL';
      If St[4]<>'' then result:=result+' -label '+St[4];
    end;

    If T='FLOPPYIMAGE' then begin
      {ImageFile;FLOPPYIMAGE;Letter;;;}
      If (Trim(St[2])='0') or (Trim(St[2])='1') then U:='none' else U:='fat';
      MarkDriveUsed(St[2]);
      If AllSameDir(St2) then begin
        result:=SpecialMultiImgMount(St[2],St2,FreeDriveLetters,'-t floppy -fs '+U);
      end else begin
        S:='"'+ShortName(St2[0])+'"'; For I:=1 to St2.Count-1 do S:=S+' "'+ShortName(St2[I])+'"';
        result:='imgmount '+St[2]+' '+S+' -t floppy -fs '+U;
      end;
    end;

    If T='CDROMIMAGE' then begin
      {ImageFile;CDROMIMAGE;Letter;;;}
      MarkDriveUsed(St[2]);
      If AllSameDir(St2) then begin
        result:=SpecialMultiImgMount(St[2],St2,FreeDriveLetters,'-t iso -fs iso');
      end else begin
        S:='"'+ShortName(St2[0])+'"'; For I:=1 to St2.Count-1 do S:=S+' "'+ShortName(St2[I])+'"';
        result:='imgmount '+St[2]+' '+S+' -t iso -fs iso';
      end;
    end;

    If T='IMAGE' then begin
      {ImageFile;IMAGE;LetterOR23;;;geometry}
      If St.Count>=6 then begin
        If (Trim(St[2])='2') or (Trim(St[2])='3') then U:='none' else U:='fat';
        MarkDriveUsed(St[2]);
        result:='imgmount '+St[2]+' "'+ShortName(S)+'" -t hdd -fs '+U+' -size '+St[5];
      end;
    end;

    If T='PHYSFS' then begin
      {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace}
      If St2.Count=2 then begin
        MarkDriveUsed(St[2]);
        CreateDir(MakeAbsPath(St2[0],PrgSetup.BaseDir));
        result:='mount '+St[2]+' "'+UnmapDrive(ShortName(St2[0]),ptMount)+':'+UnmapDrive(ShortName(St2[1]),ptMount)+':/"';
        If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
      end;
    end;

    If T='ZIP' then begin
      {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
      If St2.Count=2 then begin
        MarkDriveUsed(St[2]);
        result:='mount '+St[2]+' "'+UnmapDrive(ShortName(St2[0]),ptMount)+'"';
        If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
      end;
    end;

  finally
    St.Free;
    St2.Free;
  end;
end;

Procedure TempMountFreeDOSDir(const Game : TGame; FreeDriveLetters : String; var UseDir, Mount, UnMount : String);
Var FreeDOSPath : String;
    I : Integer;
    St : TStringList;
    S : String;
    TempDrive : Char;
begin
  UseDir:=''; Mount:=''; UnMount:='';

  FreeDOSPath:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir));
  If not DirectoryExists(FreeDOSPath) then exit;

  UseDir:='';
  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));
      If ExtUpperCase(Copy(FreeDOSPath,1,length(S)))=ExtUpperCase(S) then begin
        UseDir:=St[2]+':\'+Copy(FreeDOSPath,length(S)+1,MaxInt);
        break;
      end;
    finally
      St.Free;
    end;
  end;
  If UseDir='' then begin
    TempDrive:='Y';
    For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
    {There must be free drive letters, because there are only 10 mounts}

    Mount:='mount '+TempDrive+': "'+UnmapDrive(ShortName(FreeDOSPath),ptMount)+'"';
    UseDir:=''+TempDrive+':\';
    Unmount:='mount -u '+TempDrive;
  end;
end;

Function MakePathShort(const S : String) : String;
Var Temp : String;
begin
  SetLength(Temp,MAX_PATH+10);
  If GetShortPathName(PChar(S),PChar(Temp),MAX_PATH)<>0 then begin
    SetLength(Temp,StrLen(PChar(Temp))); result:=Trim(ExtUpperCase(Temp));
  end else begin
    result:=S;
  end;
end;

Procedure BuildLocalRunCommands(const St : TStringList; const ProgramFile, ProgramParameters : String; const UseLoadFix : Boolean; const LoadFixMemory : Integer; const Use4DOS, UseDOS32A : Boolean; const Game : TGame; const FreeDriveLetters : String; const WarnIfNotReachable : Boolean);
Var T : String;
begin
  T:=MakePathShort(Trim(ExtractFilePath(ProgramFile)));

  If (length(T)>=2) and (T[2]=':') then begin
    St.Add(Copy(T,1,2));
    St.Add('cd\');
    T:=Trim(Copy(T,3,MaxInt));
  end;

  If T<>'' then begin
    If T[1]<>'\' then T:='\'+T;
    St.Add('cd '+T);
  end;
end;

Function MountQBasic(const Autoexec : TStringList; const Game : TGame; const FreeDriveLetters : String; var QBasicPathAndFile : String) : Boolean;
Var QBFile,S,T,Path,Drive : String;
    I : Integer;
    St : TStringList;
begin
  result:=False;
  QBasicPathAndFile:='QBasic.exe';

  QBFile:=Trim(PrgSetup.QBasic);
  If (QBFile='') or (not FileExists(QBFile)) then exit;

  T:=MakePathShort(Trim(ExtractFilePath(QBFile)));
  Path:=''; Drive:='';
  For I:=0 to Game.NrOfMounts-1 do begin
    St:=ValueToList(Game.Mount[I]);
    try
      If St.Count=3 then St.Add('false');
      If St.Count=4 then St.Add('');
      If St.Count<5 then continue;
      If (Trim(ExtUpperCase(St[1]))<>'DRIVE') and (Trim(ExtUpperCase(St[1]))<>'CDROM') and (Trim(ExtUpperCase(St[1]))<>'FLOPPY') then continue;
      S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St[0]),PrgSetup.BaseDir));

      If Copy(T,1,length(S))=S then begin
        S:=Copy(T,length(S)+1,MaxInt);
        If (Drive='') or (length(S)<length(Path)) then begin Path:=S; Drive:=St[2]+':'; end;
      end;
    finally
      St.Free;
    end;
  end;
  If Drive='' then begin
    For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin
      Autoexec.Add('mount '+FreeDriveLetters[I]+' '+UnmapDrive(ExtractFilePath(T),ptMount));
      QBasicPathAndFile:=FreeDriveLetters[I]+':\'+ExtractFileName(QBFile);
      break;
    end;
  end else begin
    If (Path<>'') and (Path[1]='\') then Path:=Copy(Path,2,MaxInt);
    QBasicPathAndFile:=IncludeTrailingPathDelimiter(Drive+'\'+Path)+ExtractFileName(QBFile);
  end;

  result:=True;
end;

Function BuildRunCommands(const St : TStringList; const ProgramFile, ProgramParameters : String; const UseLoadFix : Boolean; const LoadFixMemory : Integer; const Use4DOS, UseDOS32A : Boolean; const Game : TGame; const FreeDriveLetters : String; const WarnIfNotReachable, WarnIfWindowsExe : Boolean) : Boolean;
Var Prefix,S,T,UsePath,Mount,Unmount : String;
    I : Integer;
    St2 : TStringList;
    NoFreeDOS : Boolean;
    TempDrive : Char;
    Path, Drive, RootPath : String;
begin
  result:=True;

  {Find path to FreeDOS and mount it if needed}
  TempMountFreeDOSDir(Game,FreeDriveLetters,UsePath,Mount,Unmount);
  NoFreeDOS:=(UsePath='');
  If Use4DOS or UseDOS32A then begin
    If Mount<>'' then St.Add(Mount);
  end;

  S:=Trim(ExtUpperCase(ProgramFile));
  If (Copy(S,1,7)='DOSBOX:') and (length(S)>7) then begin
    {No path to file needed, because file is in image etc. and given path is local to DOSBox directory structure}
    BuildLocalRunCommands(St,Trim(Copy(Trim(ProgramFile),8,MaxInt)),ProgramParameters,UseLoadFix,LoadFixMemory,Use4DOS,UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable);
  end else begin
    {Find path to file}
    If (Trim(ProgramFile)<>'') and (not FileExists(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))) and WarnIfNotReachable then begin
      Application.Restore;
      MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[MakeAbsPath(ProgramFile,PrgSetup.BaseDir)]),mtError,[mbOK],0);
    end;

    If IsWindowsExe(MakeAbsPath(ProgramFile,PrgSetup.BaseDir)) and WarnIfNotReachable and WarnIfWindowsExe then begin
      Application.Restore;
      MessageDlg(Format(LanguageSetup.MessageWindowsExeExecuteWarning,[MakeAbsPath(ProgramFile,PrgSetup.BaseDir)]),mtError,[mbOK],0);
    end;

    T:=MakePathShort(Trim(ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))));

    If (Trim(ProgramFile)<>'') and (T<>'') then begin
      Path:=''; Drive:=''; RootPath:='';
      For I:=0 to Game.NrOfMounts-1 do begin
        St2:=ValueToList(Game.Mount[I]);
        try
          If St2.Count=3 then St2.Add('false');
          If St2.Count=4 then St2.Add('');
          If St2.Count<5 then continue;
          If (Trim(ExtUpperCase(St2[1]))<>'DRIVE') and (Trim(ExtUpperCase(St2[1]))<>'CDROM') and (Trim(ExtUpperCase(St2[1]))<>'FLOPPY') then continue;
          S:=MakePathShort(MakeAbsPath(IncludeTrailingPathDelimiter(St2[0]),PrgSetup.BaseDir));

          If Copy(T,1,length(S))=S then begin
            RootPath:=LongPath(S);
            S:=Copy(T,length(S)+1,MaxInt);
            If (Drive='') or (length(S)<length(Path)) then begin Path:=S; Drive:=St2[2]+':'; end;
          end;
        finally
          St2.Free;
        end;
      end;
      If Drive<>'' then begin
        St.Add(Drive);
        St.Add('cd\');
        S:=Path;
        If S<>'' then begin
          If S[1]<>'\' then S:='\'+S;
          S:=MakeDOSBoxPath(S,RootPath);
          St.Add('cd '+S);
        end;
      end else begin
        St.Add('Rem !!! The program file is not reachable via any mounted drive. !!!');
        St.Add('Rem !!! Trying to interpret the path to the file as a DOSBox relative path. !!!');
        BuildLocalRunCommands(St,Trim(ProgramFile),ProgramParameters,UseLoadFix,LoadFixMemory,Use4DOS,UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable);
        If WarnIfNotReachable then begin
          Application.Restore;
          MessageDlg(Format(LanguageSetup.MessageNoMountToReachFolder,[ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))]),mtError,[mbOK],0);
          result:=False;
        end;
      end;
    end;
  end;

  If UseLoadFix then Prefix:='loadfix -'+IntToStr(LoadFixMemory)+' ' else Prefix:='';

  If ExtUpperCase(ExtractFileExt(ProgramFile))='.BAS' then begin
    {Run via QBasic}
    if not MountQBasic(St,Game,FreeDriveLetters,S) then begin
      If WarnIfNotReachable then
        Application.Restore;
        MessageDlg(Format(LanguageSetup.MessageQBasicNeededToExecuteFile,[ExtractFileName(ProgramFile)]),mtError,[mbOK],0);
    end;
    T:=Trim(PrgSetup.QBasicParam); If T='' then T:='/run %s';
    try T:=Format(T,[ExtractFileName(ProgramFile)]); except T:=Format('/run %s',[ExtractFileName(ProgramFile)]); end;
    T:=S+' '+T;
  end else begin
    If (not UseLoadFix) and (not Use4DOS) and (not UseDOS32A) and (Trim(ExtUpperCase(ExtractFileExt(ProgramFile)))='.BAT') then Prefix:='call ';

    If (T<>'') and (Trim(ProgramParameters)<>'') then T:=' '+ProgramParameters else T:='';
    S:=MakeDOSBoxPath(ExtractFileName(ProgramFile),ExtractFilePath(ProgramFile));
    If (S<>'') and (S[1]='\') then S:=Copy(S,2,MaxInt);
    T:=S+T;

    If UseDOS32A and (not NoFreeDOS) then begin
      St.Add(UsePath+'DOS32A.EXE '+T);
      exit;
    end;

    If Use4DOS and (not NoFreeDOS) then begin
      If T<>'' then T:=' /C '+T;
      St.Add(UsePath+'4DOS.COM'+T);
      exit;
    end;
  end;

  St.Add(Prefix+T);
end;

Procedure MultiLineAdd(const St : TStringList; NewLines : String);
Var I : Integer;
begin
  I:=Pos(#13,NewLines);
  while I<>0 do begin
    St.Add(Copy(NewLines,1,I-1)); NewLines:=Copy(NewLines,I+1,MaxInt);
    I:=Pos(#13,NewLines);
  end;
  St.Add(NewLines);
end;

Procedure BuildFloppyBoot(const Autoexec : TStringList; Images : String; const FreeDriveLetters : String);
Var Imgs : TStringList;
    I : Integer;
    TempDrive : Char;
    Path,S : String;
begin
  Imgs:=TStringList.Create;
  try
    I:=Pos('$',Images);
    While I<>0 do begin Imgs.Add(MakeAbsPath(Copy(Images,1,I-1),PrgSetup.BaseDir)); Images:=Copy(Images,I+1,MaxInt); I:=Pos('$',Images); end;
    Imgs.Add(MakeAbsPath(Images,PrgSetup.BaseDir));

    If AllSameDir(Imgs) then begin
      TempDrive:='Y';
      For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
      {There must be free drive letters, because there are only 10 mounts}

      Path:=IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])));

      S:='"'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[0]))+'"';
      For I:=1 to Imgs.Count-1 do S:=S+' "'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[I]))+'"';

      Autoexec.Add('mount '+TempDrive+' "'+UnmapDrive(Path,ptMount)+'"');
      Autoexec.Add('boot '+S);
    end else begin

      S:='"'+IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])))+ExtractFileName(ShortName(Imgs[0]))+'"';
      For I:=1 to Imgs.Count-1 do S:=S+' "'+IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[I])))+ExtractFileName(ShortName(Imgs[I]))+'"';
      Autoexec.Add('boot '+S);
    end;
  finally
    Imgs.Free;
  end;
end;

Procedure AutoMountCDs(const St : TStringList; const Game : TGame; var FreeDriveLetters : String);
Var AlreadyMounted,S : String;
    I : Integer;
    C,D : Char;
    St2 : TStringList;
    lpSectorsPerCluster,lpBytesPerSector,lpNumberOfFreeClusters,lpTotalNumberOfClusters : Cardinal;
begin
  {Check which CD drives are mounted regularly}
  AlreadyMounted:='';
  For I:=0 to Game.NrOfMounts do begin
    S:=Game.Mount[I];
    St2:=ValueToList(S);
    try
      If St2.Count<2 then continue;
      If Trim(ExtUpperCase(St2[1]))<>'CDROM' then continue;
      S:=Trim(ExtUpperCase(St2[0]));
      If S='' then continue;
      If (S[1]<'A') or (S[1]>'Z') then continue;
      If length(S)>3 then continue;
      If (length(S)>=2) and (S[2]<>':') then continue;
      If (length(S)>=3) and (S[2]<>'\') then continue;
      AlreadyMounted:=AlreadyMounted+S[1];
    finally
      St2.Free;
    end;
  end;

  {Find CDs and autmount them}
  For C:='C' to 'Z' do begin
    If GetDriveType(PChar(C+':\'))<>DRIVE_CDROM then continue;
    If Pos(C,AlreadyMounted)<>0 then continue;
    if not GetDiskFreeSpace(PChar(C+':\'),lpSectorsPerCluster,lpBytesPerSector,lpNumberOfFreeClusters,lpTotalNumberOfClusters) then continue;
    If lpTotalNumberOfClusters=0 then continue;
    If Pos(C,FreeDriveLetters)>0 then S:=C else begin
      S:='';
      For D:=Chr(ord(C)+1) to 'Y' do If Pos(D,FreeDriveLetters)>0 then begin S:=D; break; end;
      If S='' then For D:='A' to Chr(ord(C)-1) do If Pos(D,FreeDriveLetters)>0 then begin S:=D; break; end;
    end;
    S:=C+':\;CDROM;'+S+';TRUE;;';
    St.Add(BuildMountData(S,FreeDriveLetters));
  end;
end;

Function BuildAutoexec(const Game : TGame; const RunSetup : Boolean; const St : TStringList; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer; const WarnIfWindowsExe : Boolean) : Boolean;
  Procedure SetVolume(const Channel : String; const Left,Right : Integer);
  begin If (Left<>100) or (Right<>100) then St.Add('mixer '+Channel+' '+IntToStr(Left)+':'+IntToStr(Right)+' /NOSHOW'); end;
Var S,T,NumCommands,MouseCommands,UsePath,Mount,UnMount : String;
    I : Integer;
    FreeDriveLetters : String;
    St2 : TStringList;
begin
  result:=True;

  St.Add('');
  St.Add('[autoexec]');
  St.Add('@echo off');

  { Environment variables }

  St2:=StringToStringList(Game.Environment);
  try
    For I:=0 to St2.Count-1 do If Trim(St2[I])<>'' then St.Add('SET '+St2[I]);
  finally
    St2.Free;
  end;

  { Keyboard layout }

  T:=Trim(ExtUpperCase(Game.KeyboardLayout));
  If (T='') or (T='DEFAULT') then T:=LanguageSetup.GameKeyboardLayoutDefault;
  If Pos('(',T)>0 then begin
    S:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then T:=S; end;
  end;

  S:=Trim(ExtUpperCase(Game.Codepage));
  If (S='') or (S='DEFAULT') then S:=LanguageSetup.GameKeyboardCodepageDefault;

  St.Add('keyb '+T+' '+S+' > nul');

  { Reported DOS version }

  S:=Trim(ExtUpperCase(Game.ReportedDOSVersion));
  If (S<>'') and (S<>'DEFAULT') and (S<>'AUTO') then begin
    If Pos('.',S)<>0 then begin T:=Trim(Copy(S,Pos('.',S)+1,MaxInt)); S:=Trim(Copy(S,1,Pos('.',S)-1)); end else begin T:=''; end;
    St.Add('ver set '+S+' '+T);
  end;

  { Mixer }

  SetVolume('MASTER',Game.MixerVolumeMasterLeft,Game.MixerVolumeMasterRight);
  SetVolume('DISNEY',Game.MixerVolumeDisneyLeft,Game.MixerVolumeDisneyRight);
  SetVolume('SPKR',Game.MixerVolumeSpeakerLeft,Game.MixerVolumeSpeakerRight);
  SetVolume('GUS',Game.MixerVolumeGUSLeft,Game.MixerVolumeGUSRight);
  SetVolume('SB',Game.MixerVolumeSBLeft,Game.MixerVolumeSBRight);
  SetVolume('FM',Game.MixerVolumeFMLeft,Game.MixerVolumeFMRight);

  { Text mode lines }

  If Game.TextModeLines=28 then St.Add('Z:\28.COM');
  If Game.TextModeLines=50 then St.Add('Z:\50.COM');

  { IPX connect }

  S:=Trim(ExtUpperCase(Game.IPXType));
  If S='CLIENT' then St.Add('IPXNET CONNECT '+Game.IPXAddress+' '+Game.IPXPort);
  If S='SERVER' then St.Add('IPXNET STARTSERVER '+Game.IPXPort);

  { Mounting }

  FreeDriveLetters:='---DEFGHIJKLMNOPQRSTUVWXY-';
  if not Game.AutoexecOverrideMount then begin
    For I:=0 to 9 do
      If Game.NrOfMounts>=I+1 then MultiLineAdd(St,BuildMountData(Game.Mount[I],FreeDriveLetters)) else break;
    If Game.AutoMountCDs then AutoMountCDs(St,Game,FreeDriveLetters);
  end;

  { Setting num, caps and scroll lock and CuteMouse }

  NumCommands:='';
  S:=Trim(ExtUpperCase(Game.NumLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then NumCommands:='/N1';
  If (S='OFF') or (S='0') or (S='FALSE') then NumCommands:='/N0';
  S:=Trim(ExtUpperCase(Game.CapsLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/C1'; end;
  If (S='OFF') or (S='0') or (S='FALSE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/C0'; end;
  S:=Trim(ExtUpperCase(Game.ScrollLockStatus));
  If (S='ON') or (S='1') or (S='TRUE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/S1'; end;
  If (S='OFF') or (S='0') or (S='FALSE') then begin If NumCommands<>'' then NumCommands:=NumCommands+' '; NumCommands:=NumCommands+'/S0'; end;

  MouseCommands:='';
  If Game.Force2ButtonMouseMode then MouseCommands:='/Y';
  If Game.SwapMouseButtons then begin If MouseCommands<>'' then MouseCommands:=MouseCommands+' '; MouseCommands:=MouseCommands+'/L'; end;

  TempMountFreeDOSDir(Game,FreeDriveLetters,UsePath,Mount,UnMount);

  If ((NumCommands<>'') or (MouseCommands<>'')) and (UsePath<>'') then begin
    If Mount<>'' then St.Add(Mount);
    If NumCommands<>'' then St.Add(UsePath+'4dos.com /C Keybd '+NumCommands);
    If MouseCommands<>'' then St.Add(UsePath+'ctmouse '+MouseCommands);
    If UnMount<>'' then St.Add(UnMount);
  end;

  { User defined Autoexec }

  St2:=StringToStringList(Game.Autoexec);
  try St.AddStrings(St2); finally St2.Free; end;

  { Run command }

  S:=Trim(Game.AutoexecBootImage);
  If S<>'' then begin
    If (S='2') or (S='3') then begin
      If S='2' then St.Add('boot -l C') else St.Add('boot -l D');
    end else begin
      BuildFloppyBoot(St,S,FreeDriveLetters);
    end;
  end else begin
    If not Game.AutoexecOverridegamestart then begin
      If RunExtraFile>=0 then begin
        S:=Trim(Game.ExtraPrgFile[RunExtraFile]);
        I:=Pos(';',S);
        If (S='') or (I=0) then begin
          result:=BuildRunCommands(St,Game.GameExe,Game.GameParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,Game.UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end else begin
          S:=Copy(S,I+1,MaxInt);
          result:=BuildRunCommands(St,S,'',Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,False,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end;
      end else begin
        If RunSetup then begin
          result:=BuildRunCommands(St,Game.SetupExe,Game.SetupParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,False,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end else begin
          result:=BuildRunCommands(St,Game.GameExe,Game.GameParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,Game.UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable,WarnIfWindowsExe);
        end;
      end;
    end;
  end;

  { User defined Finalization }

  St2:=StringToStringList(Game.AutoexecFinalization);
  try St.AddStrings(St2); finally St2.Free; end;

  { Conditionally close DOSBox }

  If (S='') and (not Game.AutoexecOverridegamestart) and Game.CloseDosBoxAfterGameExit then begin
    If RunExtraFile>=0 then begin
      St.Add('exit');
    end else begin
      If RunSetup then begin
        If Trim(Game.SetupExe)<>'' then St.Add('exit');
      end else begin
        If Trim(Game.GameExe)<>'' then St.Add('exit');
      end;
    end;
  end;
end;

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean; const RunExtraFile : Integer) : TStringList;
Var St : TStringList;
    S,T : String;
    DOSBoxNr : Integer;
begin
  DOSBoxNr:=Max(0,GetDOSBoxNr(Game));

  result:=TStringList.Create;

  result.Add('[sdl]');
  result.Add('fullscreen='+BoolToStr(Game.StartFullscreen));
  result.Add('fulldouble='+BoolToStr(Game.UseDoublebuffering));
  result.Add('fullresolution='+Game.FullscreenResolution);
  result.Add('windowresolution='+Game.WindowResolution);
  result.Add('output='+Game.Render);
  result.Add('autolock='+BoolToStr(Game.AutoLockMouse));
  result.Add('sensitivity='+IntToStr(Game.MouseSensitivity));
  result.Add('waitonerror='+BoolToStr(PrgSetup.DOSBoxSettings[DOSBoxNr].WaitOnError));
  result.Add('usecancodes='+BoolToStr(Game.UseScanCodes));
  result.Add('priority='+Game.Priority);
  S:=Trim(Game.CustomKeyMappingFile);
  If (S='') or (ExtUpperCase(S)='DEFAULT') then S:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxMapperFile;
  result.Add('mapperfile='+UnmapDrive(MakeAbsPath(S,PrgDataDir),ptMapper));

  result.Add('');
  result.Add('[dosbox]');
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxLanguage));
  If S<>'ENGLISH' then begin
    If (S='') or (S='DEFAULT') then S:='' else begin
      T:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
      If (T='') or (T='DEFAULT') then T:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir;
      If FileExists(IncludeTrailingPathDelimiter(T)+S) then S:=IncludeTrailingPathDelimiter(T)+S else begin
        If not FileExists(S) then S:='';
      end;
    end;
    If S='' then S:=PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxLanguage;
    If FileExists(S) then result.Add('language='+UnmapDrive(S,ptDOSBox));
  end;
  result.Add('machine='+Game.VideoCard);
  result.Add('captures='+UnmapDrive(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir),ptScreenshot));
  result.Add('memsize='+IntToStr(Game.Memory));

  result.Add('');
  result.Add('[render]');
  result.Add('frameskip='+IntToStr(Game.FrameSkip));
  result.Add('aspect='+BoolToStr(Game.AspectCorrection));
  result.Add('scaler='+Game.Scale);

  If PrgSetup.AllowVGAChipsetSettings then begin
    result.Add('');
    result.Add('[vga]');
    result.Add('svgachipset='+Game.VGAChipset);
    result.Add('videoram='+IntToStr(Game.VideoRam));
  end;

  If PrgSetup.AllowGlideSettings then begin
    result.Add('');
    result.Add('[glide]');
    result.Add('glide='+BoolToStr(Game.GlideEmulation));
  end;

  result.Add('');
  result.Add('[cpu]');
  result.Add('core='+Game.Core);
  result.Add('cycles='+Game.Cycles);
  result.Add('cycleup='+IntToStr(Game.CyclesUp));
  result.Add('cycledown='+IntToStr(Game.CyclesDown));

  result.Add('');
  result.Add('[mixer]');
  result.Add('nosound='+BoolToStr(Game.MixerNosound));
  result.Add('rate='+IntToStr(Game.MixerRate));
  result.Add('blocksize='+IntToStr(Game.MixerBlocksize));
  result.Add('prebuffer='+IntToStr(Game.MixerPrebuffer));

  result.Add('');
  result.Add('[midi]');
  result.Add('mpu401='+Game.MIDIType);
  result.Add('device='+Game.MIDIDevice);
  result.Add('config='+Game.MIDIConfig);

  result.Add('');
  result.Add('[sblaster]');
  result.Add('sbtype='+Game.SBType);
  result.Add('sbbase='+IntToStr(Game.SBBase));
  result.Add('irq='+IntToStr(Game.SBIRQ));
  result.Add('dma='+IntToStr(Game.SBDMA));
  result.Add('hdma='+IntToStr(Game.SBHDMA));
  result.Add('mixer='+BoolToStr(Game.SBMixer));
  result.Add('oplmode='+Game.SBOplMode);
  result.Add('oplrate='+IntToStr(Game.SBOplRate));

  result.Add('');
  result.Add('[gus]');
  result.Add('gus='+BoolToStr(Game.GUS));
  result.Add('gusrate='+IntToStr(Game.GUSRate));
  result.Add('gusbase='+IntToStr(Game.GUSBase));
  result.Add('irq1='+IntToStr(Game.GUSIRQ1));
  result.Add('irq2='+IntToStr(Game.GUSIRQ2));
  result.Add('dma1='+IntToStr(Game.GUSDMA1));
  result.Add('dma2='+IntToStr(Game.GUSDMA2));
  result.Add('ultradir='+Game.GUSUltraDir);

  result.Add('');
  result.Add('[speaker]');
  result.Add('pcspeaker='+BoolToStr(Game.SpeakerPC));
  result.Add('pcrate='+IntToStr(Game.SpeakerRate));
  result.Add('tandy='+Game.SpeakerTandy);
  result.Add('tandyrate='+IntToStr(Game.SpeakerTandyRate));
  result.Add('disney='+BoolToStr(Game.SpeakerDisney));

  result.Add('');
  result.Add('[dos]');
  result.Add('xms='+BoolToStr(Game.XMS));
  result.Add('ems='+BoolToStr(Game.EMS));
  result.Add('umb='+BoolToStr(Game.UMB));

  T:=Trim(ExtUpperCase(Game.KeyboardLayout));
  If (T='') or (T='DEFAULT') then T:=LanguageSetup.GameKeyboardLayoutDefault;
  If Pos('(',T)>0 then begin
    S:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then T:=S; end;
  end;
  result.Add('keyboardlayout='+T);

  {keyboardlayout can't handle layout+codepage -> moved to autoexec as keyb command

  S:=Trim(ExtUpperCase(Game.Codepage));
  If (S='') or (S='DEFAULT') then S:=LanguageSetup.GameKeyboardCodepageDefault;

  result.Add('keyboardlayout='+T+' '+S);}

  result.Add('');
  result.Add('[joystick]');
  result.Add('joysticktype='+Game.JoystickType);
  result.Add('timed='+BoolToStr(Game.JoystickTimed));
  result.Add('autofire='+BoolToStr(Game.JoystickAutoFire));
  result.Add('swap34='+BoolToStr(Game.JoystickSwap34));
  result.Add('buttonwrap='+BoolToStr(Game.JoystickButtonwrap));

  result.Add('');
  result.Add('[serial]');
  S:=ExtLowerCase(Game.Serial1);
  result.Add('serial1='+S);
  S:=ExtLowerCase(Game.Serial2);
  result.Add('serial2='+S);
  S:=ExtLowerCase(Game.Serial3);
  result.Add('serial3='+S);
  S:=ExtLowerCase(Game.Serial4);
  result.Add('serial4='+S);

  If Game.IPX then begin
    result.Add('');
    result.Add('[ipx]');
    result.Add('ipx=true');
  end;

  If PrgSetup.AllowPrinterSettings then begin
    result.Add('');
    result.Add('[printer]');
    result.Add('printer='+BoolToStr(Game.EnablePrinterEmulation));
    result.Add('docpath='+UnmapDrive(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir),ptScreenshot));
    result.Add('dpi='+IntToStr(Game.PrinterResolution));
    result.Add('width='+IntToStr(Game.PaperWidth));
    result.Add('height='+IntToStr(Game.PaperHeight));
    result.Add('printoutput='+Game.PrinterOutputFormat);
    result.Add('multipage='+BoolToStr(Game.PrinterMultiPage));
  end;

  BuildAutoexec(Game,RunSetup,result,WarnIfNotReachable,RunExtraFile,True);

  St:=StringToStringList(Game.CustomSettings);
  try result.AddStrings(St); finally St.Free; end;
end;

Procedure FindAlternativeDOSBoxFile(var PrgFile : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(ChangeFileExt(PrgFile,'*.exe'),faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        PrgFile:=IncludeTrailingPathDelimiter(ExtractFilePath(PrgFile))+Rec.Name;
        exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Type TCharArray=Array[0..MaxInt-1] of Char;
     PCharArray=^TCharArray;

Function RunDosBox(const DOSBoxPath : String; const DOSBoxNr : Integer; const ConfFile : String; const FullScreen : Boolean; const DosBoxCommandLine : String ='') : THandle;
Var Add : String;
    PrgFile, Params, Env, S : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    I,Size : Integer;
    P : PCharArray;
    Q : Array of Char;
    Waited : Boolean;
begin
  Add:='';
  if PrgSetup.DOSBoxSettings[DOSBoxNr].HideDosBoxConsole then Add:=' -NOCONSOLE';
  If Trim(PrgSetup.DOSBoxSettings[DOSBoxNr].CommandLineParameters)<>'' then Add:=Add+' '+Trim(PrgSetup.DOSBoxSettings[DOSBoxNr].CommandLineParameters);
  If DosBoxCommandLine<>'' then Add:=Add+' '+DosBoxCommandLine;

  PrgFile:=Trim(DOSBoxPath);
  If (PrgFile='') or (ExtUpperCase(PrgFile)='DEFAULT') then PrgFile:=IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir)+DosBoxFileName else begin
    If ExtUpperCase(Copy(PrgFile,length(PrgFile)-3,4))<>'.EXE' then PrgFile:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgFile,PrgSetup.BaseDir))+DosBoxFileName;
  end;

  If not FileExists(PrgFile) then FindAlternativeDOSBoxFile(PrgFile);

  if not FileExists(PrgFile) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindDosBox,[PrgFile]),mtError,[mbOK],0);
    result:=INVALID_HANDLE_VALUE;
    exit;
  end;

  PrgFile:=UnmapDrive(PrgFile,ptDOSBox);
  Params:='-CONF "'+ConfFile+'"'+Add;

  S:=Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[DOSBoxNr].SDLVideodriver));
  Env:='';
  If S='WINDIB' then Env:='windib';
  If S='DIRECTX' then Env:='directx';
  If Env<>'' then begin
    Env:='SDL_VIDEODRIVER='+Env;
    P:=PCharArray(GetEnvironmentStrings);
    try
      Size:=0;
      For I:=0 to MaxInt-1 do If (P^[I]=#0) and (P^[I+1]=#0) then begin Size:=I+1; break; end;
      SetLength(Q,Size+length(Env)+1+1);
      Move(P^[0],Q[0],Size);
      Move(Env[1],Q[Size],length(Env));
      Q[Size+length(Env)]:=#0;
      Q[Size+length(Env)+1]:=#0;
    finally
      FreeEnvironmentStrings(PAnsiChar(P));
    end;
    P:=@Q[0];
  end else begin
    P:=nil;
  end;

  If FullScreen then ShowFullscreenInfoDialog(Application.MainForm);

  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    lpReserved:=nil;
    lpDesktop:=nil;
    lpTitle:=nil;
    dwFlags:=0;
    cbReserved2:=0;
    lpReserved2:=nil;
  end;

  if not CreateProcess(
    PChar(PrgFile),
    PChar('"'+PrgFile+'" '+Params),
    nil,
    nil,
    False,
    0,
    P,
    PChar(ExtractFilePath(PrgFile)),
    StartupInfo,
    ProcessInformation
  ) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[PrgFile]),mtError,[mbOK],0);
    result:=INVALID_HANDLE_VALUE;
    exit;
  end;

  result:=ProcessInformation.hProcess;
  CloseHandle(ProcessInformation.hThread);

  {ShellExecute(Application.MainForm.Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName),PChar('-CONF "'+ConfFile+'"'+Add),PChar(IncludeTrailingPathDelimiter((ExtractFilePath(ConfFile)))),SW_SHOW);}

  If PrgSetup.DOSBoxSettings[DOSBoxNr].CenterDOSBoxWindow and (not FullScreen) then begin
    Sleep(1000); Waited:=True;
    CenterWindowFromProcessID(ProcessInformation.dwProcessId);
  end else begin
    Waited:=False;
  end;

  If PrgSetup.MinimizeOnDosBoxStart then begin
    If not Waited then Sleep(1000);
    {MinimizedAtDOSBoxStart:=True; -> RunGameInt}
  end;

  DOSBoxCounter.Add(result);
end;

Procedure RunGameInt(const Game : TGame; const RunSetup : Boolean; const DosBoxCommandLine : String; const RunExtraFile : Integer = -1);
Var St : TStringList;
    T : String;
    ZipRecNr : Integer;
    DOSBoxHandle : THandle;
    Error : Boolean;
    DOSBoxNr : Integer;
    AlreadyMinimized : Boolean;
begin
  If not RunCheck(Game,RunSetup,RunExtraFile) then exit;

  DOSBoxNr:=GetDOSBoxNr(Game);

  If PrgSetup.MinimizeOnDosBoxStart then begin
    AlreadyMinimized:=(Application.MainForm.WindowState=wsMinimized);
    Application.Minimize;
  end else begin
    AlreadyMinimized:=False;
  end;

  try
    If Trim(Game.CaptureFolder)='' then begin
      Game.CaptureFolder:=MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir);
      Game.StoreAllValues;
    end;
    ForceDirectories(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));

    St:=BuildConfFile(Game,RunSetup,True,RunExtraFile);

    try
      try
        St.SaveToFile(TempDir+DosBoxConfFileName);
      except
        Application.Restore;
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[TempDir+DosBoxConfFileName]),mtError,[mbOK],0);
        exit;
      end;
      AddToHistory(Game.Name);

      If DOSBoxNr>=0 then T:=MakeAbsPath(PrgSetup.DOSBoxSettings[DOSBoxNr].DosBoxDir,PrgSetup.BaseDir) else T:=Trim(Game.CustomDOSBoxDir);

      ZipRecNr:=ZipManager.AddGame(Game,Error);
      If Error then exit;

      RunPrgManager.RunBeforeExecutionCommand(Game);
      DOSBoxHandle:=RunDosBox(T,Max(0,DOSBoxNr),TempDir+DosBoxConfFileName,Game.StartFullscreen,DosBoxCommandLine);

      try
        If ZipRecNr>=0 then ZipManager.ActivateRepackCheck(ZipRecNr,DOSBoxHandle);
        RunPrgManager.AddCommand(Game,DOSBoxHandle);
        ScreensaverControl.DOSBoxStarted(DOSBoxHandle,PrgSetup.DOSBoxSettings[Max(0,DOSBoxNr)].DisableScreensaver);
      finally
        CloseHandle(DOSBoxHandle);
      end;
    finally
      St.Free;
    end;
  finally
    If PrgSetup.MinimizeOnDosBoxStart and (not AlreadyMinimized) then MinimizedAtDOSBoxStart:=True;
  end;
end;

Procedure RunGame(const Game : TGame; const RunSetup : Boolean; const DosBoxCommandLine : String);
begin
  RunGameInt(Game,RunSetup,DosBoxCommandLine);
end;

Procedure RunExtraFile(const Game : TGame; const ExtraFile : Integer);
begin
  RunGameInt(Game,False,'',ExtraFile);
end;

Procedure RunCommand(const Game : TGame; const Command : String; const DisableFullscreen : Boolean);
Var St : TStringList;
    AutoexecSave, FinalizationSave : String;
    FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  AutoexecSave:=Game.Autoexec;
  FinalizationSave:=Game.AutoexecFinalization;
  try
    St:=StringToStringList(AutoexecSave);
    try
      If Command<>'' then St.Add(Command);
      Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    if DisableFullscreen then Game.StartFullscreen:=False;
    RunGame(Game,False);
  finally
    Game.Autoexec:=AutoexecSave;
    Game.AutoexecFinalization:=FinalizationSave;
    Game.StartFullscreen:=FullscreenSave;
  end;
end;

Procedure RunWithCommandline(const Game : TGame; const CommandLine : String; const DisableFullscreen : Boolean = False);
Var FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  try
    if DisableFullscreen then Game.StartFullscreen:=False;
    RunGame(Game,False,CommandLine);
  finally
    Game.StartFullscreen:=FullscreenSave;
  end;
end;

Function IsWindowsExe(const FileName : String) : Boolean;
Var FSt : TFileStream;
    I : Integer;
    C : Array[0..3] of Char;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  If Trim(ExtUpperCase(ExtractFileExt(FileName)))<>'.EXE' then exit;
  try FSt:=TFileStream.Create(FileName,fmOpenRead); except exit; end;
  try
    try
      If FSt.Size<4 then exit;
      FSt.Read(C,4);
      If (C[0]<>'M') or (C[1]<>'Z') then exit;
      If $3C>FSt.Size-4 then exit;
      FSt.Seek($3C,soBeginning);
      FSt.Read(I,4);
      If (I<0) or (I>FSt.Size-4) then exit;
      FSt.Seek(I,soBeginning);
      FSt.Read(C,4);
      result:=(C[0]='P') and (C[1]='E') and (C[2]=#0) and (C[3]=#0);
    finally
      FSt.Free;
    end;
  except result:=False; end;
end;

Function IsDOSExe(const FileName : String) : Boolean;
Var FSt : TFileStream;
    I : Integer;
    C : Array[0..3] of Char;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  If Trim(ExtUpperCase(ExtractFileExt(FileName)))<>'.EXE' then exit;
  try FSt:=TFileStream.Create(FileName,fmOpenRead); except exit; end;
  try
    try
      If FSt.Size<4 then exit;
      FSt.Read(C,4);
      If (C[0]<>'M') or (C[1]<>'Z') then exit;
      If $3C>FSt.Size-4 then exit;
      FSt.Seek($3C,soBeginning);
      FSt.Read(I,4);
      If (I<0) or (I>FSt.Size-4) then begin result:=True; exit; end;
      FSt.Seek(I,soBeginning);
      FSt.Read(C,4);
      result:=not ((C[0]='P') and (C[1]='E') and (C[2]=#0) and (C[3]=#0));
    finally
      FSt.Free;
    end;
  except result:=False; end;
end;

end.
