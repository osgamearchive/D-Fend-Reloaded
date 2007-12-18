unit TransferFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit, PrgSetupUnit,
  Menus;

type
  TTransferForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    DestPrgDirEdit: TLabeledEdit;
    DestPrgDirButton: TSpeedButton;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    MenuSelect: TMenuItem;
    MenuUnselect: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DestPrgDirButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Function GetOperationMode(var OpMode : TOperationMode) : Boolean;
    Function GetDestPrgDataDir(const OpMode : TOperationMode; var DestPrgDataDir : String) : Boolean;
    Function CopyDir(const SourceDir, DestDir : String) : Boolean;
    Function CopyFiles(const RelDir, SourceBaseDir, DestBaseDir : String) : Boolean;
    Function TransferGame(const Game : TGame; const DestDataDir : String) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  TransferForm: TTransferForm;

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     ProgressFormUnit;

{$R *.dfm}

procedure TTransferForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.TransferForm;
  InfoLabel.Caption:=LanguageSetup.TransferFormInfo;
  DestPrgDirEdit.EditLabel.Caption:=LanguageSetup.TransferFormDestPrgDir;
  DestPrgDirButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameByGenre;
  MenuSelect.Caption:=LanguageSetup.Select;
  MenuUnselect.Caption:=LanguageSetup.Unselect;
end;

procedure TTransferForm.FormShow(Sender: TObject);
Var I : Integer;
    St : TStringList;
    M : TMenuItem;
begin
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do If GameDB[I].Name<>DosBoxDOSProfile then St.AddObject(GameDB[I].Name,GameDB[I]);
    St.Sort;
    ListBox.Items.Assign(St);
    For I:=0 to ListBox.Items.Count-1 do ListBox.Checked[I]:=True;
  finally
    St.Free;
  end;

  St:=GameDB.GetGenreList(False);
  try
    For I:=0 to St.Count-1 do begin
      M:=TMenuItem.Create(self);
      M.Caption:=St[I];
      M.Tag:=3;
      M.OnClick:=SelectButtonClick;
      MenuSelect.Add(M);
      M:=TMenuItem.Create(self);
      M.Caption:=St[I];
      M.Tag:=4;
      M.OnClick:=SelectButtonClick;
      MenuUnselect.Add(M);
    end;
  finally
    St.Free;
  end;
end;

procedure TTransferForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
      2 : begin
            P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
            PopupMenu.Popup(P.X+5,P.Y+5);
          end;
    3,4 : For I:=0 to ListBox.Items.Count-1 do begin
            If ((RemoveUnderline(TMenuItem(Sender).Caption)=LanguageSetup.NotSet) and (TGame(ListBox.Items.Objects[I]).Genre=''))
            or (RemoveUnderline(TMenuItem(Sender).Caption)=TGame(ListBox.Items.Objects[I]).Genre) then ListBox.Checked[I]:=((Sender as TComponent).Tag=3);
          end;
  end;
end;

procedure TTransferForm.DestPrgDirButtonClick(Sender: TObject);
Var S : String;
begin
  S:=DestPrgDirEdit.Text;
  if SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then DestPrgDirEdit.Text:=S;
end;

function TTransferForm.GetOperationMode(var OpMode: TOperationMode): Boolean;
Var S : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;

  S:=Trim(DestPrgDirEdit.Text);
  If S='' then begin
    MessageDlg(LanguageSetup.MessageNoInstallationSelected,mtError,[mbOK],0);
    exit;
  end;

  result:=True;
  OpMode:=omPrgDir;

  S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OperationModeConfig);
  If not FileExists(S) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(S); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OpMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OpMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OpMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

function TTransferForm.GetDestPrgDataDir(const OpMode: TOperationMode; var DestPrgDataDir: String): Boolean;
Var S : String;
    LocalPrgSetup : TPrgSetup;
    SaveOpMode : TOperationMode;
begin
  result:=False;

  If OpMode=omUserDir then begin
    S:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    S:=IncludeTrailingPathDelimiter(Trim(DestPrgDirEdit.Text));
  end;

  S:=S+ExtractFileName(MainSetupFile);
  if not FileExists(S) then begin
    MessageDlg(Format(LanguageSetup.MessageNoSetupFileFound,[ExtractFilePath(S)]),mtError,[mbOK],0);
    exit;
  end;

  result:=True;

  SaveOpMode:=OperationMode;
  OperationMode:=OpMode;
  TempPrgDir:=IncludeTrailingPathDelimiter(ExtractFilePath(S));
  LocalPrgSetup:=TPrgSetup.Create(S);
  try
    DestPrgDataDir:=LocalPrgSetup.BaseDir;
  finally
    LocalPrgSetup.Free;
    OperationMode:=SaveOpMode;
    TempPrgDir:='';
  end;
end;

function TTransferForm.CopyDir(const SourceDir, DestDir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;

  if not ForceDirectories(DestDir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestDir]),mtError,[mbOK],0);
    exit;
  end;

  I:=FindFirst(SourceDir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If Rec.Name[1]<>'.' then begin
          if not CopyDir(SourceDir+Rec.Name+'\',DestDir+Rec.Name+'\') then exit;
        end;
      end else begin
        if not CopyFile(PChar(SourceDir+Rec.Name),PChar(DestDir+Rec.Name),False) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[SourceDir+Rec.Name,DestDir+Rec.Name]),mtError,[mbOK],0); exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  result:=True;
end;

function TTransferForm.CopyFiles(const RelDir, SourceBaseDir, DestBaseDir: String): Boolean;
Var S,T : String;
begin
  S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),SourceBaseDir));
  T:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),DestBaseDir));
  result:=CopyDir(S,T);
end;

function TTransferForm.TransferGame(const Game: TGame; const DestDataDir: String): Boolean;
Var S : String;
    I : Integer;
    St : TStringList;
begin
  result:=False;
  Game.StoreAllValues;

  S:=DestDataDir+GameListSubDir+'\'+ExtractFileName(Game.SetupFile);
  If FileExists(S) then begin
    I:=0;
    repeat inc(I); until not FileExists(ChangeFileExt(S,IntToStr(I)+'.conf'));
    S:=ChangeFileExt(S,IntToStr(I)+'.conf');
  end;
  if not CopyFile(PChar(Game.SetupFile),PChar(S),True) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Game.SetupFile,S]),mtError,[mbOK],0); exit;
  end;
  
  S:=Trim(Game.GameExe);
  If S='' then S:=Trim(Game.SetupExe);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(ExtractFilePath(S));
    if not CopyFiles(S,PrgDataDir,DestDataDir) then exit;
  end;

  S:=Trim(Game.CaptureFolder);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(S);
    if not CopyFiles(S,PrgDataDir,DestDataDir) then exit;
  end;

  S:=Trim(Game.Icon);
  If (S<>'') and FileExists(PrgDataDir+IconsSubDir+'\'+S) then begin
    if not CopyFile(PChar(PrgDataDir+IconsSubDir+'\'+S),PChar(DestDataDir+IconsSubDir+'\'+S),False) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[PrgDataDir+IconsSubDir+'\'+S,DestDataDir+IconsSubDir+'\'+S]),mtError,[mbOK],0); exit;
      exit;
    end;
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(S);
    if not CopyFiles(S,PrgDataDir,DestDataDir) then exit;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=IncludeTrailingPathDelimiter(St[I]);
        if not CopyFiles(S,PrgDataDir,DestDataDir) then exit;
      end;
    finally
      St.Free;
    end;
  end;

  result:=True;
end;

procedure TTransferForm.OKButtonClick(Sender: TObject);
Var OpMode : TOperationMode;
    DestPrgDataDir : String;
    I,J : Integer;
begin
  If not GetOperationMode(OpMode) then begin ModalResult:=mrNone; exit; end;
  if not GetDestPrgDataDir(OpMode,DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;

  J:=0; For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then inc(J);
  InitProgressWindow(self,J);
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
      StepProgressWindow;
      if not TransferGame(TGame(ListBox.Items.Objects[I]),DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;
    end;
  finally
    DoneProgressWindow;
  end;
end;

{ global }

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  TransferForm:=TTransferForm.Create(AOwner);
  try
    TransferForm.GameDB:=AGameDB;
    result:=(TransferForm.ShowModal=mrOK);
  finally
    TransferForm.Free;
  end;
end;


end.
