unit ZipPackageUnit;
interface

uses Classes, GameDBUnit;

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String);
Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB) : TGame;

implementation

uses Windows, SysUtils, Controls, Dialogs, SevenZipVCL, CommonTools,
     LanguageSetupUnit, GameDBToolsUnit, PrgSetupUnit, PrgConsts,
     UninstallFormUnit, ZipInfoFormUnit, DosBoxUnit, ScummVMUnit;

Function CopyFileWithMsg(const Source, Dest : String) : Boolean;
begin
  result:=ForceDirectories(ExtractFilePath(Dest));
  if result then result:=CopyFile(PChar(Source),PChar(Dest),False);
  if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Source,Dest]),mtError,[mbOK],0);
end;

Function CopyFolderWithMsg(Source, Dest : String; const IgnoreProfConfInRootDir : Boolean = False) : Boolean;
Var I : Integer;
    Rec : TSearchRec;
    S,T : String;
    B : Boolean;
begin
  result:=False;

  Source:=IncludeTrailingPathDelimiter(Source);
  Dest:=IncludeTrailingPathDelimiter(Dest);

  if not DirectoryExists(Source) then begin result:=True; exit; end;

  If not ForceDirectories(Dest) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dest]),mtError,[mbOK],0);
    exit;
  end;

  I:=FindFirst(Source+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
          If not CopyFolderWithMsg(Source+Rec.Name,Dest+Rec.Name) then exit;
        end;
      end else begin
        If IgnoreProfConfInRootDir then begin
          T:=Trim(ExtUpperCase(Rec.Name)); S:=ExtractFileExt(T);
          B:=(S<>'.CONF') and (S<>'.PROF') and (T<>'INSTALLREADME.TXT');
        end else B:=True;
        If B then begin
          If not CopyFileWithMsg(Source+Rec.Name,Dest+Rec.Name) then exit;
        end;
      end;  
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  result:=True;
end;

Function CreateInfoFile(const Game : TGame; const Dir : String) : Boolean;
Var St : TStringList;
begin
  result:=False;

  St:=TStringList.Create;
  try
    St.Add('This is a D-Fend Reloaded game package for the game');
    St.Add('"'+Game.CacheName+'".');
    St.Add('');
    St.Add('If you are using D-Fend Reloaded, you can just install this package via');
    St.Add('File|Import|Import zip-file or by just dragging the zip file to the');
    St.Add('D-Fend Reloaded program window.');
    St.Add('');
    St.Add('If you do not have a D-Fend Reloaded installation on your system, you can');
    St.Add('download it here for free:');
    St.Add('http:/'+'/dfendreloaded.sourceforge.net/Download.html');
    St.Add('');
    If ScummVMMode(Game) then begin
      St.Add('You can also run the game from this package without having D-Fend Reloaded');
      St.Add('installed. All you need is ScummVM (http:/'+'/www.scummvm.org/). You can just use');
      St.Add('the ini file from this folder to run the game inside ScummVM.');
    end else begin
      St.Add('You can also run the game from this package without having D-Fend Reloaded');
      St.Add('installed. All you need is DOSBox (http:/'+'/www.dosbox.com). You can just use');
      St.Add('the conf file from this folder to run the game inside DOSBox.');
    end;
    St.Add('');
    St.Add('You can find all files needed to run the game in the subfolders of this folder.');
    try
      St.SaveToFile(IncludeTrailingPathDelimiter(Dir)+'InstallReadme.txt');
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[IncludeTrailingPathDelimiter(Dir)+'InstallReadme.txt']),mtError,[mbOK],0);
      exit;
    end;
  finally
    St.Free;
  end;

  result:=True;
end;

Function CopyFilesToTempDir(const Game : TGame; const Dir : String) : Boolean;
Var S,T : String;
    St,Files,Folders : TStringList;
    I : Integer;
begin
  result:=False;

  Game.StoreAllValues;

  if not CopyFileWithMsg(Game.SetupFile,Dir+ExtractFileName(Game.SetupFile)) then exit;

  S:=Dir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.conf');
  If DOSBoxMode(Game) then begin
    St:=BuildConfFile(Game,False,False);
    try
      try St.SaveToFile(S); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0); exit; end;
    finally
      St.Free;
    end;
  end;
  If ScummVMMode(Game) then begin
    St:=BuildScummVMIniFile(Game);
    try
      try St.SaveToFile(S); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0); exit; end;
    finally
      St.Free;
    end;
  end;

  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
    end;
    S:=Trim(Game.ScummVMZip);
    If S<>'' then begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S)) then exit;
    end;
    S:=Trim(Game.ScummVMSavePath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(S),PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
    end;
  end;

  S:=Trim(Game.CaptureFolder);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
    If Copy(S,2,2)=':\' then begin
      MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
      result:=False; exit;
    end;
    if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) then begin
    If ExtractFilePath(Game.Icon)='' then begin
      if not CopyFileWithMsg(S,Dir+IconsSubDir+'\'+Trim(Game.Icon)) then exit;
    end else begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      if not CopyFileWithMsg(MakeAbsIconName(Game.Icon),Dir+T+'\'+ExtractFileName(Game.Icon)) then exit;
    end;
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir));
    If Copy(S,2,2)=':\' then begin
      MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
      result:=False; exit;
    end;
    if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=MakeRelPath(St[I],PrgSetup.BaseDir);
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        T:=ExtractFilePath(S);
        If (T<>'') and (T[1]='.') then Delete(T,1,1);
        If (T<>'') and (T[1]='\') then Delete(T,1,1);
        If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
        if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S)) then exit;
      end;
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir));
        If Copy(S,2,2)=':\' then begin
          MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
          result:=False; exit;
        end;
        if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
      end;
    finally
      St.Free;
    end;
  end;

  FileAndFoldersFromDrives(Game,Files,Folders);
  try
    For I:=0 to Files.Count-1 do begin
      S:=MakeRelPath(Files[I],PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      If (T<>'') and (T[1]='.') then Delete(T,1,1);
      If (T<>'') and (T[1]='\') then Delete(T,1,1);
      If (T<>'') and (T[length(T)]='\') then Delete(T,length(T),1);
      if not CopyFileWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),Dir+T+'\'+ExtractFileName(S)) then exit;
    end;
    For I:=0 to Folders.Count-1 do begin
      S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(Folders[I]),PrgSetup.BaseDir));
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      if not CopyFolderWithMsg(MakeAbsPath(S,PrgSetup.BaseDir),MakeAbsPath(S,Dir)) then exit;
    end;
  finally
    Files.Free;
    Folders.Free;
  end;

  CreateInfoFile(Game, Dir);

  result:=True;
end;

Function DeleteTempDir(const Dir: String; var ContinueNext : Boolean) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;
  ContinueNext:=False;

  If not DirectoryExists(Dir) then begin result:=True; exit; end;

  If Pos('..',Dir)<>0 then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorDotDotInPath,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      if (Rec.Attr and faDirectory)=faDirectory then begin
        If Rec.Name[1]<>'.' then begin
          if not DeleteTempDir(Dir+Rec.Name+'\',ContinueNext) then exit;
        end;
      end else begin
        if not DeleteSingleFile(Dir+Rec.Name,ContinueNext,ftZipOperation) then exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  repeat
    if not ExtDeleteFolder(Dir,ftZipOperation) then begin
      Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Dir])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
        mrIgnore : begin ContinueNext:=True; exit; end;
        mrRetry : ;
        else exit;
      End;
    end else begin
      break;
    end;
  until False;

  result:=True;
  ContinueNext:=True;
end;

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String);
Var Temp : String;
    B : Boolean;
    ACompressStrength : TCompressStrength;
begin
  If WindowsExeMode(AGame) then exit;

  Temp:=IncludeTrailingPathDelimiter(TempDir+'D-Fend Reloaded zip package');
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    exit;
  end;

  If CopyFilesToTempDir(AGame,Temp) then begin
    Case PrgSetup.CompressionLevel of
      0 : ACompressStrength:=SAVE;
      1 : ACompressStrength:=FAST;
      2 : ACompressStrength:=NORMAL;
      3 : ACompressStrength:=MAXIMUM;
      4 : ACompressStrength:=ULTRA;
      else ACompressStrength:=MAXIMUM;
    end;
    CreateZipFile(AOwner,AFileName,Temp,dmNo,ACompressStrength);
  end;

  B:=True; DeleteTempDir(Temp,B);
end;

Function GetProfFileName(const Dir : String) : String;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:='';

  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.prof',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then result:=IncludeTrailingPathDelimiter(Dir)+Rec.Name;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function CreateGameFromFolder(const Dir : String; const GameDB : TGameDB) : TGame;
Var TempProfFile,ProfFile : String;
begin
  result:=nil;

  {Add profile}

  TempProfFile:=GetProfFileName(Dir);
  If TempProfFile='' then begin
    MessageDlg(LanguageSetup.MessageZipImportError,mtError,[mbOK],0);
    exit;
  end;

  ProfFile:=PrgDataDir+GameListSubDir+'\'+ExtractFileName(TempProfFile);
  If not CopyFileWithMsg(TempProfFile,ProfFile) then exit;

  result:=TGame.Create(ProfFile);
  GameDB.Add(result);

  {Add files}

  CopyFolderWithMsg(Dir,PrgSetup.BaseDir,True);
end;

Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB) : TGame;
Var Temp : String;
    B : Boolean;
begin
  result:=nil;

  Temp:=IncludeTrailingPathDelimiter(TempDir+'D-Fend Reloaded zip package');
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    exit;
  end;

  try
    if not ExtractZipFile(AOwner,AFileName,Temp) then exit;
    result:=CreateGameFromFolder(Temp,AGameDB);
  finally
    B:=True; DeleteTempDir(Temp,B);
  end;
end;

end.
