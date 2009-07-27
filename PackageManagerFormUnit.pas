unit PackageManagerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ToolWin, StdCtrls, Buttons, ExtCtrls, CheckLst,
  Menus, PackageDBUnit, PackageDBCacheUnit, ChecksumScanner, GameDBUnit,
  PackageManagerToolsUnit;

type
  TPackageManagerForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ResponsitoriesButton: TToolButton;
    ToolButton3: TToolButton;
    ImageList: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    UpdateButton: TToolButton;
    ExePackagesListBox: TListBox;
    Splitter1: TSplitter;
    ExePackagesPanel1: TPanel;
    ExePackagesPanel2: TPanel;
    ExePackagesButton: TBitBtn;
    ExePackagesMemo: TRichEdit;
    LanguagePanel: TPanel;
    LanguageButton: TBitBtn;
    LanguageListBox: TCheckListBox;
    ToolButton5: TToolButton;
    HelpButton: TToolButton;
    InfoPanel: TPanel;
    InfoLabel: TLabel;
    ExePackagesDelButton: TBitBtn;
    AutoSetupPanel: TPanel;
    AutoSetupButton: TBitBtn;
    GamesPanel: TPanel;
    GamesButton: TBitBtn;
    GamesListView: TListView;
    AutoSetupListView: TListView;
    GamesFilterButton: TBitBtn;
    AutoSetupFilterButton: TBitBtn;
    FilterPopupMenu: TPopupMenu;
    TabSheet5: TTabSheet;
    IconsPanel: TPanel;
    IconsButton: TBitBtn;
    IconsListView: TListView;
    TabSheet6: TTabSheet;
    IconSetsPanel: TPanel;
    IconSetsButton: TBitBtn;
    IconSetsListView: TListView;
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExePackagesListBoxClick(Sender: TObject);
    procedure ExePackagesButtonClick(Sender: TObject);
    procedure ExePackagesDelButtonClick(Sender: TObject);
    procedure LanguageButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FilterClick(Sender: TObject);
    procedure GamesButtonClick(Sender: TObject);
    procedure AutoSetupButtonClick(Sender: TObject);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IconsButtonClick(Sender: TObject);
    procedure IconSetsButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    PackageDB : TPackageDB;
    PackageDBCache : TPackageDBCache;
    LanguageChecksumScanner1, LanguageChecksumScanner2, AutoSetupChecksumScanner, IconChecksumScanner : TChecksumScanner;
    GamesFilter, AutoSetupFilter : TFilter;
    Procedure LoadLists;
    Procedure PackageDBDownload(Sender : TObject; const Progress, Size : Integer; const Status : TDownloadStatus; var ContinueDownload : Boolean);
  public
    { Public-Deklarationen }
    GameDB, AutoSetupDB : TGameDB;
    HideIfAlreadyInstalled : Boolean;
  end;

var
  PackageManagerForm: TPackageManagerForm;

Procedure ShowPackageManagerDialog(const AOwner : TComponent; const AGameDB, AAutoSetupDB : TGameDB);

implementation

uses ShellAPI, IniFiles, PackageDBToolsUnit, PackageDBLanguage, CommonTools,
     PrgConsts, DownloadWaitFormUnit, PrgSetupUnit, VistaToolsUnit,
     LanguageSetupUnit, ZipPackageUnit, IconLoaderUnit, HelpConsts,
     ZipInfoFormUnit, PackageManagerRepositoriesEditFormUnit;

{$R *.dfm}

procedure TPackageManagerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  HideIfAlreadyInstalled:=True;

  Caption:=LANG_Caption;
  CloseButton.Caption:=LanguageSetup.Close;
  CloseButton.Hint:=LanguageSetup.CloseHintWindow;
  UpdateButton.Caption:=LANG_MenuUpdateLists;
  UpdateButton.Hint:=LANG_MenuUpdateListsHint;
  ResponsitoriesButton.Caption:=LANG_MenuRepositoriesList;
  ResponsitoriesButton.Hint:=LANG_MenuRepositoriesListHint;
  HelpButton.Caption:=LanguageSetup.Help;
  HelpButton.Hint:=LanguageSetup.HelpHint;

  TabSheet1.Caption:=LANG_PageGames;
  TabSheet2.Caption:=LANG_PageAutoSetups;
  TabSheet5.Caption:=LANG_PageIcons;
  TabSheet6.Caption:=LANG_PageIconSets;
  TabSheet3.Caption:=LANG_PageLanguages;
  TabSheet4.Caption:=LANG_PageExePackages;

  //... Complete ImagesList customization in 0.9
  UserIconLoader.DialogImage(DI_CloseWindow,ImageList,0);
  UserIconLoader.DialogImage(DI_Update,ImageList,2);
  UserIconLoader.DialogImage(DI_Edit,ImageList,1);
  UserIconLoader.DialogImage(DI_ToolbarHelp,ImageList,3);

  GamesFilterButton.Caption:=LANG_FilterList;
  GamesButton.Caption:=LANG_InstallGames;
  AutoSetupFilterButton.Caption:=LANG_FilterList;
  AutoSetupButton.Caption:=LANG_InstallAutoSetups;
  IconsButton.Caption:=LANG_InstallIcons;
  IconSetsButton.Caption:=LANG_InstallIconSets;
  LanguageButton.Caption:=LANG_InstallLanguages;
  ExePackagesButton.Caption:=LANG_InstallPackage;
  ExePackagesDelButton.Caption:=LANG_DeletePackage;

  UserIconLoader.DialogImage(DI_Import,GamesButton);
  UserIconLoader.DialogImage(DI_Import,AutoSetupButton);
  UserIconLoader.DialogImage(DI_Import,LanguageButton);
  UserIconLoader.DialogImage(DI_Import,IconsButton);
  UserIconLoader.DialogImage(DI_Import,IconSetsButton);
  UserIconLoader.DialogImage(DI_Import,ExePackagesButton);
  UserIconLoader.DialogImage(DI_Delete,ExePackagesDelButton);

  with GamesFilter do begin Key:=fkNoFilter; UpperValue:=''; end;
  with AutoSetupFilter do begin Key:=fkNoFilter; UpperValue:=''; end;

  InitPackageManagerListView(GamesListView,False);
  InitPackageManagerListView(AutoSetupListView,True);
  InitPackageManagerIconsListView(IconsListView);
  InitPackageManagerIconSetsListView(IconSetsListView);
end;

procedure TPackageManagerForm.FormShow(Sender: TObject);
begin
  PackageDB:=TPackageDB.Create;
  PackageDB.LoadDB(False);
  PackageDB.OnDownload:=PackageDBDownload;
  PackageDBCache:=TPackageDBCache.Create;

  LanguageChecksumScanner1:=TChecksumScanner.Create(PrgDir+LanguageSubDir,False,nil);
  LanguageChecksumScanner2:=TChecksumScanner.Create(PrgDataDir+LanguageSubDir,False,nil);
  AutoSetupChecksumScanner:=TChecksumScanner.Create(PrgDataDir+AutoSetupSubDir,True,Owner);
  IconChecksumScanner:=TChecksumScanner.Create(PrgDataDir+IconsSubDir,False,nil);

  LoadLists;
end;

procedure TPackageManagerForm.FormDestroy(Sender: TObject);
begin
  PackageDB.Free;
  PackageDBCache.Free;
  LanguageChecksumScanner1.Free;
  LanguageChecksumScanner2.Free;
  AutoSetupChecksumScanner.Free;
  IconChecksumScanner.Free;
end;

procedure TPackageManagerForm.LoadLists;
Var I,J : Integer;
    St : TStringList;
begin
  {Games list}
  LoadListView(GamesListView,PackageDB,GamesFilter,AutoSetupChecksumScanner,False,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
  GamesFilterButton.Enabled:=(GamesListView.Items.Count>0);
  GamesButton.Enabled:=(GamesListView.Items.Count>0);

  {Auto setup templates list}
  LoadListView(AutoSetupListView,PackageDB,AutoSetupFilter,AutoSetupChecksumScanner,True,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
  AutoSetupFilterButton.Enabled:=(AutoSetupListView.Items.Count>0);
  AutoSetupButton.Enabled:=(AutoSetupListView.Items.Count>0);

  {Icon list}
  LoadIconsListView(IconsListView,PackageDB,IconChecksumScanner,HideIfAlreadyInstalled);
  IconsButton.Enabled:=(IconsListView.Items.Count>0);

  {Icon sets}
  LoadIconSetsListView(IconSetsListView,PackageDB,HideIfAlreadyInstalled);
  IconSetsButton.Enabled:=(IconSetsListView.Items.Count>0);

  {Language files list}
  LanguageListBox.Items.Clear;
  St:=TStringList.Create;
  try
    For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB.List[I].LanguageCount-1 do begin
      If PackageDB.List[I].Language[J].Version<>GetNormalFileVersionAsString then continue;
      If (not HideIfAlreadyInstalled) or (LanguageChecksumScanner1.GetChecksum(ExtractFileNameFromURL(PackageDB.List[I].Language[J].URL))<>PackageDB.List[I].Language[J].PackageChecksum) and (LanguageChecksumScanner2.GetChecksum(ExtractFileNameFromURL(PackageDB.List[I].Language[J].URL))<>PackageDB.List[I].Language[J].PackageChecksum) then begin
        St.AddObject(PackageDB.List[I].Language[J].Name+' ('+ LanguageSetup.InfoFormLanguageAuthor+': '+PackageDB.List[I].Language[J].Author+')',PackageDB.List[I].Language[J]);
      end;
    end;
    St.Sort;
    LanguageListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  LanguageButton.Enabled:=(LanguageListBox.Items.Count>0);

  {Multiple games pacakges list}
  ExePackagesListBox.Items.Clear;
  St:=TStringList.Create;
  try
    For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB.List[I].ExePackageCount-1 do
      St.AddObject(PackageDB.List[I].ExePackage[J].Name,PackageDB.List[I].ExePackage[J]);
    For I:=0 to PackageDBCache.Count-1 do If St.IndexOf(PackageDBCache.Package[I].Name)<0 then
      St.AddObject(PackageDBCache.Package[I].Name,PackageDBCache.Package[I]);
    St.Sort;
    ExePackagesListBox.Items.AddStrings(St);
  finally
    St.Free;
  end;
  If ExePackagesListBox.Items.Count>0 then ExePackagesListBox.ItemIndex:=0;
  ExePackagesListBoxClick(self);

  {Info label}
  InfoLabel.Caption:=Lang_AllListsEmpty;
  InfoPanel.Visible:=False;
  For I:=0 to PackageDB.Count-1 do
    If PackageDB.List[I].GamesCount+PackageDB.List[I].AutoSetupCount+PackageDB.List[I].LanguageCount+PackageDB.List[I].ExePackageCount>0 then exit;
  InfoPanel.Visible:=True;
end;

procedure TPackageManagerForm.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
begin
  InfoTip:='';
  If (Item=nil) or (Item.Data=nil) then exit;
  InfoTip:=GetPackageManagerToolTip(TDownloadAutoSetupData(Item.Data));
end;

Procedure TPackageManagerForm.PackageDBDownload(Sender : TObject; const Progress, Size : Integer; const Status : TDownloadStatus; var ContinueDownload : Boolean);
begin
  Case Status of
    dsStart : begin Enabled:=False; InitDownloadWaitForm(self,Size); end;
    dsProgress : ContinueDownload:=StepDownloadWaitForm(Progress);
    dsDone : begin Enabled:=True; DoneDownloadWaitForm; end;
  End;
end;

procedure TPackageManagerForm.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          PackageDB.LoadDB(True);
          LoadLists;
        end;
    2 : If ShowPackageManagerRepositoriesEditDialog(self) then begin
          PackageDB.LoadDB(True);
          LoadLists;
        end;
    3 : Application.HelpCommand(HELP_CONTEXT,ID_FileImportDownload);
  End;
end;

procedure TPackageManagerForm.FilterClick(Sender: TObject);
Var P : TPoint;
    Nr : Integer;
    AutoSetups : Boolean;
    Key : TFilterKey;
    S : String;
    Filter : ^TFilter;
begin
  If Sender is TMenuItem then begin
    Nr:=(Sender as TComponent).Tag;
    AutoSetups:=(FilterPopupMenu.Tag=1);
    If Nr<0 then begin Key:=fkNoFilter; S:=''; end else Case TMenuItem(Sender).Parent.Tag of
      1 : begin Key:=fkLicense; S:=FilterSelectLicense[Nr]; end;
      2 : begin Key:=fkGenre; S:=FilterSelectGenre[Nr]; end;
      3 : begin Key:=fkDeveloper; S:=FilterSelectDeveloper[Nr]; end;
      4 : begin Key:=fkPublisher; S:=FilterSelectPublisher[Nr]; end;
      5 : begin Key:=fkYear; S:=FilterSelectYear[Nr]; end;
      6 : begin Key:=fkLanguage; S:=FilterSelectLanguage[Nr]; end;
      else exit;
    end;
    If AutoSetups then Filter:=@AutoSetupFilter else Filter:=@GamesFilter;
    Filter^.Key:=Key; Filter^.UpperValue:=ExtUpperCase(S);
    If AutoSetups
      then LoadListView(AutoSetupListView,PackageDB,AutoSetupFilter,AutoSetupChecksumScanner,True,GameDB,AutoSetupDB,HideIfAlreadyInstalled)
      else LoadListView(GamesListView,PackageDB,GamesFilter,AutoSetupChecksumScanner,False,GameDB,AutoSetupDB,HideIfAlreadyInstalled);
  end else begin
    P:=(Sender as TControl).Parent.ClientToScreen(Point((Sender as TControl).Left+5,(Sender as TControl).Top+5));
    OpenFilterPopup(P,(Sender as TControl).Tag=1,FilterPopupMenu,PackageDB,FilterClick);
  end;
end;

procedure TPackageManagerForm.GamesButtonClick(Sender: TObject);
Var I : Integer;
    DownloadZipData : TDownloadZipData;
    FileName : String;
begin
  try
    For I:=0 to GamesListView.Items.Count-1 do If GamesListView.Items[I].Checked then begin
      DownloadZipData:=TDownloadZipData(GamesListView.Items[I].Data);
      FileName:=ExtractFileNameFromURL(DownloadZipData.URL);
      If not DownloadFile(self,DownloadZipData.Size,DownloadZipData.PackageFileURL,DownloadZipData.URL,PackageDB.DBDir+FileName) then continue;
      try
        ImportZipPackage(self,PackageDB.DBDir+FileName,GameDB);
      finally
        ExtDeleteFile(PackageDB.DBDir+FileName,ftUninstall);
      end;
    end;
  finally
    LoadLists;
  end;
end;

procedure TPackageManagerForm.AutoSetupButtonClick(Sender: TObject);
Var I,J : Integer;
    DownloadAutoSetupData : TDownloadAutoSetupData;
    FileName : String;
    G,G2 : TGame;
begin
  try
    For I:=0 to AutoSetupListView.Items.Count-1 do If AutoSetupListView.Items[I].Checked then begin
      DownloadAutoSetupData:=TDownloadAutoSetupData(AutoSetupListView.Items[I].Data);
      FileName:=ExtractFileNameFromURL(DownloadAutoSetupData.URL);
      If not DownloadFile(self,DownloadAutoSetupData.Size,DownloadAutoSetupData.PackageFileURL,DownloadAutoSetupData.URL,PackageDB.DBDir+FileName) then continue;
      ForceDirectories(PrgDataDir+AutoSetupSubDir+'\');
      If FileExists(PrgDataDir+AutoSetupSubDir+'\'+FileName) then begin
        G:=TGame.Create(PackageDB.DBDir+FileName);
        try
          J:=AutoSetupDB.Add(DownloadAutoSetupData.Name); G2:=AutoSetupDB[J];
          G2.AssignFrom(G);
        finally
          G.Free;
        end;
        ExtDeleteFile(PackageDB.DBDir+FileName,ftUninstall);
      end else begin
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PrgDataDir+AutoSetupSubDir+'\'+FileName));
        G:=TGame.Create(PrgDataDir+AutoSetupSubDir+'\'+FileName);
        AutoSetupDB.Add(G);
      end;
    end;
  finally
    AutoSetupChecksumScanner.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.IconsButtonClick(Sender: TObject);
Var I : Integer;
    DownloadIconData : TDownloadIconData;
    FileName : String;
begin
  try
    For I:=0 to IconsListView.Items.Count-1 do If IconsListView.Items[I].Checked then begin
      DownloadIconData:=TDownloadIconData(IconsListView.Items[I].Data);
      FileName:=ExtractFileNameFromURL(DownloadIconData.URL);
      If DownloadFile(self,DownloadIconData.Size,DownloadIconData.PackageFileURL,DownloadIconData.URL,PackageDB.DBDir+FileName) then begin
        ForceDirectories(PrgDataDir+IconsSubDir+'\');
        If FileExists(PrgDataDir+IconsSubDir+'\'+FileName) then ExtDeleteFile(PrgDataDir+IconsSubDir+'\'+FileName,ftUninstall);
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PrgDataDir+IconsSubDir+'\'+FileName));
      end;
    end;
  finally
    IconChecksumScanner.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.IconSetsButtonClick(Sender: TObject);
Var I : Integer;
    DownloadIconSetData : TDownloadIconSetData;
    FileName, DestDir : String;
    B : Boolean;
    Ini : TIniFile;
begin
  try
    B:=False;
    For I:=0 to IconSetsListView.Items.Count-1 do If IconSetsListView.Items[I].Checked then begin
      DownloadIconSetData:=TDownloadIconSetData(IconSetsListView.Items[I].Data);
      FileName:=ExtractFileNameFromURL(DownloadIconSetData.URL);
      If DownloadFile(self,DownloadIconSetData.Size,DownloadIconSetData.PackageFileURL,DownloadIconSetData.URL,PackageDB.DBDir+FileName) then begin
        B:=True;
        ForceDirectories(PrgDataDir+IconSetsFolder+'\');
        DestDir:=PrgDataDir+IconSetsFolder+'\'+MakeFileSysOKFolderName(DownloadIconSetData.Name);
        ForceDirectories(DestDir);
        ExtractZipFile(self,PackageDB.DBDir+FileName,DestDir);
        DeleteFile(PackageDB.DBDir+FileName);

        Ini:=TIniFile.Create(IncludeTrailingPathDelimiter(DestDir)+IconsConfFile);
        try
          Ini.WriteString('Information','Version',DownloadIconSetData.Version);
        finally
          Ini.Free;
        end;
      end;
    end;
    If B then MessageDlg(LANG_IconSetDownloaded,mtInformation,[mbOK],0);
  finally
    LoadLists;
  end;
end;

procedure TPackageManagerForm.LanguageButtonClick(Sender: TObject);
Var DownloadLanguageData : TDownloadLanguageData;
    FileName : String;
    I : Integer;
    B : Boolean;
begin
  try
    B:=False;
    For I:=0 to LanguageListBox.Items.Count-1 do If LanguageListBox.Checked[I] then begin
      DownloadLanguageData:=TDownloadLanguageData(LanguageListBox.Items.Objects[I]);
      FileName:=ExtractFileNameFromURL(DownloadLanguageData.URL);
      If DownloadFile(self,DownloadLanguageData.Size,DownloadLanguageData.PackageFileURL,DownloadLanguageData.URL,PackageDB.DBDir+FileName) then begin
        B:=True;
        ForceDirectories(PrgDataDir+LanguageSubDir+'\');
        If FileExists(PrgDataDir+LanguageSubDir+'\'+FileName) then ExtDeleteFile(PrgDataDir+LanguageSubDir+'\'+FileName,ftUninstall);
        MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PrgDataDir+LanguageSubDir+'\'+FileName));
      end;
    end;
    If B then MessageDlg(LANG_LanguageDownloaded,mtInformation,[mbOK],0);
  finally
    LanguageChecksumScanner1.ReScan;
    LanguageChecksumScanner2.ReScan;
    LoadLists;
  end;
end;

procedure TPackageManagerForm.ExePackagesListBoxClick(Sender: TObject);
Var St : TStringList;
    DownloadExeData : TDownloadExeData;
begin
  ExePackagesMemo.Lines.Clear;
  If ExePackagesListBox.ItemIndex>=0 then begin
    St:=ExePackageInfo(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex],PackageDBCache);
    try ExePackagesMemo.Lines.AddStrings(St); finally St.Free; end;
  end;
  ExePackagesButton.Enabled:=(ExePackagesListBox.ItemIndex>=0);

  If ExePackagesListBox.ItemIndex>=0 then begin
    If ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex] is TCachedPackage then begin
      ExePackagesDelButton.Enabled:=True;
    end else begin
      DownloadExeData:=TDownloadExeData(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);
      ExePackagesDelButton.Enabled:=(PackageDBCache.FindChecksum(DownloadExeData.Name)<>'');
    end;
  end else begin
    ExePackagesDelButton.Enabled:=False;
  end;
end;

procedure TPackageManagerForm.ExePackagesButtonClick(Sender: TObject);
Var DownloadExeData : TDownloadExeData;
    FileName : String;
    CachedPackage : TCachedPackage;
    OldChecksum : String;
    OK : Boolean;
begin
  If ExePackagesListBox.ItemIndex<0 then exit;

  If ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex] is TCachedPackage then begin
    CachedPackage:=TCachedPackage(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);
    ShellExecute(Handle,'open',PChar(CachedPackage.Filename),PChar('/D='+PrgDir),nil,SW_Show);
    Close;
    exit;
  end;

  DownloadExeData:=TDownloadExeData(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]);
  OldChecksum:=PackageDBCache.FindChecksum(DownloadExeData.Name);
  FileName:=ExtractFileNameFromURL(DownloadExeData.URL);
  If DownloadExeData.PackageChecksum<>OldChecksum then begin
    Enabled:=False;
    try
      OK:=DownloadFile(self,DownloadExeData.Size,DownloadExeData.PackageFileURL,DownloadExeData.URL,PackageDB.DBDir+FileName);
    finally
      Enabled:=True;
    end;
    If OK then begin
      PackageDBCache.DelCache(DownloadExeData.Name);
      MoveFile(PChar(PackageDB.DBDir+FileName),PChar(PackageDBCache.DBDir+FileName));
      PackageDBCache.AddCache(DownloadExeData.Name,DownloadExeData.Description,PackageDBCache.DBDir+FileName);
    end else begin
      If OldChecksum='' then begin
        MessageDlg(Format(LANG_DownloadFailed,[DownloadExeData.URL]),mtError,[mbOK],0);
        exit;
      end else begin
        if MessageDlg(LANG_DownloadFailedUseOldVersion,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
        CachedPackage:=PackageDBCache.FindPackage(DownloadExeData.Name); if CachedPackage=nil then exit;
        ShellExecute(Handle,'open',PChar(CachedPackage.Filename),PChar('/D='+PrgDir),nil,SW_Show);
        Close;
        exit;
      end;
    end;
  end;

  ShellExecute(Handle,'open',PChar(PackageDBCache.DBDir+FileName),PChar('/D='+PrgDir),nil,SW_Show);
  Close;
end;

procedure TPackageManagerForm.ExePackagesDelButtonClick(Sender: TObject);
begin
  PackageDBCache.DelCache(TCachedPackage(ExePackagesListBox.Items.Objects[ExePackagesListBox.ItemIndex]));
  LoadLists;
end;

procedure TPackageManagerForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then ButtonWork(HelpButton);
end;

{ global }

Procedure ShowPackageManagerDialog(const AOwner : TComponent; const AGameDB, AAutoSetupDB : TGameDB);
begin
  PackageManagerForm:=TPackageManagerForm.Create(AOwner);
  try
    PackageManagerForm.GameDB:=AGameDB;
    PackageManagerForm.AutoSetupDB:=AAutoSetupDB;
    PackageManagerForm.HideIfAlreadyInstalled:=((Word(GetKeyState(VK_LSHIFT)) div 256)=0) and ((Word(GetKeyState(VK_RSHIFT)) div 256)=0);
    PackageManagerForm.ShowModal;
  finally
    PackageManagerForm.Free;
  end;
end;

end.
