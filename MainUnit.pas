unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, ComCtrls, ExtCtrls, ToolWin, ImgList, Menus,
  AppEvnts, GameDBUnit, GameDBToolsUnit;

{
0.3:
- User defined info columns
- Alternative profile dialog
- Testing: IPX and serial port
- GUP

0.4:
- Game library for autocreate profiles
- wav->mp3
- Ziped profiles
- XML-Support
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
    ToolBar1: TToolBar;
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
    N1: TMenuItem;
    MenuExtrasEditDefaultProfile: TMenuItem;
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
    ScreenshotListView: TListView;
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
    N9: TMenuItem;
    MenuExtrasDeinstallMultipleGames: TMenuItem;
    MenuFileImport: TMenuItem;
    MenuFileExport: TMenuItem;
    N10: TMenuItem;
    MenuFileCreateConf: TMenuItem;
    MenuFileImportConfFile: TMenuItem;
    OpenConfDialog: TOpenDialog;
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
    N15: TMenuItem;
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
  private
    { Private-Deklarationen }
    hChangeNotification : THandle;
    JustStarted : Boolean;
    ListSort : TSortListBy;
    ListSortReverse : Boolean;
    Procedure StartCaptureChangeNotify;
    Procedure StopCaptureChangeNotify;
    Procedure LoadMenuLanguage;
    Procedure InitGUI;
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
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  DFendReloadedMainForm: TDFendReloadedMainForm;

implementation

uses ShellAPI, ClipBrd, Math, PNGImage, CommonTools, LanguageSetupUnit,
     PrgConsts, VistaToolsUnit, PrgSetupUnit, SetupDosBoxFormUnit,
     ProfileEditorFormUnit, SetupFormUnit, IconManagerFormUnit, DosBoxUnit,
     HistoryFormUnit, TemplateFormUnit, UninstallFormUnit, ViewImageFormUnit,
     UninstallSelectFormUnit, CreateConfFormUnit, WizardFormUnit,
     CreateShortcutFormUnit, CreateImageUnit, InfoFormUnit, TransferFormUnit,
     BuildInstallerFormUnit, ResHookUnit, ChangeProfilesFormUnit,
     BuildInstallerForSingleGameFormUnit;

{$R *.dfm}

procedure TDFendReloadedMainForm.FormCreate(Sender: TObject);
begin
  JustStarted:=True;

  ListSort:=slbName;
  ListSortReverse:=False;

  try ForceDirectories(PrgDataDir+CaptureSubDir); except end;
  StartCaptureChangeNotify;

  GameDB:=TGameDB.Create(PrgDataDir+GameListSubDir);
  
  LoadMenuLanguage;
  InitGUI;
  UpdateAddFromTemplateMenu;
end;

procedure TDFendReloadedMainForm.FormShow(Sender: TObject);
Var G : TGame;
begin
  If not JustStarted then exit;
  JustStarted:=False;

  SearchDosBox(self);
  LoadHelpLinks;
  if not TreeView.Visible then TreeViewChange(Sender,TreeView.Selected);
  ProcessParams;

  If PrgSetup.FirstRun then begin
    ShowSetupDialog(self,GameDB,True);
    BuildDefaultProfile;
    G:=BuildDefaultDosProfile(GameDB);
    LoadLanguage(PrgSetup.Language);
    LoadMenuLanguage;
    ListView.Items.BeginUpdate;
    try
      ListView.Items.Clear;
      InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
      InitTreeViewForGamesList(TreeView,GameDB);
      TreeViewChange(Sender,TreeView.Selected);
      SelectGame(G);
    finally
      ListView.Items.EndUpdate;
    end;
  end;

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TDFendReloadedMainForm.FormDestroy(Sender: TObject);
begin
  StopCaptureChangeNotify;
  PrgSetup.MainMaximized:=(WindowState=wsMaximized);
  PrgSetup.MainLeft:=Left;
  PrgSetup.MainTop:=Top;
  PrgSetup.MainWidth:=Width;
  PrgSetup.MainHeight:=Height;
  PrgSetup.TreeWidth:=TreeView.Width;
  PrgSetup.ScreenshotHeight:=ScreenshotListView.Height;

  GameDB.Free;
end;

procedure TDFendReloadedMainForm.LoadMenuLanguage;
begin
  MenuFile.Caption:=LanguageSetup.MenuFile;
  MenuFileImport.Caption:=LanguageSetup.MenuFileImport;
  MenuFileImportConfFile.Caption:=LanguageSetup.MenuFileImportConf;
  MenuFileExport.Caption:=LanguageSetup.MenuFileExport;
  MenuFileExportGamesList.Caption:=LanguageSetup.MenuFileExportGamesList;
  MenuFileCreateConf.Caption:=LanguageSetup.MenuFileCreateConf;
  MenuFileSetup.Caption:=LanguageSetup.MenuFileSetup;
  MenuFileQuit.Caption:=LanguageSetup.MenuFileQuit;
  MenuView.Caption:=LanguageSetup.MenuView;
  MenuViewsShowTree.Caption:=LanguageSetup.MenuViewShowTree;
  MenuViewsShowScreenshots.Caption:=LanguageSetup.MenuViewShowScreenshots;
  MenuViewsShowSearchBox.Caption:=LanguageSetup.MenuViewShowSearchBox;
  MenuViewsShowExtraInfo.Caption:=LanguageSetup.MenuViewShowExtraInfo;
  MenuViewsList.Caption:=LanguageSetup.MenuViewReport;
  MenuViewsIcons.Caption:=LanguageSetup.MenuViewSmallIcons;
  MenuRun.Caption:=LanguageSetup.MenuRun;
  MenuRunGame.Caption:=LanguageSetup.MenuRunGame;
  MenuRunSetup.Caption:=LanguageSetup.MenuRunSetup;
  MenuRunRunDosBox.Caption:=LanguageSetup.MenuRunRunDosBox;
  MenuRunRunDosBoxKeyMapper.Caption:=LanguageSetup.MenuRunRunDosBoxKeyMapper;
  MenuRunOpenDosBoxConfig.Caption:=LanguageSetup.MenuRunOpenDosBoxConfig;
  MenuProfile.Caption:=LanguageSetup.MenuProfile;
  MenuProfileAdd.Caption:=LanguageSetup.MenuProfileAdd;
  MenuProfileAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  MenuProfileAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;
  MenuProfileEdit.Caption:=LanguageSetup.MenuProfileEdit;
  MenuProfileCopy.Caption:=LanguageSetup.MenuProfileCopy;
  MenuProfileDelete.Caption:=LanguageSetup.MenuProfileDelete;
  MenuProfileDeinstall.Caption:=LanguageSetup.MenuProfileDeinstall;
  MenuProfileMakeInstaller.Caption:=LanguageSetup.MenuProfileMakeInstaller;
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
  MenuExtrasEditDefaultProfile.Caption:=LanguageSetup.MenuExtrasEditDefaultProfile;
  MenuExtrasTemplates.Caption:=LanguageSetup.MenuExtrasTemplates;
  MenuExtrasDeinstallMultipleGames.Caption:=LanguageSetup.MenuExtrasDeinstallMultipleGames;
  MenuExtrasCreateImage.Caption:=LanguageSetup.MenuExtrasCreateImageFile;
  MenuExtrasTransferProfiles.Caption:=LanguageSetup.MenuExtrasTransferProfiles;
  MenuExtrasBuildInstaller.Caption:=LanguageSetup.MenuExtrasBuildInstaller;
  MenuExtrasChangeProfiles.Caption:=LanguageSetup.MenuExtrasChangeProfiles;
  MenuHelp.Caption:=LanguageSetup.MenuHelp;
  MenuHelpDosBox.Caption:=LanguageSetup.MenuHelpDosBox;
  MenuHelpDosBoxFAQ.Caption:=LanguageSetup.MenuHelpDosBoxFAQ;
  MenuHelpDosBoxHotkeys.Caption:=LanguageSetup.MenuHelpDosBoxHotkeys;
  MenuHelpDosBoxHotkeysDosbox.Caption:=LanguageSetup.MenuHelpDosBoxHotkeysDosbox;
  MenuHelpDosBoxCompatibility.Caption:=LanguageSetup.MenuHelpDosBoxCompatibility;
  MenuHelpDemoCompatibility.Caption:=LanguageSetup.MenuHelpDemoCompatibility;
  MenuHelpDosBoxIntro.Caption:=LanguageSetup.MenuHelpDosBoxIntro;
  MenuHelpDosBoxIntroDosBox.Caption:=LanguageSetup.MenuHelpDosBoxIntroDosBox;
  MenuHelpDosBoxReadme.Caption:=LanguageSetup.MenuHelpDosBoxReadme;
  MenuHelpAbandonware.Caption:=LanguageSetup.MenuHelpAbandonware;
  MenuHelpUpdates.Caption:=LanguageSetup.MenuHelpUpdates;
  MenuHelpAbout.Caption:=LanguageSetup.MenuHelpAbout;

  AddButtonMenuAdd.Caption:=LanguageSetup.MenuProfileAdd;
  AddButtonMenuAddFromTemplate.Caption:=LanguageSetup.MenuProfileAddFromTemplate;
  AddButtonMenuAddWithWizard.Caption:=LanguageSetup.MenuProfileAddWithWizard;

  ButtonRun.Caption:=LanguageSetup.ButtonRun;
  ButtonAdd.Caption:=LanguageSetup.ButtonAdd;
  ButtonEdit.Caption:=LanguageSetup.ButtonEdit;
  ButtonDelete.Caption:=LanguageSetup.ButtonDelete;

  PopupRunGame.Caption:=LanguageSetup.PopupRunGame;
  PopupRunSetup.Caption:=LanguageSetup.PopupRunSetup;
  PopupEdit.Caption:=LanguageSetup.PopupEdit;
  PopupCopy.Caption:=LanguageSetup.PopupCopy;
  PopupDelete.Caption:=LanguageSetup.PopupDelete;
  PopupDeinstall.Caption:=LanguageSetup.PopupDeinstall;
  PopupMakeInstaller.Caption:=LanguageSetup.PopupMakeInstaller;
  PopupOpenFolder.Caption:=LanguageSetup.PopupOpenFolder;
  PopupOpenDataFolder.Caption:=LanguageSetup.PopupOpenDataFolder;
  PopupOpenFileInDataFolder.Caption:=LanguageSetup.PopupOpenFileInDataFolder;
  PopupWWW.Caption:=LanguageSetup.GameWWW;
  PopupMarkAsFavorite.Caption:=LanguageSetup.PopupMarkAsFavorite;
  PopupCreateShortcut.Caption:=LanguageSetup.PopupCreateShortcut;

  ScreenshotPopupOpen.Caption:=LanguageSetup.ScreenshotPopupOpen;
  ScreenshotPopupRefresh.Caption:=LanguageSetup.ScreenshotPopupRefresh;
  ScreenshotPopupCopy.Caption:=LanguageSetup.ScreenshotPopupCopy;
  ScreenshotPopupSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  ScreenshotPopupDelete.Caption:=LanguageSetup.ScreenshotPopupDelete;
  ScreenshotPopupDeleteAll.Caption:=LanguageSetup.ScreenshotPopupDeleteAll;

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
  ListView.DoubleBuffered:=True;
  ScreenshotListView.DoubleBuffered:=True;
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

  If PrgSetup.RestoreWindowSize then begin
    If PrgSetup.MainMaximized then begin
      WindowState:=wsMaximized;
    end else begin
      If (PrgSetup.MainLeft>=0) and (PrgSetup.MainLeft<9*Screen.Width div 10) then Left:=PrgSetup.MainLeft;
      If (PrgSetup.MainTop>=0) and (PrgSetup.MainTop<9*Screen.Height div 10) then Top:=PrgSetup.MainTop;
      If (PrgSetup.MainWidth>=0) and (Left+PrgSetup.MainWidth<=Screen.Width) then Width:=PrgSetup.MainWidth;
      If (PrgSetup.MainHeight>=0) and (Top+PrgSetup.MainHeight<=Screen.Height) then Height:=PrgSetup.MainHeight;
    end;
    If (PrgSetup.TreeWidth>=0) and (PrgSetup.TreeWidth<9*ClientWidth div 10) then TreeView.Width:=PrgSetup.TreeWidth;
    If (PrgSetup.ScreenshotHeight>=0) and (PrgSetup.ScreenshotHeight<9*ClientHeight div 10) then ScreenshotListView.Width:=PrgSetup.ScreenshotHeight;
  end;

  ScreenshotListView.Visible:=PrgSetup.ShowScreenshots;
  MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;

  TreeView.Visible:=PrgSetup.ShowTree;
  MenuViewsShowTree.Checked:=PrgSetup.ShowTree;

  SearchEdit.Visible:=PrgSetup.ShowSearchBox;
  MenuViewsShowSearchBox.Checked:=PrgSetup.ShowSearchBox;

  MenuViewsShowExtraInfo.Checked:=PrgSetup.ShowExtraInfo;

  If Trim(ExtUpperCase(PrgSetup.ListViewStyle))='ICONS' then begin
    MenuViewsIcons.Checked:=True;
    ListView.ViewStyle:=vsIcon;
  end else begin
    MenuViewsList.Checked:=True;
    ListView.ViewStyle:=vsReport;
  end;

  ListView.ShowHint:=PrgSetup.ShowTooltips;
  MenuViewsShowTooltips.Checked:=PrgSetup.ShowTooltips;

  SearchEdit.OnChange:=nil;
  SearchEdit.Text:=LanguageSetup.Search;
  SearchEdit.Font.Color:=clGray;
  SearchEdit.OnChange:=SearchEditChange;
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
      MenuHelpDosBoxReadme.Add(M);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TDFendReloadedMainForm.PostShow(var Msg: TMessage);
begin
  If PrgSetup.StartMinimized then Application.Minimize;

  ListViewSelectItem(ListView,nil,false);

  {To fix misaligend ListView when stating maximized}
  UpdateBounds;
  Resize;
  Realign;
end;

procedure TDFendReloadedMainForm.ProcessParams;
Var I : Integer;
    S,T : String;
begin
  If ParamCount=0 then exit;

  S:=ParamStr(1);
  For I:=2 to ParamCount do S:=S+' '+ParamStr(I);
  T:=ExtUpperCase(S);

  For I:=0 to GameDB.Count-1 do If Trim(ExtUpperCase(GameDB[I].Name))=T then begin
    RunGame(GameDB[I]);
    PostMessage(Handle,WM_Close,0,0);
    exit;
  end;

  MessageDlg(Format(LanguageSetup.MessageCouldNotFindGame,[S]),mtError,[mbOK],0);
end;

procedure TDFendReloadedMainForm.StartCaptureChangeNotify;
begin
  hChangeNotification:=FindFirstChangeNotification(PChar(PrgDataDir+CaptureSubDir),True,FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or FILE_NOTIFY_CHANGE_LAST_WRITE or FILE_NOTIFY_CHANGE_SECURITY);
end;

procedure TDFendReloadedMainForm.StopCaptureChangeNotify;
begin
  If hChangeNotification<>INVALID_HANDLE_VALUE then FindCloseChangeNotification(hChangeNotification);
  hChangeNotification:=INVALID_HANDLE_VALUE;
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
end;

procedure TDFendReloadedMainForm.ListViewDblClick(Sender: TObject);
begin
  MenuWork(ButtonRun);
end;

procedure TDFendReloadedMainForm.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
Var G : TGame;
    St : TStringList;
    I : Integer;
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
  If G.Notes<>'' then begin
    St:=StringToStringList(G.Notes);
    If St.Count>0 then InfoTip:=InfoTip+#13;
    For I:=0 to Min(4,St.Count-1) do InfoTip:=InfoTip+#13+St[I];
  end;
  If Trim(G.DataDir)<>'' then InfoTip:=InfoTip+#13+#13+LanguageSetup.GameDataDirInfo;
end;

procedure TDFendReloadedMainForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
    S : String;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  MenuRunGame.Enabled:=B;
  MenuRunSetup.Enabled:=B and (Trim(TGame(Item.Data).SetupExe)<>'');
  MenuProfileEdit.Enabled:=B;
  MenuProfileCopy.Enabled:=B;
  MenuProfileDelete.Enabled:=B;
  MenuProfileDeinstall.Enabled:=B;
  MenuProfileMakeInstaller.Enabled:=B;
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
  PopupOpenFolder.Enabled:=B and (Trim(TGame(Item.Data).GameExe)<>'');
  PopupOpenDataFolder.Enabled:=B and (Trim(TGame(Item.Data).DataDir)<>'');
  PopupWWW.Enabled:=B and (Trim(TGame(Item.Data).WWW)<>'');
  PopupMarkAsFavorite.Enabled:=B;
  PopupCreateShortcut.Enabled:=B;

  ButtonRun.Enabled:=B;
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
    If ScreenshotListView.Enabled and (ListView.Selected<>nil) and (ListView.Selected.Data<>nil) then begin
      S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
      If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
      If S<>'' then AddScreenshotsToList(ScreenshotListView,ScreenshotImageList,S);
    end;
  finally
    ScreenshotListView.Items.EndUpdate;
  end;

  ScreenshotListViewSelectItem(self,ScreenshotListView.Selected,True);
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
    end;
  finally
    TemplateDB.Free;
  end;
end;

procedure TDFendReloadedMainForm.MenuWork(Sender: TObject);
Var G,DefaultGame : TGame;
    S : String;
    L : TList;
    I : Integer;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    {File}
    1001 : begin
             OpenConfDialog.Title:=LanguageSetup.MenuFileImportConfTitle;
             OpenConfDialog.Filter:=LanguageSetup.MenuFileImportConfFilter;
             If not OpenConfDialog.Execute then exit;
             G:=ImportConfFile(GameDB,OpenConfDialog.FileName);
             If G=nil then exit;
             InitTreeViewForGamesList(TreeView,GameDB);
             TreeViewChange(Sender,TreeView.Selected);
             SelectGame(G);
           end;
    1002 : begin
             SaveDialog.Title:=LanguageSetup.MenuFileExportGamesListDialog;
             SaveDialog.Filter:=LanguageSetup.MenuFileExportGamesListFilter;
             if not SaveDialog.Execute then exit;
             ExportGamesList(GameDB,SaveDialog.FileName);
           end;
    1003 : ExportConfFiles(self,GameDB);
    1004 : if ShowSetupDialog(self,GameDB) then begin
             LoadLanguage(PrgSetup.Language);
             LoadMenuLanguage;
             If SearchEdit.Font.Color=clGray then begin
               SearchEdit.OnChange:=nil;
               SearchEdit.Text:=LanguageSetup.Search;
               SearchEdit.OnChange:=SearchEditChange;
             end;
             ListView.Items.BeginUpdate;
             try
               ListView.Items.Clear;
               InitListViewForGamesList(ListView,PrgSetup.ShowExtraInfo);
               InitTreeViewForGamesList(TreeView,GameDB);
               TreeViewChange(Sender,TreeView.Selected);
             finally
               ListView.Items.EndUpdate;
             end;
           end;
    1005 : Close;
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
             ScreenshotListView.Visible:=PrgSetup.ShowScreenshots;
             MenuViewsShowScreenshots.Checked:=PrgSetup.ShowScreenshots;
             ListViewSelectItem(Sender,ListView.Selected,True);
           end;
    2003 : begin
             PrgSetup.ShowSearchBox:=not PrgSetup.ShowSearchBox;
             SearchEdit.Visible:=PrgSetup.ShowSearchBox;
             MenuViewsShowSearchBox.Visible:=PrgSetup.ShowSearchBox;
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
    2006 : begin
             MenuViewsList.Checked:=True;
             PrgSetup.ListViewStyle:='List';
             ListView.ViewStyle:=vsReport;
           end;
    2007 : begin
             MenuViewsIcons.Checked:=True;
             PrgSetup.ListViewStyle:='Icons';
             ListView.ViewStyle:=vsIcon;
           end;
    {Run}
    3001 : begin
             If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
               MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
             end;
             G:=TGame(ListView.Selected.Data);
             RunGame(G);
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
               if not EditGameProfil(self,GameDB,G,DefaultGame) then exit;
             finally
               DefaultGame.Free;
             end;
             InitTreeViewForGamesList(TreeView,GameDB);
             TreeViewChange(Sender,TreeView.Selected);
             SelectGame(G);
           end;
    4002 : begin
             G:=nil;
             DefaultGame:=TGame.Create(PrgSetup);
             try
               if not ShowWizardDialog(self,GameDB,G,DefaultGame) then exit;
             finally
               DefaultGame.Free;
             end;
             InitTreeViewForGamesList(TreeView,GameDB);
             TreeViewChange(Sender,TreeView.Selected);
             SelectGame(G);
           end;
    4003 : begin
             If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
               MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
             end;
             L:=TList.Create;
             try
               For I:=0 to ListView.Items.Count-1 do L.Add(ListView.Items[I].Data);
               G:=TGame(ListView.Selected.Data);
               if not EditGameProfil(self,GameDB,G,nil,L) then exit;
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
             StopCaptureChangeNotify;
             try UninstallGame(self,GameDB,G); finally StartCaptureChangeNotify; end;
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
             If ExtUpperCase(Copy(S,1,7))<>'HTTP://' then S:='http://'+S;
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
             ShowCreateShortcutDialog(self,TGame(ListView.Selected.Data).Name,TGame(ListView.Selected.Data).SetupFile);
           end;
    4012 : begin
             If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
               MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
             end;
             BuildInstallerForSingleGame(self,TGame(ListView.Selected.Data));
           end;
    {Extras}
    5001 : begin S:=''; ShowIconManager(self,S,True); end;
    5002 : ShowHistoryDialog(self);
    5003 : begin
             If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
             ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW);
           end;
    5004 : EditDefaultProfile(self,GameDB);
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
             StopCaptureChangeNotify;
             try UninstallMultipleGames(self,GameDB); finally StartCaptureChangeNotify; end;
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
    {Help}
    6001 : ShellExecute(Handle,'open',PChar('http://www.dosbox.com/wiki/'),nil,nil,SW_SHOW);
    6002 : ShellExecute(Handle,'open',PChar('http://www.dosbox.com/wiki/Special_Keys'),nil,nil,SW_SHOW);
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
    6004 : ShellExecute(Handle,'open',PChar('http://www.dosbox.com/comp_list.php?letter=a'),nil,nil,SW_SHOW);
    6005 : ShellExecute(Handle,'open',PChar('http://pain.scene.org/service_dosbox.php'),nil,nil,SW_SHOW);
    6006 : ShellExecute(Handle,'open',PChar('http://dosbox.sourceforge.net/oldwiki/index.php?page=CommandLine'),nil,nil,SW_SHOW);
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
    6008 : If FileExists(PrgDir+'GUP.EXE')
             then ShellExecute(Handle,'open',PChar(PrgDir+'GUP.EXE'),nil,PChar(PrgDir),SW_SHOW)
             else ShellExecute(Handle,'open',PChar('http://dfendreloaded.sourceforge.net/Download.html'),nil,nil,SW_SHOW);
    6009 : ShowInfoDialog(self);
    6101 : ShellExecute(Handle,'open',PChar(PrgSetup.DosBoxDir+RemoveUnderline((Sender as TMenuItem).Caption)),nil,nil,SW_SHOW);
    6102 : ShellExecute(Handle,'open',PChar((Sender as TMenuItem).Hint),nil,nil,SW_SHOW);
  end;
end;

Procedure TDFendReloadedMainForm.AddFromTemplateClick(Sender: TObject);
Var TemplateDB : TGameDB;
    G : TGame;
begin
  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    G:=nil;
    EditGameProfil(self,GameDB,G,TemplateDB[(Sender as TComponent).Tag]);
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
  ScreenshotPopupDelete.Enabled:=B;
  ScreenshotPopupDeleteAll.Enabled:=B;
end;

procedure TDFendReloadedMainForm.ScreenshotListViewDblClick(Sender: TObject);
begin
  ScreenshotMenuWork(ScreenshotPopupOpen);
end;

procedure TDFendReloadedMainForm.ScreenshotListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssShift]) and (Key=VK_DELETE) then begin ScreenshotMenuWork(ScreenshotPopupDeleteAll); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : ScreenshotMenuWork(ScreenshotPopupOpen);
    VK_F5 : ScreenshotMenuWork(ScreenshotPopupRefresh);
    VK_DELETE : ScreenshotMenuWork(ScreenshotPopupDelete);
  end;
end;

procedure TDFendReloadedMainForm.ScreenshotMenuWork(Sender: TObject);
Var S : String;
    I : Integer;
    P : TPicture;
begin
  Case (Sender as TComponent).Tag of
    0 : If ScreenshotListView.Selected<>nil then begin
          S:=Trim(TGame(ListView.Selected.Data).CaptureFolder);
          If S<>'' then S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          ShowImageDialog(self,IncludeTrailingPathDelimiter(S)+ScreenshotListView.Selected.Caption);
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
  end;
end;

procedure TDFendReloadedMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  If hChangeNotification=INVALID_HANDLE_VALUE then exit;
  If WaitForSingleObject(hChangeNotification,0)<>WAIT_OBJECT_0 then exit;
  UpdateScreenshotList;
  FindNextChangeNotification(hChangeNotification);
end;

procedure TDFendReloadedMainForm.ApplicationEventsMinimize(Sender: TObject);
begin
  If PrgSetup.MinimizeToTray then begin
    TrayIcon.Visible:=True;
    Visible:=False;
    ShowWindow(Application.Handle,SW_HIDE);
  end;
end;

procedure TDFendReloadedMainForm.ApplicationEventsRestore(Sender: TObject);
begin
  ShowWindow(Application.Handle,SW_SHOW);
  Visible:=True;
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOREPOSITION or SWP_NOSIZE or SWP_SHOWWINDOW);
  SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOREPOSITION or SWP_NOSIZE or SWP_SHOWWINDOW);
  TrayIcon.Visible:=False;
end;

procedure TDFendReloadedMainForm.TrayIconDblClick(Sender: TObject);
begin
  Application.Restore;
end;

end.
