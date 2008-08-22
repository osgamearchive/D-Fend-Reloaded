unit ModernProfileEditorDirectoryFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDirectoryFrame = class(TFrame, IModernProfileEditorFrame)
    ScreenshotFolderEdit: TLabeledEdit;
    ScreenshotFolderEditButton: TSpeedButton;
    GenerateScreenshotFolderNameButton: TBitBtn;
    DataFolderEdit: TLabeledEdit;
    DataFolderEditButton: TSpeedButton;
    GenerateGameDataFolderNameButton: TBitBtn;
    ExtraDirsLabel: TLabel;
    ExtraDirsListBox: TListBox;
    ExtraDirsAddButton: TSpeedButton;
    ExtraDirsEditButton: TSpeedButton;
    ExtraDirsDelButton: TSpeedButton;
    ExtraDirsInfoLabel: TLabel;
    DataFolderInfoLabel: TLabel;
    Timer: TTimer;
    ExtraFilesLabel: TLabel;
    ExtraFilesListBox: TListBox;
    ExtraFilesAddButton: TSpeedButton;
    ExtraFilesEditButton: TSpeedButton;
    ExtraFilesDelButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExtraDirsListBoxClick(Sender: TObject);
    procedure ExtraDirsListBoxDblClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure GenerateScreenshotFolderNameButtonClick(Sender: TObject);
    procedure GenerateGameDataFolderNameButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ExtraFilesListBoxClick(Sender: TObject);
    procedure ExtraFilesListBoxDblClick(Sender: TObject);
    procedure ExtraFilesListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    FCurrentProfileName : PString;
    FLastCurrentProfileName : String;
    IsWindowsMode : Boolean;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     PrgConsts, GameDBToolsUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorDirectoryFrame }

procedure TModernProfileEditorDirectoryFrame.InitGUI(const InitData : TModernProfileEditorInitData);
begin
  NoFlicker(ScreenshotFolderEdit);
  NoFlicker(DataFolderEdit);
  NoFlicker(ExtraFilesListBox);
  NoFlicker(ExtraDirsListBox);

  FCurrentProfileName:=InitData.CurrentProfileName;

  ScreenshotFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorCaptureFolder;
  ScreenshotFolderEditButton.Hint:=LanguageSetup.ChooseFile;
  GenerateScreenshotFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateScreenshotFolderName;

  DataFolderEdit.EditLabel.Caption:=LanguageSetup.GameDataDir;
  DataFolderEditButton.Hint:=LanguageSetup.ChooseFile;
  DataFolderInfoLabel.Caption:=LanguageSetup.GameDataDirEditInfo;
  GenerateGameDataFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateGameDataFolder;

  ExtraFilesLabel.Caption:=LanguageSetup.ProfileEditorExtraFiles;
  ExtraFilesAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraFilesEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraFilesDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);

  ExtraDirsLabel.Caption:=LanguageSetup.ProfileEditorExtraDirs;
  ExtraDirsAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraDirsEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraDirsDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  ExtraDirsInfoLabel.Caption:=LanguageSetup.ProfileEditorExtraDirsEditInfo;

  OpenDialog.Title:=LanguageSetup.ProfileEditorExtraFilesCaption;
  OpenDialog.Filter:=LanguageSetup.ProfileEditorExtraFilesFilter;

  FLastCurrentProfileName:='';

  HelpContext:=ID_ProfileEditProgramDirectories;
end;

procedure TModernProfileEditorDirectoryFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
begin
  If Trim(Game.CaptureFolder)<>''
    then ScreenshotFolderEdit.Text:=Game.CaptureFolder
    else ScreenshotFolderEdit.Text:=MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir);
  If LoadFromTemplate and PrgSetup.AlwaysSetScreenshotFolderAutomatically then Timer.Enabled:=True;

  FLastCurrentProfileName:=FCurrentProfileName^;

  DataFolderEdit.Text:=Game.DataDir;

  St:=ValueToList(Game.ExtraFiles); try ExtraFilesListBox.Items.AddStrings(St); finally St.Free; end;
  If ExtraFilesListBox.Items.Count>0 then ExtraFilesListBox.ItemIndex:=0;
  ExtraFilesListBoxClick(nil);
  St:=ValueToList(Game.ExtraDirs); try ExtraDirsListBox.Items.AddStrings(St); finally St.Free; end;
  If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=0;
  ExtraDirsListBoxClick(nil);

  IsWindowsMode:=WindowsExeMode(Game);
end;

procedure TModernProfileEditorDirectoryFrame.ShowFrame;
begin
  If IsWindowsMode then begin
    ExtraFilesLabel.Visible:=False;
    ExtraFilesListBox.Visible:=False;
    ExtraFilesAddButton.Visible:=False;
    ExtraFilesEditButton.Visible:=False;
    ExtraFilesDelButton.Visible:=False;
    ExtraDirsLabel.Visible:=False;
    ExtraDirsListBox.Visible:=False;
    ExtraDirsAddButton.Visible:=False;
    ExtraDirsEditButton.Visible:=False;
    ExtraDirsDelButton.Visible:=False;
    ExtraDirsInfoLabel.Visible:=False;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.TimerTimer(Sender: TObject);
Var S,DefaultFolder,OldFolder : String;
begin
  If FLastCurrentProfileName=FCurrentProfileName^ then exit;

  S:=Trim(ExtUpperCase(ScreenshotFolderEdit.Text));

  DefaultFolder:=Trim(ExtUpperCase(MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir)));
  OldFolder:=Trim(ExtUpperCase('.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FLastCurrentProfileName)+'\'));

  If (S=DefaultFolder) or (S=OldFolder) then begin
    ScreenshotFolderEdit.Text:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
    FLastCurrentProfileName:=FCurrentProfileName^;
  end else begin
    Timer.Enabled:=False;
  end;
end;

function TModernProfileEditorDirectoryFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorDirectoryFrame.GetGame(const Game: TGame);
begin
  Game.CaptureFolder:=ScreenshotFolderEdit.Text;
  Game.DataDir:=DataFolderEdit.Text;
  Game.Extrafiles:=ListToValue(ExtraFilesListBox.Items);
  Game.ExtraDirs:=ListToValue(ExtraDirsListBox.Items);
  Timer.Enabled:=False;
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxClick(Sender: TObject);
begin
  ExtraDirsEditButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
  ExtraDirsDelButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraDirsEditButton);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraDirsAddButton);
    VK_RETURN : ButtonWork(ExtraDirsEditButton);
    VK_DELETE : ButtonWork(ExtraDirsDelButton);
  end;
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxClick(Sender: TObject);
begin
  ExtraFilesEditButton.Enabled:=(ExtraFilesListBox.ItemIndex>=0);
  ExtraFilesDelButton.Enabled:=(ExtraFilesListBox.ItemIndex>=0);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraFilesEditButton);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraFilesListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraFilesAddButton);
    VK_RETURN : ButtonWork(ExtraFilesEditButton);
    VK_DELETE : ButtonWork(ExtraFilesDelButton);
  end;
end;

procedure TModernProfileEditorDirectoryFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TSpeedButton).Tag of
    0 : begin
          S:=PrgSetup.BaseDir;
          If Trim(ScreenshotFolderEdit.Text)=''
            then S:=PrgSetup.BaseDir+CaptureSubDir+'\'
            else S:=MakeAbsPath(IncludeTrailingPathDelimiter(ScreenshotFolderEdit.Text),S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          ScreenshotFolderEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    1 : begin
          If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
          If Trim(DataFolderEdit.Text)<>'' then
            S:=MakeAbsPath(DataFolderEdit.Text,S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          DataFolderEdit.Text:=S;
        end;
    2 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          OpenDialog.InitialDir:=S;
          If not OpenDialog.Execute then exit;
          S:=OpenDialog.FileName;
          ExtraFilesListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir));
          ExtraFilesListBox.ItemIndex:=ExtraFilesListBox.Items.count-1;
          ExtraFilesListBoxClick(Sender);
        end;
    3 : begin
          S:=MakeAbsPath(ExtraFilesListBox.Items[ExtraFilesListBox.ItemIndex],PrgSetup.BaseDir);
          OpenDialog.InitialDir:=ExtractFilePath(S);
          If not OpenDialog.Execute then exit;
          S:=OpenDialog.FileName;
          ExtraFilesListBox.Items[ExtraFilesListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    4 : begin
          I:=ExtraFilesListBox.ItemIndex;
          if I<0 then exit;
          ExtraFilesListBox.Items.Delete(I);
          If ExtraFilesListBox.Items.Count>0 then ExtraFilesListBox.ItemIndex:=Max(0,I-1);
          ExtraFilesListBoxClick(Sender);
        end;
    5 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir));
          ExtraDirsListBox.ItemIndex:=ExtraDirsListBox.Items.count-1;
          ExtraDirsListBoxClick(Sender);
        end;
    6 : If ExtraDirsListBox.ItemIndex>=0 then begin
          S:=MakeAbsPath(ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex],PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    7 : begin
          I:=ExtraDirsListBox.ItemIndex;
          if I<0 then exit;
          ExtraDirsListBox.Items.Delete(I);
          If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=Max(0,I-1);
          ExtraDirsListBoxClick(Sender);
        end;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.GenerateScreenshotFolderNameButtonClick(Sender: TObject);
begin
  ScreenshotFolderEdit.Text:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
end;

procedure TModernProfileEditorDirectoryFrame.GenerateGameDataFolderNameButtonClick(Sender: TObject);
Var S,T : String;
begin
  If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
  S:=IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
  T:=MakeRelPath(S,PrgSetup.BaseDir);
  If T<>'' then DataFolderEdit.Text:=T;
  If DirectoryExists(S) then exit;
  If MessageDlg(Format(LanguageSetup.MessageConfirmationCreateDir,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  ForceDirectories(S);
end;

end.
