unit UninstallFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit, CommonTools;

type
  TUninstallForm = class(TForm)
    ListBox: TCheckListBox;
    Panel1: TPanel;
    InfoLabel: TLabel;
    Panel2: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DirList : TStringList;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
  end;

var
  UninstallForm: TUninstallForm;

Function UninstallGame(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame) : Boolean;

Function DeleteSingleFile(const FileName: String; var ContinueNext : Boolean; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean;
Function DeleteDir(const Dir: String; var ContinueNext : Boolean; const DeletePrgSetupRecord : String ='') : Boolean;
Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;
Function IconUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Icon: String): Boolean;
Function ExtraFileUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; ExtraFile: String): Boolean;

Procedure FileAndFoldersFromDrives(const Game : TGame; var Files, Folders : TStringList);
Procedure UnusedFileAndFoldersFromDrives(const GameDB : TGameDB; const Game : TGame; var Files, Folders : TStringList);

implementation

uses VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts,
     GameDBToolsUnit, HelpConsts;

{$R *.dfm}

procedure TUninstallForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.UninstallForm;
  InfoLabel.Caption:=LanguageSetup.UninstallFormLabel;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;

  DirList:=nil;
end;

procedure TUninstallForm.FormShow(Sender: TObject);
Var S : String;
    St, Files, Folders : TStringList;
    I : Integer;
    B : Boolean;
begin
  DirList:=TStringList.Create;

  ListBox.Items.Add(LanguageSetup.UninstallFormProfileRecord+': '+Game.Name);
  DirList.Add('');

  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
      S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
      ListBox.Items.Add(LanguageSetup.UninstallFormProgramDir+': '+S);
      DirList.Add(S);
    end;
    S:=Trim(Game.ScummVMZip);
    If (S<>'') and (not ExtraFileUsedByOtherGame(GameDB,Game,S)) then begin
      S:=MakeAbsPath(S,PrgSetup.BaseDir);
      ListBox.Items.Add(LanguageSetup.UninstallFormExtraFile+': '+S);
      DirList.AddObject(S,TObject(1)); {TObject(1) = is file not folder}
    end;
    S:=Trim(Game.ScummVMSavePath);
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
      S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
      ListBox.Items.Add(LanguageSetup.UninstallFormSaveDir+': '+S);
      DirList.Add(S);
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,S)) then begin
      ListBox.Items.Add(LanguageSetup.UninstallFormProgramDir+': '+S);
      DirList.Add(S);
    end;
  end;

  S:=Trim(Game.CaptureFolder);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
    S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormCaptureFolder+': '+S);
    DirList.Add(S);
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) and (not IconUsedByOtherGame(GameDB,Game,S)) then begin
    ListBox.Items.Add(LanguageSetup.UninstallFormIcon+': '+S);
    DirList.AddObject(S,TObject(1)); {TObject(1) = is file not folder}
  end;

  S:=Trim(Game.DataDir);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
    S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormDataDir+': '+S);
    DirList.Add(S);
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If (Trim(St[I])<>'') and (not ExtraFileUsedByOtherGame(GameDB,Game,St[I])) then begin
        S:=MakeAbsPath(St[I],PrgSetup.BaseDir);
        ListBox.Items.Add(LanguageSetup.UninstallFormExtraFile+': '+S);
        DirList.AddObject(S,TObject(1)); {TObject(1) = is file not folder}
      end;
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If (Trim(St[I])<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(St[I]))) then begin
        S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir));
        ListBox.Items.Add(LanguageSetup.UninstallFormExtraDir+': '+S);
        DirList.Add(S);
      end;
    finally
      St.Free;
    end;
  end;

  UnusedFileAndFoldersFromDrives(GameDB,Game,Files,Folders);
  try
    For I:=0 to Files.Count-1 do begin
      S:=Files[I];
      ListBox.Items.Add(LanguageSetup.UninstallFormExtraFile+': '+S);
      DirList.AddObject(S,TObject(1)); {TObject(1) = is file not folder}
    end;
    For I:=0 to Folders.Count-1 do begin
      S:=Folders[I];
      ListBox.Items.Add(LanguageSetup.UninstallFormExtraDir+': '+S);
      DirList.Add(S);
    end;
  finally
    Files.Free;
    Folders.Free;
  end;

  For I:=0 to ListBox.Items.Count-1 do ListBox.Checked[I]:=True; 
end;

procedure TUninstallForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    ContinueNext : Boolean;
begin
  SetCurrentDir(PrgDataDir);

  For I:=1 to ListBox.Count-1 do If ListBox.Checked[I] then begin
    If Integer(DirList.Objects[I])<>0 then begin
      If (not DeleteSingleFile(DirList[I],ContinueNext,ftUninstall)) and (not ContinueNext) then exit;
    end else begin
      If (not DeleteDir(DirList[I],ContinueNext)) and (not ContinueNext) then exit;
    end;
  end;

  If ListBox.Checked[0] then GameDB.Delete(Game);
end;

procedure TUninstallForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
end;

procedure TUninstallForm.FormDestroy(Sender: TObject);
begin
  DirList.Free;
end;

procedure TUninstallForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileUninstall);
end;

procedure TUninstallForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function UninstallGame(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame) : Boolean;
begin
  If WindowsExeMode(AGame) then begin result:=False; exit; end;

  UninstallForm:=TUninstallForm.Create(AOwner);
  try
    UninstallForm.GameDB:=AGameDB;
    UninstallForm.Game:=AGame;
    result:=(UninstallForm.ShowModal=mrOK);
  finally
    UninstallForm.Free;
  end;
end;

Function DeleteSingleFile(const FileName: String; var ContinueNext : Boolean; const FileType : TDeleteFileType; const DeletePrgSetupRecord : String ='') : Boolean;
begin
  result:=False;
  repeat
    if not ExtDeleteFile(FileName,FileType,DeletePrgSetupRecord) then begin
      Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
        mrIgnore : begin ContinueNext:=True; exit; end;
        mrRetry : ;
        else exit;
      End;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;

Function DeleteDir(const Dir: String; var ContinueNext : Boolean; const DeletePrgSetupRecord : String ='') : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    S : String;
begin
  If DeletePrgSetupRecord='' then begin
    S:=Copy(PrgSetup.DeleteToRecycleBin,1,7);
    S:=S+Copy('1011110',length(S)+1,MaxInt);
  end else begin
    S:=DeletePrgSetupRecord;
  end;

  result:=False;
  ContinueNext:=False;

  If not DirectoryExists(Dir) then begin result:=True; exit; end;

  If PrgSetup.DeleteOnlyInBaseDir and (ExtUpperCase(Copy(Dir,1,length(PrgSetup.BaseDir)))<>ExtUpperCase(PrgSetup.BaseDir)) then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorProtection,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  If Pos('..',Dir)<>0 then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorDotDotInPath,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  If S[Integer(ftUninstall)+1]='1' then begin
    result:=DeleteFileToRecycleBin(Dir);
    exit;
  end;

  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      if (Rec.Attr and faDirectory)=faDirectory then begin
        If Rec.Name[1]<>'.' then begin
          if not DeleteDir(Dir+Rec.Name+'\',ContinueNext,S) then exit;
        end;
      end else begin
        if not DeleteSingleFile(Dir+Rec.Name,ContinueNext,ftUninstall,S) then exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  repeat
    if not ExtDeleteFolder(Dir,ftUninstall) then begin
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

Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;
Function SameDir(S : String) : Boolean;
begin
  If Trim(S)='' then begin result:=False; exit; end;
  If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then begin result:=False; exit; end;
  S:=Trim(ExtUpperCase(ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir))));
  result:=(Copy(S,1,length(Dir))=Dir);
end;
Var I,J : Integer;
    St,Files,Folders : TStringList;
begin
  Dir:=Trim(ExtUpperCase(ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(Dir),PrgSetup.BaseDir))));

  result:=True;

  For I:=0 to GameDB.Count-1 do begin
    If GameDB[I]=Game then continue;

    If ScummVMMode(GameDB[I]) then begin
      If SameDir(GameDB[I].ScummVMPath) then exit;
      If SameDir(GameDB[I].CaptureFolder) then exit;
    end else begin
      If SameDir(GameDB[I].GameExe) then exit;
      If SameDir(GameDB[I].SetupExe) then exit;
      If SameDir(GameDB[I].CaptureFolder) then exit;

      FileAndFoldersFromDrives(GameDB[I],Files,Folders);
      try
        For J:=0 to Folders.Count-1 do If SameDir(Folders[J]) then exit;
      finally
        Files.Free;
        Folders.Free;
      end;
    end;
    If SameDir(GameDB[I].DataDir) then exit;

    St:=ValueToList(GameDB[I].ExtraDirs);
    try
      For J:=0 to St.Count-1 do If SameDir(St[J]) then exit;
    finally
      St.Free;
    end;
  end;

  result:=False;
end;

Function IconUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Icon: String): Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  S:=Trim(ExtUpperCase(Icon));
  For I:=0 to GameDB.Count-1 do If GameDB[I]<>Game then
    If Trim(ExtUpperCase(MakeAbsIconName(GameDB[I].Icon)))=S then begin result:=True; exit; end;
end;

Function ExtraFileUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; ExtraFile: String): Boolean;
Function SameFile(S : String) : Boolean;
begin
  result:=(Trim(S)<>'') and (Trim(ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir)))=ExtraFile);
end;
Var I,J : Integer;
    St, Files, Folders : TStringList;
    S : String;
begin
  result:=True;

  ExtraFile:=Trim(ExtUpperCase(MakeAbsPath(ExtraFile,PrgSetup.BaseDir)));
  For I:=0 to GameDB.Count-1 do begin
    If GameDB[I]=Game then continue;

    St:=ValueToList(GameDB[I].ExtraFiles);
    try
      For J:=0 to St.Count-1 do If SameFile(St[J]) then exit;
    finally
      St.Free;
    end;

    If (not ScummVMMode(GameDB[I])) and (not WindowsExeMode(GameDB[I])) then begin
      FileAndFoldersFromDrives(GameDB[I],Files,Folders);
      try
        For J:=0 to Files.Count-1 do If SameFile(Files[J]) then exit;
      finally
        Files.Free;
        Folders.Free;
      end;
    end;

    If ScummVMMode(GameDB[I]) and SameFile(GameDB[I].ScummVMZip) then exit;
  end;

  result:=False;
end;

Procedure FileAndFoldersFromDrives(const Game : TGame; var Files, Folders : TStringList);
Var I,J : Integer;
    S,T : String;
    St,St2 : TStringList;
begin
  Files:=TStringList.Create;
  Folders:=TStringList.Create;

  For I:=0 to 9 do begin
    S:=Game.Mount[I];
    If S='' then continue;

    St:=ValueToList(S);
    St2:=TStringList.Create;
    try
      If St.Count<2 then continue;

      S:=Trim(St[0]); J:=Pos('$',S);
      While J>0 do begin St2.Add(Trim(Copy(S,1,J-1))); S:=Trim(Copy(S,J+1,MaxInt)); J:=Pos('$',S); end;
      St2.Add(S);

      S:=Trim(ExtUpperCase(St[1]));

      If (S='CDROMIMAGE') or (S='FLOPPYIMAGE') or (S='IMAGE') then begin
        {Image files}
        For J:=0 to St2.Count-1 do begin
          T:=MakeAbsPath(St2[J],PrgSetup.BaseDir);
          If FileExists(T) then Files.Add(T);
        end;
      end;

      If (S='PHYSFS') and (St2.Count=2) then begin
        {RealFolder$ZipFile in St2}
        T:=MakeAbsPath(IncludeTrailingPathDelimiter(St2[0]),PrgSetup.BaseDir);
        If DirectoryExists(T) then Folders.Add(T);
        T:=MakeAbsPath(St2[1],PrgSetup.BaseDir);
        If FileExists(T) then Files.Add(T);
      end;

      If (S='ZIP') and (St2.Count=2) then begin
        {RealFolder$ZipFile in St2, only add ZipFile}
        T:=MakeAbsPath(St2[1],PrgSetup.BaseDir);
        If FileExists(T) then Files.Add(T);
      end;
    finally
      St.Free;
      St2.Free;
    end;
  end;
end;

Procedure UnusedFileAndFoldersFromDrives(const GameDB : TGameDB; const Game : TGame; var Files, Folders : TStringList);
Var I : Integer;
begin
  FileAndFoldersFromDrives(Game,Files,Folders);

  I:=0;
  While I<Files.Count do begin
    If ExtraFileUsedByOtherGame(GameDB,Game,Files[I]) then begin Files.Delete(I); continue; end;
    inc(I);
  end;

  I:=0;
  While I<Folders.Count do begin
    If UsedByOtherGame(GameDB,Game,Folders[I]) then begin Folders.Delete(I); continue; end;
    inc(I);
  end;
end;

end.
