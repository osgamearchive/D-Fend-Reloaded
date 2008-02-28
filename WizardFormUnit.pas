unit WizardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls, GameDBUnit;

type
  TWizardForm = class(TForm)
    PageControl: TPageControl;
    BaseSheet: TTabSheet;
    InfoSheet: TTabSheet;
    SystemSheet: TTabSheet;
    BaseName: TLabeledEdit;
    GamesFolderEdit: TLabeledEdit;
    GamesFolderButton: TSpeedButton;
    ProgramEdit: TLabeledEdit;
    SetupEdit: TLabeledEdit;
    ProgramButton: TSpeedButton;
    SetupButton: TSpeedButton;
    GameInfoValueListEditor: TValueListEditor;
    NotesLabel: TLabel;
    NotesMemo: TMemo;
    NextButton: TBitBtn;
    PreviousButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    OpenDialog: TOpenDialog;
    BaseInfoLabel1: TLabel;
    BaseInfoLabel2: TLabel;
    BaseInfoLabel3: TLabel;
    BaseDataFolderEdit: TLabeledEdit;
    DataFolderEdit: TLabeledEdit;
    DataFolderButton: TSpeedButton;
    BaseDataFolderButton: TSpeedButton;
    StartFullscreenCheckBox: TCheckBox;
    CloseDosBoxOnExitCheckBox: TCheckBox;
    CPULabel: TLabel;
    CPUComboBox: TComboBox;
    MoreRAMCheckBox: TCheckBox;
    DriveSetupLabel: TLabel;
    DriveSetupCheckBox: TCheckBox;
    DriveSetupList: TListView;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure StepButtonWork(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game, LoadTemplate : TGame;
  end;

var
  WizardForm: TWizardForm;

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; var OpenEditorNow : Boolean) : Boolean;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, CommonTools,
     PrgConsts;

{$R *.dfm}

procedure TWizardForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.WizardForm;

  BaseSheet.Caption:=LanguageSetup.WizardFormBaseSheet;
  InfoSheet.Caption:=LanguageSetup.WizardFormInfoSheet;
  SystemSheet.Caption:=LanguageSetup.WizardFormSystemSheet;

  BaseInfoLabel1.Caption:=LanguageSetup.WizardFormInfoLabel1;
  BaseInfoLabel2.Caption:=LanguageSetup.WizardFormInfoLabel2;
  BaseInfoLabel3.Caption:=LanguageSetup.WizardFormInfoLabel3;
  BaseName.EditLabel.Caption:=LanguageSetup.WizardFormBaseName;
  GamesFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormGamesFolder;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.WizardFormProgram;
  SetupEdit.EditLabel.Caption:=LanguageSetup.WizardFormSetup;
  BaseDataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormBaseDataFolder;
  DataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormDataFolder;

  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  CloseDosBoxOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  MoreRAMCheckBox.Caption:=LanguageSetup.WizardFormMoreRAM;
  CPULabel.Caption:=LanguageSetup.WizardFormCPU;
  CPUComboBox.Items[0]:=LanguageSetup.WizardFormCPUType1;
  CPUComboBox.Items[1]:=LanguageSetup.WizardFormCPUType2;
  CPUComboBox.Items[2]:=LanguageSetup.WizardFormCPUType3;
  CPUComboBox.Items[3]:=LanguageSetup.WizardFormCPUType4;
  DriveSetupLabel.Caption:=LanguageSetup.WizardFormDriveSetupLabel;
  DriveSetupCheckBox.Caption:=LanguageSetup.WizardFormDriveSetupCheckBox;

  PreviousButton.Caption:=LanguageSetup.WizardFormButtonPrevious;
  NextButton.Caption:=LanguageSetup.WizardFormButtonNext;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  GamesFolderEdit.Text:=PrgSetup.GameDir;
  BaseDataFolderEdit.Text:=PrgSetup.DataDir;

  PageControl.ActivePageIndex:=0;
end;

procedure LoadMountingList(const Drive : String; const MountingListView : TListView);
Var St : TStringList;
    L : TListItem;
    S : String;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    St:=ValueToList(Drive);
    try
      L:=MountingListView.Items.Add;
      S:=Trim(St[0]);
      If (St.Count>1) and (Trim(ExtUpperCase(St[1]))='PHYSFS') then begin
        If Pos('$',S)<>0 then S:=Copy(S,Pos('$',S)+1,MaxInt)+' (+ '+Copy(S,1,Pos('$',S)-1)+')';
      end else begin
        If Pos('$',S)<>0 then S:=Copy(S,1,Pos('$',S)-1)+' (+'+LanguageSetup.More+')';
      end;
      L.Caption:=S;
      If St.Count>1 then L.SubItems.Add(St[1]) else L.SubItems.Add('');
      If St.Count>2 then L.SubItems.Add(St[2]) else L.SubItems.Add('');
      If St.Count>4 then L.SubItems.Add(St[4]) else L.SubItems.Add('');
      If St.Count>3 then begin
        If Trim(ExtUpperCase(St[3]))='TRUE' then L.SubItems.Add(RemoveUnderline(LanguageSetup.Yes)) else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
      end else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
    finally
      St.Free;
    end;
  finally
    MountingListView.Items.EndUpdate;
  end;
end;

procedure TWizardForm.FormShow(Sender: TObject);
Var St : TStringList;
    L : TListColumn;
begin
  GameInfoValueListEditor.TitleCaptions.Clear;
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GameInfoValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameGenre+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetGenreList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameDeveloper+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetDeveloperList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePublisher+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetPublisherList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameYear+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetYearList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameLanguage+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetLanguageList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameWWW+'=');
    Strings.Add(LanguageSetup.GameFavorite+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;
  NotesLabel.Caption:=LanguageSetup.GameNotes+':';

  GameInfoValueListEditor.Strings.ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);

  CPUComboBox.ItemIndex:=1;

  L:=DriveSetupList.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingFolderImage;
  L:=DriveSetupList.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingAs;
  L:=DriveSetupList.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLetter;
  L:=DriveSetupList.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLabel;
  L:=DriveSetupList.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingIOControl;
  LoadMountingList(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;;',DriveSetupList);
end;

procedure TWizardForm.PageControlChange(Sender: TObject);
begin
  PreviousButton.Enabled:=(PageControl.ActivePageIndex>0);
  NextButton.Enabled:=(PageControl.ActivePageIndex<2);
  OKButton.Enabled:=(PageControl.ActivePageIndex=2);
end;

procedure TWizardForm.StepButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : PageControl.ActivePageIndex:=PageControl.ActivePageIndex-1;
    1 : PageControl.ActivePageIndex:=PageControl.ActivePageIndex+1;
  end;
  PageControlChange(Sender);
end;

procedure TWizardForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : ShellExecute(Handle,'explore',PChar(GamesFolderEdit.Text),nil,PChar(GamesFolderEdit.Text),SW_SHOW);
    1 : begin
          S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(ProgramEdit.Text)='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          ProgramEdit.Text:=S;
        end;
    2 : begin
          S:=MakeAbsPath(SetupEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(SetupEdit.Text)='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          SetupEdit.Text:=S;
        end;
    3 : ShellExecute(Handle,'explore',PChar(BaseDataFolderEdit.Text),nil,PChar(BaseDataFolderEdit.Text),SW_SHOW);
    4 : begin
          If Trim(DataFolderEdit.Text)=''
            then S:=PrgSetup.DataDir
            else S:=MakeAbsPath(DataFolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          S:=DataFolderEdit.Text;
        end;
  end;
end;

procedure TWizardForm.OKButtonClick(Sender: TObject);
begin
  Game:=GameDB[GameDB.Add(BaseName.Text)];
  Game.AssignFrom(LoadTemplate);
  Game.Name:=BaseName.Text;

  Game.GameExe:=ProgramEdit.Text;
  Game.SetupExe:=SetupEdit.Text;
  Game.DataDir:=DataFolderEdit.Text;

  with GameInfoValueListEditor.Strings do begin
    Game.Genre:=ValueFromIndex[0];
    Game.Developer:=ValueFromIndex[1];
    Game.Publisher:=ValueFromIndex[2];
    Game.Year:=ValueFromIndex[3];
    Game.Language:=ValueFromIndex[4];
    Game.WWW:=ValueFromIndex[5];
    Game.Favorite:=(ValueFromIndex[6]=RemoveUnderline(LanguageSetup.Yes));
  end;
  Game.Notes:=StringListToString(NotesMemo.Lines);

  Game.StartFullscreen:=StartFullscreenCheckBox.Checked;
  Game.CloseDosBoxAfterGameExit:=CloseDosBoxOnExitCheckBox.Checked;
  if MoreRAMCheckBox.Checked then Game.Memory:=63;
  Case CPUComboBox.ItemIndex of
    0 : begin Game.Core:='auto'; Game.Cycles:='auto'; end;
  end;

  If Game.NrOfMounts=0 then begin
    Game.NrOfMounts:=1;
    Game.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;;';
  end;

  Game.CaptureFolder:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(Game.Name);
end;

{ global }

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; var OpenEditorNow : Boolean) : Boolean;
begin
  WizardForm:=TWizardForm.Create(AOwner);
  try
    WizardForm.GameDB:=AGameDB;
    WizardForm.Game:=AGame;
    WizardForm.LoadTemplate:=ADefaultGame;
    result:=(WizardForm.ShowModal=mrOK);
    if result then begin
      AGame:=WizardForm.Game;
      OpenEditorNow:=WizardForm.DriveSetupCheckBox.Checked;
    end;
  finally
    WizardForm.Free;
  end;
end;

end.
