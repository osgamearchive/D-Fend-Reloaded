unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, ComCtrls, ExtCtrls, ToolWin, ImgList, Menus,
  AppEvnts, GameDBUnit, GameDBToolsUnit;

{
0.5
- Add language strings and enable:
  - Wine options in setup dialog
  - Setup option: Use short path names
  - Create Checksums for all profiles
  - Option for creating simple HD images (for making bootable images via fdisk+format)
  - When creating a shortcut: Comment field with custom string (by default "Run [Gamename] in DOSBox/ScummVM")
  - Restore D-Fend Reloaded window when DOSBox closes
  - Check for missing files
  - Wizard file structure info box and program info dialog: Tell the user in which operation mode DFR is running
- Disable screensaver when DOSBox is running
- WizardPrgFileFrame: "?" button for manual folder edit field
- Optional different translation for next/previous step
- Commandline parameters when calling DOSBox
- DOSBox language per profile
- Better handling of different DOSBox versions
- DOSBox: waitonerror
- Ziped drives
  - Option to repack PhysFS write folder to zip file
- Option for showing captured videos (like screenshots and sounds) (?)

0.6:
- Making bootable HD images
- ZIP package (game files + profile + screenshots etc.) (?)
}

type
  TDFendReloadedMainForm = class(TForm)
    XPManifest: TXPManifest;
    TreeView: TTreeView;
    Splitter: TSplitter;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuProfileAdd: TMenuItem;
    MenuProfileEdit: TMenuItem;
    MenuProfileDelete: TMenuItem;
    MenuFileSetup: TMenuItem;
    N2: TMenuItem;
    MenuFileQuit: TMenuItem;
    MenuRun: TMenuItem;
    MenuRunGame: TMenuItem;
    MenuRunSetup: TMenuItem;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ButtonRun: TToolButton;
    ToolButton2: TToolButton;
    ButtonAdd: TToolButton;
    ButtonEdit: TToolButton;
    ButtonDelete: TToolButton;
    PopupMenu: TPopupMenu;
    PopupRunGame: TMenuItem;
    PopupRunSetup: TMenuItem;
    N3: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDelete: TMenuItem;
    N4: TMenuItem;
    PopupOpenFolder: TMenuItem;
    PopupMarkAsFavorite: TMenuItem;
    MenuExtras: TMenuItem;
    MenuProfileOpenFolder: TMenuItem;
    MenuProfileMarkAsFavorite: TMenuItem;
    MenuHelp: TMenuItem;
    N5: TMenuItem;
    MenuRunRunDosBox: TMenuItem;
    MenuRunOpenDosBoxConfig: TMenuItem;
    MenuProfile: TMenuItem;
    N6: TMenuItem;
    MenuFileExportGamesList: TMenuItem;
    SaveDialog: TSaveDialog;
    MenuExtrasIconManager: TMenuItem;
    ListviewImageList: TImageList;
    PopupOpenDataFolder: TMenuItem;
    MenuProfileOpenDataFolder: TMenuItem;
    MenuExtrasViewLogs: TMenuItem;
    MenuProfileWWW: TMenuItem;
    PopupWWW: TMenuItem;
    MenuExtrasTemplates: TMenuItem;
    TrayIcon: TTrayIcon;
    ApplicationEvents: TApplicationEvents;
    MenuExtrasOpenGamesFolder: TMenuItem;
    MenuProfileDeinstall: TMenuItem;
    PopupDeinstall: TMenuItem;
    Panel1: TPanel;
    ListView: TListView;
    Splitter1: TSplitter;
    ScreenshotImageList: TImageList;
    MenuView: TMenuItem;
    MenuViewsShowScreenshots: TMenuItem;
    ScreenshotPopupMenu: TPopupMenu;
    ScreenshotPopupOpen: TMenuItem;
    N7: TMenuItem;
    ScreenshotPopupRefresh: TMenuItem;
    N8: TMenuItem;
    ScreenshotPopupDelete: TMenuItem;
    ScreenshotPopupDeleteAll: TMenuItem;
    ScreenshotPopupCopy: TMenuItem;
    ScreenshotPopupSave: TMenuItem;
    ScreenshotSaveDialog: TSaveDialog;
    MenuExtrasDeinstallMultipleGames: TMenuItem;
    MenuFileImport: TMenuItem;
    MenuFileExport: TMenuItem;
    N10: TMenuItem;
    MenuFileCreateConf: TMenuItem;
    MenuFileImportConfFile: TMenuItem;
    OpenDialog: TOpenDialog;
    MenuProfileCopy: TMenuItem;
    PopupCopy: TMenuItem;
    MenuProfileAddWithWizard: TMenuItem;
    MenuHelpDosBox: TMenuItem;
    MenuHelpDosBoxFAQ: TMenuItem;
    MenuHelpDosBoxHotkeys: TMenuItem;
    MenuHelpDosBoxCompatibility: TMenuItem;
    MenuHelpAbandonware: TMenuItem;
    N11: TMenuItem;
    MenuHelpAbout: TMenuItem;
    ToolButton1: TToolButton;
    SearchEdit: TEdit;
    MenuViewsShowTree: TMenuItem;
    MenuViewsShowSearchBox: TMenuItem;
    MenuViewsShowExtraInfo: TMenuItem;
    N12: TMenuItem;
    MenuViewsList: TMenuItem;
    MenuViewsIcons: TMenuItem;
    ListviewIconImageList: TImageList;
    MenuProfileCreateShortcut: TMenuItem;
    PopupCreateShortcut: TMenuItem;
    MenuHelpDosBoxReadme: TMenuItem;
    MenuExtrasCreateImage: TMenuItem;
    MenuHelpDosBoxHotkeysDosbox: TMenuItem;
    MenuHelpDosBoxIntro: TMenuItem;
    MenuHelpDosBoxIntroDosBox: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    MenuExtrasTransferProfiles: TMenuItem;
    MenuExtrasBuildInstaller: TMenuItem;
    MenuRunRunDosBoxKeyMapper: TMenuItem;
    MenuHelpDemoCompatibility: TMenuItem;
    MenuProfileAddFromTemplate: TMenuItem;
    AddButtonPopupMenu: TPopupMenu;
    AddButtonMenuAdd: TMenuItem;
    AddButtonMenuAddFromTemplate: TMenuItem;
    AddButtonMenuAddWithWizard: TMenuItem;
    N17: TMenuItem;
    MenuExtrasChangeProfiles: TMenuItem;
    MenuProfileOpenFileInDataFolder: TMenuItem;
    MenuProfileMakeInstaller: TMenuItem;
    PopupMakeInstaller: TMenuItem;
    PopupOpenFileInDataFolder: TMenuItem;
    MenuViewsShowTooltips: TMenuItem;
    N18: TMenuItem;
    MenuHelpUpdates: TMenuItem;
    MenuProfileViewConfFile: TMenuItem;
    PopupViewConfFile: TMenuItem;
    MenuFileImportProfFile: TMenuItem;
    ScreenshotPopupImport: TMenuItem;
    MenuHelpHomepage: TMenuItem;
    MenuViewsListNoIcons: TMenuItem;
    MenuViewsSimpleList: TMenuItem;
    MenuViewsSimpleListNoIcons: TMenuItem;
    MenuViewsSmallIcons: TMenuItem;
    N19: TMenuItem;
    PopupViews: TMenuItem;
    PopupSimpleListNoIcons: TMenuItem;
    PopupSimpleList: TMenuItem;
    PopupListNoIcons: TMenuItem;
    PopupList: TMenuItem;
    PopupSmallIcons: TMenuItem;
    PopupIcons: TMenuItem;
    N20: TMenuItem;
    MenuHelpStatistics: TMenuItem;
    MenuHelpForum: TMenuItem;
    MenuHelpFAQs: TMenuItem;
    MenuHelpMakeDFRBetter: TMenuItem;
    MenuHelpMakeBetterIcons: TMenuItem;
    MenuHelpMakeTranslation: TMenuItem;
    CapturePageControl: TPageControl;
    CaptureScreenshotsTab: TTabSheet;
    CaptureSoundTab: TTabSheet;
    ScreenshotListView: TListView;
    SoundListView: TListView;
    SoundPopupMenu: TPopupMenu;
    SoundPopupOpen: TMenuItem;
    N21: TMenuItem;
    SoundPopupRefresh: TMenuItem;
    N22: TMenuItem;
    SoundPopupImport: TMenuItem;
    SoundPopupSave: TMenuItem;
    SoundPopupDelete: TMenuItem;
    SoundPopupDeleteAll: TMenuItem;
    SoundPopupSaveOgg: TMenuItem;
    SoundPopupSaveMp3: TMenuItem;
    SoundPopupSaveMp3All: TMenuItem;
    SoundPopupSaveOggAll: TMenuItem;
    N23: TMenuItem;
    TreeViewPopupMenu: TPopupMenu;
    TreeViewPopupEditUserFilters: TMenuItem;
    N24: TMenuItem;
    ScreenshotPopupUseAsBackground: TMenuItem;
    ScreenshotPopupRename: TMenuItem;
    SoundPopupRename: TMenuItem;
    MenuExtrasCreateISOImage: TMenuItem;
    MenuFileCreateProf: TMenuItem;
    MenuExtrasCreateIMGImage: TMenuItem;
    MenuExtrasWriteIMGImage: TMenuItem;
    MenuFileCreateXML: TMenuItem;
    MenuExtrasExtractImage: TMenuItem;
    IdleAddonTimer: TTimer;
    MenuExtrasImageFiles: TMenuItem;
    N25: TMenuItem;
    N1: TMenuItem;
    MenuExtrasImageFromFolder: TMenuItem;
    ScreenshotsInfoPanel: TPanel;
    SoundInfoPanel: TPanel;
    TrayIconPopupMenu: TPopupMenu;
    TrayIconPopupRestore: TMenuItem;
    N9: TMenuItem;
    N26: TMenuItem;
    TrayIconPopupClose: TMenuItem;
    TrayIconPopupAddProfile: TMenuItem;
    TrayIconPopupAddFromTemplate: TMenuItem;
    TrayIconPopupAddWithWizard: TMenuItem;
    N27: TMenuItem;
    TrayIconPopupRun: TMenuItem;
    MenuProfileAddScummVM: TMenuItem;
    N28: TMenuItem;
    MenuRunRunScummVM: TMenuItem;
    MenuRunOpenScummVMConfig: TMenuItem;
    AddButtonMenuAddScummVM: TMenuItem;
    PopupViewINIFile: TMenuItem;
    MenuHelpScummVM: TMenuItem;
    MenuProfileViewIniFile: TMenuItem;
    MenuHelpDosBoxHomepage: TMenuItem;
    MenuHelpScummVMReadme: TMenuItem;
    MenuHelpScummVMFAQ: TMenuItem;
    N15: TMenuItem;
    MenuHelpScummVMHomepage: TMenuItem;
    MenuHelpScummVMCompatibility: TMenuItem;
    MenuHelpScummVMCompatibilityIntern: TMenuItem;
    TrayIconPopupAddScummVMProfile: TMenuItem;
    MenuFileImportXMLFile: TMenuItem;
    ButtonClose: TToolButton;
    ButtonRunSetup: TToolButton;
    MenuExtrasCheckProfiles: TMenuItem;
    MenuHelpOperationMode: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure MenuWork(Sender: TObject);
    procedure ListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure ApplicationEventsRestore(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ScreenshotListViewDblClick(Sender: TObject);
    procedure ScreenshotListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScreenshotMenuWork(Sender: TObject);
    procedure ScreenshotListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchEditChange(Sender: TObject);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure SoundMenuWork(Sender: TObject);
    procedure SoundListViewDblClick(Sender: TObject);
    procedure SoundListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SoundListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure TreeViewPopupEditUserFiltersClick(Sender: TObject);
    procedure IdleAddonTimerTimer(Sender: TObject);
    procedure TrayIconPopupClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    hScreenshotsChangeNotification, hConfsChangeNotification : THandle;
    JustStarted : Boolean;
    ListSort : TSortListBy;
    ListSortReverse : Boolean;
    DeleteOnExit : TStringList;
    OldGamesMenuUsed : Boolean;
    StartTrayMinimize : Boolean;
    FileConflictCheckRunning : Boolean;
    SaveBoundsRect : TRect;
    SaveMaximizedState : Boolean;
    Procedure StartCaptureChangeNotify;
    Procedure StopCaptureChangeNotify;
    Procedure LoadMenuLanguage;
    Procedure InitGUI;
    Procedure InitViewStyle;
    Procedure SelectGame(const AGame : TGame);
    Procedure LoadHelpLinks;
    Procedure ProcessParams;
    Procedure UpdateScreenshotList;
    Procedure UpdateOpenFileInDataFolderMenu;
    Procedure AddDirToMenu(const Dir : String; const Menu1, Menu2 : TMenuItem; const Level : Integer);
    Procedure OpenFileInDataFolderMenuWork(Sender : TObject);
    Procedure UpdateAddFromTemplateMenu;
    Procedure AddFromTemplateClick(Sender: TObject);
    Procedure PostShow(var Msg : TMessage); Message WM_USER+1;
    Procedure RunUpdateCheck(const Quite : Boolean);
    Procedure LoadGUISetup(const PrgStart : Boolean);
    Procedure LoadListViewGUISetup(const ListView : TListView; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadTreeViewGUISetup(const TreeView : TTreeView; const Background, FontColor : String; const FontSize : Integer);
    Procedure LoadCoolBarGUISetup(const CoolBar : TCoolBar; const Background : String; const FontSize : Integer);
    Procedure ConfFileCheck;
    procedure WMDropFiles(var Message: TWMDROPFILES); message WM_DROPFILES;
    Procedure DropImportFile(const FileName: String; var ErrorCode : String);
    Procedure StartWizard(const ExeFile : String);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  DFendReloadedMainForm: TDFendReloadedMainForm;

implementation

uses ShellAPI, ShlObj, ClipBrd, Math, PNGImage, CommonTools, LanguageSetupUnit,
     PrgConsts, VistaToolsUnit, PrgSetupUnit, SetupDosBoxFormUnit,
     ProfileEditorFormUnit, SetupFormUnit, IconManagerFormUnit, DosBoxUnit,
     HistoryFormUnit, TemplateFormUnit, UninstallFormUnit, ViewImageFormUnit,
     UninstallSelectFormUnit, CreateConfFormUnit, WizardFormUnit,
     CreateShortcutFormUnit, CreateImageUnit, InfoFormUnit, TransferFormUnit,
     BuildInstallerFormUnit, ResHookUnit, ChangeProfilesFormUnit,
     BuildInstallerForSingleGameFormUnit, ModernProfileEditorFormUnit,
     ListViewImageUnit, StatisticsFormUnit, CacheChooseFormUnit, IconLoaderUnit,
     LanguageEditorStartFormUnit, LanguageEditorFormUnit, PlaySoundFormUnit,
     WallpaperStyleFormUnit, CreateISOImageFormUnit, CreateXMLFormUnit,
     ExpandImageFormUnit, FirstRunWizardFormUnit, CommonComponents,
     BuildImageFromFolderFormUnit, MiniRunFormUnit, ScummVMUnit,
     ListScummVMGamesFormUnit, DragNDropErrorFormUnit, SimpleXMLUnit,
     OperationModeInfoFormUnit;

{$R *.dfm}

procedure TDFendReloadedMainForm.FormCreate(Sender: TObject);
begin
  {Caption:=Caption+' THIS IS A BETA VERSION ! NOT FOR REGULAR USE ! (Beta 1 of version 0.4.0)';}

  Height:=790;
  Width:=Min(Width,790);
  JustStarted:=True;
  FileConflictCheckRunning:=False;
  StartTrayMinimize:=False;

  ListSort:=slbName;
  ListSortReverse:=False;
  OldGamesMenuUsed:=False;

  DeleteOnExit:=TStringList.Create;

  try ForceDirectories(PrgDataDir+CaptureSubDir); except end;
  StartCaptureChangeNotify;

  GameDB:=TGameDB.Create(PrgDataDir+GameListSubDir);

  LoadMenuLanguage;
  InitGUI;
  UpdateAddFromTemplateMenu;

  If PrgSetup.FirstRun then begin
    If IsWindowsVista then PrgSetup.SDLVideodriver:='WinDIB';
    SearchDosBox(self);
    ShowFirstRunWizardDialog(self);
  end;
end;

procedure TDFendReloadedMainForm.FormShow(Sender: TObject);
Var G : TGame;
begin
  If not JustStarted then exit;
  JustStarted:=False;

  DragAcceptFiles(Handle,True);

  TreeView.OnChange:=nil;

  SearchDosBox(self);
  LoadHelpLinks;

  If PrgSetup.FirstRun then begin
    BuildDefaultProfile;
    G:=BuildDefaultDosProfile(GameDB);
    ReBuildTemplates;
    LoadLanguage(PrgSetup.Language);
    LoadMenuLanguage;
    LoadGUISetup(False);
    SelectGame(G);
    PrgSetup.DFendVersion:=GetNormalFileVersionAsString;
  end else begin
    If PrgSetup.DFendVersion<>GetNormalFileVersionAsString then begin
      PrgSetup.DFendVersion:=GetNormalFileVersionAsString;
      G:=BuildDefaultDosProfile(GameDB);
      LoadGUISetup(False);
      SelectGame(G);
    end else begin
      LoadGUISetup(True);
    end;
  end;

  Case PrgSetup.CheckForUpdates of
    0 : {Do not check automatically};
    1 : If Round(Date)>=PrgSetup.LastUpdateCheck+7 then RunUpdateCheck(True);
    2 : If Round(Date)>=PrgSetup.LastUpdateCheck+1 then RunUpdateCheck(True);
    3 : RunUpdateCheck(True);
  end;

  LoadUserIcons(ImageList,'Main');

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TDFendReloadedMainForm.FormDestroy(Sender: TObject);
Var I : Integer;
begin
  try
    try
      For I:=0 to DeleteOnExit.Count-1 do If FileExists(DeleteOnExit[I]) then DeleteFile(DeleteOnExit[I]);
    finally
      DeleteOnExit.Free;
    end;
  except end;

  StopCaptureChangeNotify;
  PrgSetup.MainMaximized:=(WindowState=wsMaximized);
  PrgSetup.MainLeft:=Left;
  PrgSetup.MainTop:=Top;
  PrgSetup.MainWidth:=Width;
  PrgSetup.MainHeight:=Height;
  PrgSetup.TreeWidth:=TreeView.Width;
  PrgSetup.ScreenshotHeight:=CapturePageControl.Height;

  GameDB.Free;
end;

procedure TDFendReloadedMainForm.LoadMenuLanguage;
begin
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  MenuFile.Caption:=LanguageSetup.MenuFile;
  MenuFileImport.Caption:=LanguageSetup.MenuFileImport;
  MenuFileImportConfFile.Caption:=LanguageSetup.MenuFileImportConf;
  MenuFileImportProfFile.Caption:=LanguageSetup.MenuFileImportProf;
  MenuFileExport.Caption:=LanguageSetup.MenuFileExport;
  MenuFileExportGamesList.Caption:=LanguageSetup.MenuFileExportGamesList;
  MenuFileCreateConf.Caption:=LanguageSetup.MenuFileCreateConf;
  MenuFileCreateProf.Caption:=LanguageSetup.MenuFileCreateProf;
  MenuFileSetup.Caption:=LanguageSetup.MenuFileSetup;
  MenuFileQuit.Caption:=LanguageSetup.MenuFileQuit;
  MenuView.Caption:=LanguageSetup.MenuView;
  MenuViewsShowTree.Caption:=LanguageSetup.MenuViewShowTree;
  MenuViewsShowScreenshots.Caption:=LanguageSetup.MenuViewShowScreenshots;
  MenuViewsShowSearchBox.Caption:=LanguageSetup.MenuViewShowSearchBox;
  MenuViewsShowExtraInfo.Caption:=LanguageSetup.MenuViewShowExtraInfo;
  MenuViewsShowTooltips.Caption:=LanguageSetup.MenuViewShowTooltips;
  MenuViewsSimpleListNoIcons.Caption:=LanguageSetup.MenuViewListNoIcons;
  MenuViewsSimpleList.Caption:=LanguageSetup.MenuViewList;
  MenuViewsListNoIcons.Caption:=LanguageSetup.MenuViewReportNoIcons;
  MenuViewsList.Caption:=LanguageSetup.MenuViewReport;
  MenuViewsSmallIcons.Caption:=LanguageSetup.MenuViewSmallIcons;
  MenuViewsIcons.Caption:=LanguageSetup.MenuViewIcons;
  MenuRun.Caption:=LanguageSetup.MenuRun;
  MenuRunGame.Caption:=LanguageSetup.MenuRunGame;
  MenuRunSetup.Caption:=LanguageSetup.MenuRunSetup;
  MenuRunRunDosBox.Caption:=LanguageSetup.MenuRunRunDosBox;
  MenuRunRunDosBoxKeyMapper.Caption:=LanguageSetup.MenuRunRunDosBoxKeyMapper;
  MenuRunOpenDosBoxConfig.Caption:=LanguageSetup.MenuRunOpenDosBoxConfig;
  MenuRunRunScummVM.Caption:=LanguageSetup.MenuRunRunScummVM;
  MenuRunOpenScummVMConfig.Caption:=LanguageSetup.MenuRunOpenScummVMConfig;
  MenuProfile.Caption:=LanguageSetup.MenuProfile;
  MenuProfileAdd.Caption:=LanguageSetup.MenuProfileAdd;
  MenuProfileAddScummVM.Caption:=LanguageSetup.MenuProfileAddScummVM;
  MenuProfileAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  MenuProfileAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;
  MenuProfileEdit.Caption:=LanguageSetup.MenuProfileEdit;
  MenuProfileCopy.Caption:=LanguageSetup.MenuProfileCopy;
  MenuProfileDelete.Caption:=LanguageSetup.MenuProfileDelete;
  MenuProfileDeinstall.Caption:=LanguageSetup.MenuProfileDeinstall;
  MenuProfileMakeInstaller.Caption:=LanguageSetup.MenuProfileMakeInstaller;
  MenuProfileViewConfFile.Caption:=LanguageSetup.MenuProfileViewConfFile;
  MenuProfileViewIniFile.Caption:=LanguageSetup.MenuProfileViewIniFile;
  MenuProfileOpenFolder.Caption:=LanguageSetup.MenuProfileOpenFolder;
  MenuProfileOpenDataFolder.Caption:=LanguageSetup.MenuProfileOpenDataFolder;
  MenuProfileOpenFileInDataFolder.Caption:=LanguageSetup.MenuProfileOpenFileInDataFolder;
  MenuProfileWWW.Caption:=LanguageSetup.GameWWW;
  MenuProfileMarkAsFavorite.Caption:=LanguageSetup.MenuProfileMarkAsFavorite;
  MenuProfileCreateShortcut.Caption:=LanguageSetup.MenuProfileCreateShortcut;
  MenuExtras.Caption:=LanguageSetup.MenuExtras;
  MenuExtrasIconManager.Caption:=LanguageSetup.MenuExtrasIconManager;
  MenuExtrasViewLogs.Caption:=LanguageSetup.MenuExtrasViewLogs;
  MenuExtrasOpenGamesFolder.Caption:=LanguageSetup.MenuExtrasViewLogsOpenGamesFolder;
  MenuExtrasTemplates.Caption:=LanguageSetup.MenuExtrasTemplates;
  MenuExtrasDeinstallMultipleGames.Caption:=LanguageSetup.MenuExtrasDeinstallMultipleGames;
  MenuExtrasImageFiles.Caption:=LanguageSetup.MenuExtrasImageFiles;
  MenuExtrasCreateIMGImage.Caption:=LanguageSetup.MenuExtrasCreateIMGImageFile;
  MenuExtrasWriteIMGImage.Caption:=LanguageSetup.MenuExtrasWriteIMGImageFile;
  MenuExtrasCreateImage.Caption:=LanguageSetup.MenuExtrasCreateImageFile;
  MenuExtrasCreateISOImage.Caption:=LanguageSetup.MenuExtrasCreateISOImageFile;
  MenuExtrasExtractImage.Caption:=LanguageSetup.MenuExtrasExtractImage;
  MenuExtrasImageFromFolder.Caption:=LanguageSetup.MenuExtrasImageFromFolder;
  MenuExtrasTransferProfiles.Caption:=LanguageSetup.MenuExtrasTransferProfiles;
  MenuExtrasBuildInstaller.Caption:=LanguageSetup.MenuExtrasBuildInstaller;
  MenuExtrasChangeProfiles.Caption:=LanguageSetup.MenuExtrasChangeProfiles;

  MenuHelp.Caption:=LanguageSetup.MenuHelp;
  MenuHelpDosBox.Caption:=LanguageSetup.MenuHelpDosBox;
  MenuHelpDosBoxReadme.Caption:=LanguageSetup.MenuHelpDosBoxReadme;
  MenuHelpDosBoxFAQ.Caption:=LanguageSetup.MenuHelpDosBoxFAQ;
  MenuHelpDosBoxIntro.Caption:=LanguageSetup.MenuHelpDosBoxIntro;
  MenuHelpDosBoxIntroDosBox.Caption:=LanguageSetup.MenuHelpDosBoxIntroDosBox;
  MenuHelpDosBoxHotkeys.Caption:=LanguageSetup.MenuHelpDosBoxHotkeys;
  MenuHelpDosBoxHotkeysDosbox.Caption:=LanguageSetup.MenuHelpDosBoxHotkeysDosbox;
  MenuHelpDosBoxHomepage.Caption:=LanguageSetup.MenuHelpDosBoxHomepage;
  MenuHelpDosBoxCompatibility.Caption:=LanguageSetup.MenuHelpDosBoxCompatibility;
  MenuHelpDemoCompatibility.Caption:=LanguageSetup.MenuHelpDemoCompatibility;
  MenuHelpScummVM.Caption:=LanguageSetup.MenuHelpScummVM;
  MenuHelpScummVMReadme.Caption:=LanguageSetup.MenuHelpScummVMReadme;
  MenuHelpScummVMFAQ.Caption:=LanguageSetup.MenuHelpScummVMFAQ;
  MenuHelpScummVMHomepage.Caption:=LanguageSetup.MenuHelpScummVMHomepage;
  MenuHelpScummVMCompatibility.Caption:=LanguageSetup.MenuHelpScummVMCompatibility;
  MenuHelpScummVMCompatibilityIntern.Caption:=LanguageSetup.MenuHelpScummVMCompatibilityList;
  MenuHelpAbandonware.Caption:=LanguageSetup.MenuHelpAbandonware;
  MenuHelpHomepage.Caption:=LanguageSetup.MenuHelpHomepage;
  MenuHelpForum.Caption:=LanguageSetup.MenuHelpForum;
  MenuHelpUpdates.Caption:=LanguageSetup.MenuHelpUpdates;
  MenuHelpFAQs.Caption:=LanguageSetup.MenuHelpFAQs;
  MenuHelpMakeDFRBetter.Caption:=LanguageSetup.MenuHelpMakeDFRBetter;
  MenuHelpMakeBetterIcons.Caption:=LanguageSetup.MenuHelpMakeBetterIcons;
  MenuHelpMakeTranslation.Caption:=LanguageSetup.MenuHelpMakeTranslation;
  MenuHelpStatistics.Caption:=LanguageSetup.MenuHelpStatistics;
  MenuHelpAbout.Caption:=LanguageSetup.MenuHelpAbout;

  AddButtonMenuAdd.Caption:=LanguageSetup.MenuProfileAdd;
  AddButtonMenuAddScummVM.Caption:=LanguageSetup.MenuProfileAddScummVM;
  AddButtonMenuAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  AddButtonMenuAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;

  ButtonClose.Caption:=LanguageSetup.ButtonClose;
  ButtonClose.Hint:=RemoveUnderline(LanguageSetup.ButtonClose);
  ButtonRun.Caption:=LanguageSetup.ButtonRun;
  ButtonRun.Hint:=RemoveUnderline(LanguageSetup.ButtonRun);
  ButtonRunSetup.Caption:=LanguageSetup.ButtonRunSetup;
  ButtonRunSetup.Hint:=RemoveUnderline(LanguageSetup.ButtonRunSetup); 
  ButtonAdd.Caption:=LanguageSetup.ButtonAdd;
  ButtonAdd.Hint:=RemoveUnderline(LanguageSetup.ButtonAdd);
  ButtonEdit.Caption:=LanguageSetup.ButtonEdit;
  ButtonEdit.Hint:=RemoveUnderline(LanguageSetup.ButtonEdit);
  ButtonDelete.Caption:=LanguageSetup.ButtonDelete;
  ButtonDelete.Hint:=RemoveUnderline(LanguageSetup.ButtonDelete);

  PopupRunGame.Caption:=LanguageSetup.PopupRunGame;
  PopupRunSetup.Caption:=LanguageSetup.PopupRunSetup;
  PopupEdit.Caption:=LanguageSetup.PopupEdit;
  PopupCopy.Caption:=LanguageSetup.PopupCopy;
  PopupDelete.Caption:=LanguageSetup.PopupDelete;
  PopupDeinstall.Caption:=LanguageSetup.PopupDeinstall;
  PopupMakeInstaller.Caption:=LanguageSetup.PopupMakeInstaller;
  PopupViewConfFile.Caption:=LanguageSetup.MenuProfileViewConfFile;
  PopupViewINIFile.Caption:=LanguageSetup.MenuProfileViewIniFile;
  PopupOpenFolder.Caption:=LanguageSetup.PopupOpenFolder;
  PopupOpenDataFolder.Caption:=LanguageSetup.PopupOpenDataFolder;
  PopupOpenFileInDataFolder.Caption:=LanguageSetup.PopupOpenFileInDataFolder;
  PopupWWW.Caption:=LanguageSetup.GameWWW;
  PopupMarkAsFavorite.Caption:=LanguageSetup.PopupMarkAsFavorite;
  PopupCreateShortcut.Caption:=LanguageSetup.PopupCreateShortcut;
  PopupViews.Caption:=LanguageSetup.PopupView;
  PopupSimpleListNoIcons.Caption:=LanguageSetup.MenuViewListNoIcons;
  PopupSimpleList.Caption:=LanguageSetup.MenuViewList;
  PopupListNoIcons.Caption:=LanguageSetup.MenuViewReportNoIcons;
  PopupList.Caption:=LanguageSetup.MenuViewReport;
  PopupSmallIcons.Caption:=LanguageSetup.MenuViewSmallIcons;
  PopupIcons.Caption:=LanguageSetup.MenuViewIcons;

  CaptureScreenshotsTab.Caption:=LanguageSetup.CaptureScreenshots;
  ScreenshotsInfoPanel.Caption:=LanguageSetup.CaptureScreenshotsInfo;
  CaptureSoundTab.Caption:=LanguageSetup.CaptureSounds;
  SoundInfoPanel.Caption:=LanguageSetup.CaptureSoundsInfo;

  ScreenshotPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  ScreenshotPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  ScreenshotPopupImport.Caption:=LanguageSetup.ScreenshotPopupImport;
  ScreenshotPopupCopy.Caption:=LanguageSetup.ScreenshotPopupCopy;
  ScreenshotPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  ScreenshotPopupRename.Caption:=LanguageSetup.ScreenshotPopupRename;
  ScreenshotPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  ScreenshotPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;
  ScreenshotPopupUseAsBackground.Caption:=LanguageSetup.ScreenshotPopupUseAsBackground;

  SoundPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  SoundPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  SoundPopupImport.Caption:=LanguageSetup.ScreenshotPopupImport;
  SoundPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  SoundPopupSaveMp3.Caption:=LanguageSetup.SoundsPopupSaveMp3;
  SoundPopupSaveOgg.Caption:=LanguageSetup.SoundsPopupSaveOgg;
  SoundPopupRename.Caption:=LanguageSetup.ScreenshotPopupRename;
  SoundPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  SoundPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;
  SoundPopupSaveMp3All.Caption:=LanguageSetup.SoundsPopupSaveMp3All;
  SoundPopupSaveOggAll.Caption:=LanguageSetup.SoundsPopupSaveOggAll;

  TrayIconPopupRestore.Caption:=LanguageSetup.TrayPopupRestore;
  TrayIconPopupRun.Caption:=LanguageSetup.TrayPopupRun;
  TrayIconPopupAddProfile.Caption:=LanguageSetup.TrayPopupAdd;
  TrayIconPopupAddScummVMProfile.Caption:=LanguageSetup.MenuProfileAddScummVM;
  TrayIconPopupAddFromTemplate.Caption:=LanguageSetup.TrayPopupAddFromTemplate;
  TrayIconPopupAddWithWizard.Caption:=LanguageSetup.TrayPopupAddWithWizard;
  TrayIconPopupClose.Caption:=LanguageSetup.TrayPopupClose;

  TreeViewPopupEditUserFilters.Caption:=LanguageSetup.TreeViewPopupUserDefinedCategories;

  ScreenshotImageList.Height:=Max(20,Min(500,PrgSetup.ScreenshotPreviewSize));
  ScreenshotImageList.Width:=ScreenshotImageList.Height*16 div 10;

  MenuKeyCaps[mkcBkSp]:=LanguageSetup.KeyBackspace;
  MenuKeyCaps[mkcTab]:=LanguageSetup.KeyTab;
  MenuKeyCaps[mkcEsc]:=LanguageSetup.KeyEscape;
  MenuKeyCaps[mkcEnter]:=LanguageSetup.KeyEnter;
  MenuKeyCaps[mkcSpace]:=LanguageSetup.KeySpace;
  MenuKeyCaps[mkcPgUp]:=LanguageSetup.KeyPageUp;
  MenuKeyCaps[mkcPgDn]:=LanguageSetup.KeyPageDown;
  MenuKeyCaps[mkcEnd]:=LanguageSetup.KeyEnd;
  MenuKeyCaps[mkcHome]:=LanguageSetup.KeyHome;
  MenuKeyCaps[mkcLeft]:=LanguageSetup.KeyLeft;
  MenuKeyCaps[mkcUp]:=LanguageSetup.KeyUp;
  MenuKeyCaps[mkcRight]:=LanguageSetup.KeyRight;
  MenuKeyCaps[mkcDown]:=LanguageSetup.KeyDown;
  MenuKeyCaps[mkcIns]:=LanguageSetup.KeyInsert;
  MenuKeyCaps[mkcDel]:=LanguageSetup.KeyDelete;
  MenuKeyCaps[mkcShift]:=LanguageSetup.KeyShift;
  MenuKeyCaps[mkcCtrl]:=LanguageSetup.KeyCtrl;
  MenuKeyCaps[mkcAlt]:=LanguageSetup.KeyAlt;

  MsgDlgWarning:=LanguageSetup.MsgDlgWarning;
  MsgDlgError:=LanguageSetup.MsgDlgError;
  MsgDlgInformation:=LanguageSetup.MsgDlgInformation;
  MsgDlgConfirm:=LanguageSetup.MsgDlgConfirm;
  MsgDlgYes:=LanguageSetup.MsgDlgYes;
  MsgDlgNo:=LanguageSetup.MsgDlgNo;
  MsgDlgOK:=LanguageSetup.MsgDlgOK;
  MsgDlgCancel:=LanguageSetup.MsgDlgCancel;
  MsgDlgAbort:=LanguageSetup.MsgDlgAbort;
  MsgDlgRetry:=LanguageSetup.MsgDlgRetry;
  MsgDlgIgnore:=LanguageSetup.MsgDlgIgnore;
  MsgDlgAll:=LanguageSetup.MsgDlgAll;
  MsgDlgNoToAll:=LanguageSetup.MsgDlgNoToAll;
  MsgDlgYesToAll:=LanguageSetup.MsgDlgYesToAll;
end;

procedure TDFendReloadedMainForm.InitGUI;
begin
  DoubleBuffered:=True;
  SearchEdit.DoubleBuffered:=True;
  SetVistaFonts(self);
  {ListView.DoubleBuffered:=True; - causes problems with tooltips}
  CapturePageControl.DoubleBuffered:=True;
  ScreenshotListView.DoubleBuffered:=True;
  SoundListView.DoubleBuffered:=True;
  TreeView.DoubleBuffered:=True;

  MenuRunGame.ShortCut:=ShortCut(VK_Return,[]);
  MenuRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  MenuProfileEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  PopupRunGame.ShortCut:=ShortCut(VK_Return,[]);
  PopupRunSetup.ShortCut:=ShortCut(VK_Return,[ssShift]);
  PopupEdit.ShortCut:=ShortCut(VK_Return,[ssCtrl]);
  ScreenshotPopupOpen.ShortCut:=ShortCut(VK_Return,[]);

  InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
  InitTreeViewForGamesList(TreeView,GameDB);

  Case PrgSetup.StartWindowSize of
    0 : {nothing};
    1 : begin
          If PrgSetup.MainMaximized then begin
            {Minimize in OnShow};
          end else begin
            If (PrgSetup.MainLeft>=0) and (PrgSetup.MainLeft<9*Screen.Width div 10) then Left:=PrgSetup.MainLeft;
            If (PrgSetup.MainTop>=0) and (PrgSetup.MainTop<9*Screen.Height div 10) then Top:=PrgSetup.MainTop;
            If (PrgSetup.MainWidth>=0) and (Left+PrgSetup.MainWidth<=Screen.Width) then Width:=PrgSetup.MainWidth;
            If (PrgSetup.MainHeight>=0) and (Top+PrgSetup.MainHeight<=Screen.Height) then Height:=PrgSetup.MainHeight;
            Position:=poDesigned;
          end;
          If (PrgSetup.TreeWidth>=0) and (PrgSetup.TreeWidth<9*ClientWidth div 10) then TreeView.Width:=PrgSetup.TreeWidth;
          If (PrgSetup.ScreenshotHeight>=0) and (PrgSetup.ScreenshotHeight<9*ClientHeight div 10) then CapturePageControl.Width:=PrgSetup.ScreenshotHeight;
        end;
    2 : {Minimize in OnShow};
    3 : {Maximize in OnShow};
  end;

  CapturePageControl.Visible:=PrgSetup.ShowScreenshots;
  MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;

  TreeView.Visible:=PrgSetup.ShowTree;
  MenuViewsShowTree.Checked:=PrgSetup.ShowTree;

  ButtonClose.Visible:=PrgSetup.ShowToolbarButtonClose;
  ButtonRun.Visible:=PrgSetup.ShowToolbarButtonRun;
  ButtonRunSetup.Visible:=PrgSetup.ShowToolbarButtonRunSetup;
  ButtonAdd.Visible:=PrgSetup.ShowToolbarButtonAdd;
  ButtonEdit.Visible:=PrgSetup.ShowToolbarButtonEdit;
  ButtonDelete.Visible:=PrgSetup.ShowToolbarButtonDelete;

  SearchEdit.Visible:=PrgSetup.ShowSearchBox;
  MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;

  MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;
  InitViewStyle;

  ListView.ShowHint:=PrgSetup.ShowTooltips;
  MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;

  SearchEdit.OnChange:=nil;
  SearchEdit.Text:=LanguageSetup.Search;
  SearchEdit.Font.Color:=clGray;
  SearchEdit.OnChange:=SearchEditChange;

  MenuFileImportXMLFile.Visible:=PrgSetup.ShowXMLImportMenuItem;
  MenuFileCreateXML.Visible:=PrgSetup.ShowXMLExportMenuItem;
end;

procedure TDFendReloadedMainForm.InitViewStyle;
Var S : String;
    I : Integer;
begin
  S:=Trim(ExtUpperCase(PrgSetup.ListViewStyle));
  I:=3;
  If S='SIMPLELISTNOICONS' then I:=0;
  If S='SIMPLELIST' then I:=1;
  If S='LISTNOICONS' then I:=2;
  If S='LIST' then I:=3;
  If S='SMALLICONS' then I:=4;
  If S='ICONS' then I:=5;

  Case I of
    0 : begin
          MenuViewsSimpleListNoIcons.Checked:=True;
          PopupSimpleListNoIcons.Checked:=True;
          ListView.SmallImages:=nil;
          If (ListView.SmallImages<>nil) and (ListView.ViewStyle=vsList) then ListView.ViewStyle:=vsReport;
          ListView.ViewStyle:=vsList;
        end;
    1 : begin
          MenuViewsSimpleList.Checked:=True;
          PopupSimpleList.Checked:=True;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsList;
        end;
    2 : begin
          MenuViewsListNoIcons.Checked:=True;
          PopupListNoIcons.Checked:=True;
          If (ListView.SmallImages<>nil) and (ListView.ViewStyle=vsReport) then ListView.ViewStyle:=vsList;
          ListView.SmallImages:=nil;
          ListView.ViewStyle:=vsReport;
        end;
    3 : begin
          MenuViewsList.Checked:=True;
          PopupList.Checked:=True;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsReport;
        end;
    4 : begin
          MenuViewsSmallIcons.Checked:=True;
          PopupSmallIcons.Checked:=True;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsSmallIcon;
        end;
    5 : begin
          MenuViewsIcons.Checked:=True;
          PopupIcons.Checked:=True;
          ListView.SmallImages:=ListviewImageList;
          ListView.ViewStyle:=vsIcon;
        end;
  end;
end;

procedure TDFendReloadedMainForm.LoadHelpLinks;
Var St : TStringList;
    I : Integer;
    S : String;
    M : TMenuItem;
    Rec : TSearchRec;
begin
  If FileExists(PrgDir+'Links.txt') then begin
    St:=TStringList.Create;
    try
      try St.LoadFromFile(PrgDir+'Links.txt'); except exit; end;
      For I:=0 to St.Count-1 do begin
        S:=Trim(St[I]);
        If S='' then continue;
        If (S='-') or (S='---') then begin
          M:=TMenuItem.Create(self);
          M.Caption:='-';
          MenuHelpAbandonware.Add(M);
          continue;
        end;
        If Pos(';',S)=0 then continue;
        M:=TMenuItem.Create(self);
        M.Caption:=Trim(Copy(S,1,Pos(';',S)-1));
        M.Hint:=Trim(Copy(S,Pos(';',S)+1,MaxInt));
        M.Tag:=6102;
        M.OnClick:=MenuWork;
        MenuHelpAbandonware.Add(M);
      end;
    finally
      St.Free;
    end;
  end;

  I:=FindFirst(PrgSetup.DosBoxDir+'Readme*.txt',faAnyFile,Rec);
  try
    while I=0 do begin
      M:=TMenuItem.Create(self);
      M.Caption:=Trim(Rec.Name);
      M.Tag:=6101;
      M.OnClick:=MenuWork;
      M.ImageIndex:=24;
      MenuHelpDosBoxReadme.Add(M);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TDFendReloadedMainForm.PostShow(var Msg: TMessage);
begin
  Case PrgSetup.StartWindowSize of
    0 : begin
          {nothing}
          {To fix misaligend ListView when stating maximized}
          If WindowState=wsMaximized then begin
            WindowState:=wsNormal;
            WindowState:=wsMaximized;
          end;
        end;
    1 : If PrgSetup.MainMaximized then begin
          WindowState:=wsMaximized;
        end else begin
          {Done in InitGUI};
        end;
    2 : If PrgSetup.MinimizeToTray then begin
          WindowState:=wsMinimized;
          ApplicationEventsMinimize(self);
          StartTrayMinimize:=True;
        end else begin
          WindowState:=wsMinimized;
        end;
    3 : WindowState:=wsMaximized;
  end;

  If ListView.Items.Count=0
    then TreeViewChange(TreeView,nil)
    else ListViewSelectItem(ListView,nil,False);

  {To fix misaligend ListView when stating maximized}
  UpdateBounds;
  Resize;
  Realign;

  ProcessParams;

  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
end;

procedure TDFendReloadedMainForm.ProcessParams;
Var I : Integer;
    S,T : String;
begin
  If ParamCount=0 then exit;

  S:=ParamStr(1);

  T:=Trim(ExtUpperCase(S));
  If (Pos('WINEMODE',T)>0) or (Pos('WINESUPPORTENABLED',T)>0) or (Pos('WINDOWSMODE',T)>0) or (Pos('NOWINESUPPORT',T)>0) or (Pos('WINESUPPORTDISABLED',T)>0) then exit;

  For I:=2 to ParamCount do S:=S+' '+ParamStr(I);
  T:=ExtUpperCase(S);

  For I:=0 to GameDB.Count-1 do If Trim(ExtUpperCase(GameDB[I].Name))=T then begin
    If ScummVMMode(GameDB[I])
      then RunScummVMGame(GameDB[I])
      else RunGame(GameDB[I]);
    PostMessage(Handle,WM_CLOSE,0,0);
    exit;
  end;

  MessageDlg(Format(LanguageSetup.MessageCouldNotFindGame,[S]),mtError,[mbOK],0);
end;

procedure TDFendReloadedMainForm.StartCaptureChangeNotify;
begin
  hScreenshotsChangeNotification:=FindFirstChangeNotification(
    PChar(PrgDataDir+CaptureSubDir),
    True,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
  );

  hConfsChangeNotification:=FindFirstChangeNotification(
    PChar(PrgDataDir+GameListSubDir),
    True,
    FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY
  );
end;

procedure TDFendReloadedMainForm.StopCaptureChangeNotify;
begin
  If hScreenshotsChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hScreenshotsChangeNotification);
  hScreenshotsChangeNotification:=INVALID_HANDLE_VALUE;

  If hConfsChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hConfsChangeNotification);
  hConfsChangeNotification:=INVALID_HANDLE_VALUE;
end;

procedure TDFendReloadedMainForm.SearchEditChange(Sender: TObject);
begin
  If SearchEdit.Font.Color=clGray then begin
    SearchEdit.Font.Color:=clWindowText;
    SearchEdit.Text:='';
    exit;
  end;
  TreeViewChange(Sender,TreeView.Selected);
end;

procedure TDFendReloadedMainForm.SelectGame(const AGame: TGame);
Var I : Integer;
begin
  If AGame=nil then exit;
  For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data)=AGame then begin
    ListView.Selected:=ListView.Items[I];
    ListView.Selected.MakeVisible(False);
    break;
  end;
  ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

procedure TDFendReloadedMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
Var G : TGame;
    S : String;
begin
  ListView.Items.BeginUpdate;
  try
    If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
    ListView.Items.Clear;

    If SearchEdit.Font.Color<>clGray then S:=SearchEdit.Text else S:='';

    If TreeView.Selected=nil then begin
      AddGamesToList(ListView,ListviewImageList,ListviewIconImageList,ImageList,GameDB,RemoveUnderline(LanguageSetup.All),'',S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse);
    end else begin
      If TreeView.Selected.Parent=nil
        then AddGamesToList(ListView,ListviewImageList,ListviewIconImageList,ImageList,GameDB,TreeView.Selected.Text,'',S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse)
        else AddGamesToList(ListView,ListviewImageList,ListviewIconImageList,ImageList,GameDB,TreeView.Selected.Parent.Text,TreeView.Selected.Text,S,PrgSetup.ShowExtraInfo,ListSort,ListSortReverse);
    end;
    If G<>nil then SelectGame(G);
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TDFendReloadedMainForm.ListViewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  DefaultDraw:=True;
  If (Item<>nil) and (Item.Data<>nil) and TGame(Item.Data).Favorite then TListview(Sender).Canvas.Font.Style:=[fsBold] else TListview(Sender).Canvas.Font.Style:=[];
end;

procedure TDFendReloadedMainForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort,ListSortReverse);
  TreeViewChange(Sender,TreeView.Selected);
end;

procedure TDFendReloadedMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F2) and (Shift=[]) then MenuWork(MenuProfileEdit);
  If (Key=VK_F5) and (Shift=[]) then EditDefaultProfile(self,GameDB);
end;

procedure TDFendReloadedMainForm.ListViewDblClick(Sender: TObject);
begin
  MenuWork(ButtonRun);
end;

procedure TDFendReloadedMainForm.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
Var G : TGame;
    St : TStringList;
    I,J : Integer;
    S : String;
begin
  If Item=nil then exit;
  G:=TGame(Item.Data); If G=nil then exit;
  InfoTip:=G.Name;

  If G.Genre<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameGenre+': '+G.Genre;
  If G.Developer<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameDeveloper+': '+G.Developer;
  If G.Publisher<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GamePublisher+': '+G.Publisher;
  If G.Year<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameYear+': '+G.Year;
  If G.Language<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameLanguage+': '+G.Language;
  If G.WWW<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameWWW+': '+G.WWW;

  St:=StringToStringList(G.UserInfo);
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]); If S='' then continue;
      J:=Pos('=',S); If J>0 then InfoTip:=InfoTip+#13+Trim(Copy(S,1,J-1))+': '+Trim(Copy(S,J+1,MaxInt));
    end;
  finally
    St.Free;
  end;

  S:=GetLastModificationDate(G); If S<>'' then InfoTip:=InfoTip+#13+LanguageSetup.GameLastModification+': '+S;

  If G.Notes<>'' then begin
    St:=StringToStringList(G.Notes);
    If St.Count>0 then InfoTip:=InfoTip+#13;
    For I:=0 to Min(4,St.Count-1) do InfoTip:=InfoTip+#13+St[I];
  end;
  If Trim(G.DataDir)<>'' then InfoTip:=InfoTip+#13+#13+LanguageSetup.GameDataDirInfo;
end;

procedure TDFendReloadedMainForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B,B2 : Boolean;
    S : String;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);
  If B then B2:=ScummVMMode(TGame(Item.Data)) else B2:=False;

  MenuRunGame.Enabled:=B;
  MenuRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  MenuProfileEdit.Enabled:=B;
  MenuProfileCopy.Enabled:=B;
  MenuProfileDelete.Enabled:=B;
  MenuProfileDeinstall.Enabled:=B;
  MenuProfileMakeInstaller.Enabled:=B;
  If not B then begin
    MenuProfileViewConfFile.Visible:=True;
    MenuProfileViewConfFile.Enabled:=False;
    MenuProfileViewIniFile.Visible:=False;
  end else begin
    MenuProfileViewConfFile.Visible:=not B2;
    MenuProfileViewConfFile.Enabled:=not B2;
    MenuProfileViewIniFile.Visible:=B2;
    MenuProfileViewIniFile.Enabled:=B2;
  end;
  MenuProfileViewConfFile.Enabled:=B;

  MenuProfileOpenFolder.Enabled:=B and (Trim(TGame(Item.Data).GameExe)<>'');
  MenuProfileOpenDataFolder.Enabled:=B and (Trim(TGame(Item.Data).DataDir)<>'');
  MenuProfileMarkAsFavorite.Enabled:=B;
  MenuProfileWWW.Enabled:=B and (Trim(TGame(Item.Data).WWW)<>'');
  MenuProfileCreateShortcut.Enabled:=B;

  PopupRunGame.Enabled:=B;
  PopupRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  PopupEdit.Enabled:=B;
  PopupCopy.Enabled:=B;
  PopupDelete.Enabled:=B;
  PopupDeinstall.Enabled:=B;
  PopupMakeInstaller.Enabled:=B;
  If not B then begin
    PopupViewConfFile.Visible:=True;
    PopupViewConfFile.Enabled:=False;
    PopupViewINIFile.Visible:=False;
  end else begin
    PopupViewConfFile.Visible:=not B2;
    PopupViewConfFile.Enabled:=not B2;
    PopupViewINIFile.Visible:=B2;
    PopupViewINIFile.Enabled:=B2;
  end;
  PopupOpenFolder.Enabled:=B and (Trim(TGame(Item.Data).GameExe)<>'');
  PopupOpenDataFolder.Enabled:=B and (Trim(TGame(Item.Data).DataDir)<>'');
  PopupWWW.Enabled:=B and (Trim(TGame(Item.Data).WWW)<>'');
  PopupMarkAsFavorite.Enabled:=B;
  PopupCreateShortcut.Enabled:=B;

  ButtonRun.Enabled:=B;
  ButtonRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  ButtonEdit.Enabled:=B;
  ButtonDelete.Enabled:=B;

  UpdateScreenshotList;

  UpdateOpenFileInDataFolderMenu;
end;

Procedure TDFendReloadedMainForm.UpdateScreenshotList;
Var S : String;
begin
  ScreenshotListView.Items.BeginUpdate;
  try
    ScreenshotListView.Items.Clear;
    ScreenshotImageList.Clear;
    If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddScreenshotsToList(ScreenshotListView,ScreenshotImageList,S);
    end;
  finally
    ScreenshotListView.Items.EndUpdate;
  end;
  ScreenshotsInfoPanel.Visible:=(ScreenshotListView.Items.Count=0) and (ListView.Selected<>nil) and (not ScummVMMode(TGame(ListView.Selected.Data)));

  ScreenshotListViewSelectItem(self,ScreenshotListView.Selected,True);

  SoundListView.Items.BeginUpdate;
  try
    SoundListView.Items.Clear;
    If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddSoundsToList(SoundListView,S,33);
    end;
  finally
    SoundListView.Items.EndUpdate;
  end;
  SoundInfoPanel.Visible:=(SoundListView.Items.Count=0) and (ListView.Selected<>nil) and (not ScummVMMode(TGame(ListView.Selected.Data)));

  SoundListViewSelectItem(self,SoundListView.Selected,True);
end;

Procedure TDFendReloadedMainForm.UpdateOpenFileInDataFolderMenu;
Var B : Boolean;
    Dir : String;
begin
  B:=(ListView.Selected<>nil) and (ListView.Selected.Data<>nil) and (Trim(TGame(ListView.Selected.Data).DataDir)<>'');

  MenuProfileOpenFileInDataFolder.Enabled:=B;
  PopupOpenFileInDataFolder.Enabled:=B;

  while MenuProfileOpenFileInDataFolder.Count>0 do MenuProfileOpenFileInDataFolder.Items[0].Free;
  while PopupOpenFileInDataFolder.Count>0 do PopupOpenFileInDataFolder.Items[0].Free;

  If not B then exit;

  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(TGame(ListView.Selected.Data).DataDir,PrgSetup.BaseDir));
  if not DirectoryExists(Dir) then exit;

  AddDirToMenu(Dir,MenuProfileOpenFileInDataFolder,PopupOpenFileInDataFolder,0);
end;

Procedure TDFendReloadedMainForm.AddDirToMenu(const Dir : String; const Menu1, Menu2 : TMenuItem; const Level : Integer);
Var Rec : TSearchRec;
    I,Count : Integer;
    M1,M2,M : TMenuItem;
begin
  Count:=0;
  I:=FindFirst(Dir+'*.*',faDirectory,Rec);
  try
    while I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        If Count=20 then begin
          M1:=TMenuItem.Create(Menu1); M1.Caption:='(...)'; M1.Tag:=2; M1.OnClick:=OpenFileInDataFolderMenuWork; M1.ImageIndex:=8; Menu1.Add(M1);
          M2:=TMenuItem.Create(Menu2); M2.Caption:='(...)'; M2.Tag:=2; M2.OnClick:=OpenFileInDataFolderMenuWork; M2.ImageIndex:=8; Menu2.Add(M2);
          break;
        end;
        M1:=TMenuItem.Create(Menu1); M1.Caption:=Rec.Name; M1.Tag:=1; M1.ImageIndex:=11; Menu1.Add(M1);
        M2:=TMenuItem.Create(Menu2); M2.Caption:=Rec.Name; M2.Tag:=1; M2.ImageIndex:=11; Menu2.Add(M2);
        If Level<2 then begin
          AddDirToMenu(Dir+Rec.Name+'\',M1,M2,Level+1);
        end else begin
          M:=TMenuItem.Create(M1); M.Caption:='(...)'; M.Tag:=2; M.OnClick:=OpenFileInDataFolderMenuWork; M.ImageIndex:=8; M1.Add(M);
          M:=TMenuItem.Create(M2); M.Caption:='(...)'; M.Tag:=2; M.OnClick:=OpenFileInDataFolderMenuWork; M.ImageIndex:=8; M2.Add(M);
        end;
        inc(Count);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  Count:=0;
  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        If Count=20 then begin
          M1:=TMenuItem.Create(Menu1); M1.Caption:='(...)'; M1.Tag:=2; M1.OnClick:=OpenFileInDataFolderMenuWork; M1.ImageIndex:=8; Menu1.Add(M1);
          M2:=TMenuItem.Create(Menu2); M2.Caption:='(...)'; M2.Tag:=2; M2.OnClick:=OpenFileInDataFolderMenuWork; M2.ImageIndex:=8; Menu2.Add(M2);
          break;
        end;
        M1:=TMenuItem.Create(Menu1); M1.Caption:=Rec.Name; M1.Tag:=1; M1.OnClick:=OpenFileInDataFolderMenuWork; M1.ImageIndex:=24; Menu1.Add(M1);
        M2:=TMenuItem.Create(Menu2); M2.Caption:=Rec.Name; M2.Tag:=1; M2.OnClick:=OpenFileInDataFolderMenuWork; M2.ImageIndex:=24; Menu2.Add(M2);
        inc(Count);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure TDFendReloadedMainForm.OpenFileInDataFolderMenuWork(Sender : TObject);
Var I : Integer;
    Dir,S : String;
    M : TMenuItem;
begin
  M:=Sender as TMenuItem;
  I:=M.Tag;
  If (I<>1) and (I<>2) then exit;
  If I=1 then S:=RemoveUnderline(M.Caption) else S:='';

  M:=M.Parent;
  while (M<>MenuProfileOpenFileInDataFolder) and (M<>PopupOpenFileInDataFolder) do begin
    S:=RemoveUnderline(M.Caption)+'\'+S;
    M:=M.Parent;
  end;

  if (ListView.Selected=nil) or (ListView.Selected.Data=nil) or (Trim(TGame(ListView.Selected.Data).DataDir)='') then exit;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(TGame(ListView.Selected.Data).DataDir,PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then exit;

  If I=2
    then ShellExecute(Handle,'open',PChar(Dir+S),nil,PChar(Dir+S),SW_SHOW)
    else ShellExecute(Handle,'open',PChar(Dir+S),nil,nil,SW_SHOW);
end;

Procedure TDFendReloadedMainForm.UpdateAddFromTemplateMenu;
Var TemplateDB : TGameDB;
    I : Integer;
    M : TMenuItem;
begin
  while MenuProfileAddFromTemplate.Count>0 do MenuProfileAddFromTemplate.Items[0].Free;
  while AddButtonMenuAddFromTemplate.Count>0 do AddButtonMenuAddFromTemplate.Items[0].Free;
  while TrayIconPopupAddFromTemplate.Count>0 do TrayIconPopupAddFromTemplate.Items[0].Free;

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    MenuProfileAddFromTemplate.Visible:=(TemplateDB.Count>0);
    AddButtonMenuAddFromTemplate.Visible:=(TemplateDB.Count>0);
    For I:=0 to TemplateDB.Count-1 do begin
      M:=TMenuItem.Create(MenuProfileAddFromTemplate);
      M.Caption:=TemplateDB[I].Name;
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      MenuProfileAddFromTemplate.Add(M);

      M:=TMenuItem.Create(AddButtonMenuAddFromTemplate);
      M.Caption:=TemplateDB[I].Name;
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      AddButtonMenuAddFromTemplate.Add(M);

      M:=TMenuItem.Create(TrayIconPopupAddFromTemplate);
      M.Caption:=TemplateDB[I].Name;
      M.Tag:=I;
      M.OnClick:=AddFromTemplateClick;
      TrayIconPopupAddFromTemplate.Add(M);
    end;
  finally
    TemplateDB.Free;
  end;
end;

Procedure TDFendReloadedMainForm.LoadListViewGUISetup(const ListView : TListView; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then begin ListView.Color:=clWindow; SetListViewImage(ListView,'') end else begin
    try
      ListView.Color:=StringToColor(S); SetListViewImage(ListView,'');
    except
      ListView.Color:=clWindow; SetListViewImage(ListView,MakeAbsPath(S,PrgSetup.BaseDir));
    end;
  end;

  S:=Trim(FontColor);
  If S='' then ListView.Font.Color:=clWindowText else begin
    try ListView.Font.Color:=StringToColor(FontColor); except ListView.Font.Color:=clWindowText; end;
  end;
  ListView.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadTreeViewGUISetup(const TreeView : TTreeView; const Background, FontColor : String; const FontSize : Integer);
Var S : String;
begin
  S:=Trim(Background);
  If S='' then begin TreeView.Color:=clWindow; end else begin
    try
      TreeView.Color:=StringToColor(S);
    except
      TreeView.Color:=clWindow;
    end;
  end;

  S:=Trim(FontColor);
  If S='' then TreeView.Font.Color:=clWindowText else begin
    try TreeView.Font.Color:=StringToColor(FontColor); except TreeView.Font.Color:=clWindowText; end;
  end;
  TreeView.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadCoolBarGUISetup(const CoolBar : TCoolBar; const Background : String; const FontSize : Integer);
Var S : String;
    P : TPicture;
begin
  S:=Trim(Background);
  CoolBar.Bitmap:=nil;
  If S<>'' then begin
    S:=MakeAbsPath(S,PrgSetup.BaseDir);
    If FileExists(S) then begin
      P:=LoadImageFromFile(S);
      try
        If P<>nil then CoolBar.Bitmap.Assign(P.Graphic);
      finally
        P.Free;
      end;
    end;
  end;

  CoolBar.Font.Size:=FontSize;
end;

Procedure TDFendReloadedMainForm.LoadGUISetup(const PrgStart : Boolean);
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
    InitTreeViewForGamesList(TreeView,GameDB);
    if not PrgStart then TreeViewChange(self,TreeView.Selected);
  finally
    ListView.Items.EndUpdate;
  end;

  LoadListViewGUISetup(ListView,PrgSetup.GamesListViewBackground,PrgSetup.GamesListViewFontColor,PrgSetup.GamesListViewFontSize);
  LoadListViewGUISetup(ScreenshotListView,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadListViewGUISetup(SoundListView,PrgSetup.ScreenshotsListViewBackground,PrgSetup.ScreenshotsListViewFontColor,PrgSetup.ScreenshotsListViewFontSize);
  LoadTreeViewGUISetup(TreeView,PrgSetup.GamesTreeViewBackground,PrgSetup.GamesTreeViewFontColor,PrgSetup.GamesTreeViewFontSize);
  LoadCoolBarGUISetup(CoolBar,PrgSetup.ToolbarBackground,PrgSetup.ToolbarFontSize);

  CoolBar.Visible:=PrgSetup.ShowToolbar;
  ToolBar.ShowCaptions:=PrgSetup.ShowToolbarTexts;
  ToolBar.List:=ToolBar.ShowCaptions;
  ToolBar.ShowHint:=not ToolBar.ShowCaptions;
  If not ToolBar.ShowCaptions then ToolBar.ButtonWidth:=ToolBar.ButtonHeight;

  ButtonClose.Visible:=PrgSetup.ShowToolbarButtonClose;
  ButtonRun.Visible:=PrgSetup.ShowToolbarButtonRun;
  ButtonRunSetup.Visible:=PrgSetup.ShowToolbarButtonRunSetup;
  ButtonAdd.Visible:=PrgSetup.ShowToolbarButtonAdd;
  ButtonEdit.Visible:=PrgSetup.ShowToolbarButtonEdit;
  ButtonDelete.Visible:=PrgSetup.ShowToolbarButtonDelete;

  SearchEdit.Visible:=PrgSetup.ShowSearchBox;
  MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;

  TreeView.OnChange:=TreeViewChange;

  MenuRunRunScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuRunOpenScummVMConfig.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuProfileAddScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  AddButtonMenuAddScummVM.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  MenuHelpScummVMCompatibilityIntern.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  TrayIconPopupAddScummVMProfile.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
end;

Procedure TDFendReloadedMainForm.StartWizard(const ExeFile : String);
Var G : TGame;
    B : Boolean;
begin
   G:=nil;
   if not ShowWizardDialog(self,GameDB,ExeFile,G,B) then exit;
   InitTreeViewForGamesList(TreeView,GameDB);
   TreeViewChange(self,TreeView.Selected);
   SelectGame(G);
   If B then MenuWork(ButtonEdit);
end;

procedure TDFendReloadedMainForm.MenuWork(Sender: TObject);
Var G,DefaultGame : TGame;
    S,T : String;
    L : TList;
    I : Integer;
    P : TPoint;
    St : TStringList;
    B : Boolean;
begin
  StopCaptureChangeNotify;
  try
    Case (Sender as TComponent).Tag of
      {File}
      1001 : begin
               OpenDialog.DefaultExt:='conf';
               OpenDialog.Title:=LanguageSetup.MenuFileImportConfTitle;
               OpenDialog.Filter:=LanguageSetup.MenuFileImportConfFilter;
               If not OpenDialog.Execute then exit;
               G:=ImportConfFile(GameDB,OpenDialog.FileName);
               If G=nil then exit;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      1002 : begin
               SaveDialog.DefaultExt:='txt';
               SaveDialog.Title:=LanguageSetup.MenuFileExportGamesListDialog;
               SaveDialog.Filter:=LanguageSetup.MenuFileExportGamesListFilter;
               if not SaveDialog.Execute then exit;
               ExportGamesList(GameDB,SaveDialog.FileName);
             end;
      1003 : ExportConfFiles(self,GameDB);
      1004 : ExportProfFiles(self,GameDB);
      1005 : ExportXMLFiles(self,GameDB);
      1006 : if ShowSetupDialog(self,GameDB) then begin
               LoadLanguage(PrgSetup.Language);
               LoadMenuLanguage;
               If SearchEdit.Font.Color=clGray then begin
                 SearchEdit.OnChange:=nil;
                 SearchEdit.Text:=LanguageSetup.Search;
                 SearchEdit.OnChange:=SearchEditChange;
               end;
               LoadGUISetup(False);
             end;
      1007 : Close;
      1008 : begin
               OpenDialog.DefaultExt:='prof';
               OpenDialog.Title:=LanguageSetup.MenuFileImportProfTitle;
               OpenDialog.Filter:=LanguageSetup.MenuFileImportProfFilter;
               If not OpenDialog.Execute then exit;
               S:=GameDB.ProfFileName(ExtractFileName(OpenDialog.FileName));
               if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
                 MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
                 exit;
               end;
               G:=TGame.Create(S);
               GameDB.Add(G);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      1009 : begin
               OpenDialog.DefaultExt:='xml';
               //OpenDialog.Title:=LanguageSetup.MenuFileImportXMLTitle;
               OpenDialog.Title:='XML import';
               //OpenDialog.Filter:=LanguageSetup.MenuFileImportXMLFilter;
               OpenDialog.Filter:='XML files (*.xml)|*xml|All files|*.*';
               If not OpenDialog.Execute then exit;
               If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
               S:=ImportXMLFile(GameDB,OpenDialog.FileName);
               If S<>'' then begin MessageDlg(S,mtError,[mbOK],0); exit; end;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      {View}
      2001 : begin
               PrgSetup.ShowTree:=not PrgSetup.ShowTree;
               TreeView.Visible:=PrgSetup.ShowTree;
               MenuViewsShowTree.Checked:=PrgSetup.ShowTree;
               If not PrgSetup.ShowTree then begin
                 TreeView.Selected:=nil;
                 TreeViewChange(Sender,nil);
               end;
             end;
      2002 : begin
               PrgSetup.ShowScreenshots:=not PrgSetup.ShowScreenshots;
               CapturePageControl.Visible:=PrgSetup.ShowScreenshots;
               MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;
               ListViewSelectItem(Sender,ListView.Selected,True);
             end;
      2003 : begin
               PrgSetup.ShowSearchBox:=not PrgSetup.ShowSearchBox;
               SearchEdit.Visible:=PrgSetup.ShowSearchBox;
               MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;
               if not SearchEdit.Visible then begin
                 SearchEdit.OnChange:=nil;
                 SearchEdit.Text:=LanguageSetup.Search;
                 SearchEdit.Font.Color:=clGray;
                 SearchEdit.OnChange:=SearchEditChange;
                 InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
                 ListViewSelectItem(Sender,ListView.Selected,True);
               end;
             end;
      2004 : begin
               PrgSetup.ShowExtraInfo:=not PrgSetup.ShowExtraInfo;
               MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;
               InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      2005 : begin
               PrgSetup.ShowTooltips:=not PrgSetup.ShowTooltips;
               MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;
               ListView.ShowHint:=PrgSetup.ShowTooltips;
             end;
      2006 : begin PrgSetup.ListViewStyle:='SimpleListNoIcons'; InitViewStyle; end;
      2007 : begin PrgSetup.ListViewStyle:='SimpleList'; InitViewStyle; end;
      2008 : begin PrgSetup.ListViewStyle:='ListNoIcons'; InitViewStyle; end;
      2009 : begin PrgSetup.ListViewStyle:='List'; InitViewStyle; end;
      2010 : begin PrgSetup.ListViewStyle:='SmallIcons'; InitViewStyle; end;
      2011 : begin PrgSetup.ListViewStyle:='Icons'; InitViewStyle; end;
      {Run}
      3001 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               If ScummVMMode(G) then RunScummVMGame(G) else RunGame(G);
             end;
      3002 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               RunGame(G,True);
             end;
      3003 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName)
               then ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName),nil,PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)),SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
      3004 : begin
               If not FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName) then begin
                 MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
                 exit;
               end;
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 G:=TGame.Create(TempDir+'TempGameRec.prof');
                 try
                   with G do begin AssignFrom(DefaultGame); GameExe:=''; Autoexec:=''; NrOfMounts:=0; end;
                   RunWithCommandline(G,'-startmapper',True);
                 finally
                   G.Free;
                 end;
               finally
                 DefaultGame.Free;
               end;
               DeleteFile(TempDir+'TempGameRec.prof');
             end;
      3005 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxConfFileName)
               then ShellExecute(Handle,'open','notepad.exe',PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxConfFileName),PChar(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)),SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxConfFileName]),mtError,[mbOK],0);
      3006 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile)
               then ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile),nil,PChar(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)),SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile]),mtError,[mbOK],0);
      3007 : begin
               S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_APPDATA))+'ScummVM\';
              If FileExists(S+ScummVMConfFileName)
                 then ShellExecute(Handle,'open','notepad.exe',PChar(S+ScummVMConfFileName),PChar(S),SW_SHOW)
                 else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[S+ScummVMConfFileName]),mtError,[mbOK],0);
             end;
      {Profile}
      4000 : Case PrgSetup.AddButtonFunction of
               0 : MenuWork(MenuProfileAdd);
               1 : MenuWork(MenuProfileAddWithWizard);
               2 : begin
                     P:=ButtonAdd.Parent.ClientToScreen(Point(ButtonAdd.Left,ButtonAdd.Top));
                     AddButtonPopupMenu.Popup(P.X+5,P.Y+5);
                   end;
             end;
      4001 : begin
               G:=nil;
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 If PrgSetup.DFendStyleProfileEditor then begin
                   if not EditGameProfil(self,GameDB,G,DefaultGame) then exit;
                 end else begin
                   if not ModernEditGameProfil(self,GameDB,G,DefaultGame) then exit;
                 end;
               finally
                 DefaultGame.Free;
               end;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      4002 : StartWizard('');
      4003 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               L:=TList.Create;
               try
                 For I:=0 to ListView.Items.Count-1 do L.Add(ListView.Items[I].Data);
                 G:=TGame(ListView.Selected.Data);
                 If PrgSetup.DFendStyleProfileEditor then begin
                   if not EditGameProfil(self,GameDB,G,nil,L) then exit;
                 end else begin
                   if not ModernEditGameProfil(self,GameDB,G,nil,L) then exit;
                 end;
                 InitTreeViewForGamesList(TreeView,GameDB);
                 TreeViewChange(Sender,TreeView.Selected);
                 SelectGame(G);
               finally
                 L.Free;
               end;
             end;
      4004 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               S:=TGame(ListView.Selected.Data).Name;
               If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
               G:=GameDB[GameDB.Add(S)];
               G.AssignFrom(TGame(ListView.Selected.Data));
               G.Name:=S;
               G.LoadCache;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      4005 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               If PrgSetup.AskBeforeDelete then begin
                 if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecordOnly,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
               end;
               ListView.Items.Clear;
               GameDB.Delete(G);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      4006 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               ListView.Selected:=nil;
               ListView.Items.Clear;
               UninstallGame(self,GameDB,G);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      4007 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               S:=ExtractFilePath(MakeAbsPath(TGame(ListView.Selected.Data).GameExe,PrgSetup.BaseDir));
               ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      4008 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               S:=MakeAbsPath(TGame(ListView.Selected.Data).DataDir,PrgSetup.BaseDir);
               ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      4009 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               S:=Trim(TGame(ListView.Selected.Data).WWW);
               If S='' then exit;
               If ExtUpperCase(Copy(S,1,7))<>'HTTP:/'+'/' then S:='http:/'+'/'+S;
               ShellExecute(Handle,'open',PChar(S),nil,nil,SW_SHOW);
             end;
      4010 : If (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
               TGame(ListView.Selected.Data).Favorite:=not TGame(ListView.Selected.Data).Favorite;
               TreeViewChange(Sender,TreeView.Selected);
             end;
      4011 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               If WineSupportEnabled and PrgSetup.LinuxLinkMode then begin
                 CreateLinuxShortCut(self,TGame(ListView.Selected.Data));
               end else begin
                 ShowCreateShortcutDialog(self,TGame(ListView.Selected.Data).Name,TGame(ListView.Selected.Data).SetupFile,TGame(ListView.Selected.Data).Icon,ScummVMMode(TGame(ListView.Selected.Data)));
               end;
             end;
      4012 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               BuildInstallerForSingleGame(self,TGame(ListView.Selected.Data));
             end;
      4013 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
                 MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
               end;
               G:=TGame(ListView.Selected.Data);
               If ScummVMMode(G) then begin
                 S:=TempDir+ChangeFileExt(ExtractFileName(G.SetupFile),'.ini');
                 T:='ScummVM';
                 St:=BuildScummVMIniFile(G);
               end else begin
                 S:=TempDir+ChangeFileExt(ExtractFileName(G.SetupFile),'.conf');
                 T:='DOSBox';
                 St:=BuildConfFile(G,False,False);
               end;
                 try
                   St.Insert(0,'# This '+T+' configuration file was automatically created by D-Fend Reloaded.');
                   St.Insert(1,'# Changes made to this file will NOT be transfered to D-Rend Reloaded profiles list.');
                   St.Insert(2,'# D-Fend Reloaded will delete this file from temp directory on program close.');
                   St.Insert(3,'');
                   St.Insert(4,'# Config file for profile "'+G.Name+'"');
                   St.Insert(5,'');
                   St.SaveToFile(S);
                 finally
                   St.Free;
                 end;
               ShellExecute(Handle,'open','notepad.exe',PChar(S),nil,SW_SHOW);
               If DeleteOnExit.IndexOf(S)<0 then DeleteOnExit.Add(S);
             end;
      4014 : begin
               G:=nil;
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 DefaultGame.ProfileMode:='ScummVM';
                 if not ModernEditGameProfil(self,GameDB,G,DefaultGame) then exit;
               finally
                 DefaultGame.ProfileMode:='DOSBox';
                 DefaultGame.Free;
               end;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      {Extras}
      5001 : begin S:=''; ShowIconManager(self,S,PrgSetup.GameDir,True); end;
      5002 : ShowHistoryDialog(self);
      5003 : begin
               If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
               ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW);
             end;
      5005 : begin
               G:=ShowTemplateDialog(self,GameDB);
               UpdateAddFromTemplateMenu;
               if G=nil then exit;
               ListView.Items.Clear;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      5006 : begin
               ListView.Selected:=nil;
               ListView.Items.Clear;
               UninstallMultipleGames(self,GameDB);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             end;
      5007 : ShowCreateImageFileDialog(self,True,True);
      5008 : TransferGames(self,GameDB);
      5009 : BuildInstaller(self,GameDB);
      5010 : begin
               If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then G:=nil else G:=TGame(ListView.Selected.Data);
               If not ShowChangeProfilesDialog(self,GameDB) then exit;
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
               SelectGame(G);
             end;
      5011 : ShowCreateISOImageDialog(self,False);
      5012 : ShowCreateISOImageDialog(self,True);
      5013 : ShowWriteIMGImageDialog(self);
      5014 : ShowExpandImageDialog(self);
      5015 : ShowBuildImageFromFolderDialog(self);
      5016 : begin
               St:=CheckGameDB(GameDB);
               try
                 If St.Count=0 then begin
                   MessageDlg('There are no missing files. All files and directories for all profiles are available.',mtInformation,[mbOK],0);
                 end else begin
                   ShowInfoTextDialog(self,'Missing files',St);
                 end;
               finally
                 St.Free;
               end;
             end;
      {Help}
      6001 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/wiki/'),nil,nil,SW_SHOW);
      6002 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/wiki/Special_Keys'),nil,nil,SW_SHOW);
      6003 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName) then begin
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 RunCommand(DefaultGame,'intro special',True);
               finally
                 DefaultGame.Free;
               end;
             end else begin
               MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
             end;
      6004 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/comp_list.php?letter=a'),nil,nil,SW_SHOW);
      6005 : ShellExecute(Handle,'open',PChar('http:/'+'/pain.scene.org/service_dosbox.php'),nil,nil,SW_SHOW);
      6006 : ShellExecute(Handle,'open',PChar('http:/'+'/dosbox.sourceforge.net/oldwiki/index.php?page=CommandLine'),nil,nil,SW_SHOW);
      6007 : If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName) then begin
               DefaultGame:=TGame.Create(PrgSetup);
               try
                 RunCommand(DefaultGame,'intro',True);
               finally
                 DefaultGame.Free;
               end;
             end else begin
               MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName]),mtError,[mbOK],0);
             end;
      6008 : ShellExecute(Handle,'open',PChar(LanguageSetup.MenuHelpHomepageURL),nil,nil,SW_SHOW);
      6009 : ShellExecute(Handle,'open',PChar('http:/'+'/vogons.zetafleet.com/viewtopic.php?t=17415'),nil,nil,SW_SHOW);
      6010 : If FileExists(PrgDir+'UpdateCheck.exe')
               then RunUpdateCheck(False)
               else ShellExecute(Handle,'open',PChar(LanguageSetup.MenuHelpUpdatesURL),nil,nil,SW_SHOW);
      6011 : If FileExists(PrgDir+'FAQs.txt')
               then ShellExecute(Handle,'open',PChar(PrgDir+'FAQs.txt'),nil,nil,SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[PrgDir+'FAQs.txt']),mtError,[mbOK],0);
      6012 : If FileExists(PrgDataDir+'Icons.ini')
               then ShellExecute(Handle,'open',PChar(PrgDataDir+'Icons.ini'),nil,nil,SW_SHOW)
               else MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[PrgDataDir+'Icons.ini']),mtError,[mbOK],0);
      6013 : begin
               if not ShowLanguageEditorStartDialog(self,S) then exit;
               ShowLanguageEditorDialog(self,S);
               If Trim(ExtUpperCase(S))=Trim(ExtUpperCase(LanguageSetup.SetupFile)) then begin
                 LanguageSetup.ReloadINI;
                 LoadLanguage(PrgSetup.Language);
                 LoadMenuLanguage;
                 If SearchEdit.Font.Color=clGray then begin
                   SearchEdit.OnChange:=nil;
                   SearchEdit.Text:=LanguageSetup.Search;
                   SearchEdit.OnChange:=SearchEditChange;
                 end;
                 LoadGUISetup(False);
               end;
             end;
      6014 : ShowStatisticsDialog(self,GameDB);
      6015 : ShowInfoDialog(self);
      6016 : ShellExecute(Handle,'open',PChar('http:/'+'/www.dosbox.com/'),nil,nil,SW_SHOW);
      6017 : If (Trim(PrgSetup.ScummVMPath)<>'') and FileExists(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+'Readme.txt')
               then ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+'Readme.txt'),nil,nil,SW_SHOW)
               else ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/documentation.php'),nil,nil,SW_SHOW);
      6018 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/faq.php'),nil,nil,SW_SHOW);
      6019 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/'),nil,nil,SW_SHOW);
      6020 : ShellExecute(Handle,'open',PChar('http:/'+'/www.scummvm.org/compatibility.php'),nil,nil,SW_SHOW);
      6021 : ShowListScummVMGamesDialog(self);
      6022 : ShowOperationModeInfoDialog(self);
      6101 : ShellExecute(Handle,'open',PChar(PrgSetup.DosBoxDir+RemoveUnderline((Sender as TMenuItem).Caption)),nil,nil,SW_SHOW);
      6102 : begin
               If not OldGamesMenuUsed then begin
                 MessageDlg(LanguageSetup.MenuHelpAbandonwareInfo,mtInformation,[mbOK],0);
                 OldGamesMenuUsed:=True;
               end;
               ShellExecute(Handle,'open',PChar((Sender as TMenuItem).Hint),nil,nil,SW_SHOW);
             end;
    end;
  finally
    StartCaptureChangeNotify;
  end;
end;

procedure TDFendReloadedMainForm.TrayIconPopupClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : TrayIconDblClick(Sender);
    1 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAdd); end;
    2 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAddScummVM); end;
    3 : begin TrayIconDblClick(Sender); MenuWork(MenuProfileAddWithWizard); end;
    4 : Close;
    5 : ShowMiniRunDialog(self,GameDB);
  end;
end;

Procedure TDFendReloadedMainForm.RunUpdateCheck(const Quite : Boolean);
Var St : TStringList;
    FileName,Add : String;
begin
  FileName:=TempDir+'UpdateCheckSetup.txt';

  St:=TStringList.Create;
  try
    St.Add(GetNormalFileVersionAsString);
    If PrgSetup.VersionSpecificUpdateCheck then Add:='?Version='+GetNormalFileVersionAsString else Add:='';
    St.Add(PrgSetup.UpdateCheckURL+Add);
    St.Add('DFendReloadedUpdate.exe');
    St.Add(PrgDir);
    If Quite then St.Add('silent') else St.Add('normal');
    St.Add(LanguageSetup.UpdateCannotFindFile);
    St.Add(LanguageSetup.UpdateDownloadFailed);
    St.Add(LanguageSetup.UpdateURL);
    St.Add(LanguageSetup.UpdateDownloading);
    St.Add(LanguageSetup.UpdateConnecting);
    St.Add(LanguageSetup.UpdateFileName);
    St.Add(LanguageSetup.UpdateTransfered);
    St.Add(LanguageSetup.UpdateFileSize);
    St.Add(LanguageSetup.UpdateRamainingTime);
    St.Add(LanguageSetup.UpdateTotalTime);
    St.Add(LanguageSetup.UpdateCannotReadFile);
    St.Add(LanguageSetup.UpdateNoUpdates);
    St.Add(LanguageSetup.UpdateNewVersionPart1);
    St.Add(LanguageSetup.UpdateNewVersionPart2);
    St.Add(LanguageSetup.OK);
    St.Add(LanguageSetup.Yes);
    St.Add(LanguageSetup.No);

    St.SaveToFile(FileName);
  finally
    St.Free;
  end;

  ShellExecute(Handle,'open',PChar(PrgDir+'UpdateCheck.exe'),PChar(FileName),PChar(PrgDir),SW_SHOW);

  If DeleteOnExit.IndexOf(FileName)<0 then DeleteOnExit.Add(FileName);

  PrgSetup.LastUpdateCheck:=Round(Date);
end;

Procedure TDFendReloadedMainForm.AddFromTemplateClick(Sender: TObject);
Var TemplateDB : TGameDB;
    G : TGame;
begin
  If (Sender as TMenuItem).Parent=TrayIconPopupAddFromTemplate then TrayIconDblClick(Sender);

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    G:=nil;
    If PrgSetup.DFendStyleProfileEditor then begin
      if not EditGameProfil(self,GameDB,G,TemplateDB[(Sender as TComponent).Tag]) then exit;
    end else begin
      if not ModernEditGameProfil(self,GameDB,G,TemplateDB[(Sender as TComponent).Tag]) then exit;
    end;
    InitTreeViewForGamesList(TreeView,GameDB);
    TreeViewChange(Sender,TreeView.Selected);
    SelectGame(G);
  finally
    TemplateDB.Free;
  end;
end;

procedure TDFendReloadedMainForm.ScreenshotListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
begin
  B:=(Item<>nil);

  ScreenshotPopupOpen.Enabled:=B;
  ScreenshotPopupCopy.Enabled:=B;
  ScreenshotPopupSave.Enabled:=B;
  ScreenshotPopupRename.Enabled:=B;
  ScreenshotPopupDelete.Enabled:=B;
  ScreenshotPopupDeleteAll.Enabled:=B;
  ScreenshotPopupUseAsBackground.Enabled:=B;
end;

procedure TDFendReloadedMainForm.SoundListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
    S : String;
    I : Integer;
begin
  B:=(Item<>nil);

  If B then S:=ExtUpperCase(ExtractFileExt(Item.Caption)) else S:='';

  SoundPopupOpen.Enabled:=B;
  SoundPopupSave.Enabled:=B;
  SoundPopupSaveMp3.Enabled:=B and (S='.WAV') and FileExists(PrgSetup.WaveEncMp3);
  SoundPopupSaveOgg.Enabled:=B and (S='.WAV') and FileExists(PrgSetup.WaveEncOgg);
  SoundPopupDelete.Enabled:=B;
  SoundPopupDeleteAll.Enabled:=B;

  B:=False;
  For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin B:=True; break; end;
  SoundPopupSaveMp3All.Enabled:=B and FileExists(PrgSetup.WaveEncMp3);
  SoundPopupSaveOggAll.Enabled:=B and FileExists(PrgSetup.WaveEncOgg);
end;

procedure TDFendReloadedMainForm.ScreenshotListViewDblClick(Sender: TObject);
begin
  ScreenshotMenuWork(ScreenshotPopupOpen);
end;

procedure TDFendReloadedMainForm.SoundListViewDblClick(Sender: TObject);
begin
  SoundMenuWork(SoundPopupOpen);
end;

procedure TDFendReloadedMainForm.ScreenshotListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin ScreenshotMenuWork(ScreenshotPopupDeleteAll); exit; end;
  If (Shift=[ssCtrl]) and (Key=ord('C')) then begin ScreenshotMenuWork(ScreenshotPopupCopy); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : ScreenshotMenuWork(ScreenshotPopupOpen);
    VK_INSERT : ScreenshotMenuWork(ScreenshotPopupImport);
    VK_F5 : ScreenshotMenuWork(ScreenshotPopupRefresh);
    VK_DELETE : ScreenshotMenuWork(ScreenshotPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.SoundListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin SoundMenuWork(SoundPopupDeleteAll); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : SoundMenuWork(SoundPopupOpen);
    VK_INSERT : SoundMenuWork(SoundPopupImport);
    VK_F5 : SoundMenuWork(SoundPopupRefresh);
    VK_DELETE : SoundMenuWork(SoundPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.ScreenshotMenuWork(Sender: TObject);
Var S,T : String;
    I : Integer;
    P : TPicture;
    G : TGame;
    WPStype : TWallpaperStyle;
    St1, St2 : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          St1:=TStringList.Create;
          St2:=TStringList.Create;
          try
            For I:=0 to ScreenshotListView.Items.Count-1 do begin
              If I<ScreenshotListView.Selected.Index then St1.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
              If I>ScreenshotListView.Selected.Index then St2.Add(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption);
            end;
            ShowImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,St1,St2);
          finally
            St1.Free;
            St2.Free;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    1 : ListViewSelectItem(Sender,ListView.Selected,True);
    2 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          P:=LoadImageFromFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption);
          try
            Clipboard.Assign(P);
          finally
            P.Free;
          end;
        end;
    3 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          P:=LoadImageFromFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption);
          try
            ScreenshotSaveDialog.Title:=LanguageSetup.ViewImageFormSaveTitle;
            ScreenshotSaveDialog.Filter:=LanguageSetup.ViewImageFormSaveFilter;
            if not ScreenshotSaveDialog.Execute then exit;
            S:=Trim(ExtUpperCase(ExtractFileExt(ScreenshotSaveDialog.FileName)));
            SaveImageToFile(P,ScreenshotSaveDialog.FileName);
          finally
            P.Free;
          end;
        end;
    4 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          if not DeleteFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption) then
            Messagedlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    5 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to ScreenshotListView.Items.Count-1 do if not DeleteFile(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+ScreenshotListView.Items[I].Caption]),mtError,[mbOK],0);
            break;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    6 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          OpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
          OpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
          If not OpenDialog.Execute then exit;
          S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OpenDialog.FileName);
          if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
            exit;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    7 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          If not ShowWallpaperStyleDialog(self,WPStype) then exit;
          SetDesktopWallpaper(IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption,WPStype);
        end;
    8 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
            S:=IncludeTrailingPathDelimiter(S);
          T:=ChangeFileExt(ScreenshotListView.Selected.Caption,'');
          If not InputQuery(LanguageSetup.ScreenshotPopupRenameCaption,LanguageSetup.ScreenshotPopupRenameLabel,T) then exit;
          T:=T+ExtractFileExt(ScreenshotListView.Selected.Caption);
          If not RenameFile(S+ScreenshotListView.Selected.Caption,S+T) then
            MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[S+SoundListView.Selected.Caption,S+T]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
  end;
end;

procedure TDFendReloadedMainForm.SoundMenuWork(Sender: TObject);
Var S,T : String;
    G : TGame;
    I : Integer;
    SaveDialog : TSaveDialog;
begin
  Case (Sender as TComponent).Tag of
    0 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          PlaySoundDialog(self,IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    1 : ListViewSelectItem(Sender,ListView.Selected,True);
    3 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            T:=ExtractFileExt(S);
            If (T<>'') and (T[1]='.') then T:=Copy(T,2,MaxInt);
            SaveDialog.DefaultExt:=T;
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            T:=Trim(ExtUpperCase(T));
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveWAVFilter;
            If T='MP3' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
            If T='OGG' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            If not CopyFile(PChar(S),PChar(T),True) then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0);
          finally
            SaveDialog.Free;
          end;
        end;
    4 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            SaveDialog.DefaultExt:='mp3';
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(Format(PrgSetup.WaveEncMp3Parameters,[S,T])),nil,SW_SHOW);
          finally
            SaveDialog.Free;
          end;
        end;
    5 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption;
          SaveDialog:=TSaveDialog.Create(self);
          try
            SaveDialog.DefaultExt:='ogg';
            SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
            SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
            If not SaveDialog.Execute then exit;
            T:=SaveDialog.FileName;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(Format(PrgSetup.WaveEncOggParameters,[S,T])),nil,SW_SHOW);
          finally
            SaveDialog.Free;
          end;
        end;
    6 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          if not DeleteFile(IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption) then
            Messagedlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+SoundListView.Selected.Caption]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    7 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to SoundListView.Items.Count-1 do if not DeleteFile(IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[IncludeTrailingPathDelimiter(S)+SoundListView.Items[I].Caption]),mtError,[mbOK],0);
            break;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    8 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          OpenDialog.Title:=LanguageSetup.SoundCaptureImportTitle;
          OpenDialog.Filter:=LanguageSetup.SoundCaptureImportFilter;
          If not OpenDialog.Execute then exit;
          S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OpenDialog.FileName);
          if not CopyFile(PChar(OpenDialog.FileName),PChar(S),True) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,S]),mtError,[mbOK],0);
            exit;
          end;
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
    9 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin
            T:=SoundListView.Items[I].Caption;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(Format(PrgSetup.WaveEncMp3Parameters,[S+T,S+ChangeFileExt(T,'.mp3')])),nil,SW_SHOW);
          end;
        end;
   10 : begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          For I:=0 to SoundListView.Items.Count-1 do If ExtUpperCase(ExtractFileExt(SoundListView.Items[I].Caption))='.WAV' then begin
            T:=SoundListView.Items[I].Caption;
            ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(Format(PrgSetup.WaveEncOggParameters,[S+T,S+ChangeFileExt(T,'.ogg')])),nil,SW_SHOW);
          end;
        end;
   11 : If SoundListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          S:=IncludeTrailingPathDelimiter(S);
          T:=ChangeFileExt(SoundListView.Selected.Caption,'');
          If not InputQuery(LanguageSetup.ScreenshotPopupRenameCaption,LanguageSetup.ScreenshotPopupRenameLabel,T) then exit;
          T:=T+ExtractFileExt(SoundListView.Selected.Caption);
          If not RenameFile(S+SoundListView.Selected.Caption,S+T) then
            MessageDlg(Format(LanguageSetup.MessageCouldNotRenameFile,[S+SoundListView.Selected.Caption,S+T]),mtError,[mbOK],0);
          ListViewSelectItem(Sender,ListView.Selected,True);
        end;
  end;
end;

procedure TDFendReloadedMainForm.TreeViewPopupEditUserFiltersClick(Sender: TObject);
begin
  if ShowTreeListSetupDialog(self,GameDB) then begin
     LoadLanguage(PrgSetup.Language);
     LoadMenuLanguage;
     If SearchEdit.Font.Color=clGray then begin
       SearchEdit.OnChange:=nil;
       SearchEdit.Text:=LanguageSetup.Search;
       SearchEdit.OnChange:=SearchEditChange;
     end;
     LoadGUISetup(False);
   end;
end;

procedure TDFendReloadedMainForm.IdleAddonTimerTimer(Sender: TObject);
Var Done : Boolean;
begin
  Done:=False;
  ApplicationEventsIdle(Sender,Done);
end;

var DOSBoxRunning : Boolean;

Function EnumWindowsFunc(const hWindow : THandle; const lParam : Integer) : Boolean; StdCall;
Var S : String;
begin
  result:=True;

  SetLength(S,255);
  If GetWindowText(hWindow,PChar(S),250)=0 then exit;
  SetLength(S,StrLen(PChar(S)));
  If Copy(Trim(ExtUpperCase(S)),1,6)<>'DOSBOX' then exit;
  If Copy(S,1,10)='DOSBox DOS' then exit;

  DOSBoxRunning:=True;
  result:=False;
end;

procedure TDFendReloadedMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  If PrgSetup.MinimizeOnDosBoxStart and PrgSetup.RestoreWhenDOSBoxCloses and (WindowState=wsMinimized) and MinimizedAtDOSBoxStaert then begin
    DOSBoxRunning:=False;
    EnumWindows(@EnumWindowsFunc,0);
    if DOSBoxRunning then exit;
    MinimizedAtDOSBoxStaert:=False;
    If PrgSetup.MinimizeToTray then begin
      TrayIconDblClick(Sender);
      Application.ProcessMessages;
      ApplicationEventsRestore(Sender);
      ShowWindow(Application.Handle,SW_RESTORE);
    end else begin
      Application.Restore;
    end;
  end;

  If FileConflictCheckRunning then exit;
  FileConflictCheckRunning:=True;
  try
    If (hScreenshotsChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hScreenshotsChangeNotification,0)=WAIT_OBJECT_0) then begin
      UpdateScreenshotList;
      FindNextChangeNotification(hScreenshotsChangeNotification);
    end;

    If (hConfsChangeNotification<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(hConfsChangeNotification,0)=WAIT_OBJECT_0) then begin
      ConfFileCheck;
      FindNextChangeNotification(hConfsChangeNotification);
    end;
  finally
    FileConflictCheckRunning:=False;
  end;
end;

procedure TDFendReloadedMainForm.FormResize(Sender: TObject);
begin
  If WindowState=wsMinimized then exit;

  SaveBoundsRect:=BoundsRect;
  SaveMaximizedState:=(WindowState=wsMaximized);
end;

procedure TDFendReloadedMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  If PrgSetup.MinimizeToTray then begin
    TrayIcon.Visible:=True;
    Visible:=False;
    ShowWindow(Application.Handle,SW_HIDE);
  end;

  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
end;

procedure TDFendReloadedMainForm.ApplicationEventsRestore(Sender: TObject);
begin
  ShowWindow(Application.Handle,SW_SHOW);
  Visible:=True;
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOREPOSITION or SWP_NOSIZE or SWP_SHOWWINDOW);
  SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOREPOSITION or SWP_NOSIZE or SWP_SHOWWINDOW);
  TrayIcon.Visible:=False;
  if not SaveMaximizedState then BoundsRect:=SaveBoundsRect;
end;

procedure TDFendReloadedMainForm.TrayIconDblClick(Sender: TObject);
begin
  Application.Restore;
  If StartTrayMinimize then begin
    StartTrayMinimize:=False;
    Application.ProcessMessages;
    ApplicationEventsRestore(Sender);
    ShowWindow(Application.Handle,SW_RESTORE);
    WindowState:=wsNormal;
  end;
end;

Procedure TDFendReloadedMainForm.ConfFileCheck;
Var I : Integer;
    St,St2 : TStringList;
    G,Game : TGame;
    Rec : TSearchRec;
    NeedListUpdate : Boolean;
begin
  St:=TStringList.Create;
  St2:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do Case GameDB[I].CheckAndUpdateTimeStamp of
      fcsChanged : St.AddObject(GameDB[I].CacheName,GameDB[I]);
      fcsDeleted : St2.AddObject(GameDB[I].CacheName,GameDB[I]);
    end;
    If (St.Count>0) or (St2.Count>0) then begin
      G:=nil; if ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);
      If St2.Count>0 then ListView.Items.Clear;
      If St.Count>0 then ShowCacheChooseDialog(self,St,GameDB);
      If St2.Count>0 then ShowRestoreDeletedDialog(self,St2,GameDB);
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
    end;
  finally
    St.Free;
    St2.Free;
  end;

  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do St.Add(Trim(ExtUpperCase(ExtractFileName(GameDB[I].SetupFile))));
    NeedListUpdate:=False;
    G:=nil; if ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);
    I:=FindFirst(PrgDataDir+GameListSubDir+'\*.prof',faAnyFile,Rec);
    try
      while I=0 do begin
        If St.IndexOf(Trim(ExtUpperCase(Rec.Name)))<0 then begin
          Game:=TGame.Create(PrgDataDir+GameListSubDir+'\'+Rec.Name);
          GameDB.Add(Game);
          NeedListUpdate:=True;
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
    If NeedListUpdate then begin
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(self,TreeView.Selected);
      SelectGame(G);
    end;
  finally
    St.Free;
  end;
end;

Procedure TDFendReloadedMainForm.DropImportFile(const FileName: String; var ErrorCode : String);
Var FileExt : String;
    G : TGame;
    S : String;
begin
  ErrorCode:='';

  FileExt:=Trim(ExtUpperCase(ExtractFileExt(FileName)));
  G:=nil; If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data);

  If FileExt='.CONF' then begin
    G:=ImportConfFile(GameDB,FileName);
    If G=nil then exit;
    InitTreeViewForGamesList(TreeView,GameDB);
    TreeViewChange(nil,TreeView.Selected);
    SelectGame(G);
    exit;
  end;

  If FileExt='.PROF' then begin
    S:=GameDB.ProfFileName(ExtractFileName(FileName));
    if not CopyFile(PChar(FileName),PChar(S),True) then begin
      ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
      exit;
    end;
    G:=TGame.Create(S);
    GameDB.Add(G);
    InitTreeViewForGamesList(TreeView,GameDB);
    TreeViewChange(nil,TreeView.Selected);
    SelectGame(G);
    exit;
  end;

  If (FileExt='.JPG') or (FileExt='.JPEG') or (FileExt='.PNG') or (FileExt='.GIF') or (FileExt='.BMP') then begin
    If (G<>nil) and (not ScummVMMode(G)) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S='' then exit;
      S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(FileName);
      if not CopyFile(PChar(FileName),PChar(S),True) then
        ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
    end else begin
      ErrorCode:=Format(LanguageSetup.DragDropErrorNoProfileSelectedForScreenshots,[ExtractFileName(FileName)]);
    end;
    exit;
  end;

  If (FileExt='.WAV') or (FileExt='.MP3') or (FileExt='.OGG') then begin
    If (G<>nil) and (not ScummVMMode(G)) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S='' then exit;
      S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(FileName);
      if not CopyFile(PChar(FileName),PChar(S),True) then ErrorCode:=Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]);
    end else begin
      ErrorCode:=Format(LanguageSetup.DragDropErrorNoProfileSelectedForSoundFiles,[ExtractFileName(FileName)]);
    end;
    exit;
  end;

  If (FileExt='.EXE') or (FileExt='.COM') or (FileExt='.BAT') or (FileExt='.BAS') then begin
    StartWizard(FileName);
    exit;
  end;

  ErrorCode:=Format(LanguageSetup.DragDropErrorUnknownExtension,[ExtractFileName(FileName)]);
end;

procedure TDFendReloadedMainForm.WMDropFiles(var Message: TWMDROPFILES);
var FileCount : longint;
    S,T : String;
    I : Integer;
    Errors : TStringList;
begin
 FileCount:=DragQueryFile(Message.Drop,$FFFFFFFF,nil,0);
 Errors:=TStringList.Create;
 try
   For I:=0 to FileCount-1 do begin
     SetLength(S,520);
     DragQueryFile(Message.Drop,I,PChar(S),512);
     SetLength(S,StrLen(PChar(S)));
     T:=''; DropImportFile(S,T);
     If T<>'' then Errors.Add(T);
   end;
   If Errors.Count>0 then begin
     ShowDragNDropErrorDialog(self,Errors);
   end;
 finally
   Errors.Free;
 end;
end;

end.
