unit DosBoxUnit;
interface

uses Classes, GameDBUnit;

Procedure RunGame(const Game : TGame; const RunSetup : Boolean = False; const DosBoxCommandLine : String ='');
Procedure RunCommand(const Game : TGame; const Command : String; const DisableFullscreen : Boolean = False);
Procedure RunWithCommandline(const Game : TGame; const CommandLine : String; const DisableFullscreen : Boolean = False);

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean) : TStringList;

implementation

uses Windows, SysUtils, ShellAPI, Forms, Dialogs,
     CommonTools, PrgSetupUnit, PrgConsts, LanguageSetupUnit, GameDBToolsUnit;

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

Function SpecialMultiImgMount(const DriveLetter : String; const Imgs : TStringList; const FreeDriveLetters : String; const MountCommandAdd : String) : String;
Var I : Integer;
    TempDrive : Char;
    Path,S : String;
begin
  TempDrive:='Y';
  For I:=length(FreeDriveLetters) downto 1 do If FreeDriveLetters[I]<>'-' then begin TempDrive:=FreeDriveLetters[I]; break; end;
  {There must be free drive letters, because there are only 10 mounts}

  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(ShortName(Imgs[0])));

  S:='"'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[0]))+'"';
  For I:=1 to Imgs.Count-1 do S:=S+' "'+TempDrive+':\'+ExtractFileName(ShortName(Imgs[I]))+'"';

  result:=
    'mount '+TempDrive+' "'+Path+'"'+#13+
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
      result:='mount '+St[2]+' "'+ShortName(S)+'"';
      If (St.Count>=6) and (St[5]<>'') then result:=result+' -freesize '+St[5];
    end;

    If T='FLOPPY' then begin
      {RealFolder;FLOPPY;Letter;False;;}
      MarkDriveUsed(St[2]);
      result:='mount '+St[2]+' "'+ShortName(S)+'" -t floppy';
    end;

    If T='CDROM' then begin
      {RealFolder;CDROM;Letter;IO;Label;}
      MarkDriveUsed(St[2]);
      result:='mount '+St[2]+' "'+ShortName(S)+'" -t cdrom';
      If Trim(UpperCase(St[3]))='TRUE' then result:=result+' -IOCTL';
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
        result:='mount '+St[2]+' '+ShortName(St2[0])+':'+ShortName(St2[1])+':/';
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
    Case I of
      0 : St:=ValueToList(Game.Mount0);
      1 : St:=ValueToList(Game.Mount1);
      2 : St:=ValueToList(Game.Mount2);
      3 : St:=ValueToList(Game.Mount3);
      4 : St:=ValueToList(Game.Mount4);
      5 : St:=ValueToList(Game.Mount5);
      6 : St:=ValueToList(Game.Mount6);
      7 : St:=ValueToList(Game.Mount7);
      8 : St:=ValueToList(Game.Mount8);
      9 : St:=ValueToList(Game.Mount9);
      else St:=TStringList.Create;
    end;
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

    Mount:='mount '+TempDrive+': "'+ShortName(FreeDOSPath)+'"';
    UseDir:=''+TempDrive+':\';
    Unmount:='mount -u '+TempDrive;
  end;
end;

Procedure BuildRunCommands(const St : TStringList; const ProgramFile, ProgramParameters : String; const UseLoadFix : Boolean; const LoadFixMemory : Integer; const Use4DOS, UseDOS32A : Boolean; const Game : TGame; const FreeDriveLetters : String; const WarnIfNotReachable : Boolean);
Var Prefix,S,T,Temp,UsePath,Mount,Unmount : String;
    I : Integer;
    St2 : TStringList;
    NoFreeDOS : Boolean;
    TempDrive : Char;
    Path, Drive : String;
begin
  TempMountFreeDOSDir(Game,FreeDriveLetters,UsePath,Mount,Unmount);
  NoFreeDOS:=(UsePath='');
  If Use4DOS or UseDOS32A then begin
    If Mount<>'' then St.Add(Mount);
  end;

  T:=Trim(ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir)));

  SetLength(Temp,MAX_PATH+10);
  If GetShortPathName(PChar(T),PChar(Temp),MAX_PATH)<>0 then begin
    SetLength(Temp,StrLen(PChar(Temp))); T:=Trim(ExtUpperCase(Temp));
  end;

  If (Trim(ProgramFile)<>'') and (T<>'') then begin
    Path:=''; Drive:='';
    For I:=0 to Game.NrOfMounts-1 do begin
      Case I of
        0 : St2:=ValueToList(Game.Mount0);
        1 : St2:=ValueToList(Game.Mount1);
        2 : St2:=ValueToList(Game.Mount2);
        3 : St2:=ValueToList(Game.Mount3);
        4 : St2:=ValueToList(Game.Mount4);
        5 : St2:=ValueToList(Game.Mount5);
        6 : St2:=ValueToList(Game.Mount6);
        7 : St2:=ValueToList(Game.Mount7);
        8 : St2:=ValueToList(Game.Mount8);
        9 : St2:=ValueToList(Game.Mount9);
        else St2:=TStringList.Create;
      end;
      try
        If St2.Count=3 then St2.Add('false');
        If St2.Count=4 then St2.Add('');
        If St2.Count<5 then continue;
        If (Trim(ExtUpperCase(St2[1]))<>'DRIVE') and (Trim(ExtUpperCase(St2[1]))<>'CDROM') then continue;
        S:=MakeAbsPath(IncludeTrailingPathDelimiter(St2[0]),PrgSetup.BaseDir);

        SetLength(Temp,MAX_PATH+10);
        If GetShortPathName(PChar(S),PChar(Temp),MAX_PATH)<>0 then begin
          SetLength(Temp,StrLen(PChar(Temp))); S:=Trim(ExtUpperCase(Temp));
        end;

        If Copy(T,1,length(S))=S then begin
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
        St.Add('cd '+S);
      end;
    end else begin
      St.Add('Rem !!! The program file is not reachable via any mounted drive. !!!');
      If WarnIfNotReachable then
        MessageDlg(Format(LanguageSetup.MessageNoMountToReachFolder,[ExtractFilePath(MakeAbsPath(ProgramFile,PrgSetup.BaseDir))]),mtError,[mbOK],0);
    end;
  end;
  If UseLoadFix then Prefix:='loadfix -'+IntToStr(LoadFixMemory)+' ' else Prefix:='';
  If (not UseLoadFix) and (not Use4DOS) and (not UseDOS32A) and (Trim(ExtUpperCase(ExtractFileExt(ProgramFile)))='.BAT') then Prefix:='call ';

  If Trim(ProgramParameters)<>'' then T:=' '+ProgramParameters else T:='';
  T:=ExtractFileName(ProgramFile)+T;

  If UseDOS32A and (not NoFreeDOS) then begin
    St.Add(UsePath+'DOS32A.EXE '+T);
    exit;
  end;

  If Use4DOS and (not NoFreeDOS) then begin
    If T<>'' then T:=' /C '+T;
    St.Add(UsePath+'4DOS.COM'+T);
    exit;
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

      Autoexec.Add('mount '+TempDrive+' "'+Path+'"');
      Autoexec.Add('boot '+S);
    end else begin
      Autoexec.Add('boot "'+ShortName(MakeAbsPath(S,PrgSetup.BaseDir))+'"');
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
    Case I of
      1 : S:=Game.Mount0;
      2 : S:=Game.Mount1;
      3 : S:=Game.Mount2;
      4 : S:=Game.Mount3;
      5 : S:=Game.Mount4;
      6 : S:=Game.Mount5;
      7 : S:=Game.Mount6;
      8 : S:=Game.Mount7;
      9 : S:=Game.Mount8;
     10 : S:=Game.Mount9;
    end;
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

Procedure BuildAutoexec(const Game : TGame; const RunSetup : Boolean; const St : TStringList; const WarnIfNotReachable : Boolean);
  Procedure SetVolume(const Channel : String; const Left,Right : Integer);
  begin If (Left<>100) or (Right<>100) then St.Add('mixer '+Channel+' '+IntToStr(Left)+':'+IntToStr(Right)+' /NOSHOW'); end;
Var S,T,NumCommands,MouseCommands,UsePath,Mount,UnMount : String;
    I : Integer;
    FreeDriveLetters : String;
    St2 : TStringList;
begin
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
    If Game.NrOfMounts>=1 then MultiLineAdd(St,BuildMountData(Game.Mount0,FreeDriveLetters));
    If Game.NrOfMounts>=2 then MultiLineAdd(St,BuildMountData(Game.Mount1,FreeDriveLetters));
    If Game.NrOfMounts>=3 then MultiLineAdd(St,BuildMountData(Game.Mount2,FreeDriveLetters));
    If Game.NrOfMounts>=4 then MultiLineAdd(St,BuildMountData(Game.Mount3,FreeDriveLetters));
    If Game.NrOfMounts>=5 then MultiLineAdd(St,BuildMountData(Game.Mount4,FreeDriveLetters));
    If Game.NrOfMounts>=6 then MultiLineAdd(St,BuildMountData(Game.Mount5,FreeDriveLetters));
    If Game.NrOfMounts>=7 then MultiLineAdd(St,BuildMountData(Game.Mount6,FreeDriveLetters));
    If Game.NrOfMounts>=8 then MultiLineAdd(St,BuildMountData(Game.Mount7,FreeDriveLetters));
    If Game.NrOfMounts>=9 then MultiLineAdd(St,BuildMountData(Game.Mount8,FreeDriveLetters));
    If Game.NrOfMounts>=10 then MultiLineAdd(St,BuildMountData(Game.Mount9,FreeDriveLetters));
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
      If RunSetup then begin
        BuildRunCommands(St,Game.SetupExe,Game.SetupParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,False,Game,FreeDriveLetters,WarnIfNotReachable);
        If Game.CloseDosBoxAfterGameExit and (Trim(Game.SetupExe)<>'') then St.Add('exit');
      end else begin
        BuildRunCommands(St,Game.GameExe,Game.GameParameters,Game.LoadFix,Game.LoadFixMemory,Game.Use4DOS,Game.UseDOS32A,Game,FreeDriveLetters,WarnIfNotReachable);
        If Game.CloseDosBoxAfterGameExit and (Trim(Game.GameExe)<>'') then St.Add('exit');
      end;
    end;
  end;
end;

Function BuildConfFile(const Game : TGame; const RunSetup : Boolean; const WarnIfNotReachable : Boolean) : TStringList;
Var St : TStringList;
    S : String;
begin
  result:=TStringList.Create;

  result.Add('[sdl]');
  result.Add('fullscreen='+BoolToStr(Game.StartFullscreen));
  result.Add('fulldouble='+BoolToStr(Game.UseDoublebuffering));
  result.Add('fullresolution='+Game.FullscreenResolution);
  result.Add('windowresolution='+Game.WindowResolution);
  result.Add('output='+Game.Render);
  result.Add('autolock='+BoolToStr(Game.AutoLockMouse));
  result.Add('sensitivity='+IntToStr(Game.MouseSensitivity));
  result.Add('waitonerror=true');
  result.Add('usecancodes='+BoolToStr(Game.UseScanCodes));
  result.Add('priority='+Game.Priority);
  result.Add('mapperfile='+MakeAbsPath(PrgSetup.DosBoxMapperFile,PrgDataDir));

  result.Add('');
  result.Add('[dosbox]');
  result.Add('language='+PrgSetup.DosBoxLanguage);
  result.Add('machine='+Game.VideoCard);
  result.Add('captures='+MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));
  result.Add('memsize='+IntToStr(Game.Memory));

  result.Add('');
  result.Add('[render]');
  result.Add('frameskip='+IntToStr(Game.FrameSkip));
  result.Add('aspect='+BoolToStr(Game.AspectCorrection));
  result.Add('scaler='+Game.Scale);

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
  S:=Trim(ExtUpperCase(Game.KeyboardLayout));
  If (S='') or (S='DEFAULT') then S:=LanguageSetup.GameKeyboardLayoutDefault;
  If Pos('(',S)>0 then begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)>0 then begin
      S:=Trim(Copy(S,1,Pos(')',S)-1));
      If S<>'' then result.Add('keyboardlayout='+S);
    end;
  end else begin
    result.Add('keyboardlayout=');
  end;

  result.Add('');
  result.Add('[joystick]');
  result.Add('joysticktype='+Game.JoystickType);
  result.Add('timed='+BoolToStr(Game.JoystickTimed));
  result.Add('autofire='+BoolToStr(Game.JoystickAutoFire));
  result.Add('swap34='+BoolToStr(Game.JoystickSwap34));
  result.Add('buttonwrap='+BoolToStr(Game.JoystickButtonwrap));

  result.Add('');
  result.Add('[serial]');
  result.Add('Serial1='+Game.Serial1);
  result.Add('Serial2='+Game.Serial2);
  result.Add('Serial3='+Game.Serial3);
  result.Add('Serial4='+Game.Serial4);

  BuildAutoexec(Game,RunSetup,result,WarnIfNotReachable);

  St:=StringToStringList(Game.CustomSettings);
  try result.AddStrings(St); finally St.Free; end;
end;

Procedure CenterWindow(Const hWindow : HWnd);
Var R : TRect;
begin
 GetWindowRect(hWindow,R);
 SetWindowPos(
   hWindow,
   HWND_TOP,
   (Screen.Width div 2)-((R.Right-R.Left) div 2),
   (Screen.Height div 2)-((R.Bottom-R.Top) div 2),
   0,
   0,
   SWP_SHOWWINDOW or SWP_NOSIZE
 );
end;

Function EnumWindowsFunc(const hWindow : THandle; const lParam : Integer) : Boolean; StdCall;
Var S : String;
begin
  result:=True;

  SetLength(S,255);
  If GetWindowText(hWindow,PChar(S),250)=0 then exit;
  SetLength(S,StrLen(PChar(S)));
  If Copy(Trim(ExtUpperCase(S)),1,6)<>'DOSBOX' then exit;

  CenterWindow(hWindow);
end;

Procedure CenterDOSBoxWindow;
begin
  EnumWindows(@EnumWindowsFunc,0);
end;

Type TCharArray=Array[0..MaxInt-1] of Char;
     PCharArray=^TCharArray;

Procedure RunDosBox(const DOSBoxPath : String; const ConfFile : String; const FullScreen : Boolean; const DosBoxCommandLine : String ='');
Var Add : String;
    PrgFile, Params, Env : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    I,Size : Integer;
    P : PCharArray;
    Q : Array of Char;
begin
  if PrgSetup.HideDosBoxConsole then Add:=' -NOCONSOLE';
  If DosBoxCommandLine<>'' then Add:=Add+' '+DosBoxCommandLine;

  PrgFile:=Trim(DOSBoxPath);
  If (PrgFile='') or (ExtUpperCase(PrgFile)='DEFAULT') then PrgFile:=IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName else begin
    If ExtUpperCase(Copy(PrgFile,length(PrgFile)-3,4))<>'.EXE' then PrgFile:=IncludeTrailingPathDelimiter(PrgFile)+DosBoxFileName;
  end;

  if not FileExists(PrgFile) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindDosBox,[PrgFile]),mtError,[mbOK],0);
    exit;
  end;

  Params:='-CONF '+ConfFile+Add;

  If Trim(ExtUpperCase(PrgSetup.SDLVideodriver))='WINDIB' then begin
    Env:='SDL_VIDEODRIVER=windib';
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

  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    lpReserved:=nil;
    lpDesktop:=nil;
    lpTitle:=nil;
    dwFlags:=0;
    cbReserved2:=0;
    lpReserved2:=nil;
  end;

  CreateProcess(
    PChar(PrgFile),
    PChar(PrgFile+' '+Params),
    nil,
    nil,
    False,
    0,
    P,
    PChar(ExtractFilePath(PrgFile)),
    StartupInfo,
    ProcessInformation
  );

  CloseHandle(ProcessInformation.hProcess);
  CloseHandle(ProcessInformation.hThread);

  {ShellExecute(Application.MainForm.Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName),PChar('-CONF '+ConfFile+Add),PChar(IncludeTrailingPathDelimiter((ExtractFilePath(ConfFile)))),SW_SHOW);}

  If PrgSetup.CenterDOSBoxWindow and (not FullScreen) then begin
    Sleep(1000);
    CenterDOSBoxWindow;
  end;
end;

Procedure RunGame(const Game : TGame; const RunSetup : Boolean; const DosBoxCommandLine : String);
Var St : TStringList;
    S,T : String;
begin
  If not RunCheck(Game,RunSetup) then exit;

  If PrgSetup.MinimizeOnDosBoxStart then Application.Minimize;

  ForceDirectories(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));

  St:=BuildConfFile(Game,RunSetup,True);
  try
    SetLength(S,260); GetTempPath(250,PChar(S)); SetLength(S,StrLen(PChar(S)));
    S:=IncludeTrailingPathDelimiter(S);
    try
      St.SaveToFile(S+DosBoxConfFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S+DosBoxConfFileName]),mtError,[mbOK],0);
      exit;
    end;
    AddToHistory(Game.Name);

    T:=Trim(Game.CustomDOSBoxDir);
    If (T='') or (ExtUpperCase(T)='DEFAULT') then T:='' else T:=MakeAbsPath(T,PrgSetup.BaseDir);
    RunDosBox(T,S+DosBoxConfFileName,Game.StartFullscreen,DosBoxCommandLine);
  finally
    St.Free;
  end;
end;

Procedure RunCommand(const Game : TGame; const Command : String; const DisableFullscreen : Boolean);
Var St : TStringList;
    AutoexecSave : String;
    FullscreenSave : Boolean;
begin
  FullscreenSave:=Game.StartFullscreen;
  AutoexecSave:=Game.Autoexec;
  try
    St:=StringToStringList(AutoexecSave);
    try
      St.Add(Command);
      Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    if DisableFullscreen then Game.StartFullscreen:=False;
    RunGame(Game,False);
  finally
    Game.Autoexec:=AutoexecSave;
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

end.
