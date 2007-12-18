unit ProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, ValEdit,
  ImgList;

type
  TProfileEditorForm = class(TForm)
    PageControl: TPageControl;
    ProfileSettingsSheet: TTabSheet;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    IconPanel: TPanel;
    IconImage: TImage;
    IconSelectButton: TBitBtn;
    IconDeleteButton: TBitBtn;
    GameInfoSheet: TTabSheet;
    ProfileSettingsValueListEditor: TValueListEditor;
    ExtraDirsLabel: TLabel;
    ExtraDirsListBox: TListBox;
    ExtraDirsAddButton: TSpeedButton;
    ExtraDirsEditButton: TSpeedButton;
    ExtraDirsDelButton: TSpeedButton;
    GameInfoValueListEditor: TValueListEditor;
    NotesLabel: TLabel;
    OpenDialog: TOpenDialog;
    GeneralSheet: TTabSheet;
    GeneralValueListEditor: TValueListEditor;
    EnvironmentSheet: TTabSheet;
    EnvironmentValueListEditor: TValueListEditor;
    MountingSheet: TTabSheet;
    MountingListView: TListView;
    MountingAddButton: TBitBtn;
    MountingEditButton: TBitBtn;
    MountingDelButton: TBitBtn;
    MountingDeleteAllButton: TBitBtn;
    SoundSheet: TTabSheet;
    AutoexecSheet: TTabSheet;
    CustomSetsSheet: TTabSheet;
    AutoexecOverrideGameStartCheckBox: TCheckBox;
    AutoexecOverrideMountingCheckBox: TCheckBox;
    AutoexecClearButton: TBitBtn;
    SoundValueListEditor: TValueListEditor;
    PageControl2: TPageControl;
    SoundSBSheet: TTabSheet;
    SoundGUSSheet: TTabSheet;
    SoundMIDISheet: TTabSheet;
    SoundMiscSheet: TTabSheet;
    SoundSBValueListEditor: TValueListEditor;
    SoundGUSValueListEditor: TValueListEditor;
    SoundMIDIValueListEditor: TValueListEditor;
    SoundMiscValueListEditor: TValueListEditor;
    CustomSetsClearButton: TBitBtn;
    GenerateScreenshotFolderNameButton: TBitBtn;
    AutoexecLoadButton: TBitBtn;
    AutoexecSaveButton: TBitBtn;
    CustomSetsLoadButton: TBitBtn;
    CustomSetsSaveButton: TBitBtn;
    SaveDialog: TSaveDialog;
    KeyboardLayoutInfoLabel: TLabel;
    SoundJoystickSheet: TTabSheet;
    SoundJoystickValueListEditor: TValueListEditor;
    AutoexecBootNormal: TRadioButton;
    AutoexecBootHDImage: TRadioButton;
    AutoexecBootFloppyImage: TRadioButton;
    AutoexecBootHDImageComboBox: TComboBox;
    AutoexecBootFloppyImageEdit: TEdit;
    AutoexecBootFloppyImageButton: TSpeedButton;
    CustomSetsValueListEditor: TValueListEditor;
    CustomSetsEnvAdd: TBitBtn;
    CustomSetsEnvDel: TBitBtn;
    CustomSetsEnvLabel: TLabel;
    NotesMemo: TRichEdit;
    AutoexecMemo: TRichEdit;
    CustomSetsMemo: TRichEdit;
    GenerateGameDataFolderNameButton: TBitBtn;
    ImageList: TImageList;
    MountingAutoCreateButton: TBitBtn;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProfileSettingsValueListEditorEditButtonClick(Sender: TObject);
    procedure ExtraDirsListBoxClick(Sender: TObject);
    procedure ExtraDirsListBoxDblClick(Sender: TObject);
    procedure ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MountingListViewDblClick(Sender: TObject);
    procedure MountingListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure GameInfoValueListEditorEditButtonClick(Sender: TObject);
    procedure ProfileSettingsValueListEditorSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure ProfileSettingsValueListEditorKeyUp(Sender: TObject;
      var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    IconName : String;
    Mounting : TStringList;
    Procedure LoadIcon;
    Procedure InitGUI;
    Procedure LoadData;
    Procedure LoadMountingList;
    Function NextFreeDriveLetter : Char;
  public
    { Public-Deklarationen }
    MoveStatus : Integer;
    LoadTemplate, Game : TGame;
    GameDB : TGameDB;
    RestoreLastPosition : Boolean;
  end;

var
  ProfileEditorForm: TProfileEditorForm;

Function EditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const GameList : TList = nil) : Boolean;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgConsts,
     PrgSetupUnit, IconManagerFormUnit, ProfileMountEditorFormUnit;

{$R *.dfm}

var LastPage, LastTop, LastLeft : Integer;

procedure TProfileEditorForm.InitGUI;
Var St : TStringList;
    I : Integer;
    L : TListColumn;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  MoveStatus:=0;

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  PreviousButton.Caption:=LanguageSetup.Previous;
  NextButton.Caption:=LanguageSetup.Next;

  {Profile Settings Sheet}

  ProfileSettingsSheet.Caption:=LanguageSetup.ProfileEditorProfileSettingsSheet;
  IconPanel.ControlStyle:=IconPanel.ControlStyle-[csParentBackground];
  IconSelectButton.Caption:=LanguageSetup.ProfileEditorIconSelect;
  IconDeleteButton.Caption:=LanguageSetup.ProfileEditorIconDelete;
  ProfileSettingsValueListEditor.TitleCaptions.Clear;
  ProfileSettingsValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  ProfileSettingsValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with ProfileSettingsValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorProfileName+'=');
    Strings.Add(LanguageSetup.ProfileEditorFilename+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    Strings.Add(LanguageSetup.ProfileEditorGameEXE+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.ProfileEditorGameParameters+'=');
    Strings.Add(LanguageSetup.ProfileEditorSetupEXE+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.ProfileEditorSetupParameters+'=');
    Strings.Add(LanguageSetup.ProfileEditorLoadFix+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorLoadFixMemory+'=');
    ItemProps[Strings.Count-1].EditMask:='900';
    Strings.Add(LanguageSetup.ProfileEditorCaptureFolder+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
  end;
  ExtraDirsLabel.Caption:=LanguageSetup.ProfileEditorExtraDirs;
  ExtraDirsAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraDirsEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraDirsDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  GenerateScreenshotFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateScreenshotFolderName;

  { Game Info Sheet }

  GameInfoSheet.Caption:=LanguageSetup.ProfileEditorGameInfoSheet;
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
    Strings.Add(LanguageSetup.GameDataDir+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameFavorite+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;
  GenerateGameDataFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateGameDataFolder;
  NotesLabel.Caption:=LanguageSetup.GameNotes+':';

  { General Sheet }

  GeneralSheet.Caption:=LanguageSetup.ProfileEditorGeneralSheet;
  GeneralValueListEditor.TitleCaptions.Clear;
  GeneralValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GeneralValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GeneralValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameCloseDosBoxAfterGameExit+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameStartFullscreen+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameAutoLockMouse+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameUseDoublebuffering+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameAspectCorrection+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameUseScanCodes+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameMouseSensitivity+'=');
    ItemProps[Strings.Count-1].EditMask:='9000';
    For I:=1 to 10 do ItemProps[Strings.Count-1].PickList.Add(IntToStr(I*10));
    For I:=1 to 4 do ItemProps[Strings.Count-1].PickList.Add(IntToStr(100+I*25));
    For I:=1 to 8 do ItemProps[Strings.Count-1].PickList.Add(IntToStr(200+I*50));
    For I:=7 to 10 do ItemProps[Strings.Count-1].PickList.Add(IntToStr(I*100));
    Strings.Add(LanguageSetup.GameRender+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Render,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameWindowResolution+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Resolution,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameFullscreenResolution+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Resolution,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameScale+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Scale,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePriorityForeground+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('lower');
    ItemProps[Strings.Count-1].PickList.Add('normal');
    ItemProps[Strings.Count-1].PickList.Add('higher');
    ItemProps[Strings.Count-1].PickList.Add('highest');
    Strings.Add(LanguageSetup.GamePriorityBackground+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('lower');
    ItemProps[Strings.Count-1].PickList.Add('normal');
    ItemProps[Strings.Count-1].PickList.Add('higher');
    ItemProps[Strings.Count-1].PickList.Add('highest');
  end;

  { Environment Sheet }

  EnvironmentSheet.Caption:=LanguageSetup.ProfileEditorEnvironmentSheet;
  EnvironmentValueListEditor.TitleCaptions.Clear;
  EnvironmentValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  EnvironmentValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  KeyboardLayoutInfoLabel.Caption:=LanguageSetup.GameKeyboardLayoutInfo;
  with EnvironmentValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameMemory+'=');
    ItemProps[Strings.Count-1].EditMask:='90';
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Memory,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameXMS+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameEMS+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameUMB+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameCycles+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Cycles,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameCyclesUp+'=');
    ItemProps[Strings.Count-1].EditMask:='9000';
    Strings.Add(LanguageSetup.GameCyclesDown+'=');
    ItemProps[Strings.Count-1].EditMask:='9000';
    Strings.Add(LanguageSetup.GameCore+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Core,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameFrameskip+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Frameskip,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameVideoCard+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    ItemProps[Strings.Count-1].PickList.Add('hercules');
    ItemProps[Strings.Count-1].PickList.Add('cga');
    ItemProps[Strings.Count-1].PickList.Add('tandy');
    ItemProps[Strings.Count-1].PickList.Add('vga');
    Strings.Add(LanguageSetup.GameKeyboardLayout+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameSerial+' 1=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Serial,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameSerial+' 2=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Serial,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameSerial+' 3=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Serial,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameSerial+' 4=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Serial,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameIPX+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameIPXEstablishConnection+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.GameIPXEstablishConnectionNone));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.GameIPXEstablishConnectionClient));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.GameIPXEstablishConnectionServer));
    Strings.Add(LanguageSetup.GameIPXAddress+'=');
    Strings.Add(LanguageSetup.GameIPXPort+'=');
  end;

  { Mounting Sheet }

  MountingSheet.Caption:=LanguageSetup.ProfileEditorMountingSheet;
  MountingAddButton.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  MountingEditButton.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  MountingDelButton.Caption:=LanguageSetup.ProfileEditorMountingDel;
  MountingDeleteAllButton.Caption:=LanguageSetup.ProfileEditorMountingDelAll;
  MountingDeleteAllButton.Caption:=LanguageSetup.ProfileEditorMountingDelAll;
  MountingAutoCreateButton.Caption:=LanguageSetup.ProfileEditorMountingAutoCreate;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingFolderImage;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingAs;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLetter;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLabel;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingIOControl;

  { Sound Sheet }

  SoundSheet.Caption:=LanguageSetup.ProfileEditorSoundSheet;
  SoundValueListEditor.TitleCaptions.Clear;
  SoundValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundEnableSound+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundSampleRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('8000');
    ItemProps[Strings.Count-1].PickList.Add('11025');
    ItemProps[Strings.Count-1].PickList.Add('22050');
    ItemProps[Strings.Count-1].PickList.Add('32000');
    ItemProps[Strings.Count-1].PickList.Add('44100');
    Strings.Add(LanguageSetup.ProfileEditorSoundBlockSize+'=');
    ItemProps[Strings.Count-1].PickList.Add('512');
    ItemProps[Strings.Count-1].PickList.Add('1024');
    ItemProps[Strings.Count-1].PickList.Add('2048');
    ItemProps[Strings.Count-1].PickList.Add('4096');
    ItemProps[Strings.Count-1].PickList.Add('8192');
    Strings.Add(LanguageSetup.ProfileEditorSoundPrebuffer+'=');
    ItemProps[Strings.Count-1].PickList.Add('1');
    ItemProps[Strings.Count-1].PickList.Add('5');
    ItemProps[Strings.Count-1].PickList.Add('10');
    ItemProps[Strings.Count-1].PickList.Add('15');
    ItemProps[Strings.Count-1].PickList.Add('20');
    ItemProps[Strings.Count-1].PickList.Add('25');
    ItemProps[Strings.Count-1].PickList.Add('30');
  end;
  SoundSBSheet.Caption:=LanguageSetup.ProfileEditorSoundSoundBlaster;
  SoundGUSSheet.Caption:=LanguageSetup.ProfileEditorSoundGUS;
  SoundMIDISheet.Caption:=LanguageSetup.ProfileEditorSoundMIDI;
  SoundJoystickSheet.Caption:=LanguageSetup.ProfileEditorSoundJoystick;
  SoundMiscSheet.Caption:=LanguageSetup.ProfileEditorSoundMisc;

  SoundSBValueListEditor.TitleCaptions.Clear;
  SoundSBValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundSBValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundSBValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundSBType+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Sblaster,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBAddress+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('210');
    ItemProps[Strings.Count-1].PickList.Add('220');
    ItemProps[Strings.Count-1].PickList.Add('240');
    ItemProps[Strings.Count-1].PickList.Add('260');
    ItemProps[Strings.Count-1].PickList.Add('280');
    Strings.Add(LanguageSetup.ProfileEditorSoundSBIRQ+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('3');
    ItemProps[Strings.Count-1].PickList.Add('5');
    ItemProps[Strings.Count-1].PickList.Add('7');
    ItemProps[Strings.Count-1].PickList.Add('10');
    ItemProps[Strings.Count-1].PickList.Add('11');
    Strings.Add(LanguageSetup.ProfileEditorSoundSBDMA+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('0');
    ItemProps[Strings.Count-1].PickList.Add('1');
    ItemProps[Strings.Count-1].PickList.Add('3');
    Strings.Add(LanguageSetup.ProfileEditorSoundSBHDMA+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('5');
    ItemProps[Strings.Count-1].PickList.Add('6');
    ItemProps[Strings.Count-1].PickList.Add('7');
    Strings.Add(LanguageSetup.ProfileEditorSoundSBOplMode+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Oplmode,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBOplRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('8000');
    ItemProps[Strings.Count-1].PickList.Add('11025');
    ItemProps[Strings.Count-1].PickList.Add('22050');
    ItemProps[Strings.Count-1].PickList.Add('32000');
    ItemProps[Strings.Count-1].PickList.Add('44100');
    Strings.Add(LanguageSetup.ProfileEditorSoundSBUseMixer+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;

  SoundGUSValueListEditor.TitleCaptions.Clear;
  SoundGUSValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundGUSValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundGUSValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSEnabled+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSAddress+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('210');
    ItemProps[Strings.Count-1].PickList.Add('220');
    ItemProps[Strings.Count-1].PickList.Add('240');
    ItemProps[Strings.Count-1].PickList.Add('260');
    ItemProps[Strings.Count-1].PickList.Add('280');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSIRQ1+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('3');
    ItemProps[Strings.Count-1].PickList.Add('5');
    ItemProps[Strings.Count-1].PickList.Add('7');
    ItemProps[Strings.Count-1].PickList.Add('10');
    ItemProps[Strings.Count-1].PickList.Add('11');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSIRQ2+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('3');
    ItemProps[Strings.Count-1].PickList.Add('5');
    ItemProps[Strings.Count-1].PickList.Add('7');
    ItemProps[Strings.Count-1].PickList.Add('10');
    ItemProps[Strings.Count-1].PickList.Add('11');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSDMA1+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('0');
    ItemProps[Strings.Count-1].PickList.Add('1');
    ItemProps[Strings.Count-1].PickList.Add('3');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSDMA2+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('0');
    ItemProps[Strings.Count-1].PickList.Add('1');
    ItemProps[Strings.Count-1].PickList.Add('3');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('8000');
    ItemProps[Strings.Count-1].PickList.Add('11025');
    ItemProps[Strings.Count-1].PickList.Add('22050');
    ItemProps[Strings.Count-1].PickList.Add('32000');
    ItemProps[Strings.Count-1].PickList.Add('44100');
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSPath+'=');
  end;

  SoundMIDIValueListEditor.TitleCaptions.Clear;
  SoundMIDIValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundMIDIValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundMIDIValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundMIDIType+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('intelligent');
    ItemProps[Strings.Count-1].PickList.Add('none');
    ItemProps[Strings.Count-1].PickList.Add('uart');
    Strings.Add(LanguageSetup.ProfileEditorSoundMIDIDevice+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('default');
    ItemProps[Strings.Count-1].PickList.Add('alsa');
    ItemProps[Strings.Count-1].PickList.Add('oss');
    ItemProps[Strings.Count-1].PickList.Add('win32');
    ItemProps[Strings.Count-1].PickList.Add('coreaudio');
    ItemProps[Strings.Count-1].PickList.Add('none');
    Strings.Add(LanguageSetup.ProfileEditorSoundMIDIConfigInfo+'=');
  end;

  SoundJoystickValueListEditor.TitleCaptions.Clear;
  SoundJoystickValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundJoystickValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundJoystickValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundJoystickType+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Joysticks,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundJoystickTimed+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundJoystickAutoFire+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundJoystickSwap34+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundJoystickButtonwrap+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;

  SoundMiscValueListEditor.TitleCaptions.Clear;
  SoundMiscValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundMiscValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundMiscValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscEnablePCSpeaker+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('8000');
    ItemProps[Strings.Count-1].PickList.Add('11025');
    ItemProps[Strings.Count-1].PickList.Add('22050');
    ItemProps[Strings.Count-1].PickList.Add('32000');
    ItemProps[Strings.Count-1].PickList.Add('44100');
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscEnableTandy+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('auto');
    ItemProps[Strings.Count-1].PickList.Add('off');
    ItemProps[Strings.Count-1].PickList.Add('on');
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscTandyRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('8000');
    ItemProps[Strings.Count-1].PickList.Add('11025');
    ItemProps[Strings.Count-1].PickList.Add('22050');
    ItemProps[Strings.Count-1].PickList.Add('32000');
    ItemProps[Strings.Count-1].PickList.Add('44100');
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscEnableDisneySoundsSource+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;

  { Autoexec Sheet }

  AutoexecSheet.Caption:=LanguageSetup.ProfileEditorAutoexecSheet;
  AutoexecOverrideGameStartCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideGameStart;
  AutoexecOverrideMountingCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideMounting;
  AutoexecClearButton.Caption:=LanguageSetup.Del;
  AutoexecLoadButton.Caption:=LanguageSetup.Load;
  AutoexecSaveButton.Caption:=LanguageSetup.Save;
  AutoexecBootNormal.Caption:=LanguageSetup.ProfileEditorAutoexecBootNormal;
  AutoexecBootHDImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootHDImage;
  AutoexecBootFloppyImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootFloppyImage;
  AutoexecBootFloppyImageButton.Hint:=LanguageSetup.ChooseFile;

  { CustomSets Sheet }

  CustomSetsSheet.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsClearButton.Caption:=LanguageSetup.Del;
  CustomSetsLoadButton.Caption:=LanguageSetup.Load;
  CustomSetsSaveButton.Caption:=LanguageSetup.Save;
  CustomSetsEnvLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsEnvironment;
  CustomSetsValueListEditor.TitleCaptions.Clear;
  CustomSetsValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  CustomSetsValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  CustomSetsEnvAdd.Caption:=LanguageSetup.Add;
  CustomSetsEnvDel.Caption:=LanguageSetup.Del;
end;

procedure TProfileEditorForm.FormShow(Sender: TObject);
begin
  Mounting:=TStringList.Create;

  InitGUI;

  If (Game=nil) and (LoadTemplate<>nil) then begin
    Game:=LoadTemplate;
    try LoadData; finally Game:=nil; end;
  end else begin
    LoadData;
  end;

  If RestoreLastPosition then begin
    PageControl.ActivePageIndex:=LastPage;
    Top:=LastTop;
    Left:=LastLeft;
  end;
end;

procedure TProfileEditorForm.FormDestroy(Sender: TObject);
begin
  Mounting.Free;
end;

procedure TProfileEditorForm.LoadData;
Var St : TStringList;
    S,T : String;
    I : Integer;
begin
  {Profile Settings Sheet}

  If Game=nil then begin
    with ProfileSettingsValueListEditor.Strings do begin
      ValueFromIndex[1]:=LanguageSetup.ProfileEditorNoFilename;
      ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[7]:='64';
      ValueFromIndex[8]:=MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir);
    end;
  end else begin
    IconName:=Game.Icon;
    LoadIcon;
    with ProfileSettingsValueListEditor.Strings do begin
      If LoadTemplate=nil then begin
        If Game.Name<>'' then ValueFromIndex[0]:=Game.Name;
      end;
      If LoadTemplate<>nil then begin
        ValueFromIndex[1]:=LanguageSetup.ProfileEditorNoFilename;
      end else begin
        If Game.SetupFile<>'' then begin
          ValueFromIndex[1]:=ExtractFileName(Game.SetupFile)
        end else begin
          ProfileSettingsValueListEditor.ItemProps[0].ReadOnly:=True;
          ValueFromIndex[0]:=LanguageSetup.ProfileEditorNoFilename;
          ValueFromIndex[1]:=LanguageSetup.ProfileEditorNoFilename;
        end;
      end;
      If Game.GameExe<>'' then ValueFromIndex[2]:=Game.GameExe;
      If Game.GameParameters<>'' then ValueFromIndex[3]:=Game.GameParameters;
      If Game.SetupExe<>'' then ValueFromIndex[4]:=Game.SetupExe;
      If Game.SetupParameters<>'' then ValueFromIndex[5]:=Game.SetupParameters;
      If Game.LoadFix then ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[7]:=IntToStr(Game.LoadFixMemory);
      If Game.CaptureFolder<>'' then ValueFromIndex[8]:=Game.CaptureFolder else ValueFromIndex[8]:=MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir);
    end;
    St:=ValueToList(Game.ExtraDirs); try ExtraDirsListBox.Items.AddStrings(St); finally St.Free; end;
    If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=0;
  end;
  ExtraDirsListBoxClick(nil);

  { Game Info Sheet }

  If Game=nil then begin
    GameInfoValueListEditor.Strings.ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
  end else begin
    with GameInfoValueListEditor.Strings do begin
      If Game.Genre<>'' then ValueFromIndex[0]:=Game.Genre;
      If Game.Developer<>'' then ValueFromIndex[1]:=Game.Developer;
      If Game.Publisher<>'' then ValueFromIndex[2]:=Game.Publisher;
      If Game.Year<>'' then ValueFromIndex[3]:=Game.Year;
      If Game.Language<>'' then ValueFromIndex[4]:=Game.Language;
      If Game.WWW<>'' then ValueFromIndex[5]:=Game.WWW;
      If Game.DataDir<>'' then ValueFromIndex[6]:=Game.DataDir;
      If Game.Favorite then ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.No);
    end;
    St:=StringToStringList(Game.Notes);
    try NotesMemo.Lines.Assign(St); finally St.Free; end;
  end;

  { General Sheet }

  If Game=nil then begin
    with GeneralValueListEditor.Strings do begin
      ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[6]:='100';
      ValueFromIndex[7]:='surface';
      ValueFromIndex[8]:='original';
      ValueFromIndex[9]:='original';
      ValueFromIndex[10]:='normal2x';
      ValueFromIndex[11]:='higher';
      ValueFromIndex[12]:='normal';
    end;
  end else begin
    with GeneralValueListEditor.Strings do begin
      If Game.CloseDosBoxAfterGameExit then ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.No);
      If Game.StartFullscreen then ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.No);
      If Game.AutoLockMouse then ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      If Game.UseDoublebuffering then ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      If Game.AspectCorrection then ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      If Game.UseScanCodes then ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[6]:=IntToStr(Game.MouseSensitivity);
      If Game.Render<>'' then ValueFromIndex[7]:=Game.Render;
      If Game.WindowResolution<>'' then ValueFromIndex[8]:=Game.WindowResolution;
      If Game.FullscreenResolution<>'' then ValueFromIndex[9]:=Game.FullscreenResolution;

      St:=ValueToList(GameDB.ConfOpt.Scale,';,');
      try
        If Game.Scale='' then begin
          If St.Count>0 then ValueFromIndex[10]:=St[0];
        end else begin
          S:=Trim(ExtUpperCase(Game.Scale));
          For I:=0 to St.Count-1 do begin
            T:=Trim(ExtUpperCase(St[I]));
            If Pos('(',T)=0 then continue;
            T:=Copy(T,Pos('(',T)+1,MaxInt);
            If Pos(')',T)=0 then continue;
            T:=Copy(T,1,Pos(')',T)-1);
            If Trim(T)=S then ValueFromIndex[10]:=St[I];
          end;
        end;
      finally
        St.Free;
      end;

      St:=ValueToList(Game.Priority,',');
      try
        If (St.Count>=1) and (St[0]<>'') then ValueFromIndex[11]:=St[0];
        If (St.Count>=2) and (St[1]<>'') then ValueFromIndex[12]:=St[1];
      finally
        St.Free;
      end;
    end;
  end;

  { Environment Sheet }

  If Game=nil then begin
    with EnvironmentValueListEditor.Strings do begin
      ValueFromIndex[0]:='32';
      ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[4]:='auto';
      ValueFromIndex[5]:='500';
      ValueFromIndex[6]:='20';
      ValueFromIndex[7]:='auto';
      ValueFromIndex[8]:='0';
      ValueFromIndex[9]:='vga';
      ValueFromIndex[10]:='default';
      ValueFromIndex[11]:='dummy';
      ValueFromIndex[12]:='dummy';
      ValueFromIndex[13]:='disabled';
      ValueFromIndex[14]:='disabled';
      ValueFromIndex[15]:=RemoveUnderline(LanguageSetup.No);
    end;
  end else begin
    with EnvironmentValueListEditor.Strings do begin
      ValueFromIndex[0]:=IntToStr(Game.Memory);
      If Game.XMS then ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.No);
      If Game.EMS then ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      If Game.UMB then ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[4]:=Game.Cycles;
      ValueFromIndex[5]:=IntToStr(Game.CyclesUp);
      ValueFromIndex[6]:=IntToStr(Game.CyclesDown);
      if Game.Core<>'' then ValueFromIndex[7]:=Game.Core;
      ValueFromIndex[8]:=IntToStr(Game.FrameSkip);
      If Game.VideoCard<>'' then ValueFromIndex[9]:=Game.VideoCard;
      If Game.KeyboardLayout<>'' then ValueFromIndex[10]:=Game.KeyboardLayout else ValueFromIndex[10]:='default';
      ValueFromIndex[11]:=Game.Serial1;
      ValueFromIndex[12]:=Game.Serial2;
      ValueFromIndex[13]:=Game.Serial3;
      ValueFromIndex[14]:=Game.Serial4;
      If Game.IPX then ValueFromIndex[15]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[15]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[16]:=LanguageSetup.GameIPXEstablishConnectionNone;
      S:=Trim(ExtUpperCase(Game.IPXType));
      If S='CLIENT' then ValueFromIndex[16]:=LanguageSetup.GameIPXEstablishConnectionClient;
      If S='SERVER' then ValueFromIndex[16]:=LanguageSetup.GameIPXEstablishConnectionServer;
      If Game.IPXAddress<>'' then ValueFromIndex[17]:=Game.IPXAddress;
      If Game.IPXPort<>'' then ValueFromIndex[18]:=Game.IPXPort;
    end;
  end;

  { Mounting Sheet }

  If Game<>nil then begin
    If Game.NrOfMounts>=1 then Mounting.Add(Game.Mount0);
    If Game.NrOfMounts>=2 then Mounting.Add(Game.Mount1);
    If Game.NrOfMounts>=3 then Mounting.Add(Game.Mount2);
    If Game.NrOfMounts>=4 then Mounting.Add(Game.Mount3);
    If Game.NrOfMounts>=5 then Mounting.Add(Game.Mount4);
    If Game.NrOfMounts>=6 then Mounting.Add(Game.Mount5);
    If Game.NrOfMounts>=7 then Mounting.Add(Game.Mount6);
    If Game.NrOfMounts>=8 then Mounting.Add(Game.Mount7);
    If Game.NrOfMounts>=9 then Mounting.Add(Game.Mount8);
    If Game.NrOfMounts>=10 then Mounting.Add(Game.Mount9);
    LoadMountingList;
  end;

  { Sound Sheet }

  If Game=nil then begin
    with SoundValueListEditor.Strings do begin
      ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[1]:='22050';
      ValueFromIndex[2]:='2048';
      ValueFromIndex[3]:='10';
    end;
    with SoundSBValueListEditor.Strings do begin
      ValueFromIndex[0]:='sb16';
      ValueFromIndex[1]:='220';
      ValueFromIndex[2]:='7';
      ValueFromIndex[3]:='1';
      ValueFromIndex[4]:='5';
      ValueFromIndex[5]:='auto';
      ValueFromIndex[6]:='22050';
      ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.Yes);
    end;
    with SoundGUSValueListEditor.Strings do begin
      ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[1]:='240';
      ValueFromIndex[2]:='5';
      ValueFromIndex[3]:='5';
      ValueFromIndex[4]:='1';
      ValueFromIndex[5]:='1';
      ValueFromIndex[6]:='22050';
      ValueFromIndex[7]:='C:\ULTRASND';
    end;
    with SoundMIDIValueListEditor.Strings do begin
      ValueFromIndex[0]:='intelligent';
      ValueFromIndex[1]:='default';
      ValueFromIndex[2]:='';
    end;
    with SoundJoystickValueListEditor.Strings do begin
      ValueFromIndex[0]:='none';
      ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes);
    end;
    with SoundMiscValueListEditor.Strings do begin
      ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[1]:='22050';
      ValueFromIndex[2]:='auto';
      ValueFromIndex[3]:='22050';
      ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes);
    end;
  end else begin
    with SoundValueListEditor.Strings do begin
      If not Game.MixerNosound then ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[1]:=IntToStr(Game.MixerRate);
      ValueFromIndex[2]:=IntToStr(Game.MixerBlocksize);
      ValueFromIndex[3]:=IntToStr(Game.MixerPrebuffer);
    end;
    with SoundSBValueListEditor.Strings do begin
      If Game.SBType<>'' then ValueFromIndex[0]:=Game.SBType;
      ValueFromIndex[1]:=IntToStr(Game.SBBase);
      ValueFromIndex[2]:=IntToStr(Game.SBIRQ);
      ValueFromIndex[3]:=IntToStr(Game.SBDMA);
      ValueFromIndex[4]:=IntToStr(Game.SBHDMA);
      If Game.SBOplMode<>'' then ValueFromIndex[5]:=Game.SBOplMode;
      ValueFromIndex[6]:=IntToStr(Game.SBOplRate);
      If Game.SBMixer then ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.No);
    end;
    with SoundGUSValueListEditor.Strings do begin
      If Game.GUS then ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[1]:=IntToStr(Game.GUSBase);
      ValueFromIndex[2]:=IntToStr(Game.GUSIRQ1);
      ValueFromIndex[3]:=IntToStr(Game.GUSIRQ2);
      ValueFromIndex[4]:=IntToStr(Game.GUSDMA1);
      ValueFromIndex[5]:=IntToStr(Game.GUSDMA2);
      ValueFromIndex[6]:=IntToStr(Game.GUSRate);
      If Game.GUSUltraDir<>'' then ValueFromIndex[7]:=Game.GUSUltraDir;
    end;
    with SoundMIDIValueListEditor.Strings do begin
      If Game.MIDIType<>'' then ValueFromIndex[0]:=Game.MIDIType;
      If Game.MIDIDevice<>'' then ValueFromIndex[1]:=Game.MIDIDevice;
      If Game.MIDIConfig<>'' then ValueFromIndex[2]:=Game.MIDIConfig;
    end;
    with SoundJoystickValueListEditor.Strings do begin
      If Game.JoystickType<>'' then ValueFromIndex[0]:=Game.JoystickType;
      If Game.JoystickTimed then ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.No);
      If Game.JoystickAutoFire then ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      If Game.JoystickSwap34 then ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      If Game.JoystickButtonwrap then ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
    end;
    with SoundMiscValueListEditor.Strings do begin
      If Game.SpeakerPC then ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[1]:=IntToStr(Game.SpeakerRate);
      ValueFromIndex[2]:=Game.SpeakerTandy;
      ValueFromIndex[3]:=IntToStr(Game.SpeakerTandyRate);
      If Game.SpeakerDisney then ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
    end;
  end;

  { Autoexec Sheet }

  If Game=nil then begin
    AutoexecOverrideGameStartCheckBox.Checked:=False;
    AutoexecOverrideMountingCheckBox.Checked:=False;
  end else begin
    AutoexecOverrideGameStartCheckBox.Checked:=Game.AutoexecOverridegamestart;
    AutoexecOverrideMountingCheckBox.Checked:=Game.AutoexecOverrideMount;
    St:=StringToStringList(Game.Autoexec);
    try
      AutoexecMemo.Lines.Assign(St);
    finally
      St.Free;
    end;
    S:=Trim(Game.AutoexecBootImage);
    If (S='2') or (S='3') then begin
      AutoexecBootHDImage.Checked:=True;
      If S='2' then AutoexecBootHDImageComboBox.ItemIndex:=0 else AutoexecBootHDImageComboBox.ItemIndex:=1;
    end else If S<>'' then begin
      AutoexecBootFloppyImage.Checked:=True;
      AutoexecBootFloppyImageEdit.Text:=S;
    end;
  end;

  { CustomSets Sheet }

  If Game=nil then begin
    CustomSetsValueListEditor.Strings.Add('PATH=Z:\');
  end else begin
    St:=StringToStringList(Game.CustomSettings);
    try
      CustomSetsMemo.Lines.Assign(St);
    finally
      St.Free;
    end;
    St:=StringToStringList(Game.Environment);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then
        CustomSetsValueListEditor.Strings.Add(Replace(St[I],'['+IntToStr(ord('='))+']','='));
    finally
      St.Free;
    end;
  end;

  { Sheet Nr }

  If PrgSetup.ReopenLastProfileEditorTab and (Game<>nil) then begin
    Case Game.LastOpenTab of
      0..5 : PageControl.ActivePageIndex:=Game.LastOpenTab;
      6 : PageControl.ActivePageIndex:=7;
      7 : PageControl.ActivePageIndex:=6;
      8 : PageControl.ActivePageIndex:=2;
      9 : PageControl.ActivePageIndex:=5;
    end;
  end else begin
    PageControl.ActivePageIndex:=0;
  end;
end;

procedure TProfileEditorForm.LoadIcon;
begin
  If IconName='' then begin
    IconImage.Picture:=nil;
    exit;
  end;
  try
    IconImage.Picture.LoadFromFile(IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir)+IconName);
  except end;
end;

procedure TProfileEditorForm.LoadMountingList;
Var I : Integer;
    St : TStringList;
    L : TListItem;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        L:=MountingListView.Items.Add;
        L.Caption:=St[0];
        If St.Count>1 then L.SubItems.Add(St[1]) else L.SubItems.Add('');
        If St.Count>2 then L.SubItems.Add(St[2]) else L.SubItems.Add('');
        If St.Count>4 then L.SubItems.Add(St[4]) else L.SubItems.Add('');
        If St.Count>3 then begin
          If Trim(ExtUpperCase(St[2]))='TRUE' then L.SubItems.Add(RemoveUnderline(LanguageSetup.Yes)) else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
        end else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
      finally
        St.Free;
      end;
    end;
    If MountingListView.Items.Count>0 then MountingListView.ItemIndex:=0;
  finally
    MountingListView.Items.EndUpdate;
  end;
end;

procedure TProfileEditorForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    St : TStringList;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : MoveStatus:=0;
    1 : MoveStatus:=-1;
    2 : MoveStatus:=1;
  End;

  If Game=nil then begin
    I:=GameDB.Add(ProfileSettingsValueListEditor.Strings.ValueFromIndex[0]);
    Game:=GameDB[I];
  end;

  {Profile Settings Sheet}

  Game.Icon:=IconName;
  with ProfileSettingsValueListEditor.Strings do begin
    If not ProfileSettingsValueListEditor.ItemProps[0].ReadOnly then Game.Name:=ValueFromIndex[0];
    Game.GameExe:=ValueFromIndex[2];
    Game.GameParameters:=ValueFromIndex[3];
    Game.SetupExe:=ValueFromIndex[4];
    Game.SetupParameters:=ValueFromIndex[5];
    Game.LoadFix:=(ValueFromIndex[6]=RemoveUnderline(LanguageSetup.Yes));
    try Game.LoadFixMemory:=StrToInt(ValueFromIndex[7]); except end;
    Game.CaptureFolder:=ValueFromIndex[8];
  end;
  Game.ExtraDirs:=ListToValue(ExtraDirsListBox.Items);

  { Game Info Sheet}

  with GameInfoValueListEditor.Strings do begin
    Game.Genre:=ValueFromIndex[0];
    Game.Developer:=ValueFromIndex[1];
    Game.Publisher:=ValueFromIndex[2];
    Game.Year:=ValueFromIndex[3];
    Game.Language:=ValueFromIndex[4];
    Game.WWW:=ValueFromIndex[5];
    Game.DataDir:=ValueFromIndex[6];
    Game.Favorite:=(ValueFromIndex[7]=RemoveUnderline(LanguageSetup.Yes));
  end;
  Game.Notes:=StringListToString(NotesMemo.Lines);

  { General Sheet }

  with GeneralValueListEditor.Strings do begin
    Game.CloseDosBoxAfterGameExit:=(ValueFromIndex[0]=RemoveUnderline(LanguageSetup.Yes));
    Game.StartFullscreen:=(ValueFromIndex[1]=RemoveUnderline(LanguageSetup.Yes));
    Game.AutoLockMouse:=(ValueFromIndex[2]=RemoveUnderline(LanguageSetup.Yes));
    Game.UseDoublebuffering:=(ValueFromIndex[3]=RemoveUnderline(LanguageSetup.Yes));
    Game.AspectCorrection:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
    Game.UseScanCodes:=(ValueFromIndex[5]=RemoveUnderline(LanguageSetup.Yes));
    try Game.MouseSensitivity:=StrToInt(ValueFromIndex[6]); except end;
    Game.Render:=ValueFromIndex[7];
    Game.WindowResolution:=ValueFromIndex[8];
    Game.FullscreenResolution:=ValueFromIndex[9];
    S:=ValueFromIndex[10];
    If Pos('(',S)=0 then Game.Scale:='' else begin
      S:=Copy(S,Pos('(',S)+1,MaxInt);
      If Pos(')',S)=0 then Game.Scale:=''  else Game.Scale:=Copy(S,1,Pos(')',S)-1);
    end;
    Game.Priority:=ValueFromIndex[11]+','+ValueFromIndex[12];
  end;

  { Environment Sheet }

  with EnvironmentValueListEditor.Strings do begin
    try Game.Memory:=StrToInt(ValueFromIndex[0]); except end;
    Game.XMS:=(ValueFromIndex[1]=RemoveUnderline(LanguageSetup.Yes));
    Game.EMS:=(ValueFromIndex[2]=RemoveUnderline(LanguageSetup.Yes));
    Game.UMB:=(ValueFromIndex[3]=RemoveUnderline(LanguageSetup.Yes));
    Game.Cycles:=ValueFromIndex[4];
    try Game.CyclesUp:=StrToInt(ValueFromIndex[5]); except end;
    try Game.CyclesDown:=StrToInt(ValueFromIndex[6]); except end;
    Game.Core:=ValueFromIndex[7];
    try Game.FrameSkip:=StrToInt(ValueFromIndex[8]); except end;
    Game.VideoCard:=ValueFromIndex[9];
    Game.KeyboardLayout:=ValueFromIndex[10];

    Game.Serial1:=ValueFromIndex[11];
    Game.Serial2:=ValueFromIndex[12];
    Game.Serial3:=ValueFromIndex[13];
    Game.Serial4:=ValueFromIndex[14];
    Game.IPX:=(ValueFromIndex[15]=RemoveUnderline(LanguageSetup.Yes));
    If ValueFromIndex[16]=LanguageSetup.GameIPXEstablishConnectionNone then Game.IPXType:='none';
    If ValueFromIndex[16]=LanguageSetup.GameIPXEstablishConnectionClient then Game.IPXType:='client';
    If ValueFromIndex[16]=LanguageSetup.GameIPXEstablishConnectionServer then Game.IPXType:='server';
    Game.IPXAddress:=ValueFromIndex[17];
    Game.IPXPort:=ValueFromIndex[18];
  end;

  { Mounting Sheet }

  Game.NrOfMounts:=Mounting.Count;
  If Mounting.Count>0 then Game.Mount0:=Mounting[0] else Game.Mount0:='';
  If Mounting.Count>1 then Game.Mount1:=Mounting[1] else Game.Mount1:='';
  If Mounting.Count>2 then Game.Mount2:=Mounting[2] else Game.Mount2:='';
  If Mounting.Count>3 then Game.Mount3:=Mounting[3] else Game.Mount3:='';
  If Mounting.Count>4 then Game.Mount4:=Mounting[4] else Game.Mount4:='';
  If Mounting.Count>5 then Game.Mount5:=Mounting[5] else Game.Mount5:='';
  If Mounting.Count>6 then Game.Mount6:=Mounting[6] else Game.Mount6:='';
  If Mounting.Count>7 then Game.Mount7:=Mounting[7] else Game.Mount7:='';
  If Mounting.Count>8 then Game.Mount8:=Mounting[8] else Game.Mount8:='';
  If Mounting.Count>9 then Game.Mount9:=Mounting[9] else Game.Mount9:='';

  { Sound Sheet }

  with SoundValueListEditor.Strings do begin
    Game.MixerNosound:=(ValueFromIndex[1]=RemoveUnderline(LanguageSetup.No));
    try Game.MixerRate:=StrToInt(ValueFromIndex[1]); except end;
    try Game.MixerBlocksize:=StrToInt(ValueFromIndex[2]); except end;
    try Game.MixerPrebuffer:=StrToInt(ValueFromIndex[3]); except end;
  end;
  with SoundSBValueListEditor.Strings do begin
    Game.SBType:=ValueFromIndex[0];
    try Game.SBBase:=StrToInt(ValueFromIndex[1]); except end;
    try Game.SBIRQ:=StrToInt(ValueFromIndex[2]); except end;
    try Game.SBDMA:=StrToInt(ValueFromIndex[3]); except end;
    try Game.SBHDMA:=StrToInt(ValueFromIndex[4]); except end;
    Game.SBOplMode:=ValueFromIndex[5];
    try Game.SBOplRate:=StrToInt(ValueFromIndex[6]); except end;
    Game.SBMixer:=(ValueFromIndex[7]=RemoveUnderline(LanguageSetup.Yes));
  end;
  with SoundGUSValueListEditor.Strings do begin
    Game.GUS:=(ValueFromIndex[0]=RemoveUnderline(LanguageSetup.Yes));
    Game.GUSBase:=StrToInt(ValueFromIndex[1]);
    Game.GUSIRQ1:=StrToInt(ValueFromIndex[2]);
    Game.GUSIRQ2:=StrToInt(ValueFromIndex[3]);
    Game.GUSDMA1:=StrToInt(ValueFromIndex[4]);
    Game.GUSDMA2:=StrToInt(ValueFromIndex[5]);
    Game.GUSRate:=StrToInt(ValueFromIndex[6]);
    Game.GUSUltraDir:=ValueFromIndex[7];
  end;
  with SoundMIDIValueListEditor.Strings do begin
    Game.MIDIType:=ValueFromIndex[0];
    Game.MIDIDevice:=ValueFromIndex[1];
    Game.MIDIConfig:=ValueFromIndex[2];
  end;
  with SoundJoystickValueListEditor.Strings do begin
    Game.JoystickType:=ValueFromIndex[0];
    Game.JoystickTimed:=(ValueFromIndex[1]=RemoveUnderline(LanguageSetup.Yes));
    Game.JoystickAutoFire:=(ValueFromIndex[2]=RemoveUnderline(LanguageSetup.Yes));
    Game.JoystickSwap34:=(ValueFromIndex[3]=RemoveUnderline(LanguageSetup.Yes));
    Game.JoystickButtonwrap:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
  end;
  with SoundMiscValueListEditor.Strings do begin
    Game.SpeakerPC:=(ValueFromIndex[0]=RemoveUnderline(LanguageSetup.Yes));
    try Game.SpeakerRate:=StrToInt(ValueFromIndex[1]); except end;
    ValueFromIndex[2]:=Game.SpeakerTandy;
    try Game.SpeakerTandyRate:=StrToInt(ValueFromIndex[3]); except end;
    Game.SpeakerDisney:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
  end;

  { Autoexec Sheet }

  Game.AutoexecOverridegamestart:=AutoexecOverrideGameStartCheckBox.Checked;
  Game.AutoexecOverrideMount:=AutoexecOverrideMountingCheckBox.Checked;
  Game.Autoexec:=StringListToString(AutoexecMemo.Lines);
  If AutoexecBootNormal.Checked then Game.AutoexecBootImage:='';
  If AutoexecBootHDImage.Checked then begin
    If AutoexecBootHDImageComboBox.ItemIndex=0 then Game.AutoexecBootImage:='2' else Game.AutoexecBootImage:='3';
  end;
  If AutoexecBootFloppyImage.Checked then Game.AutoexecBootImage:=AutoexecBootFloppyImageEdit.Text;

  { Custom Sets }

  Game.CustomSettings:=StringListToString(CustomSetsMemo.Lines);
  St:=TStringList.Create;
  try
    For I:=0 to CustomSetsValueListEditor.Strings.Count-1 do St.Add(Replace(CustomSetsValueListEditor.Strings[I],'=','['+IntToStr(ord('='))+']'));
    Game.Environment:=StringListToString(St);
  finally
    St.Free;
  end;

  { Sheet Nr }

  Case PageControl.ActivePageIndex of
    0..5 : Game.LastOpenTab:=PageControl.ActivePageIndex;
    6 : Game.LastOpenTab:=7;
    7 : Game.LastOpenTab:=6;
  end;

  Game.StoreAllValues;
  Game.LoadCache;
end;

procedure TProfileEditorForm.ButtonWork(Sender: TObject);
Var S,T : String;
    I : Integer;
    St : TStringList;
begin
  Case (Sender as TComponent).Tag of
    {Icon}
    0 : if ShowIconManager(self,IconName) then LoadIcon;
    1 : begin IconName:=''; LoadIcon; end;
    {ExtraDirs}
    2 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir));
          ExtraDirsListBox.ItemIndex:=ExtraDirsListBox.Items.count-1;
          ExtraDirsListBoxClick(Sender);
        end;
    3 : If ExtraDirsListBox.ItemIndex>=0 then begin
          S:=MakeAbsPath(ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex],PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    4 : begin
          I:=ExtraDirsListBox.ItemIndex;
          if I<0 then exit;
          ExtraDirsListBox.Items.Delete(I);
          If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=Max(0,I-1);
          ExtraDirsListBoxClick(Sender);
        end;
    {Mounting}
    5 : If Mounting.Count<10 then begin
          S:=';Drive;'+NextFreeDriveLetter+';false;;';
          if not ShowProfileMountEditorDialog(self,S) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    6 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S) then exit;
          Mounting[I]:=S;
          LoadMountingList;
          MountingListView.ItemIndex:=I;
        end;
    7 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          Mounting.Delete(I);
          LoadMountingList;
          If Mounting.Count>0 then MountingListView.ItemIndex:=Max(0,I-1);
        end;
    8 : If (Mounting.Count>0) and (Messagedlg(LanguageSetup.ProfileEditorMountingDeleteAllMessage,mtConfirmation,[mbYes,mbNo],0)=mrYes) then begin
          Mounting.Clear;
          LoadMountingList;
        end;
   20 : begin
          I:=0;
          while I<Mounting.Count do begin
            St:=ValueToList(Mounting[I]);
            try
              If (St.Count>=3) and (St[2]='C') then begin Mounting.Delete(I); continue; end;
              inc(I);
            finally
              St.Free;
            end;
          end;
          If Mounting.Count<10 then
            Mounting.Insert(0,MakeRelPath(PrgSetup.GameDir,PrgDataDir)+';Drive;C;false;');
          LoadMountingList;
        end;
    {GenerateScreenshotFolderName}
    9 : with ProfileSettingsValueListEditor.Strings do begin
          ValueFromIndex[8]:='.\'+CaptureSubDir+'\'+ValueFromIndex[0]+'\';
        end;
    {Autoexec}
    10 : AutoexecMemo.Lines.Clear;
    11 : begin
           OpenDialog.DefaultExt:='txt';
           OpenDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
           OpenDialog.Title:=LanguageSetup.ProfileEditorAutoexecLoadTitle;
           OpenDialog.InitialDir:=PrgDataDir;
           if not OpenDialog.Execute then exit;
           try
             AutoexecMemo.Lines.LoadFromFile(OpenDialog.FileName);
           except
             MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
           end;
         end;
    12 : begin
           SaveDialog.DefaultExt:='txt';
           SaveDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
           SaveDialog.Title:=LanguageSetup.ProfileEditorAutoexecSaveTitle;
           SaveDialog.InitialDir:=PrgDataDir;
           if not SaveDialog.Execute then exit;
           try
             AutoexecMemo.Lines.SaveToFile(SaveDialog.FileName);
           except
             MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
           end;
         end;
    13 : begin
          S:=MakeAbsPath(AutoexecBootFloppyImageEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          AutoexecBootFloppyImageEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
         end;
    {CustomSets}
    14 : CustomSetsMemo.Lines.Clear;
    15 : begin
           ForceDirectories(PrgDataDir+CustomConfigsSubDir);

           OpenDialog.DefaultExt:='txt';
           OpenDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
           OpenDialog.Title:=LanguageSetup.ProfileEditorCustomSetsLoadTitle;
           OpenDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
           if not OpenDialog.Execute then exit;
           try
             CustomSetsMemo.Lines.LoadFromFile(OpenDialog.FileName);
           except
             MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
           end;
         end;
    16 : begin
           ForceDirectories(PrgDataDir+CustomConfigsSubDir);

           SaveDialog.DefaultExt:='txt';
           SaveDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
           SaveDialog.Title:=LanguageSetup.ProfileEditorCustomSetsSaveTitle;
           SaveDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
           if not SaveDialog.Execute then exit;
           try
             CustomSetsMemo.Lines.SaveToFile(SaveDialog.FileName);
           except
             MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
           end;
         end;
    17 : CustomSetsValueListEditor.Strings.Add('Key=');
    18 : if (CustomSetsValueListEditor.Row>0) and (CustomSetsValueListEditor.RowCount>2) then CustomSetsValueListEditor.Strings.Delete(CustomSetsValueListEditor.Row-1);
    {GenerateGameDataFolderName}
    19 : begin
           If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
           S:=IncludeTrailingPathDelimiter(S)+ProfileSettingsValueListEditor.Strings.ValueFromIndex[0]+'\';
           T:=MakeRelPath(S,PrgSetup.BaseDir);
           If T<>'' then GameInfoValueListEditor.Strings.ValueFromIndex[6]:=T;
           If DirectoryExists(S) then exit;
           If MessageDlg(Format(LanguageSetup.MessageConfirmationCreateDir,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
           ForceDirectories(S);
         end;
  end;
end;

function TProfileEditorForm.NextFreeDriveLetter: Char;
Var I : Integer;
    B : Boolean;
    St : TStringList;
begin
  result:='C';
  repeat
    B:=True;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count<3 then continue;
        if UpperCase(St[2])=result then begin inc(result); B:=False; break; end;
      finally
        St.Free;
      end;
    end;
  until B;
end;

procedure TProfileEditorForm.ProfileSettingsValueListEditorEditButtonClick(Sender: TObject);
Var S : String;
begin
  Case ProfileSettingsValueListEditor.Row of
    3 : begin
          S:=MakeAbsPath(ProfileSettingsValueListEditor.Strings.ValueFromIndex[2],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(ProfileSettingsValueListEditor.Strings.ValueFromIndex[2])='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          ProfileSettingsValueListEditor.Strings.ValueFromIndex[2]:=S;
        end;
    5 : begin
          S:=MakeAbsPath(ProfileSettingsValueListEditor.Strings.ValueFromIndex[4],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(ProfileSettingsValueListEditor.Strings.ValueFromIndex[4])='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          ProfileSettingsValueListEditor.Strings.ValueFromIndex[4]:=S;
        end;
    9 : begin
          S:=PrgSetup.BaseDir;
          If Trim(ProfileSettingsValueListEditor.Strings.ValueFromIndex[8])=''
            then S:=PrgSetup.BaseDir+CaptureSubDir+'\'
            else S:=MakeAbsPath(IncludeTrailingPathDelimiter(ProfileSettingsValueListEditor.Strings.ValueFromIndex[8]),S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          ProfileSettingsValueListEditor.Strings.ValueFromIndex[8]:=IncludeTrailingPathDelimiter(S);
        end;
  end;
end;

procedure TProfileEditorForm.ProfileSettingsValueListEditorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Var S : String;
begin
  If ProfileSettingsValueListEditor.Strings.Count<2 then S:='' else S:=ProfileSettingsValueListEditor.Strings.ValueFromIndex[0];
  If Trim(S)='' then S:=LanguageSetup.NotSet;
  Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
end;

procedure TProfileEditorForm.ProfileSettingsValueListEditorSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
Var S : String;
begin
  If ProfileSettingsValueListEditor.Strings.Count<2 then S:='' else S:=ProfileSettingsValueListEditor.Strings.ValueFromIndex[0];
  If Trim(S)='' then S:=LanguageSetup.NotSet;
  Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
end;

procedure TProfileEditorForm.GameInfoValueListEditorEditButtonClick(Sender: TObject);
Var S : String;
begin
  Case GameInfoValueListEditor.Row of
    7 : begin
          If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
          If Trim(GameInfoValueListEditor.Strings.ValueFromIndex[6])<>'' then
            S:=MakeAbsPath(GameInfoValueListEditor.Strings.ValueFromIndex[6],S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          GameInfoValueListEditor.Strings.ValueFromIndex[6]:=S;
        end;
  end;
end;

procedure TProfileEditorForm.ExtraDirsListBoxClick(Sender: TObject);
begin
  ExtraDirsEditButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
  ExtraDirsDelButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
end;

procedure TProfileEditorForm.ExtraDirsListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraDirsEditButton);
end;

procedure TProfileEditorForm.ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraDirsAddButton);
    VK_RETURN : ButtonWork(ExtraDirsEditButton);
    VK_DELETE : ButtonWork(ExtraDirsDelButton);
  end;
end;

procedure TProfileEditorForm.MountingListViewDblClick(Sender: TObject);
begin
  ButtonWork(MountingEditButton);
end;

procedure TProfileEditorForm.MountingListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(MountingAddButton);
    VK_RETURN : ButtonWork(MountingEditButton);
    VK_DELETE : ButtonWork(MountingDelButton);
  end;
end;

{ global }

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const PrevButton, NextButton, RestorePos : Boolean) : Integer;
begin
  ProfileEditorForm:=TProfileEditorForm.Create(AOwner);

  try
    ProfileEditorForm.RestoreLastPosition:=RestorePos;
    If RestorePos then ProfileEditorForm.Position:=poDesigned;
    ProfileEditorForm.GameDB:=AGameDB;
    ProfileEditorForm.Game:=AGame;
    ProfileEditorForm.LoadTemplate:=ADefaultGame;
    ProfileEditorForm.PreviousButton.Visible:=PrevButton;
    ProfileEditorForm.NextButton.Visible:=NextButton;
    If ProfileEditorForm.ShowModal=mrOK then begin
      result:=ProfileEditorForm.MoveStatus;
      AGame:=ProfileEditorForm.Game;
      LastPage:=ProfileEditorForm.PageControl.ActivePageIndex;
      LastTop:=ProfileEditorForm.Top;
      LastLeft:=ProfileEditorForm.Left;
    end else begin
      result:=-2;
    end;
  finally
    ProfileEditorForm.Free;
  end;
end;

Function EditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const GameList : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
begin
  I:=0; RestorePos:=False;
  repeat
    If GameList=nil then begin
      NextButton:=False;
      PrevButton:=False;
    end else begin
      If I=1 then begin
        J:=GameList.IndexOf(AGame);
        If (J>=0) and (J<GameList.Count-1) then AGame:=TGame(GameList[J+1]);
      end;
      If I=-1 then begin
        J:=GameList.IndexOf(AGame);
        If J>0 then AGame:=TGame(GameList[J-1]);
      end;
      J:=GameList.IndexOf(AGame);
      NextButton:=(J>=0) and (J<GameList.Count-1);
      PrevButton:=(J>0);
    end;
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,PrevButton,NextButton,RestorePos);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

end.
