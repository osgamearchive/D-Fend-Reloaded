unit ZipPackageUnit;
interface

uses Classes, Math, GameDBUnit;

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String);
Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB) : TGame;

Function AdditionalDataMatching(const Folder : String; const Template : TGame) : Boolean;

Function GetTemplateFromFolderExt(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; const StartableFiles : TStringList = nil) : TStringList;
Function GetTemplateFromFolder(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; var FileToStart : String; const StartableFiles : TStringList = nil) : Integer;

Procedure TempZipFilesStartCleanUp;

implementation

uses Windows, SysUtils, Forms, Controls, Dialogs, ShellAPI, ShlObj, SevenZipVCL,
     CommonTools, LanguageSetupUnit, GameDBToolsUnit, PrgSetupUnit, PrgConsts,
     UninstallFormUnit, ZipInfoFormUnit, DosBoxUnit, ScummVMUnit, HashCalc,
     ImportSelectTemplateFormUnit, SelectTemplateForZipImportFormUnit;

Function CopyFileWithMsg(const Source, Dest : String) : Boolean;
begin
  result:=ForceDirectories(ExtractFilePath(Dest));
  If result then begin If FileExists(Dest) then exit; end;
  if result then result:=CopyFile(PChar(Source),PChar(Dest),False);
  if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Source,Dest]),mtError,[mbOK],0);
end;

Function CopyFolderWithMsg(Source, Dest : String; const NewGame : TGame = nil; const IgnoreProfConfInRootDir : Boolean = False) : Boolean;
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
          B:=False;
          If (NewGame<>nil) and DirectoryExists(Dest+Rec.Name) then begin
            {Change path if destination capture or data folder already exists}
            S:=IncludeTrailingPathDelimiter(ExtUpperCase(Dest+Rec.Name));
            If IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(NewGame.CaptureFolder,PrgSetup.BaseDir)))=S then begin
              S:=IncludeTrailingPathDelimiter(Dest+Rec.Name);
              I:=0;
              While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(IncludeTrailingPathDelimiter(S)) do begin
                inc(I); S:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(Dest+Rec.Name)+IntToStr(I));
              end;
              If not CopyFolderWithMsg(Source+Rec.Name,S,NewGame) then exit;
              NewGame.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir,True); NewGame.StoreAllValues;
              B:=True;
            end else begin
              If IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(NewGame.DataDir,PrgSetup.BaseDir)))=S then begin
                S:=IncludeTrailingPathDelimiter(Dest+Rec.Name);
                I:=0;
                While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(IncludeTrailingPathDelimiter(S)) do begin
                  inc(I); S:=IncludeTrailingPathDelimiter(ExcludeTrailingPathDelimiter(Dest+Rec.Name)+IntToStr(I));
                end;
                If not CopyFolderWithMsg(Source+Rec.Name,S,NewGame) then exit;
                NewGame.DataDir:=MakeRelPath(S,PrgSetup.BaseDir,True); NewGame.StoreAllValues;
                B:=True;
              end;
            end;
          end;
          If not B then begin
            If not CopyFolderWithMsg(Source+Rec.Name,Dest+Rec.Name,NewGame) then exit;
          end;
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
    St:=BuildConfFile(Game,False,False,-1);
    If St<>nil then begin
      try
        try St.SaveToFile(S); except MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0); exit; end;
      finally
        St.Free;
      end;
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
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
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
      S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
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
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
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
    S:=IncludeTrailingPathDelimiter(MakeRelPath(S,PrgSetup.BaseDir,True));
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
        S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir,True));
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
      S:=IncludeTrailingPathDelimiter(MakeRelPath(IncludeTrailingPathDelimiter(Folders[I]),PrgSetup.BaseDir,True));
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

Procedure BuildZipPackage(const AOwner : TComponent; const AGame : TGame; const AFileName : String);
Var Temp : String;
    ACompressStrength : TCompressStrength;
begin
  If WindowsExeMode(AGame) then exit;

  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
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

  ChDir(GetSpecialFolder(Application.MainForm.Handle,CSIDL_DESKTOPDIRECTORY));
  ExtDeleteFolder(Temp,ftTemp);
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

Function GetPrgFilesFromFolder(Folder : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  Folder:=IncludeTrailingPathDelimiter(Folder);

  result:=TStringList.Create;

  I:=FindFirst(Folder+'*.exe',faAnyFile,Rec);
  try
    While I=0 do begin result.Add(Rec.Name); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Folder+'*.com',faAnyFile,Rec);
  try
    While I=0 do begin result.Add(Rec.Name); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Folder+'*.bat',faAnyFile,Rec);
  try
    While I=0 do begin result.Add(Rec.Name); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;
end;

Procedure RatePrgFiles(const Files : TStringList);
Var I,J : Integer;
    S : String;
begin
  For I:=0 to Files.Count-1 do begin
    S:=ExtUpperCase(Files[I]);
    J:=0;
    If Copy(S,1,5)='GAME.' then J:=10;
    If Copy(S,1,6)='SETUP.' then J:=-10;
    If S='RUNME.BAT' then J:=20;
    If S='RUN.BAT' then J:=20;
    If (J=0) and (Copy(S,length(S)-3,4)='.BAT') then J:=1;
    Files.Objects[I]:=Pointer(J);
  end;
end;

Function AdditionalDataMatching(const Folder : String; const Template : TGame) : Boolean;
Var I : Integer;
    F,C : String;
    NotMatching : Boolean;
begin
  result:=False; NotMatching:=False;
  For I:=1 to 5 do begin
    Case I of
      1 : begin F:=Template.AddtionalChecksumFile1; C:=Template.AddtionalChecksumFile1Checksum; end;
      2 : begin F:=Template.AddtionalChecksumFile2; C:=Template.AddtionalChecksumFile2Checksum; end;
      3 : begin F:=Template.AddtionalChecksumFile3; C:=Template.AddtionalChecksumFile3Checksum; end;
      4 : begin F:=Template.AddtionalChecksumFile4; C:=Template.AddtionalChecksumFile4Checksum; end;
      5 : begin F:=Template.AddtionalChecksumFile5; C:=Template.AddtionalChecksumFile5Checksum; end;
    End;
    If F='' then continue;
    If FileExists(Folder+F) then begin
      If GetMD5Sum(Folder+F)=C then result:=True else NotMatching:=True;
    end;
  end;
  if NotMatching then result:=False;
end;

Function GetTemplateFromFolderExt(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; const StartableFiles : TStringList) : TStringList;
Var PrgFiles : TStringList;
    I,J,LastLevel,NewLevel : Integer;
    GameCheckSum : String;
    MatchByAdditionalData : TList;
    B : Boolean;
begin
  result:=TStringList.Create;

  Folder:=IncludeTrailingPathDelimiter(Folder);

  PrgFiles:=GetPrgFilesFromFolder(Folder);
  try
    RatePrgFiles(PrgFiles);
    If StartableFiles<>nil then begin StartableFiles.Clear; StartableFiles.AddStrings(PrgFiles); end;

    {Find all matching auto setup templates}
    LastLevel:=1000; NewLevel:=-1;
    repeat
      For I:=0 to PrgFiles.Count-1 do begin J:=Integer(PrgFiles.Objects[I]); If (J<LastLevel) and (J>NewLevel) then NewLevel:=J; end;
      If NewLevel=-1 then break;

      For I:=0 to PrgFiles.Count-1 do If Integer(PrgFiles.Objects[I])=NewLevel then begin
        GameCheckSum:=GetMD5Sum(Folder+PrgFiles[I]);
        For J:=0 to AutoSetupDB.Count-1 do If (AutoSetupDB[J].GameExeMD5<>'') and (AutoSetupDB[J].GameExeMD5=GameCheckSum) then begin
          result.AddObject(PrgFiles[I],TObject(J));
        end;
      end;
      LastLevel:=NewLevel; NewLevel:=-1;
    until False;

    {If there is more than one, use additional checksums}
    If result.Count>0 then begin
      MatchByAdditionalData:=TList.Create;
      try
        B:=False;
        For I:=0 to result.Count-1 do If AdditionalDataMatching(Folder,AutoSetupDB[Integer(result.Objects[I])]) then begin
          MatchByAdditionalData.Add(Pointer(1)); B:=True;
        end else begin
          MatchByAdditionalData.Add(Pointer(0));
        end;
        If B then begin
          I:=0;
          While I<result.Count do if Integer(MatchByAdditionalData[I])=0 then begin
            result.Delete(I);
            MatchByAdditionalData.Delete(I);
          end else begin
            inc(I);
          end;
        end;
      finally
        MatchByAdditionalData.Free;
      end;
    end;
  finally
    PrgFiles.Free;
  end;
end;

Function GetTemplateFromFolder(const IsFolderScan : Boolean; Folder : String; const AutoSetupDB : TGameDB; var FileToStart : String; const StartableFiles : TStringList) : Integer;
Var MatchingTemplates,PrgFiles : TStringList;
    I,J,NewLevel : Integer;
begin
  result:=-1;

  PrgFiles:=TStringList.Create;
  try
    MatchingTemplates:=GetTemplateFromFolderExt(IsFolderScan,Folder,AutoSetupDB,PrgFiles);
    try
      If StartableFiles<>nil then begin StartableFiles.Clear; StartableFiles.AddStrings(PrgFiles); end;

      {If there is still more than one, let the user select the template to use}
      If MatchingTemplates.Count>0 then begin
        If IsFolderScan then begin
          J:=ShowSelectTemplateDialog(Application.MainForm,Folder,AutoSetupDB,MatchingTemplates);
        end else begin
          J:=ShowSelectTemplateDialog(Application.MainForm,'',AutoSetupDB,MatchingTemplates);
        end;
        If J>=0 then begin
          result:=Integer(MatchingTemplates.Objects[J]);
          FileToStart:=MatchingTemplates[J];
        end else begin
          result:=-2;
        end;
        exit;
      end;

      {Use defalt template on highest ranked PrgFile}
      NewLevel:=-1;
      For I:=0 to PrgFiles.Count-1 do begin
        J:=Integer(PrgFiles.Objects[I]);
        If (J>NewLevel) then begin NewLevel:=J; FileToStart:=PrgFiles[I] end;
      end;
    finally
      MatchingTemplates.Free;
    end;
  finally
    PrgFiles.Free;
  end;
end;

Function GetFolderForGame(const GameDir : String; const NewGameFolderSuggestion : String) : String;
Var I : Integer;
begin
  If NewGameFolderSuggestion='' then result:='Game' else result:=NewGameFolderSuggestion;

  If (not DirectoryExists(GameDir+result)) or PrgSetup.IgnoreDirectoryCollisions then exit;

  I:=1;
  repeat
    If not DirectoryExists(GameDir+result+IntToStr(I)) then begin result:=result+IntToStr(I); exit; end;
    inc(I);
  until False;
end;

Function OnlySubFolderCheck(const Dir : String) : String;
Var Rec : TSearchRec;
    I,Files,Folders : Integer;
    SubFolder : String;
begin
  result:=Dir;

  Files:=0; Folders:=0; SubFolder:='';
  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then inc(Files) else begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin inc(Folders); SubFolder:=Rec.Name; end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If (Files=0) and (Folders=1) and (SubFolder<>'') then result:=IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Dir)+SubFolder);
end;

Function AddGameFromSimpleFolder(Dir : String; const GameDB, TemplateDB, AutoSetupDB : TGameDB; const ProfileName, ProfileFolder, FileToStart, SetupFileToStart : String; const TemplateNr : Integer) : TGame;
Var GameDir,NewGameFolder,S : String;
    I,J : Integer;
    Rec : TSearchRec;
    G : TGame;
begin
  result:=nil;

  {Create folder for new game}
  GameDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  NewGameFolder:=GetFolderForGame(GameDir,ProfileFolder);
  ForceDirectories(GameDir+NewGameFolder);
  if not CopyFolderWithMsg(Dir,GameDir+NewGameFolder) then exit;

  {Create game DB record}
  I:=GameDB.Add(ProfileName); result:=GameDB[I];
  If TemplateNr<0 then begin
    If TemplateNr=-1 then begin
      G:=TGame.Create(PrgSetup); try result.AssignFrom(G); finally G.Free; end;
    end else begin
      result.AssignFrom(TemplateDB[-TemplateNr-2]);
    end;
  end else begin
    GameDB[I].AssignFrom(AutoSetupDB[TemplateNr]);
  end;
  result.ProfileMode:='DOSBox';
  result.Name:=ProfileName;
  result.GameExe:=MakeRelPath(GameDir+NewGameFolder+'\'+FileToStart,PrgSetup.BaseDir);
  If Trim(SetupFileToStart)<>'' then result.SetupExe:=MakeRelPath(GameDir+NewGameFolder+'\'+SetupFileToStart,PrgSetup.BaseDir);

  {Look for Icons in game folder}
  J:=FindFirst(GameDir+NewGameFolder+'\*.ico',faAnyFile,Rec);
  try
    If J=0 then result.Icon:=MakeRelPath(GameDir+NewGameFolder+'\'+Rec.Name,PrgSetup.BaseDir);
  finally
    FindClose(Rec);
  end;

  {Set capture directory}
  S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.CacheName)+'\';
  I:=0;
  While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
    inc(I); S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(result.CacheName)+IntToStr(I)+'\';
  end;
  result.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
  ForceDirectories(MakeAbsPath(result.CaptureFolder,PrgSetup.BaseDir));

  result.StoreAllValues;
  result.LoadCache;
end;

Function CreateGameFromSimpleFolder(Dir : String; const GameDB : TGameDB; const ArchiveFileName : String) : TGame;
Var AutoSetupDB,TemplateDB : TGameDB;
    StartableFiles, AutoSetup : TStringList;
    Nr : Integer;
    ProfileName,FileToStart,SetupFileToStart,ProfileFolder : String;
begin
  result:=nil;

  {If folder has only got some subfolder, use this}
  Dir:=OnlySubFolderCheck(Dir);

  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
  StartableFiles:=TStringList.Create;
  try
    AutoSetup:=GetTemplateFromFolderExt(False,Dir,AutoSetupDB,StartableFiles);
    If StartableFiles.Count=0 then begin MessageDlg(LanguageSetup.MessageZipImportError,mtError,[mbOK],0); exit; end;
    try
      TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
      try
        If not ShowSelectTemplateForZipImportDialog(Application.MainForm,AutoSetupDB,TemplateDB,StartableFiles,AutoSetup,ArchiveFileName,ProfileName,FileToStart,SetupFileToStart,ProfileFolder,Nr) then exit;
        result:=AddGameFromSimpleFolder(Dir,GameDB,TemplateDB,AutoSetupDB,ProfileName,ProfileFolder,FileToStart,SetupFileToStart,Nr);
        if result=nil then exit;
      finally
        TemplateDB.Free;
      end;
    finally
      AutoSetup.Free;
    end;
  finally
    AutoSetupDB.Free;
    StartableFiles.Free;
  end;
end;

Function CreateGameFromDFRPackageFolder(const Dir : String; const GameDB : TGameDB; const TempProfFile : String) : TGame;
Var ProfFile : String;
    I : Integer;
begin
  result:=nil;

  {Add profile}
  ProfFile:=PrgDataDir+GameListSubDir+'\'+ExtractFileName(TempProfFile);
  If FileExists(ProfFile) then begin
    I:=0;
    repeat inc(I); until not FileExists(ChangeFileExt(ProfFile,IntToStr(I)+'.prof'));
    ProfFile:=ChangeFileExt(ProfFile,IntToStr(I)+'.prof');
  end;
  If not CopyFileWithMsg(TempProfFile,ProfFile) then exit;

  result:=TGame.Create(ProfFile);
  GameDB.Add(result);

  {Add files}
  CopyFolderWithMsg(Dir,PrgSetup.BaseDir,result,True);
end;


Function CreateGameFromFolder(const Dir : String; const GameDB : TGameDB; const ArchivFileName : String) : TGame;
Var TempProfFile : String;
begin
  TempProfFile:=GetProfFileName(Dir);

  If TempProfFile='' then begin
    {Add simple zip archive}
    result:=CreateGameFromSimpleFolder(Dir,GameDB,ArchivFileName);
  end else begin
    {Add normal zip package (with prof file)}
    result:=CreateGameFromDFRPackageFolder(Dir,GameDB,TempProfFile);
  end;
end;

Function ImportZipPackage(const AOwner : TComponent; const AFileName : String; const AGameDB : TGameDB) : TGame;
Var Temp : String;
begin
  result:=nil;

  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  If not ForceDirectories(Temp) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Temp]),mtError,[mbOK],0);
    exit;
  end;

  try
    if not ExtractZipFile(AOwner,AFileName,Temp) then exit;
    result:=CreateGameFromFolder(Temp,AGameDB,AFileName);
    If result<>nil then begin
      result.StoreAllValues;
      result.LoadCache;
    end;
  finally
    ExtDeleteFolder(Temp,ftTemp);
  end;
end;

Procedure TempZipFilesStartCleanUp;
Var Temp : String;
begin
  Temp:=IncludeTrailingPathDelimiter(TempDir+TempSubFolder);
  ExtDeleteFolder(Temp,ftTemp);
end;

end.
