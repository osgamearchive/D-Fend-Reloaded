unit ProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, ValEdit,
  ImgList, Spin;

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
    AutoexecLabel: TLabel;
    AutoexecUse4DOSCheckBox: TCheckBox;
    AutoexecBootFloppyImageTab: TStringGrid;
    AutoexecBootFloppyImageAddButton: TSpeedButton;
    AutoexecBootFloppyImageDelButton: TSpeedButton;
    AutoexecBootFloppyImageInfoLabel: TLabel;
    GameInfoMetaDataButton: TBitBtn;
    SoundVolumeSheet: TTabSheet;
    SoundVolumeLeftLabel: TLabel;
    SoundVolumeRightLabel: TLabel;
    SoundVolumeMasterLabel: TLabel;
    SoundVolumeMasterLeftEdit: TSpinEdit;
    SoundVolumeMasterRightEdit: TSpinEdit;
    SoundVolumeDisneyLeftEdit: TSpinEdit;
    SoundVolumeDisneyRightEdit: TSpinEdit;
    SoundVolumeSpeakerLeftEdit: TSpinEdit;
    SoundVolumeSpeakerRightEdit: TSpinEdit;
    SoundVolumeGUSLeftEdit: TSpinEdit;
    SoundVolumeGUSRightEdit: TSpinEdit;
    SoundVolumeSBLeftEdit: TSpinEdit;
    SoundVolumeSBRightEdit: TSpinEdit;
    SoundVolumeFMLeftEdit: TSpinEdit;
    SoundVolumeFMRightEdit: TSpinEdit;
    SoundVolumeDisneyLabel: TLabel;
    SoundVolumeSpeakerLabel: TLabel;
    SoundVolumeGUSLabel: TLabel;
    SoundVolumeSBLabel: TLabel;
    SoundVolumeFMLabel: TLabel;
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
    procedure EnvironmentValueListEditorEditButtonClick(Sender: TObject);
    procedure GeneralValueListEditorEditButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    IconName : String;
    Mounting : TStringList;
    OldFileName : String;
    Procedure LoadIcon;
    Procedure InitGUI;
    Procedure LoadData;
    Procedure LoadMountingList;
    Function NextFreeDriveLetter : Char;
    Function CheckProfile : Boolean;
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
     PrgSetupUnit, IconManagerFormUnit, ProfileMountEditorFormUnit,
     SerialEditFormUnit, UserInfoFormUnit, IconLoaderUnit;

{$R *.dfm}

var LastPage, LastTop, LastLeft : Integer;

procedure TProfileEditorForm.InitGUI;
Var St : TStringList;
    I : Integer;
    L : TListColumn;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  AutoexecBootFloppyImageTab.ColWidths[0]:=AutoexecBootFloppyImageTab.ClientWidth-25;

  MoveStatus:=0;

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  PreviousButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Previous;
  NextButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Next;

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
  GameInfoMetaDataButton.Caption:=LanguageSetup.ProfileEditorUserdefinedInfo;
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
    Strings.Add(LanguageSetup.GameForce2ButtonMouseMode+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameSwapMouseButtons+'=');
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
    St:=ValueToList(GameDB.ConfOpt.MouseSensitivity,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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
    If PrgSetup.AllowTextModeLineChange then begin
      Strings.Add(LanguageSetup.GameTextModeLines+'=');
      ItemProps[Strings.Count-1].ReadOnly:=True;
      ItemProps[Strings.Count-1].PickList.Add('25');
      ItemProps[Strings.Count-1].PickList.Add('28');
      ItemProps[Strings.Count-1].PickList.Add('50');
    end;
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
    Strings.Add(LanguageSetup.GameDOSBoxVersion+'=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
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
    Strings.Add(LanguageSetup.GameDOS32A+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
    Strings.Add(LanguageSetup.GameCycles+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Cycles,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameCyclesUp+'=');
    ItemProps[Strings.Count-1].EditMask:='90000';
    St:=ValueToList(GameDB.ConfOpt.CyclesUp,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameCyclesDown+'=');
    ItemProps[Strings.Count-1].EditMask:='90000';
    St:=ValueToList(GameDB.ConfOpt.CyclesDown,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameCore+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Core,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameFrameskip+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Frameskip,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameVideoCard+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Video,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameKeyboardLayout+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameKeyboardNumLock+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    with ItemProps[Strings.Count-1].PickList do begin Add(LanguageSetup.DoNotChange); Add(LanguageSetup.Off); Add(LanguageSetup.On); end;
    Strings.Add(LanguageSetup.GameKeyboardCapsLock+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    with ItemProps[Strings.Count-1].PickList do begin Add(LanguageSetup.DoNotChange); Add(LanguageSetup.Off); Add(LanguageSetup.On); end;
    Strings.Add(LanguageSetup.GameKeyboardScrollLock+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    with ItemProps[Strings.Count-1].PickList do begin Add(LanguageSetup.DoNotChange); Add(LanguageSetup.Off); Add(LanguageSetup.On); end;
    Strings.Add(LanguageSetup.GameSerial+' 1=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameSerial+' 2=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameSerial+' 3=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
    Strings.Add(LanguageSetup.GameSerial+' 4=');
    ItemProps[Strings.Count-1].EditStyle:=esEllipsis;
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
    Strings.Add(LanguageSetup.GameReportedDOSVersion+'=');
    St:=ValueToList(GameDB.ConfOpt.ReportedDOSVersion,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
  end;

  { Mounting Sheet }

  MountingSheet.Caption:=LanguageSetup.ProfileEditorMountingSheet;
  MountingAddButton.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  MountingEditButton.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  MountingDelButton.Caption:=LanguageSetup.ProfileEditorMountingDel;
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
    St:=ValueToList(GameDB.ConfOpt.Rate,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundBlockSize+'=');
    St:=ValueToList(GameDB.ConfOpt.Blocksize,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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
    St:=ValueToList(GameDB.ConfOpt.SBBase,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBIRQ+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.IRQ,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBDMA+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.Dma,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBHDMA+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.HDMA,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBOplMode+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=ValueToList(GameDB.ConfOpt.Oplmode,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundSBOplRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.OPLRate,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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
    St:=ValueToList(GameDB.ConfOpt.GUSBase,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSIRQ1+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.IRQ1,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSIRQ2+'=');
    St:=ValueToList(GameDB.ConfOpt.IRQ2,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    ItemProps[Strings.Count-1].ReadOnly:=True;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSDMA1+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.Dma1,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSDMA2+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.Dma2,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.GUSRate,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundGUSPath+'=');
  end;

  SoundMIDIValueListEditor.TitleCaptions.Clear;
  SoundMIDIValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  SoundMIDIValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with SoundMIDIValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.ProfileEditorSoundMIDIType+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.MPU401,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundMIDIDevice+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.MIDIDevice,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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
    St:=ValueToList(GameDB.ConfOpt.PCRate,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscEnableTandy+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add('auto');
    ItemProps[Strings.Count-1].PickList.Add('off');
    ItemProps[Strings.Count-1].PickList.Add('on');
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscTandyRate+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    St:=ValueToList(GameDB.ConfOpt.TandyRate,';,'); try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.ProfileEditorSoundMiscEnableDisneySoundsSource+'=');
    ItemProps[Strings.Count-1].ReadOnly:=True;
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.Yes));
    ItemProps[Strings.Count-1].PickList.Add(RemoveUnderline(LanguageSetup.No));
  end;

  SoundVolumeSheet.Caption:=LanguageSetup.ProfileEditorSoundVolumeSheet;
  SoundVolumeLeftLabel.Caption:=LanguageSetup.Left;
  SoundVolumeRightLabel.Caption:=LanguageSetup.Right;
  SoundVolumeMasterLabel.Caption:=LanguageSetup.ProfileEditorSoundMasterVolume;
  SoundVolumeDisneyLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscDisneySoundsSource;
  SoundVolumeSpeakerLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscPCSpeaker;
  SoundVolumeGUSLabel.Caption:=LanguageSetup.ProfileEditorSoundGUS;
  SoundVolumeSBLabel.Caption:=LanguageSetup.ProfileEditorSoundSoundBlaster;
  SoundVolumeFMLabel.Caption:=LanguageSetup.ProfileEditorSoundFM;

  { Autoexec Sheet }

  AutoexecSheet.Caption:=LanguageSetup.ProfileEditorAutoexecSheet;
  AutoexecOverrideGameStartCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideGameStart;
  AutoexecOverrideMountingCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideMounting;
  AutoexecUse4DOSCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecUse4DOS;
  AutoexecLabel.Caption:=LanguageSetup.ProfileEditorAutoexecBat;
  AutoexecMemo.Font.Name:='Courier New';
  AutoexecClearButton.Caption:=LanguageSetup.Del;
  AutoexecLoadButton.Caption:=LanguageSetup.Load;
  AutoexecSaveButton.Caption:=LanguageSetup.Save;
  AutoexecBootNormal.Caption:=LanguageSetup.ProfileEditorAutoexecBootNormal;
  AutoexecBootHDImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootHDImage;
  AutoexecBootFloppyImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootFloppyImage;
  AutoexecBootFloppyImageInfoLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  AutoexecBootFloppyImageButton.Hint:=LanguageSetup.ChooseFile;
  AutoexecBootFloppyImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  AutoexecBootFloppyImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;

  { CustomSets Sheet }

  CustomSetsSheet.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsMemo.Font.Name:='Courier New';
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

  LoadUserIcons(ImageList,'ClassicProfileEditor');

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
Var St,St2 : TStringList;
    S,T : String;
    I,ShiftNr : Integer;
begin
  OldFileName:='';

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
          OldFileName:=Game.SetupFile;
          ValueFromIndex[1]:=ChangeFileExt(ExtractFileName(Game.SetupFile),'');
          ProfileSettingsValueListEditor.ItemProps[1].ReadOnly:=False;
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
      ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[8]:='100';
      ValueFromIndex[9]:='surface';
      ValueFromIndex[10]:='original';
      ValueFromIndex[11]:='original';
      ValueFromIndex[12]:='normal2x';
      If PrgSetup.AllowTextModeLineChange then begin
        ValueFromIndex[13]:='25';
        ShiftNr:=1;
      end else begin
        ShiftNr:=0;
      end;
      ValueFromIndex[13+ShiftNr]:='higher';
      ValueFromIndex[14+ShiftNr]:='normal';
      ValueFromIndex[15+ShiftNr]:='default';
    end;
  end else begin
    with GeneralValueListEditor.Strings do begin
      If Game.CloseDosBoxAfterGameExit then ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[0]:=RemoveUnderline(LanguageSetup.No);
      If Game.StartFullscreen then ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.No);
      If Game.AutoLockMouse then ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      If Game.Force2ButtonMouseMode then ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      If Game.SwapMouseButtons then ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      If Game.UseDoublebuffering then ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[5]:=RemoveUnderline(LanguageSetup.No);
      If Game.AspectCorrection then ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
      If Game.UseScanCodes then ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[7]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[8]:=IntToStr(Game.MouseSensitivity);
      If Game.Render<>'' then ValueFromIndex[9]:=Game.Render;
      If Game.WindowResolution<>'' then ValueFromIndex[10]:=Game.WindowResolution;
      If Game.FullscreenResolution<>'' then ValueFromIndex[11]:=Game.FullscreenResolution;

      St:=ValueToList(GameDB.ConfOpt.Scale,';,');
      try
        If Game.Scale='' then begin
          If St.Count>0 then ValueFromIndex[12]:=St[0];
        end else begin
          S:=Trim(ExtUpperCase(Game.Scale));
          For I:=0 to St.Count-1 do begin
            T:=Trim(ExtUpperCase(St[I]));
            If Pos('(',T)=0 then continue;
            T:=Copy(T,Pos('(',T)+1,MaxInt);
            If Pos(')',T)=0 then continue;
            T:=Copy(T,1,Pos(')',T)-1);
            If Trim(T)=S then ValueFromIndex[12]:=St[I];
          end;
        end;
      finally
        St.Free;
      end;

      If PrgSetup.AllowTextModeLineChange then begin
        If (Game.TextModeLines=25) or (Game.TextModeLines=28) or (Game.TextModeLines=50)
          then ValueFromIndex[13]:=IntToStr(Game.TextModeLines)
          else ValueFromIndex[13]:='25';
        ShiftNr:=1;
      end else begin
        ShiftNr:=0;
      end;

      St:=ValueToList(Game.Priority,',');
      try
        If (St.Count>=1) and (St[0]<>'') then ValueFromIndex[13+ShiftNr]:=St[0];
        If (St.Count>=2) and (St[1]<>'') then ValueFromIndex[14+ShiftNr]:=St[1];
      finally
        St.Free;
      end;

      If Game.CustomDOSBoxDir<>'' then ValueFromIndex[15+ShiftNr]:=Game.CustomDOSBoxDir else ValueFromIndex[15]:='default';
    end;
  end;

  { Environment Sheet }

  If Game=nil then begin
    with EnvironmentValueListEditor.Strings do begin
      ValueFromIndex[0]:='32';
      ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes);
      ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[5]:='auto';
      ValueFromIndex[6]:='500';
      ValueFromIndex[7]:='20';
      ValueFromIndex[8]:='auto';
      ValueFromIndex[9]:='0';
      ValueFromIndex[10]:='vga';
      ValueFromIndex[11]:='default';
      ValueFromIndex[12]:=LanguageSetup.DoNotChange;
      ValueFromIndex[13]:=LanguageSetup.DoNotChange;
      ValueFromIndex[14]:=LanguageSetup.DoNotChange;
      ValueFromIndex[15]:='dummy';
      ValueFromIndex[16]:='dummy';
      ValueFromIndex[17]:='disabled';
      ValueFromIndex[18]:='disabled';
      ValueFromIndex[19]:=RemoveUnderline(LanguageSetup.No);
      {20-22: ''}
      ValueFromIndex[23]:='default';
    end;
  end else begin
    with EnvironmentValueListEditor.Strings do begin
      ValueFromIndex[0]:=IntToStr(Game.Memory);
      If Game.XMS then ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[1]:=RemoveUnderline(LanguageSetup.No);
      If Game.EMS then ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[2]:=RemoveUnderline(LanguageSetup.No);
      If Game.UMB then ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[3]:=RemoveUnderline(LanguageSetup.No);
      If Game.UseDOS32A then ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[4]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[5]:=Game.Cycles;
      ValueFromIndex[6]:=IntToStr(Game.CyclesUp);
      ValueFromIndex[7]:=IntToStr(Game.CyclesDown);
      if Game.Core<>'' then ValueFromIndex[8]:=Game.Core;
      ValueFromIndex[9]:=IntToStr(Game.FrameSkip);
      If Game.VideoCard<>'' then ValueFromIndex[10]:=Game.VideoCard;
      If Game.KeyboardLayout<>'' then ValueFromIndex[11]:=Game.KeyboardLayout else ValueFromIndex[11]:='default';

      S:=Trim(ExtUpperCase(Game.NumLockStatus));
      If (S='ON') or (S='1') or (S='TRUE') then ValueFromIndex[12]:=LanguageSetup.On else begin
        If (S='OFF') or (S='0') or (S='FALSE') then ValueFromIndex[12]:=LanguageSetup.Off else ValueFromIndex[12]:=LanguageSetup.DoNotChange;
      end;
      S:=Trim(ExtUpperCase(Game.CapsLockStatus));
      If (S='ON') or (S='1') or (S='TRUE') then ValueFromIndex[13]:=LanguageSetup.On else begin
        If (S='OFF') or (S='0') or (S='FALSE') then ValueFromIndex[13]:=LanguageSetup.Off else ValueFromIndex[13]:=LanguageSetup.DoNotChange;
      end;
      S:=Trim(ExtUpperCase(Game.ScrollLockStatus));
      If (S='ON') or (S='1') or (S='TRUE') then ValueFromIndex[14]:=LanguageSetup.On else begin
        If (S='OFF') or (S='0') or (S='FALSE') then ValueFromIndex[14]:=LanguageSetup.Off else ValueFromIndex[14]:=LanguageSetup.DoNotChange;
      end;
      ValueFromIndex[15]:=Game.Serial1;
      ValueFromIndex[16]:=Game.Serial2;
      ValueFromIndex[17]:=Game.Serial3;
      ValueFromIndex[18]:=Game.Serial4;
      If Game.IPX then ValueFromIndex[19]:=RemoveUnderline(LanguageSetup.Yes) else ValueFromIndex[19]:=RemoveUnderline(LanguageSetup.No);
      ValueFromIndex[20]:=LanguageSetup.GameIPXEstablishConnectionNone;
      S:=Trim(ExtUpperCase(Game.IPXType));
      If S='CLIENT' then ValueFromIndex[20]:=LanguageSetup.GameIPXEstablishConnectionClient;
      If S='SERVER' then ValueFromIndex[20]:=LanguageSetup.GameIPXEstablishConnectionServer;
      If Game.IPXAddress<>'' then ValueFromIndex[21]:=Game.IPXAddress;
      If Game.IPXPort<>'' then ValueFromIndex[22]:=Game.IPXPort;
      If Game.ReportedDOSVersion<>'' then ValueFromIndex[23]:=Game.ReportedDOSVersion;
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
    SoundVolumeMasterLeftEdit.Value:=Game.MixerVolumeMasterLeft;
    SoundVolumeMasterRightEdit.Value:=Game.MixerVolumeMasterRight;
    SoundVolumeDisneyLeftEdit.Value:=Game.MixerVolumeDisneyLeft;
    SoundVolumeDisneyRightEdit.Value:=Game.MixerVolumeDisneyRight;
    SoundVolumeSpeakerLeftEdit.Value:=Game.MixerVolumeSpeakerLeft;
    SoundVolumeSpeakerRightEdit.Value:=Game.MixerVolumeSpeakerRight;
    SoundVolumeGUSLeftEdit.Value:=Game.MixerVolumeGUSLeft;
    SoundVolumeGUSRightEdit.Value:=Game.MixerVolumeGUSRight;
    SoundVolumeSBLeftEdit.Value:=Game.MixerVolumeSBLeft;
    SoundVolumeSBRightEdit.Value:=Game.MixerVolumeSBRight;
    SoundVolumeFMLeftEdit.Value:=Game.MixerVolumeFMLeft;
    SoundVolumeFMRightEdit.Value:=Game.MixerVolumeFMRight;
  end;

  { Autoexec Sheet }

  If Game=nil then begin
    AutoexecOverrideGameStartCheckBox.Checked:=False;
    AutoexecOverrideMountingCheckBox.Checked:=False;
    AutoexecUse4DOSCheckBox.Checked:=False;
  end else begin
    AutoexecOverrideGameStartCheckBox.Checked:=Game.AutoexecOverridegamestart;
    AutoexecOverrideMountingCheckBox.Checked:=Game.AutoexecOverrideMount;
    AutoexecUse4DOSCheckBox.Checked:=Game.Use4DOS;
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
      St2:=TStringList.Create;
      try
        S:=Trim(S);
        I:=Pos('$',S);
        While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
        St2.Add(S);
        AutoexecBootFloppyImageTab.RowCount:=St2.Count;
        For I:=0 to St2.Count-1 do AutoexecBootFloppyImageTab.Cells[0,I]:=St2[I];
      finally
        St2.Free;
      end;
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

  {Set profile name in caption}

  ProfileSettingsValueListEditorSetEditText(ProfileSettingsValueListEditor,ProfileSettingsValueListEditor.Col,ProfileSettingsValueListEditor.Row,'');
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
    S : String;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
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
    end;
    If MountingListView.Items.Count>0 then MountingListView.ItemIndex:=0;
  finally
    MountingListView.Items.EndUpdate;
  end;
end;

function TProfileEditorForm.CheckProfile: Boolean;
Var I : Integer;
    S1,S2 : String;
    B : Boolean;
begin
  result:=False;

  { Profile Settings Sheet }

  S1:=ProfileSettingsValueListEditor.Strings.ValueFromIndex[7];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.LoadFixMemory) else S2:=IntToStr(DefaultValueReaderGame.LoadFixMemory);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorLoadFixMemory,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=0; exit;
    end;
  end;

  { General Sheet }

  S1:=GeneralValueListEditor.Strings.ValueFromIndex[8];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.MouseSensitivity) else S2:=IntToStr(DefaultValueReaderGame.MouseSensitivity);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameMouseSensitivity,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=2; exit;
    end;
  end;

  S1:=GeneralValueListEditor.Strings.ValueFromIndex[12];
  If Pos('(',S1)=0 then B:=False else begin
    S1:=Copy(S1,Pos('(',S1)+1,MaxInt);
    B:=(Pos(')',S1)<>0);
  end;
  If not B then begin
    S1:=GeneralValueListEditor.Strings.ValueFromIndex[12];
    If Game<>nil then S2:=Game.Scale else S2:=DefaultValueReaderGame.Scale;
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameScale,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=2; exit;
    end;
  end;

  { Environment Sheet }

  S1:=EnvironmentValueListEditor.Strings.ValueFromIndex[0];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.Memory) else S2:=IntToStr(DefaultValueReaderGame.Memory);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameMemory,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=3; exit;
    end;
  end;

  S1:=EnvironmentValueListEditor.Strings.ValueFromIndex[6];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.CyclesUp) else S2:=IntToStr(DefaultValueReaderGame.CyclesUp);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameCyclesUp,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=3; exit;
    end;
  end;

  S1:=EnvironmentValueListEditor.Strings.ValueFromIndex[7];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.CyclesDown) else S2:=IntToStr(DefaultValueReaderGame.CyclesDown);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameCyclesDown,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=3; exit;
    end;
  end;

  S1:=EnvironmentValueListEditor.Strings.ValueFromIndex[9];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.FrameSkip) else S2:=IntToStr(DefaultValueReaderGame.FrameSkip);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameFrameskip,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=3; exit;
    end;
  end;

  S1:=Trim(ExtUpperCase(EnvironmentValueListEditor.Strings.ValueFromIndex[20]));
  If S1=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionNone)) then B:=True;
  If S1=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionClient)) then B:=True;
  If S1=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionServer)) then B:=True;
  If not B then begin
    S1:=EnvironmentValueListEditor.Strings.ValueFromIndex[20];
    If Game<>nil then S2:=Game.IPXType else S2:=DefaultValueReaderGame.IPXType;
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.GameIPX,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=3; exit;
    end;
  end;

  { Sound Sheet }

  S1:=SoundValueListEditor.Strings.ValueFromIndex[1];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.MixerRate) else S2:=IntToStr(DefaultValueReaderGame.MixerRate);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSampleRate,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundValueListEditor.Strings.ValueFromIndex[2];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.MixerBlocksize) else S2:=IntToStr(DefaultValueReaderGame.MixerBlocksize);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundBlockSize,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundValueListEditor.Strings.ValueFromIndex[3];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.MixerPrebuffer) else S2:=IntToStr(DefaultValueReaderGame.MixerPrebuffer);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundPrebuffer,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundSBValueListEditor.Strings.ValueFromIndex[1];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SBBase) else S2:=IntToStr(DefaultValueReaderGame.SBBase);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSBAddress,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundSBValueListEditor.Strings.ValueFromIndex[2];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SBIRQ) else S2:=IntToStr(DefaultValueReaderGame.SBIRQ);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSBIRQ,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundSBValueListEditor.Strings.ValueFromIndex[3];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SBDMA) else S2:=IntToStr(DefaultValueReaderGame.SBDMA);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSBDMA,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundSBValueListEditor.Strings.ValueFromIndex[4];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SBHDMA) else S2:=IntToStr(DefaultValueReaderGame.SBHDMA);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSBHDMA,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundSBValueListEditor.Strings.ValueFromIndex[6];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SBOplRate) else S2:=IntToStr(DefaultValueReaderGame.SBOplRate);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundSBOplRate,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundMiscValueListEditor.Strings.ValueFromIndex[1];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SpeakerRate) else S2:=IntToStr(DefaultValueReaderGame.SpeakerRate);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  S1:=SoundMiscValueListEditor.Strings.ValueFromIndex[3];
  If not TryStrToInt(Trim(S1),I) then begin
    If Game<>nil then S2:=IntToStr(Game.SpeakerTandyRate) else S2:=IntToStr(DefaultValueReaderGame.SpeakerTandyRate);
    If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[S1,LanguageSetup.ProfileEditorSoundMiscTandyRate,S2]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      PageControl.ActivePageIndex:=5; exit;
    end;
  end;

  result:=True;
end;

procedure TProfileEditorForm.OKButtonClick(Sender: TObject);
Var I,ShiftNr : Integer;
    St : TStringList;
    S, NewFileName : String;
begin
  if not CheckProfile then begin
    ModalResult:=mrNone;
    exit;
  end;

  Case (Sender as TComponent).Tag of
    0 : MoveStatus:=0;
    1 : MoveStatus:=-1;
    2 : MoveStatus:=1;
  End;

  If Game=nil then begin
    I:=GameDB.Add(ProfileSettingsValueListEditor.Strings.ValueFromIndex[0]);
    Game:=GameDB[I];
  end;

  { Profile Settings Sheet }

  Game.Icon:=IconName;
  with ProfileSettingsValueListEditor.Strings do begin
    If not ProfileSettingsValueListEditor.ItemProps[0].ReadOnly then Game.Name:=ValueFromIndex[0];
    Game.GameExe:=ValueFromIndex[2];
    Game.GameParameters:=ValueFromIndex[3];
    Game.SetupExe:=ValueFromIndex[4];
    Game.SetupParameters:=ValueFromIndex[5];
    Game.LoadFix:=(ValueFromIndex[6]=RemoveUnderline(LanguageSetup.Yes));
    try Game.LoadFixMemory:=StrToInt(Trim(ValueFromIndex[7])); except end;
    Game.CaptureFolder:=ValueFromIndex[8];
  end;
  Game.ExtraDirs:=ListToValue(ExtraDirsListBox.Items);

  { Game Info Sheet }

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
    Game.Force2ButtonMouseMode:=(ValueFromIndex[3]=RemoveUnderline(LanguageSetup.Yes));
    Game.SwapMouseButtons:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
    Game.UseDoublebuffering:=(ValueFromIndex[5]=RemoveUnderline(LanguageSetup.Yes));
    Game.AspectCorrection:=(ValueFromIndex[6]=RemoveUnderline(LanguageSetup.Yes));
    Game.UseScanCodes:=(ValueFromIndex[7]=RemoveUnderline(LanguageSetup.Yes));
    try Game.MouseSensitivity:=StrToInt(Trim(ValueFromIndex[8])); except end;
    Game.Render:=ValueFromIndex[9];
    Game.WindowResolution:=ValueFromIndex[10];
    Game.FullscreenResolution:=ValueFromIndex[11];
    S:=ValueFromIndex[12];
    If Pos('(',S)=0 then Game.Scale:='' else begin
      S:=Copy(S,Pos('(',S)+1,MaxInt);
      If Pos(')',S)=0 then Game.Scale:=''  else Game.Scale:=Copy(S,1,Pos(')',S)-1);
    end;

    If PrgSetup.AllowTextModeLineChange then begin
      try Game.TextModeLines:=StrToInt(ValueFromIndex[13]); except end;
      ShiftNr:=1;
    end else begin
      ShiftNr:=0;
    end;
    Game.Priority:=ValueFromIndex[13+ShiftNr]+','+ValueFromIndex[14+ShiftNr];
    Game.CustomDOSBoxDir:=ValueFromIndex[15+ShiftNr];
  end;

  { Environment Sheet }

  with EnvironmentValueListEditor.Strings do begin
    try Game.Memory:=StrToInt(Trim(ValueFromIndex[0])); except end;
    Game.XMS:=(ValueFromIndex[1]=RemoveUnderline(LanguageSetup.Yes));
    Game.EMS:=(ValueFromIndex[2]=RemoveUnderline(LanguageSetup.Yes));
    Game.UMB:=(ValueFromIndex[3]=RemoveUnderline(LanguageSetup.Yes));
    Game.UseDOS32A:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
    Game.Cycles:=ValueFromIndex[5];
    try Game.CyclesUp:=StrToInt(Trim(ValueFromIndex[6])); except end;
    try Game.CyclesDown:=StrToInt(Trim(ValueFromIndex[7])); except end;
    Game.Core:=ValueFromIndex[8];
    try Game.FrameSkip:=StrToInt(Trim(ValueFromIndex[9])); except end;
    Game.VideoCard:=ValueFromIndex[10];
    Game.KeyboardLayout:=ValueFromIndex[11];
    If ValueFromIndex[12]=LanguageSetup.DoNotChange then Game.NumLockStatus:='';
    If ValueFromIndex[12]=LanguageSetup.Off then Game.NumLockStatus:='off';
    If ValueFromIndex[12]=LanguageSetup.On then Game.NumLockStatus:='on';
    If ValueFromIndex[13]=LanguageSetup.DoNotChange then Game.CapsLockStatus:='';
    If ValueFromIndex[13]=LanguageSetup.Off then Game.CapsLockStatus:='off';
    If ValueFromIndex[13]=LanguageSetup.On then Game.CapsLockStatus:='on';
    If ValueFromIndex[14]=LanguageSetup.DoNotChange then Game.ScrollLockStatus:='';
    If ValueFromIndex[14]=LanguageSetup.Off then Game.ScrollLockStatus:='off';
    If ValueFromIndex[14]=LanguageSetup.On then Game.ScrollLockStatus:='on';
    Game.Serial1:=ValueFromIndex[15];
    Game.Serial2:=ValueFromIndex[16];
    Game.Serial3:=ValueFromIndex[17];
    Game.Serial4:=ValueFromIndex[18];
    Game.IPX:=(ValueFromIndex[19]=RemoveUnderline(LanguageSetup.Yes));
    If Trim(ExtUpperCase(ValueFromIndex[20]))=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionNone)) then Game.IPXType:='none';
    If Trim(ExtUpperCase(ValueFromIndex[20]))=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionClient)) then Game.IPXType:='client';
    If Trim(ExtUpperCase(ValueFromIndex[20]))=Trim(ExtUpperCase(LanguageSetup.GameIPXEstablishConnectionServer)) then Game.IPXType:='server';
    Game.IPXAddress:=ValueFromIndex[21];
    Game.IPXPort:=ValueFromIndex[22];
    Game.ReportedDOSVersion:=ValueFromIndex[23];
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
    try Game.MixerRate:=StrToInt(Trim(ValueFromIndex[1])); except end;
    try Game.MixerBlocksize:=StrToInt(Trim(ValueFromIndex[2])); except end;
    try Game.MixerPrebuffer:=StrToInt(Trim(ValueFromIndex[3])); except end;
  end;
  with SoundSBValueListEditor.Strings do begin
    Game.SBType:=ValueFromIndex[0];
    try Game.SBBase:=StrToInt(Trim(ValueFromIndex[1])); except end;
    try Game.SBIRQ:=StrToInt(Trim(ValueFromIndex[2])); except end;
    try Game.SBDMA:=StrToInt(Trim(ValueFromIndex[3])); except end;
    try Game.SBHDMA:=StrToInt(Trim(ValueFromIndex[4])); except end;
    Game.SBOplMode:=ValueFromIndex[5];
    try Game.SBOplRate:=StrToInt(Trim(ValueFromIndex[6])); except end;
    Game.SBMixer:=(ValueFromIndex[7]=RemoveUnderline(LanguageSetup.Yes));
  end;
  with SoundGUSValueListEditor.Strings do begin
    Game.GUS:=(ValueFromIndex[0]=RemoveUnderline(LanguageSetup.Yes));
    Game.GUSBase:=StrToInt(Trim(ValueFromIndex[1]));
    Game.GUSIRQ1:=StrToInt(Trim(ValueFromIndex[2]));
    Game.GUSIRQ2:=StrToInt(Trim(ValueFromIndex[3]));
    Game.GUSDMA1:=StrToInt(Trim(ValueFromIndex[4]));
    Game.GUSDMA2:=StrToInt(Trim(ValueFromIndex[5]));
    Game.GUSRate:=StrToInt(Trim(ValueFromIndex[6]));
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
    try Game.SpeakerRate:=StrToInt(Trim(ValueFromIndex[1])); except end;
    ValueFromIndex[2]:=Game.SpeakerTandy;
    try Game.SpeakerTandyRate:=StrToInt(Trim(ValueFromIndex[3])); except end;
    Game.SpeakerDisney:=(ValueFromIndex[4]=RemoveUnderline(LanguageSetup.Yes));
  end;
  Game.MixerVolumeMasterLeft:=SoundVolumeMasterLeftEdit.Value;
  Game.MixerVolumeMasterRight:=SoundVolumeMasterRightEdit.Value;
  Game.MixerVolumeDisneyLeft:=SoundVolumeDisneyLeftEdit.Value;
  Game.MixerVolumeDisneyRight:=SoundVolumeDisneyRightEdit.Value;
  Game.MixerVolumeSpeakerLeft:=SoundVolumeSpeakerLeftEdit.Value;
  Game.MixerVolumeSpeakerRight:=SoundVolumeSpeakerRightEdit.Value;
  Game.MixerVolumeGUSLeft:=SoundVolumeGUSLeftEdit.Value;
  Game.MixerVolumeGUSRight:=SoundVolumeGUSRightEdit.Value;
  Game.MixerVolumeSBLeft:=SoundVolumeSBLeftEdit.Value;
  Game.MixerVolumeSBRight:=SoundVolumeSBRightEdit.Value;
  Game.MixerVolumeFMLeft:=SoundVolumeFMLeftEdit.Value;
  Game.MixerVolumeFMRight:=SoundVolumeFMRightEdit.Value;

  { Autoexec Sheet }

  Game.AutoexecOverridegamestart:=AutoexecOverrideGameStartCheckBox.Checked;
  Game.AutoexecOverrideMount:=AutoexecOverrideMountingCheckBox.Checked;
  Game.Use4DOS:=AutoexecUse4DOSCheckBox.Checked;
  Game.Autoexec:=StringListToString(AutoexecMemo.Lines);
  If AutoexecBootNormal.Checked then Game.AutoexecBootImage:='';
  If AutoexecBootHDImage.Checked then begin
    If AutoexecBootHDImageComboBox.ItemIndex=0 then Game.AutoexecBootImage:='2' else Game.AutoexecBootImage:='3';
  end;
  If AutoexecBootFloppyImage.Checked then begin
    S:=AutoexecBootFloppyImageTab.Cells[0,0];
    For I:=1 to AutoexecBootFloppyImageTab.RowCount-1 do S:=S+'$'+AutoexecBootFloppyImageTab.Cells[0,I];
    Game.AutoexecBootImage:=S;
  end;

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

  If (OldFileName<>'') and (ProfileSettingsValueListEditor.Strings.ValueFromIndex[1]<>ChangeFileExt(ExtractFileName(OldFileName),'')) then begin
    NewFileName:=IncludeTrailingPathDelimiter(ExtractFilePath(OldFileName))+ChangeFileExt(ProfileSettingsValueListEditor.Strings.ValueFromIndex[1],'.prof');
    Game.RenameINI(NewFileName);
  end;
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
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=MakeAbsPath(AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
         end;
    21 : begin
          AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount+1;
          AutoexecBootFloppyImageTab.Row:=AutoexecBootFloppyImageTab.RowCount-1;
         end;
    22 : begin
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          If AutoexecBootFloppyImageTab.RowCount=1 then begin
            AutoexecBootFloppyImageTab.Cells[0,0]:='';
          end else begin
            For I:=AutoexecBootFloppyImageTab.Row+1 to AutoexecBootFloppyImageTab.RowCount-1 do AutoexecBootFloppyImageTab.Cells[0,I-1]:=AutoexecBootFloppyImageTab.Cells[0,I];
            AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount-1;
          end;
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
    {Userdefined meta information}
    23 : ShowUserInfoDialog(self,Game);
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

procedure TProfileEditorForm.GeneralValueListEditorEditButtonClick(Sender: TObject);
Var S : String;
    ShiftNr : Integer;
begin
  If PrgSetup.AllowTextModeLineChange then ShiftNr:=1 else ShiftNr:=0;

  S:=Trim(GeneralValueListEditor.Strings.ValueFromIndex[15+ShiftNr]);
  If (S='') or (ExtUpperCase(S)='DEFAULT') then S:=PrgSetup.DosBoxDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  S:=MakeRelPath(S,PrgSetup.BaseDir);
  If S='' then exit;
  GeneralValueListEditor.Strings.ValueFromIndex[15+ShiftNr]:=IncludeTrailingPathDelimiter(S);
end;

procedure TProfileEditorForm.EnvironmentValueListEditorEditButtonClick(Sender: TObject);
Var S : String;
begin
  S:=EnvironmentValueListEditor.Strings.ValueFromIndex[EnvironmentValueListEditor.Row-1];
  if not ShowSerialEditDialog(self,S) then exit;
  If S<>'' then EnvironmentValueListEditor.Strings.ValueFromIndex[EnvironmentValueListEditor.Row-1]:=S;
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
