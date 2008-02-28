unit SetupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus, CheckLst, Spin,
  ImgList, GameDBUnit;

type
  TSetupForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PageControl: TPageControl;
    GeneralSheet: TTabSheet;
    DefaultValueSheet: TTabSheet;
    ServiceSheet: TTabSheet;
    DefaultValueLabel: TLabel;
    DefaultValueComboBox: TComboBox;
    DefaultValueSpeedButton: TSpeedButton;
    DefaultValuePopupMenu: TPopupMenu;
    PopupThisValue: TMenuItem;
    PopupAllValues: TMenuItem;
    Service1Button: TBitBtn;
    Service2Button: TBitBtn;
    DefaultValueMemo: TRichEdit;
    DosBoxSheet: TTabSheet;
    DosBoxDirEdit: TLabeledEdit;
    DosBoxButton: TSpeedButton;
    FindDosBoxButton: TSpeedButton;
    DosBoxLngOpenDialog: TOpenDialog;
    HideDosBoxConsoleCheckBox: TCheckBox;
    MinimizeDFendCheckBox: TCheckBox;
    MinimizeToTrayCheckBox: TCheckBox;
    LanguageSheet: TTabSheet;
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    DosBoxLangLabel: TLabel;
    SecuritySheet: TTabSheet;
    AskBeforeDeleteCheckBox: TCheckBox;
    DeleteProectionCheckBox: TCheckBox;
    DeleteProectionLabel: TLabel;
    ListViewSheet: TTabSheet;
    DosBoxLangEditComboBox: TComboBox;
    Service3Button: TBitBtn;
    Service4Button: TBitBtn;
    DosBoxMapperEdit: TLabeledEdit;
    DosBoxMapperButton: TSpeedButton;
    DosBoxTxtOpenDialog: TOpenDialog;
    SDLVideodriverLabel: TLabel;
    SDLVideoDriverComboBox: TComboBox;
    SDLVideodriverInfoLabel: TLabel;
    AddButtonFunctionLabel: TLabel;
    AddButtonFunctionComboBox: TComboBox;
    StartWithWindowsCheckBox: TCheckBox;
    PathFREEDOSEdit: TLabeledEdit;
    PathFREEDOSButton: TSpeedButton;
    PrgOpenDialog: TOpenDialog;
    ImageList: TImageList;
    DirectorySheet: TTabSheet;
    BaseDirEdit: TLabeledEdit;
    BaseDirButton: TSpeedButton;
    GameDirEdit: TLabeledEdit;
    GameDirButton: TSpeedButton;
    DataDirEdit: TLabeledEdit;
    DataDirButton: TSpeedButton;
    StartSizeLabel: TLabel;
    StartSizeComboBox: TComboBox;
    ProfileEditorSheet: TTabSheet;
    ReopenLastActiveProfileSheetCheckBox: TCheckBox;
    ProfileEditorDFendRadioButton: TRadioButton;
    ProfileEditorModernRadioButton: TRadioButton;
    PageControl1: TPageControl;
    ListViewSheet1: TTabSheet;
    ListViewSheet2: TTabSheet;
    ListViewSheet3: TTabSheet;
    ListViewSheet4: TTabSheet;
    ListViewListBox: TCheckListBox;
    ListViewLabel: TLabel;
    ListViewUpButton: TSpeedButton;
    ListViewDownButton: TSpeedButton;
    ColDefaultValueSpeedButton: TSpeedButton;
    ScreenshotPreviewLabel: TLabel;
    ScreenshotPreviewEdit: TSpinEdit;
    GamesListBackgroundRadioButton1: TRadioButton;
    GamesListBackgroundRadioButton2: TRadioButton;
    GamesListBackgroundRadioButton3: TRadioButton;
    GamesListBackgroundColorBox: TColorBox;
    GamesListBackgroundEdit: TEdit;
    GamesListBackgroundButton: TSpeedButton;
    GamesListFontSizeLabel: TLabel;
    GamesListFontSizeEdit: TSpinEdit;
    GamesListFontColorLabel: TLabel;
    GamesListFontColorBox: TColorBox;
    ScreenshotsListBackgroundRadioButton2: TRadioButton;
    ScreenshotsListBackgroundColorBox: TColorBox;
    ScreenshotsListBackgroundRadioButton3: TRadioButton;
    ScreenshotsListBackgroundEdit: TEdit;
    ScreenshotsListBackgroundButton: TSpeedButton;
    ScreenshotsListFontSizeLabel: TLabel;
    ScreenshotsListFontSizeEdit: TSpinEdit;
    ScreenshotsListFontColorLabel: TLabel;
    ScreenshotsListFontColorBox: TColorBox;
    ScreenshotsListBackgroundRadioButton1: TRadioButton;
    TreeViewBackgroundColorBox: TColorBox;
    TreeViewBackgroundRadioButton2: TRadioButton;
    TreeViewBackgroundRadioButton1: TRadioButton;
    TreeViewFontSizeLabel: TLabel;
    TreeViewFontSizeEdit: TSpinEdit;
    TreeViewFontColorLabel: TLabel;
    TreeViewFontColorBox: TColorBox;
    ImageOpenDialog: TOpenDialog;
    ToolbarGroupBox: TGroupBox;
    ToolbarImageEdit: TEdit;
    ToolbarFontSizeLabel: TLabel;
    ToolbarFontSizeEdit: TSpinEdit;
    ToolbarImageButton: TSpeedButton;
    ToolbarImageCheckBox: TCheckBox;
    TreeViewGroupsLabel: TLabel;
    TreeViewGroupsEdit: TMemo;
    TreeViewGroupsInfoLabel: TLabel;
    ModeComboBox: TComboBox;
    ModeLabel: TLabel;
    WaveEncSheet: TTabSheet;
    WaveEncMp3Edit: TLabeledEdit;
    WaveEncMp3Button1: TSpeedButton;
    WaveEncMp3Button2: TSpeedButton;
    WaveEncOggEdit: TLabeledEdit;
    WaveEncOggButton1: TSpeedButton;
    WaveEncOggButton2: TSpeedButton;
    UpdateGroupBox: TGroupBox;
    UpdateLabel: TLabel;
    Update3RadioButton: TRadioButton;
    Update2RadioButton: TRadioButton;
    Update1RadioButton: TRadioButton;
    Update0RadioButton: TRadioButton;
    LanguageInfoLabel: TLabel;
    CenterDOSBoxCheckBox: TCheckBox;
    AutoSetScreenshotFolderRadioGroup: TRadioGroup;
    NotSetGroupBox: TGroupBox;
    NotSetRadioButton1: TRadioButton;
    NotSetRadioButton2: TRadioButton;
    NotSetRadioButton3: TRadioButton;
    NotSetEdit: TEdit;
    LanguageOpenEditor: TBitBtn;
    LanguageNew: TBitBtn;
    InstallerLangEditComboBox: TComboBox;
    InstallerLangLabel: TLabel;
    Timer: TTimer;
    InstallerLangInfoLabel: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DefaultValueComboBoxChange(Sender: TObject);
    procedure DefaultValueSpeedButtonClick(Sender: TObject);
    procedure PopupMenuWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpgradeButtonClick(Sender: TObject);
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure ListViewMoveButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure GamesListBackgroundEditChange(Sender: TObject);
    procedure GamesListBackgroundColorBoxChange(Sender: TObject);
    procedure TreeViewBackgroundColorBoxChange(Sender: TObject);
    procedure ScreenshotsListBackgroundColorBoxChange(Sender: TObject);
    procedure ScreenshotsListBackgroundEditChange(Sender: TObject);
    procedure ToolbarImageEditChange(Sender: TObject);
    procedure ModeComboBoxChange(Sender: TObject);
    procedure NotSetEditChange(Sender: TObject);
    procedure InstallerLangEditComboBoxChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    JustLoading : Boolean;
    DosBoxLang : TStringList;
    LastIndex : Integer;
    InstallerLang : Integer;
    LangTimerCounter : Integer;
    Procedure InitGUI;
    Procedure ReadCurrentInstallerLanguage;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    SetAdvanced : Boolean;
    FirstRun : Boolean;
    LanguageEditorMode : Integer;
  end;

var
  SetupForm: TSetupForm;

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const OpenLanguageTab : Boolean = False; const FirstRun : Boolean = False) : Boolean;
Function ShowTreeListSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShellAPI, Math, IniFiles, Registry, LanguageSetupUnit, PrgSetupUnit,
     VistaToolsUnit, CommonTools, SetupDosBoxFormUnit, GameDBToolsUnit, PrgConsts,
     IconLoaderUnit, LanguageEditorStartFormUnit, LanguageEditorFormUnit;

{$R *.dfm}

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  DosBoxLang:=TStringList.Create;
  JustLoading:=False;
  SetAdvanced:=False;
  FirstRun:=False;
  LanguageEditorMode:=0;
end;

procedure TSetupForm.FormDestroy(Sender: TObject);
Var I : Integer;
begin
  for I:=0 to DefaultValueComboBox.Items.Count-1 do TStringList(DefaultValueComboBox.Items.Objects[I]).Free;
  DosBoxLang.Free;
end;

Procedure GetColOrderAndVisible(var O,V : String);
begin
  V:=PrgSetup.ColVisible;
  while length(V)<6 do V:=V+'1';
  If Length(V)>6 then V:=Copy(V,1,6);
  PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  while length(O)<6 do O:=O+'1';
  If Length(O)>6 then O:=Copy(O,1,6);
  PrgSetup.ColOrder:=O;
end;

procedure TSetupForm.InitGUI;
Var I : Integer;
    S : String;
begin
  Caption:=LanguageSetup.SetupForm;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  ModeLabel.Caption:=LanguageSetup.SetupFormMode;
  I:=ModeComboBox.ItemIndex;
  ModeComboBox.Items[0]:=LanguageSetup.SetupFormModeEasy;
  ModeComboBox.Items[1]:=LanguageSetup.SetupFormModeAdvanced;
  ModeComboBox.ItemIndex:=I;

  {General}

  GeneralSheet.Caption:=LanguageSetup.SetupFormGeneralSheet;
  StartSizeLabel.Caption:=LanguageSetup.SetupFormStartSizeLabel;
  I:=StartSizeComboBox.ItemIndex;
  StartSizeComboBox.Items[0]:=LanguageSetup.SetupFormStartSizeNormal;
  StartSizeComboBox.Items[1]:=LanguageSetup.SetupFormStartSizeLast;
  StartSizeComboBox.Items[2]:=LanguageSetup.SetupFormStartSizeMinimized;
  StartSizeComboBox.Items[3]:=LanguageSetup.SetupFormStartSizeMaximized;
  StartSizeComboBox.ItemIndex:=I;
  MinimizeToTrayCheckBox.Caption:=LanguageSetup.SetupFormMinimizeToTray;
  StartWithWindowsCheckBox.Caption:=LanguageSetup.SetupFormStartWithWindows;
  AddButtonFunctionLabel.Caption:=LanguageSetup.SetupFormAddButtonFunctionLabel;
  I:=AddButtonFunctionComboBox.ItemIndex;
  AddButtonFunctionComboBox.Items[0]:=LanguageSetup.SetupFormAddButtonFunctionAdd;
  AddButtonFunctionComboBox.Items[1]:=LanguageSetup.SetupFormAddButtonFunctionWizard;
  AddButtonFunctionComboBox.Items[2]:=LanguageSetup.SetupFormAddButtonFunctionMenu;
  AddButtonFunctionComboBox.ItemIndex:=I;
  ToolbarGroupBox.Caption:=LanguageSetup.SetupFormToolbar;
  ToolbarImageCheckBox.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  ToolbarImageButton.Hint:=LanguageSetup.ChooseFile;
  ToolbarFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;

  {Directories}

  DirectorySheet.Caption:=LanguageSetup.SetupFormDirectoriesSheet;
  BaseDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormBaseDir;
  BaseDirButton.Hint:=LanguageSetup.ChooseFolder;
  GameDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormGameDir;
  GameDirButton.Hint:=LanguageSetup.ChooseFolder;
  DataDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDataDir;
  DataDirButton.Hint:=LanguageSetup.ChooseFolder;

  {Language}

  LanguageSheet.Caption:=LanguageSetup.SetupFormLanguageSheet;
  LanguageLabel.Caption:=LanguageSetup.SetupFormLanguage;
  LanguageOpenEditor.Caption:=LanguageSetup.SetupFormLanguageOpenEditor;
  LanguageNew.Caption:=LanguageSetup.SetupFormLanguageOpenEditorNew;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  InstallerLangLabel.Caption:=LanguageSetup.SetupFormInstallerLang;
  InstallerLangInfoLabel.Caption:=LanguageSetup.SetupFormInstallerLangInfo;

  {Game list}

  ListViewSheet.Caption:=LanguageSetup.SetupFormListViewSheet;

  ListViewSheet1.Caption:=LanguageSetup.SetupFormListViewSheet1;
  ListViewLabel.Caption:=LanguageSetup.SetupFormListViewInfo;
  ColDefaultValueSpeedButton.Hint:=LanguageSetup.SetupFormDefaultValueReset;

  ListViewSheet2.Caption:=LanguageSetup.SetupFormListViewSheet2;
  GamesListBackgroundRadioButton1.Caption:=LanguageSetup.SetupFormBackgroundColorDefault;
  GamesListBackgroundRadioButton2.Caption:=LanguageSetup.SetupFormBackgroundColorColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then GamesListBackgroundColorBox.Style:=GamesListBackgroundColorBox.Style+[cbPrettyNames]
    else GamesListBackgroundColorBox.Style:=GamesListBackgroundColorBox.Style-[cbPrettyNames];
  GamesListBackgroundRadioButton3.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  GamesListBackgroundButton.Hint:=LanguageSetup.ChooseFile;
  GamesListFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;
  GamesListFontColorLabel.Caption:=LanguageSetup.SetupFormFontColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then GamesListFontColorBox.Style:=GamesListFontColorBox.Style+[cbPrettyNames]
    else GamesListFontColorBox.Style:=GamesListFontColorBox.Style-[cbPrettyNames];
  NotSetGroupBox.Caption:=LanguageSetup.ValueForNotSet+' "'+LanguageSetup.NotSet+'"';
  NotSetRadioButton1.Caption:='"'+LanguageSetup.NotSet+'"';

  ListViewSheet3.Caption:=LanguageSetup.SetupFormListViewSheet3;
  TreeViewBackgroundRadioButton1.Caption:=LanguageSetup.SetupFormBackgroundColorDefault;
  TreeViewBackgroundRadioButton2.Caption:=LanguageSetup.SetupFormBackgroundColorColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then TreeViewBackgroundColorBox.Style:=TreeViewBackgroundColorBox.Style+[cbPrettyNames]
    else TreeViewBackgroundColorBox.Style:=TreeViewBackgroundColorBox.Style-[cbPrettyNames];
  TreeViewFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;
  TreeViewFontColorLabel.Caption:=LanguageSetup.SetupFormFontColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then TreeViewFontColorBox.Style:=TreeViewFontColorBox.Style+[cbPrettyNames]
    else TreeViewFontColorBox.Style:=TreeViewFontColorBox.Style-[cbPrettyNames];
  TreeViewGroupsLabel.Caption:=LanguageSetup.SetupFormTreeViewGroupLabel;
  TreeViewGroupsInfoLabel.Caption:=LanguageSetup.SetupFormTreeViewGroupInfoLabel;

  ListViewSheet4.Caption:=LanguageSetup.SetupFormListViewSheet4;
  ScreenshotsListBackgroundRadioButton1.Caption:=LanguageSetup.SetupFormBackgroundColorDefault;
  ScreenshotsListBackgroundRadioButton2.Caption:=LanguageSetup.SetupFormBackgroundColorColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then ScreenshotsListBackgroundColorBox.Style:=ScreenshotsListBackgroundColorBox.Style+[cbPrettyNames]
    else ScreenshotsListBackgroundColorBox.Style:=ScreenshotsListBackgroundColorBox.Style-[cbPrettyNames];
  ScreenshotsListBackgroundRadioButton3.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  ScreenshotsListBackgroundButton.Hint:=LanguageSetup.ChooseFile;
  ScreenshotsListFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;
  ScreenshotsListFontColorLabel.Caption:=LanguageSetup.SetupFormFontColor;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then ScreenshotsListFontColorBox.Style:=ScreenshotsListFontColorBox.Style+[cbPrettyNames]
    else ScreenshotsListFontColorBox.Style:=ScreenshotsListFontColorBox.Style-[cbPrettyNames];
  ScreenshotPreviewLabel.Caption:=LanguageSetup.SetupFormScreenshotPreviewSize;

  {Profile editor}

  ProfileEditorSheet.Caption:=LanguageSetup.ProfileEditor;
  ReopenLastActiveProfileSheetCheckBox.Caption:=LanguageSetup.SetupFormReopenLastActiveProfileSheet;
  ProfileEditorDFendRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorDFendStyle;
  ProfileEditorModernRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorModern;
  AutoSetScreenshotFolderRadioGroup.Caption:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolder;
  AutoSetScreenshotFolderRadioGroup.Items[0]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderOnlyWizard;
  AutoSetScreenshotFolderRadioGroup.Items[1]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderAlways;

  {DOSBox}

  DosBoxSheet.Caption:=LanguageSetup.SetupFormDosBoxSheet;
  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  DosBoxMapperEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxMapperFile;
  DosBoxMapperButton.Hint:=LanguageSetup.ChooseFile;
  HideDosBoxConsoleCheckBox.Caption:=LanguageSetup.SetupFormHideDosBoxConsole;
  MinimizeDFendCheckBox.Caption:=LanguageSetup.SetupFormMinimizeDFend;
  CenterDOSBoxCheckBox.Caption:=LanguageSetup.SetupFormCenterDOSBoxWindow;
  SDLVideodriverLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriver;
  SDLVideodriverInfoLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriverInfo;
  PathFREEDOSEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxFREEDOSPath;
  PathFREEDOSButton.Hint:=LanguageSetup.ChooseFile;

  {Wave encoder}

  WaveEncSheet.Caption:=LanguageSetup.SetupFormWaveEnc;
  WaveEncMp3Edit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncMp3;
  WaveEncMp3Button1.Hint:=LanguageSetup.ChooseFile;
  WaveEncMp3Button2.Hint:=LanguageSetup.SetupFormSearchLame;
  WaveEncOggEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncOgg;
  WaveEncOggButton1.Hint:=LanguageSetup.ChooseFile;
  WaveEncOggButton2.Hint:=LanguageSetup.SetupFormSearchOggEnc;

  {Security}

  SecuritySheet.Caption:=LanguageSetup.SetupFormSecuritySheet;
  AskBeforeDeleteCheckBox.Caption:=LanguageSetup.SetupFormAskBeforeDelete;
  DeleteProectionCheckBox.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDir;
  DeleteProectionLabel.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDirLabel;

  {Default values}

  DefaultValueSheet.Caption:=LanguageSetup.SetupFormDefaultValueSheet;
  DefaultValueLabel.Caption:=LanguageSetup.SetupFormDefaultValueLabel;
  DefaultValueSpeedButton.Hint:=LanguageSetup.SetupFormDefaultValueReset;
  DefaultValueMemo.Font.Name:='Courier New';
  PopupThisValue.Caption:=LanguageSetup.SetupFormDefaultValueResetThis;
  PopupAllValues.Caption:=LanguageSetup.SetupFormDefaultValueResetAll;
  I:=DefaultValueComboBox.ItemIndex;
  DefaultValueComboBox.Items.Clear;
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameResolution,ValueToList(GameDB.ConfOpt.Resolution,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameJoysticks,ValueToList(GameDB.ConfOpt.Joysticks,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameScale,ValueToList(GameDB.ConfOpt.Scale,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameRender,ValueToList(GameDB.ConfOpt.Render,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCycles,ValueToList(GameDB.ConfOpt.Cycles,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameVideo,ValueToList(GameDB.ConfOpt.Video,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameMemory,ValueToList(GameDB.ConfOpt.Memory,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameFrameskip,ValueToList(GameDB.ConfOpt.Frameskip,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCore,ValueToList(GameDB.ConfOpt.Core,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameSblaster,ValueToList(GameDB.ConfOpt.Sblaster,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameOplmode,ValueToList(GameDB.ConfOpt.Oplmode,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameKeyboardLayout,ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameReportedDOSVersion,ValueToList(GameDB.ConfOpt.ReportedDOSVersion,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMIDIDevice,ValueToList(GameDB.ConfOpt.MIDIDevice,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundBlockSize,ValueToList(GameDB.ConfOpt.Blocksize,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCyclesDown,ValueToList(GameDB.ConfOpt.CyclesDown,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCyclesUp,ValueToList(GameDB.ConfOpt.CyclesUp,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBDMA,ValueToList(GameDB.ConfOpt.Dma,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSDMA1,ValueToList(GameDB.ConfOpt.Dma1,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSDMA2,ValueToList(GameDB.ConfOpt.Dma2,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSAddress,ValueToList(GameDB.ConfOpt.GUSBase,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSRate,ValueToList(GameDB.ConfOpt.GUSRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBHDMA,ValueToList(GameDB.ConfOpt.HDMA,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBIRQ,ValueToList(GameDB.ConfOpt.IRQ,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSIRQ1,ValueToList(GameDB.ConfOpt.IRQ1,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSIRQ2,ValueToList(GameDB.ConfOpt.IRQ2,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMIDIType,ValueToList(GameDB.ConfOpt.MPU401,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBOplRate,ValueToList(GameDB.ConfOpt.OPLRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,ValueToList(GameDB.ConfOpt.PCRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSampleRate,ValueToList(GameDB.ConfOpt.Rate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBAddress,ValueToList(GameDB.ConfOpt.SBBase,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameMouseSensitivity,ValueToList(GameDB.ConfOpt.MouseSensitivity,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMiscTandyRate,ValueToList(GameDB.ConfOpt.TandyRate,';,'));

  DefaultValueComboBox.ItemIndex:=I;

  {Service}

  ServiceSheet.Caption:=LanguageSetup.SetupFormServiceSheet;
  Service1Button.Caption:=LanguageSetup.SetupFormService1;
  Service2Button.Caption:=LanguageSetup.SetupFormService2;
  Service3Button.Caption:=LanguageSetup.SetupFormService3;
  Service4Button.Caption:=LanguageSetup.SetupFormService4;
  S:=LanguageSetup.MenuHelpUpdates;
  While (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
  UpdateGroupBox.Caption:=S;
  Update0RadioButton.Caption:=LanguageSetup.SetupFormUpdate0;
  Update1RadioButton.Caption:=LanguageSetup.SetupFormUpdate1;
  Update2RadioButton.Caption:=LanguageSetup.SetupFormUpdate2;
  Update3RadioButton.Caption:=LanguageSetup.SetupFormUpdate3;
  UpdateLabel.Caption:=LanguageSetup.SetupFormUpdateInfo;
end;

procedure TSetupForm.FormShow(Sender: TObject);
Var S,T : String;
    I,J,Nr : Integer;
    Rec : TSearchRec;
    B : Boolean;
    C : TColor;
    St : TStringList;
    Ini : TIniFile;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  InitGUI;

  LoadUserIcons(ImageList,'SetupForm');

  JustLoading:=True;
  try
    {General}

    StartSizeComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.StartWindowSize));
    MinimizeToTrayCheckBox.Checked:=PrgSetup.MinimizeToTray;
    StartWithWindowsCheckBox.Checked:=PrgSetup.StartWithWindows;
    AddButtonFunctionComboBox.ItemIndex:=Min(2,Max(0,PrgSetup.AddButtonFunction));
    ToolbarImageCheckBox.Checked:=Trim(PrgSetup.ToolbarBackground)<>'';
    ToolbarImageEdit.Text:=PrgSetup.ToolbarBackground;
    ToolbarFontSizeEdit.Value:=PrgSetup.ToolbarFontSize;

    {Directories}

    BaseDirEdit.Text:=PrgSetup.BaseDir;
    GameDirEdit.Text:=PrgSetup.GameDir;
    DataDirEdit.Text:=PrgSetup.DataDir;

    {Language}

    I:=FindFirst(PrgDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
    try
      while I=0 do begin
        LanguageComboBox.Items.Add(Copy(Rec.Name,1,length(Rec.Name)-4));
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
    If PrgDataDir<>PrgDir then begin
      I:=FindFirst(PrgDataDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
      try
        while I=0 do begin
          LanguageComboBox.Items.Add(Copy(Rec.Name,1,length(Rec.Name)-4));
          I:=FindNext(Rec);
        end;
      finally
        FindClose(Rec);
      end;
    end;

    S:=Trim(PrgSetup.Language);
    If (length(S)>4) and (ExtUpperCase(Copy(S,length(S)-3,4))='.INI') then begin
      S:=Trim(Copy(S,1,length(S)-4));
      LanguageComboBox.ItemIndex:=-1;
      For I:=0 to LanguageComboBox.Items.Count-1 do If ExtUpperCase(LanguageComboBox.Items[I])=ExtUpperCase(S) then begin
        LanguageComboBox.ItemIndex:=I; break;
      end;
    end;
    If (LanguageComboBox.Items.Count>0) and (LanguageComboBox.ItemIndex<0) then LanguageComboBox.ItemIndex:=0;

    LanguageComboBoxChange(Sender); {to setup outdated warning}

    DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
    DosBoxDirEditChange(Self); {to fill the language combobox; needs DosBoxDirEdit.Text to be set}

    I:=DosBoxLang.IndexOf(PrgSetup.DosBoxLanguage);
    If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;

    LanguageComboBox.OnChange:=nil;
    For I:=0 to LanguageComboBox.Items.Count-1 do begin
      S:=LanguageComboBox.Items[I]+'.ini';
      If FileExists(PrgDir+LanguageSubDir+'\'+S) then S:=PrgDir+LanguageSubDir+'\'+S else begin
        If FileExists(PrgDataDir+LanguageSubDir+'\'+S) then S:=PrgDataDir+LanguageSubDir+'\'+S else continue;
      end;
      Ini:=TIniFile.Create(S); try S:=Ini.ReadString('LanguageFileInfo','NSISLanguageID',''); finally Ini.Free; end;
      If S='' then continue;
      try InstallerLangEditComboBox.Items.AddObject(LanguageComboBox.Items[I],Pointer(StrToInt(S))); except end;
    end;
    ReadCurrentInstallerLanguage;
    LanguageComboBox.OnChange:=LanguageComboBoxChange;

    {Game list}

    GetColOrderAndVisible(S,T);
    For I:=0 to 5 do begin
      try Nr:=StrToInt(S[I+1]); except Nr:=-1; end;
      If (Nr<1) or (Nr>6) then continue;
      Case Nr-1 of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(Nr-1));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(Nr-1));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(Nr-1));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(Nr-1));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(Nr-1));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(Nr-1));
      end;
      ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(T[Nr]<>'0');
    end;
    For I:=0 to 5 do begin
      B:=False;
      For J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
        B:=True; break;
      end;
      If not B then Case I of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
      end;
    end;

    S:=Trim(PrgSetup.GamesListViewBackground);
    If S='' then GamesListBackgroundRadioButton1.Checked:=True else begin
      try
        C:=StringToColor(S); GamesListBackgroundRadioButton2.Checked:=True; GamesListBackgroundColorBox.Selected:=C;
      except
        GamesListBackgroundRadioButton3.Checked:=True; GamesListBackgroundEdit.Text:=S;
      end;
    end;
    S:=Trim(PrgSetup.GamesListViewFontColor);
    If S='' then GamesListFontColorBox.Selected:=clWindowText else begin
      try GamesListFontColorBox.Selected:=StringToColor(S); except GamesListFontColorBox.Selected:=clWindowText; end;
    end;
    GamesListFontSizeEdit.Value:=PrgSetup.GamesListViewFontSize;
    S:=Trim(PrgSetup.ValueForNotSet);
    NotSetRadioButton1.Checked:=(S='');
    NotSetRadioButton2.Checked:=(S='-');
    NotSetRadioButton3.Checked:=(S<>'') and (S<>'-');
    If NotSetRadioButton3.Checked then NotSetEdit.Text:=S;

    S:=Trim(PrgSetup.GamesTreeViewBackground);
    If S='' then TreeViewBackgroundRadioButton1.Checked:=True else begin
      try
        C:=StringToColor(S); TreeViewBackgroundRadioButton2.Checked:=True; TreeViewBackgroundColorBox.Selected:=C;
      except
        TreeViewBackgroundRadioButton1.Checked:=True;
      end;
    end;
    S:=Trim(PrgSetup.GamesTreeViewFontColor);
    If S='' then TreeViewFontColorBox.Selected:=clWindowText else begin
      try TreeViewFontColorBox.Selected:=StringToColor(S); except TreeViewFontColorBox.Selected:=clWindowText; end;
    end;
    TreeViewFontSizeEdit.Value:=PrgSetup.GamesTreeViewFontSize;
    St:=StringToStringList(PrgSetup.UserGroups);
    try TreeViewGroupsEdit.Lines.AddStrings(St); finally St.Free; end;

    S:=Trim(PrgSetup.ScreenshotsListViewBackground);
    If S='' then ScreenshotsListBackgroundRadioButton1.Checked:=True else begin
      try
        C:=StringToColor(S); ScreenshotsListBackgroundRadioButton2.Checked:=True; ScreenshotsListBackgroundColorBox.Selected:=C;
      except
        ScreenshotsListBackgroundRadioButton3.Checked:=True; ScreenshotsListBackgroundEdit.Text:=S;
      end;
    end;
    S:=Trim(PrgSetup.ScreenshotsListViewFontColor);
    If S='' then ScreenshotsListFontColorBox.Selected:=clWindowText else begin
      try ScreenshotsListFontColorBox.Selected:=StringToColor(S); except ScreenshotsListFontColorBox.Selected:=clWindowText; end;
    end;
    ScreenshotsListFontSizeEdit.Value:=PrgSetup.ScreenshotsListViewFontSize;
    ScreenshotPreviewEdit.Value:=Max(ScreenshotPreviewEdit.MinValue,Min(ScreenshotPreviewEdit.MaxValue,PrgSetup.ScreenshotPreviewSize));

    {Profile editor}

    ReopenLastActiveProfileSheetCheckBox.Checked:=PrgSetup.ReopenLastProfileEditorTab;
    ProfileEditorDFendRadioButton.Checked:=PrgSetup.DFendStyleProfileEditor;
    ProfileEditorModernRadioButton.Checked:=not PrgSetup.DFendStyleProfileEditor;
    If PrgSetup.AlwaysSetScreenshotFolderAutomatically then AutoSetScreenshotFolderRadioGroup.ItemIndex:=1 else AutoSetScreenshotFolderRadioGroup.ItemIndex:=0;

    {DOSBox}

    DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
    DosBoxDirEditChange(Sender);
    DosBoxMapperEdit.Text:=PrgSetup.DosBoxMapperFile;
    HideDosBoxConsoleCheckBox.Checked:=PrgSetup.HideDosBoxConsole;
    MinimizeDFendCheckBox.Checked:=PrgSetup.MinimizeOnDosBoxStart;
    CenterDOSBoxCheckBox.Checked:=PrgSetup.CenterDOSBoxWindow;
    If Trim(ExtUpperCase(PrgSetup.SDLVideodriver))='WINDIB' then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
    PathFREEDOSEdit.Text:=PrgSetup.PathToFREEDOS;

    {Wave encoder}

    WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
    WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;

    {Security}

    AskBeforeDeleteCheckBox.Checked:=PrgSetup.AskBeforeDelete;
    DeleteProectionCheckBox.Checked:=PrgSetup.DeleteOnlyInBaseDir;

    {Default values}

    DefaultValueComboBox.ItemIndex:=0; LastIndex:=-1;
    DefaultValueComboBoxChange(Sender);

    {Service}
    {no settings}

    {Update}

    case PrgSetup.CheckForUpdates of
      0 : Update0RadioButton.Checked:=True;
      1 : Update1RadioButton.Checked:=True;
      2 : Update2RadioButton.Checked:=True;
      3 : Update3RadioButton.Checked:=True;
    end;
  finally
    JustLoading:=False;
  end;

  If PrgSetup.EasySetupMode and (not SetAdvanced) then ModeComboBox.ItemIndex:=0 else ModeComboBox.ItemIndex:=1;
  ModeComboBoxChange(Sender);
end;

procedure TSetupForm.ReadCurrentInstallerLanguage;
Var Reg : TRegistry;
    I, SelLang : Integer;
begin
  InstallerLang:=-1;
  Reg:=TRegistry.Create;
  try
    Reg.Access:=KEY_READ;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    If Reg.OpenKey('\Software\D-Fend Reloaded',False) and Reg.ValueExists('Installer Language') then begin
      try InstallerLang:=StrToInt(Reg.ReadString('Installer Language')); except end;
    end;
  finally
    Reg.Free;
  end;

  InstallerLangEditComboBox.OnChange:=nil;

  If InstallerLang>=0 then begin
    SelLang:=-1;
    For I:=0 to InstallerLangEditComboBox.Items.Count-1 do If Integer(InstallerLangEditComboBox.Items.Objects[I])=InstallerLang then begin
      SelLang:=I; break;
    end;
  end else begin
    SelLang:=-1;
  end;

  If (InstallerLangEditComboBox.Items.Count>0) and (Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.Items.Count-1])=-1) then begin
    InstallerLangEditComboBox.Items.Delete(InstallerLangEditComboBox.Items.Count-1);
  end;

  If SelLang=-1 then begin
    InstallerLangEditComboBox.Items.AddObject('?',TObject(-1));
    InstallerLangEditComboBox.ItemIndex:=InstallerLangEditComboBox.Items.Count-1;
  end else begin
    InstallerLangEditComboBox.ItemIndex:=SelLang;
  end;

  InstallerLangEditComboBox.OnChange:=InstallerLangEditComboBoxChange;
end;

procedure TSetupForm.TimerTimer(Sender: TObject);
begin
  dec(LangTimerCounter);
  If LangTimerCounter=0 then Timer.Enabled:=False;
  ReadCurrentInstallerLanguage;
end;

procedure TSetupForm.ToolbarImageEditChange(Sender: TObject);
begin
  ToolbarImageCheckBox.Checked:=True;
end;

procedure TSetupForm.GamesListBackgroundColorBoxChange(Sender: TObject);
begin
  GamesListBackgroundRadioButton2.Checked:=True;
end;

procedure TSetupForm.GamesListBackgroundEditChange(Sender: TObject);
begin
  GamesListBackgroundRadioButton3.Checked:=True;
end;

procedure TSetupForm.TreeViewBackgroundColorBoxChange(Sender: TObject);
begin
  TreeViewBackgroundRadioButton2.Checked:=True;
end;

procedure TSetupForm.ScreenshotsListBackgroundColorBoxChange(Sender: TObject);
begin
  ScreenshotsListBackgroundRadioButton2.Checked:=True;
end;

procedure TSetupForm.ScreenshotsListBackgroundEditChange(Sender: TObject);
begin
  ScreenshotsListBackgroundRadioButton3.Checked:=True;
end;

procedure TSetupForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
begin
  DefaultValueComboBoxChange(Sender);

  PrgSetup.EasySetupMode:=(ModeComboBox.ItemIndex=0);  

  {General}

  PrgSetup.StartWindowSize:=StartSizeComboBox.ItemIndex;
  PrgSetup.MinimizeToTray:=MinimizeToTrayCheckBox.Checked;
  PrgSetup.StartWithWindows:=StartWithWindowsCheckBox.Checked;
  SetStartWithWindows(PrgSetup.StartWithWindows);
  PrgSetup.AddButtonFunction:=AddButtonFunctionComboBox.ItemIndex;
  If ToolbarImageCheckBox.Checked then PrgSetup.ToolbarBackground:=ToolbarImageEdit.Text else PrgSetup.ToolbarBackground:='';
  PrgSetup.ToolbarFontSize:=ToolbarFontSizeEdit.Value;

  {Directories}

  PrgSetup.BaseDir:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
  PrgSetup.GameDir:=IncludeTrailingPathDelimiter(GameDirEdit.Text);
  PrgSetup.DataDir:=IncludeTrailingPathDelimiter(DataDirEdit.Text);

  {Language}

  PrgSetup.Language:=LanguageComboBox.Text+'.ini';

  PrgSetup.DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];

  {Game list}

  S:=''; For I:=0 to ListViewListBox.Items.Count-1 do S:=S+IntToStr(Integer(ListViewListBox.Items.Objects[I])+1); PrgSetup.ColOrder:=S;
  S:=''; For I:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[I])=I then begin If ListViewListBox.Checked[I] then S:=S+'1' else S:=S+'0'; end; PrgSetup.ColVisible:=S;

  If GamesListBackgroundRadioButton1.Checked then PrgSetup.GamesListViewBackground:='';
  If GamesListBackgroundRadioButton2.Checked then PrgSetup.GamesListViewBackground:=ColorToString(GamesListBackgroundColorBox.Selected);
  If GamesListBackgroundRadioButton3.Checked then PrgSetup.GamesListViewBackground:=GamesListBackgroundEdit.Text;
  PrgSetup.GamesListViewFontSize:=GamesListFontSizeEdit.Value;
  PrgSetup.GamesListViewFontColor:=ColorToString(GamesListFontColorBox.Selected);
  If NotSetRadioButton1.Checked then PrgSetup.ValueForNotSet:='';
  If NotSetRadioButton2.Checked then PrgSetup.ValueForNotSet:='-';
  If NotSetRadioButton3.Checked then PrgSetup.ValueForNotSet:=NotSetEdit.Text;

  If TreeViewBackgroundRadioButton1.Checked then PrgSetup.GamesTreeViewBackground:='';
  If TreeViewBackgroundRadioButton2.Checked then PrgSetup.GamesTreeViewBackground:=ColorToString(TreeViewBackgroundColorBox.Selected);
  PrgSetup.GamesTreeViewFontSize:=TreeViewFontSizeEdit.Value;
  PrgSetup.GamesTreeViewFontColor:=ColorToString(TreeViewFontColorBox.Selected);
  prgSetup.UserGroups:=StringListToString(TreeViewGroupsEdit.Lines);

  If ScreenshotsListBackgroundRadioButton1.Checked then PrgSetup.ScreenshotsListViewBackground:='';
  If ScreenshotsListBackgroundRadioButton2.Checked then PrgSetup.ScreenshotsListViewBackground:=ColorToString(ScreenshotsListBackgroundColorBox.Selected);
  If ScreenshotsListBackgroundRadioButton3.Checked then PrgSetup.ScreenshotsListViewBackground:=ScreenshotsListBackgroundEdit.Text;
  PrgSetup.ScreenshotsListViewFontSize:=ScreenshotsListFontSizeEdit.Value;
  PrgSetup.ScreenshotsListViewFontColor:=ColorToString(ScreenshotsListFontColorBox.Selected);
  PrgSetup.ScreenshotPreviewSize:=ScreenshotPreviewEdit.Value;

  {Profile editor}

  PrgSetup.ReopenLastProfileEditorTab:=ReopenLastActiveProfileSheetCheckBox.Checked;
  PrgSetup.DFendStyleProfileEditor:=ProfileEditorDFendRadioButton.Checked;
  PrgSetup.AlwaysSetScreenshotFolderAutomatically:=(AutoSetScreenshotFolderRadioGroup.ItemIndex=1);

  {DOSBox}

  PrgSetup.DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
  PrgSetup.DosBoxMapperFile:=DosBoxMapperEdit.Text;
  PrgSetup.HideDosBoxConsole:=HideDosBoxConsoleCheckBox.Checked;
  PrgSetup.MinimizeOnDosBoxStart:=MinimizeDFendCheckBox.Checked;
  PrgSetup.CenterDOSBoxWindow:=CenterDOSBoxCheckBox.Checked;
  If SDLVideoDriverComboBox.ItemIndex=1 then PrgSetup.SDLVideodriver:='WinDIB' else PrgSetup.SDLVideodriver:='DirectX';
  PrgSetup.PathToFREEDOS:=PathFREEDOSEdit.Text;

  {Wave encoder}

  PrgSetup.WaveEncMp3:=WaveEncMp3Edit.Text;
  PrgSetup.WaveEncOgg:=WaveEncOggEdit.Text;

  {Security}

  PrgSetup.AskBeforeDelete:=AskBeforeDeleteCheckBox.Checked;  
  PrgSetup.DeleteOnlyInBaseDir:=DeleteProectionCheckBox.Checked;

  {Default values}

  GameDB.ConfOpt.Resolution:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[0]),',');
  GameDB.ConfOpt.Joysticks:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[1]),',');
  GameDB.ConfOpt.Scale:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[2]),',');
  GameDB.ConfOpt.Render:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[3]),',');
  GameDB.ConfOpt.Cycles:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[4]),',');
  GameDB.ConfOpt.Video:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[5]),',');
  GameDB.ConfOpt.Memory:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[6]),',');
  GameDB.ConfOpt.Frameskip:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[7]),',');
  GameDB.ConfOpt.Core:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[8]),',');
  GameDB.ConfOpt.Sblaster:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[9]),',');
  GameDB.ConfOpt.Oplmode:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[10]),',');
  GameDB.ConfOpt.KeyboardLayout:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[11]),',');
  GameDB.ConfOpt.ReportedDOSVersion:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[12]),',');
  GameDB.ConfOpt.MIDIDevice:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[13]),',');
  GameDB.ConfOpt.Blocksize:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[14]),',');
  GameDB.ConfOpt.CyclesDown:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[15]),',');
  GameDB.ConfOpt.CyclesUp:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[16]),',');
  GameDB.ConfOpt.Dma:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[17]),',');
  GameDB.ConfOpt.Dma1:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[18]),',');
  GameDB.ConfOpt.Dma2:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[19]),',');
  GameDB.ConfOpt.GUSBase:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[20]),',');
  GameDB.ConfOpt.GUSRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[21]),',');
  GameDB.ConfOpt.HDMA:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[22]),',');
  GameDB.ConfOpt.IRQ:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[23]),',');
  GameDB.ConfOpt.IRQ1:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[24]),',');
  GameDB.ConfOpt.IRQ2:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[25]),',');
  GameDB.ConfOpt.MPU401:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[26]),',');
  GameDB.ConfOpt.OPLRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[27]),',');
  GameDB.ConfOpt.PCRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[28]),',');
  GameDB.ConfOpt.Rate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[29]),',');
  GameDB.ConfOpt.SBBase:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[30]),',');
  GameDB.ConfOpt.MouseSensitivity:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[31]),',');
  GameDB.ConfOpt.TandyRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[32]),',');

  {Security}
  {no settings}

  {Update}

  If Update0RadioButton.Checked then PrgSetup.CheckForUpdates:=0;
  If Update1RadioButton.Checked then PrgSetup.CheckForUpdates:=1;
  If Update2RadioButton.Checked then PrgSetup.CheckForUpdates:=2;
  If Update3RadioButton.Checked then PrgSetup.CheckForUpdates:=3;
end;

procedure TSetupForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=BaseDirEdit.Text; If S='' then S:=PrgDataDir;
          if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then BaseDirEdit.Text:=S;
        end;
    1 : begin
          S:=GameDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormGameDir,S) then GameDirEdit.Text:=S;
        end;
    2 : begin
          S:=DataDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDataDir,S) then DataDirEdit.Text:=S;
        end;
    3 : begin
          S:=DosBoxDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then begin
            DosBoxDirEdit.Text:=S;
            DosBoxDirEditChange(Sender);
          end;
        end;
    4 : if SearchDosBox(self) then begin
          DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
          DosBoxDirEditChange(Sender);
        end;
    5 : begin
          DosBoxTxtOpenDialog.Title:=LanguageSetup.SetupFormDosBoxMapperFileTitle;
          DosBoxTxtOpenDialog.Filter:=LanguageSetup.SetupFormDosBoxMapperFileFilter;
          If Trim(DosBoxMapperEdit.Text)=''
            then DosBoxTxtOpenDialog.InitialDir:=PrgDataDir
            else DosBoxTxtOpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(DosBoxMapperEdit.Text,PrgDataDir));
          if not DosBoxTxtOpenDialog.Execute then exit;
          DosBoxMapperEdit.Text:=MakeRelPath(DosBoxTxtOpenDialog.FileName,PrgDataDir);
        end;
    6 : begin
          S:=PathFREEDOSEdit.Text;
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          if SelectDirectory(Handle,LanguageSetup.SetupFormFreeDOSDir,S) then begin
            PathFREEDOSEdit.Text:=MakeRelPath(S,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          end;
        end;
    7 : begin
          ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
          ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
          S:=GamesListBackgroundEdit.Text;
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          ImageOpenDialog.InitialDir:=ExtractFilePath(S);
          If ImageOpenDialog.Execute then begin
            GamesListBackgroundEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          end;
        end;
    8 : begin
          ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
          ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
          S:=ScreenshotsListBackgroundEdit.Text;
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          ImageOpenDialog.InitialDir:=ExtractFilePath(S);
          If ImageOpenDialog.Execute then begin
            ScreenshotsListBackgroundEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          end;
        end;
    9 : begin
          ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
          ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
          S:=ToolbarImageEdit.Text;
          If Trim(S)='' then S:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
          S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          ImageOpenDialog.InitialDir:=ExtractFilePath(S);
          If ImageOpenDialog.Execute then begin
            ToolbarImageEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(BaseDirEdit.Text));
          end;
        end;
   10 : begin
          S:=Trim(WaveEncMp3Edit.Text); If S<>'' then S:=ExtractFilePath(S);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncMp3;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncMp3Edit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   11 : if SearchLame(self) then WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
   12 : begin
          S:=Trim(WaveEncOggEdit.Text); If S<>'' then S:=ExtractFilePath(S);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncOgg;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncOggEdit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   13 : if SearchOggEnc(self) then WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;
   14 : If MessageDlg(LanguageSetup.SetupFormLanguageOpenEditorConfirmation,mtConfirmation,[mbOK,mbCancel],0)=mrOK then begin
          LanguageEditorMode:=1;
          ModalResult:=mrOK;
          OKButtonClick(Sender);
        end;
   15 : If MessageDlg(LanguageSetup.SetupFormLanguageOpenEditorConfirmation,mtConfirmation,[mbOK,mbCancel],0)=mrOK then begin
          LanguageEditorMode:=2;
          ModalResult:=mrOK;
          OKButtonClick(Sender);
        end;
  end;
end;

procedure TSetupForm.DefaultValueComboBoxChange(Sender: TObject);
begin
  If LastIndex>=0 then begin
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Clear;
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Assign(DefaultValueMemo.Lines);
  end;

  LastIndex:=DefaultValueComboBox.ItemIndex;
  DefaultValueMemo.Lines.Clear;
  If LastIndex<0 then exit;
  DefaultValueMemo.Lines.Assign(TStringList(DefaultValueComboBox.Items.Objects[LastIndex]));
end;

procedure TSetupForm.DefaultValueSpeedButtonClick(Sender: TObject);
Var P : TPoint;
begin
  P:=DefaultValueSheet.ClientToScreen(Point(DefaultValueSpeedButton.Left,DefaultValueSpeedButton.Top));
  DefaultValuePopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TSetupForm.PopupMenuWork(Sender: TObject);
Var All : Boolean;
    I : Integer;
begin
  All:=((Sender as TComponent).Tag=1);

  I:=LastIndex; LastIndex:=-1;

  If (I=0) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[0]).Free;
    DefaultValueComboBox.Items.Objects[0]:=ValueToList(DefaultValuesResolution,';,');
  end;

  If (I=1) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[1]).Free;
    DefaultValueComboBox.Items.Objects[1]:=ValueToList(DefaultValuesJoysticks,';,');
  end;

  If (I=2) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[2]).Free;
    DefaultValueComboBox.Items.Objects[2]:=ValueToList(DefaultValuesScale,';,');
  end;

  If (I=3) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[3]).Free;
    DefaultValueComboBox.Items.Objects[3]:=ValueToList(DefaultValueRender,';,');
  end;

  If (I=4) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[4]).Free;
    DefaultValueComboBox.Items.Objects[4]:=ValueToList(DefaultValueCycles,';,');
  end;

  If (I=5) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[5]).Free;
    DefaultValueComboBox.Items.Objects[5]:=ValueToList(DefaultValuesVideo,';,');
  end;

  If (I=6) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[6]).Free;
    DefaultValueComboBox.Items.Objects[6]:=ValueToList(DefaultValuesMemory,';,');
  end;

  If (I=7) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[7]).Free;
    DefaultValueComboBox.Items.Objects[7]:=ValueToList(DefaultValuesFrameSkip,';,');
  end;

  If (I=8) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[8]).Free;
    DefaultValueComboBox.Items.Objects[8]:=ValueToList(DefaultValuesCore,';,');
  end;

  If (I=9) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[9]).Free;
    DefaultValueComboBox.Items.Objects[9]:=ValueToList(DefaultValueSBlaster,';,');
  end;

  If (I=10) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[10]).Free;
    DefaultValueComboBox.Items.Objects[10]:=ValueToList(DefaultValuesOPLModes,';,');
  end;

  If (I=11) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[11]).Free;
    DefaultValueComboBox.Items.Objects[11]:=ValueToList(DefaultValuesKeyboardLayout,';,');
  end;

  If (I=12) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[12]).Free;
    DefaultValueComboBox.Items.Objects[12]:=ValueToList(DefaultValuesReportedDOSVersion,';,');
  end;

  If (I=13) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[13]).Free;
    DefaultValueComboBox.Items.Objects[13]:=ValueToList(DefaultValuesMIDIDevice,';,');
  end;

  If (I=14) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[14]).Free;
    DefaultValueComboBox.Items.Objects[14]:=ValueToList(DefaultValuesBlocksize,';,');
  end;

  If (I=15) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[15]).Free;
    DefaultValueComboBox.Items.Objects[15]:=ValueToList(DefaultValuesCyclesDown,';,');
  end;

  If (I=16) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[16]).Free;
    DefaultValueComboBox.Items.Objects[16]:=ValueToList(DefaultValuesCyclesUp,';,');
  end;

  If (I=17) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[17]).Free;
    DefaultValueComboBox.Items.Objects[17]:=ValueToList(DefaultValuesDMA,';,');
  end;

  If (I=18) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[18]).Free;
    DefaultValueComboBox.Items.Objects[18]:=ValueToList(DefaultValuesDMA1,';,');
  end;

  If (I=19) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[19]).Free;
    DefaultValueComboBox.Items.Objects[19]:=ValueToList(DefaultValuesDMA2,';,');
  end;

  If (I=20) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[20]).Free;
    DefaultValueComboBox.Items.Objects[20]:=ValueToList(DefaultValuesGUSBase,';,');
  end;

  If (I=21) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[21]).Free;
    DefaultValueComboBox.Items.Objects[21]:=ValueToList(DefaultValuesGUSRate,';,');
  end;

  If (I=22) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[22]).Free;
    DefaultValueComboBox.Items.Objects[22]:=ValueToList(DefaultValuesHDMA,';,');
  end;

  If (I=23) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[23]).Free;
    DefaultValueComboBox.Items.Objects[23]:=ValueToList(DefaultValuesIRQ,';,');
  end;

  If (I=24) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[24]).Free;
    DefaultValueComboBox.Items.Objects[24]:=ValueToList(DefaultValuesIRQ1,';,');
  end;

  If (I=25) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[25]).Free;
    DefaultValueComboBox.Items.Objects[25]:=ValueToList(DefaultValuesIRQ2,';,');
  end;

  If (I=26) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[26]).Free;
    DefaultValueComboBox.Items.Objects[26]:=ValueToList(DefaultValuesMPU401,';,');
  end;

  If (I=27) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[27]).Free;
    DefaultValueComboBox.Items.Objects[27]:=ValueToList(DefaultValuesOPLRate,';,');
  end;

  If (I=28) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[28]).Free;
    DefaultValueComboBox.Items.Objects[28]:=ValueToList(DefaultValuesPCRate,';,');
  end;

  If (I=29) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[29]).Free;
    DefaultValueComboBox.Items.Objects[29]:=ValueToList(DefaultValuesRate,';,');
  end;

  If (I=30) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[30]).Free;
    DefaultValueComboBox.Items.Objects[30]:=ValueToList(DefaultValuesSBBase,';,');
  end;

  If (I=31) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[31]).Free;
    DefaultValueComboBox.Items.Objects[31]:=ValueToList(DefaultValuesMouseSensitivity,';,');
  end;

  If (I=32) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[32]).Free;
    DefaultValueComboBox.Items.Objects[32]:=ValueToList(DefaultValuesTandyRate,';,');
  end;

  DefaultValueComboBox.ItemIndex:=I; DefaultValueComboBoxChange(Sender);
end;

procedure TSetupForm.UpgradeButtonClick(Sender: TObject);
Var I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : DeleteOldFiles;
    1 : ReplaceAbsoluteDirs(GameDB);
    2 : begin
          I:=GameDB.IndexOf(DosBoxDOSProfile);
          If I>=0 then begin
            If MessageDlg(LanguageSetup.SetupFormService3Confirmation,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            GameDB.Delete(I);
          end;
          BuildDefaultDosProfile(GameDB);
        end;
    3 : BuildDefaultProfile;
  end;
end;

Procedure FindAndAddLngFiles(const Dir : String; const St, St2 : TStrings);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(Dir+'*.lng',faAnyFile,Rec);
  try
    while I=0 do begin
      St.Add(ChangeFileExt(Rec.Name,''));
      St2.Add(Dir+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TSetupForm.DosBoxDirEditChange(Sender: TObject);
Var S : String;
    I : Integer;
begin
  S:=DosBoxLangEditComboBox.Text;
  DosBoxLangEditComboBox.Items.Clear;
  DosBoxLang.Clear;

  DosBoxLangEditComboBox.Items.Add('English');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDirEdit.Text),DosBoxLangEditComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DosBoxLangEditComboBox.Items,DosBoxLang);
  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

Function VersionStringToInt(S : String) : Integer;
Var I : Integer;
    T : String;
begin
  result:=0;
  S:=Trim(S);

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256*256; except end;

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256; except end;

  try result:=result+StrToInt(S); except end;
end;

procedure TSetupForm.LanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  If not JustLoading then begin
    LoadLanguage(LanguageComboBox.Text+'.ini');
    InitGUI;
  end;

  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    LanguageInfoLabel.Visible:=True;
    LanguageInfoLabel.Caption:=LanguageSetup.LanguageNoVersion;
  end else begin
    If VersionStringToInt(S)<VersionStringToInt(GetNormalFileVersionAsString) then begin
      LanguageInfoLabel.Visible:=True;
      LanguageInfoLabel.Caption:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end else begin
      LanguageInfoLabel.Visible:=False;
    end;
  end;
end;

procedure TSetupForm.InstallerLangEditComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  Timer.Enabled:=False;
  If InstallerLangEditComboBox.ItemIndex<0 then exit;
  I:=Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.ItemIndex]);
  If (I=InstallerLang) or (I=-1) then exit;

  ShellExecute(Handle,'open',PChar(PrgDir+'SetInstallerLanguage.exe'),PChar(IntToStr(I)),nil,SW_SHOW);
  LangTimerCounter:=10;
  Timer.Enabled:=True;
end;

procedure TSetupForm.ListViewMoveButtonClick(Sender: TObject);
Var I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : If ListViewListBox.ItemIndex>0 then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex-1);
        end;
    1 : If (ListViewListBox.ItemIndex>=0) and (ListViewListBox.ItemIndex<ListViewListBox.Items.Count-2) then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex+1);
        end;
    2 : begin
          ListViewListBox.Clear;
          For I:=0 to 5 do begin
            Case I of
              0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
              1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
              2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
              3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
              4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
              5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
            end;
            ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=True;
        end;
    end;
  end;
end;

procedure TSetupForm.ModeComboBoxChange(Sender: TObject);
Var Adv : Boolean;
begin
  Adv:=(ModeComboBox.ItemIndex=1);

  { General }

  StartWithWindowsCheckBox.Visible:=Adv;
  AddButtonFunctionLabel.Visible:=Adv;
  AddButtonFunctionComboBox.Visible:=Adv;
  ToolbarGroupBox.Visible:=Adv;

  { Language }

  LanguageOpenEditor.Visible:=not FirstRun;
  LanguageNew.Visible:=not FirstRun;

  { Game list }

  ListViewSheet.TabVisible:=Adv;

  { Profile editor }

  ProfileEditorSheet.TabVisible:=Adv;

  { DOSBox }

  DosBoxMapperEdit.Visible:=Adv;
  DosBoxMapperButton.Visible:=Adv;
  HideDosBoxConsoleCheckBox.Visible:=Adv;
  MinimizeDFendCheckBox.Visible:=Adv;
  CenterDOSBoxCheckBox.Visible:=Adv;
  SDLVideodriverLabel.Visible:=Adv;
  SDLVideoDriverComboBox.Visible:=Adv;
  SDLVideodriverInfoLabel.Visible:=Adv;

  { Security }

  SecuritySheet.TabVisible:=Adv;

  { Default values }

  DefaultValueSheet.TabVisible:=Adv;

  { Service }

  Service1Button.Visible:=Adv;
  Service2Button.Visible:=Adv;

  If Adv
    then UpdateGroupBox.Top:=Service2Button.Top+Service2Button.Height+12
    else UpdateGroupBox.Top:=Service4Button.Top+Service4Button.Height+12
end;

procedure TSetupForm.NotSetEditChange(Sender: TObject);
begin
  NotSetRadioButton3.Checked:=True;
end;

{ global }

Procedure OpenLanguageEditor(const AOwner : TComponent; const LanguageEditorMode : Integer);
Var S : String;
begin
  Case SetupForm.LanguageEditorMode of
    1 : begin
          ShowLanguageEditorDialog(AOwner,LanguageSetup.SetupFile);
          LanguageSetup.ReloadINI;
        end;
    2 : if ShowLanguageEditorStartDialog(AOwner,S,True) then begin
          ShowLanguageEditorDialog(AOwner,S);
          If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(LanguageSetup.SetupFile)) then LanguageSetup.ReloadINI;
        end;
  end;
end;

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const OpenLanguageTab : Boolean; const FirstRun : Boolean) : Boolean;
begin
  SetupForm:=TSetupForm.Create(AOwner);
  try
    SetupForm.FirstRun:=FirstRun;
    SetupForm.GameDB:=AGameDB;
    if OpenLanguageTab then SetupForm.PageControl.ActivePageIndex:=SetupForm.LanguageSheet.PageIndex else SetupForm.PageControl.ActivePageIndex:=0;
    result:=(SetupForm.ShowModal=mrOK);
    If result and (SetupForm.LanguageEditorMode>0) then OpenLanguageEditor(AOwner,SetupForm.LanguageEditorMode);
  finally
    SetupForm.Free;
  end;
end;

Function ShowTreeListSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  SetupForm:=TSetupForm.Create(AOwner);
  try
    SetupForm.GameDB:=AGameDB;
    SetupForm.SetAdvanced:=True;
    SetupForm.PageControl.ActivePageIndex:=SetupForm.ListViewSheet.PageIndex;
    SetupForm.PageControl1.ActivePageIndex:=SetupForm.ListViewSheet3.PageIndex;
    result:=(SetupForm.ShowModal=mrOK);
    If result and (SetupForm.LanguageEditorMode>0) then OpenLanguageEditor(AOwner,SetupForm.LanguageEditorMode);
  finally
    SetupForm.Free;
  end;
end;

end.
