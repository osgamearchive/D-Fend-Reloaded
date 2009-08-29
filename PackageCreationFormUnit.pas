unit PackageCreationFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, CheckLst, Menus,
  GameDBUnit, GameDBToolsUnit;

type
  TPackageCreationForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ImageList: TImageList;
    TabSheet6: TTabSheet;
    OutputFileEdit: TLabeledEdit;
    OutputFileButton: TSpeedButton;
    GamesPanel: TPanel;
    AutoSetupPanel: TPanel;
    GamesSelectAllButton: TBitBtn;
    GamesSelectNoneButton: TBitBtn;
    GamesSelectGenreButton: TBitBtn;
    AutoSetupSelectAllButton: TBitBtn;
    AutoSetupSelectNoneButton: TBitBtn;
    AutoSetupSelectGenreButton: TBitBtn;
    GamesPopupMenu: TPopupMenu;
    AutoSetupPopupMenu: TPopupMenu;
    IconsPanel: TPanel;
    IconsSelectAllButton: TBitBtn;
    IconsSelectNoneButton: TBitBtn;
    IconsListView: TListView;
    IconsImageList: TImageList;
    IconSetsPanel: TPanel;
    IconSetsSelectAllButton: TBitBtn;
    IconSetsSelectNoneButton: TBitBtn;
    LanguageFilesPanel: TPanel;
    LanguageFilesSelectAllButton: TBitBtn;
    LanguageFilesSelectNoneButton: TBitBtn;
    InfoLabel: TLabel;
    IconSetsListBox: TCheckListBox;
    LanguageFilesListBox: TCheckListBox;
    PackagesPanel: TPanel;
    PackagesAddButton: TBitBtn;
    PackagesEditButton: TBitBtn;
    PackagesListBox: TListBox;
    PackagesDelButton: TBitBtn;
    GamesListView: TListView;
    AutoSetupListView: TListView;
    DummyImageList1: TImageList;
    DummyImageList2: TImageList;
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure OutputFileButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure PackagesListBoxClick(Sender: TObject);
    procedure PackagesListBoxDblClick(Sender: TObject);
    procedure PackagesListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GamesListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure AutoSetupListViewColumnClick(Sender: TObject;
      Column: TListColumn);
  private
    { Private-Deklarationen }
    ListSortGames, ListSortAutoSetups : TSortListBy;
    ListSortGamesReverse, ListSortAutoSetupsReverse : Boolean;
    Procedure LoadLists;
    Procedure LoadGamesList;
    Procedure LoadAutoSetupsList;
    Function CreatePackageFile(const OutputDir : String) : TStringList;
  public
    { Public-Deklarationen }
    GameDB, AutoSetupDB : TGameDB;
  end;

var
  PackageCreationForm: TPackageCreationForm;

Function ShowPackageCreationDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, Math, CommonTools, LanguageSetupUnit, VistaToolsUnit,
     HelpConsts, PrgSetupUnit, PrgConsts, PackageBuilderUnit, IconLoaderUnit,
     ZipPackageUnit, ZipInfoFormUnit,  MainUnit;

{$R *.dfm}

procedure TPackageCreationForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(OutputFileEdit);
  NoFlicker(OKButton);
  NoFlicker(CancelButton);
  NoFlicker(HelpButton);
  
  Caption:=LanguageSetup.PackageCreator;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  TabSheet1.Caption:=LanguageSetup.PackageManagerPageGames;
  TabSheet2.Caption:=LanguageSetup.PackageManagerPageAutoSetups;
  TabSheet3.Caption:=LanguageSetup.PackageManagerPageIcons;
  TabSheet5.Caption:=LanguageSetup.PackageManagerPageIconSets;
  TabSheet4.Caption:=LanguageSetup.PackageManagerPageLanguages;
  TabSheet5.Caption:=LanguageSetup.PackageManagerPageExePackages;

  OutputFileEdit.EditLabel.Caption:=LanguageSetup.PackageCreatorOutputFile;
  OutputFileButton.Hint:=LanguageSetup.ChooseFile;
  InfoLabel.Caption:=LanguageSetup.PackageCreatorOutputFileInfo;

  GamesSelectAllButton.Caption:=LanguageSetup.All;
  GamesSelectNoneButton.Caption:=LanguageSetup.None;
  GamesSelectGenreButton.Caption:=LanguageSetup.GameBy;
  AutoSetupSelectAllButton.Caption:=LanguageSetup.All;
  AutoSetupSelectNoneButton.Caption:=LanguageSetup.None;
  AutoSetupSelectGenreButton.Caption:=LanguageSetup.GameBy;
  IconsSelectAllButton.Caption:=LanguageSetup.All;
  IconsSelectNoneButton.Caption:=LanguageSetup.None;
  IconSetsSelectAllButton.Caption:=LanguageSetup.All;
  IconSetsSelectNoneButton.Caption:=LanguageSetup.None;
  LanguageFilesSelectAllButton.Caption:=LanguageSetup.All;
  LanguageFilesSelectNoneButton.Caption:=LanguageSetup.None;
  PackagesAddButton.Caption:=LanguageSetup.Add;
  PackagesEditButton.Caption:=LanguageSetup.Edit;
  PackagesDelButton.Caption:=LanguageSetup.Del;

  UserIconLoader.DialogImage(DI_Add,PackagesAddButton);
  UserIconLoader.DialogImage(DI_Edit,PackagesEditButton);
  UserIconLoader.DialogImage(DI_Delete,PackagesDelButton);
  UserIconLoader.DialogImage(DI_SelectFolder,OutputFileButton);

  OpenDialog.Title:=LanguageSetup.PackageManagerPageExePackagesSelect;
  OpenDialog.Filter:=LanguageSetup.BuildInstallerDestFileFilter;

  ListSortGames:=slbName;
  ListSortGamesReverse:=False;
  ListSortAutoSetups:=slbName;
  ListSortAutoSetupsReverse:=False;

  InitListViewForGamesList(GamesListView,True);
  InitListViewForGamesList(AutoSetupListView,True);
  LoadLists;
end;

procedure TPackageCreationForm.LoadLists;
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
    Icon : TIcon;
    St,St2 : TStringList;
begin
  {Games}
  LoadGamesList;
  BuildSelectPopupMenu(GamesPopupMenu,GameDB,ButtonWork,True,True);

  {AutoSetup}
  LoadAutoSetupsList;
  BuildSelectPopupMenu(AutoSetupPopupMenu,AutoSetupDB,ButtonWork,False,True);

  {Icons}
  IconsListView.Items.BeginUpdate;
  try
    I:=FindFirst(PrgDataDir+IconsSubDir+'\*.ico',faAnyFile,Rec);
    try While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        L:=IconsListView.Items.Add; L.Caption:=Rec.Name;
        Icon:=TIcon.Create;
        try Icon.LoadFromFile(PrgDataDir+IconsSubDir+'\'+Rec.Name); IconsImageList.AddIcon(Icon); L.ImageIndex:=IconsImageList.Count-1; except end;
        Icon.Free;
      end;
      I:=FindNext(Rec);
    end; finally FindClose(Rec); end;
  finally IconsListView.Items.EndUpdate; end;
  If IconsListView.Items.Count>0 then begin IconsListView.Column[0].Width:=-2; IconsListView.Column[0].Width:=-1; end else IconsListView.Column[0].Width:=-2;

  {IconSets}
  St:=TStringList.Create; St2:=TStringList.Create;
  try
    ListOfIconSets(St,St2,nil);
    IconSetsListBox.Items.AddStrings(St2);
  finally
    St.Free; St2.Free;
  end;

  {Language files}
  St:=GetLanguageList;
  try LanguageFilesListBox.Items.AddStrings(St); finally St.Free; end;

  {Games packages}
  PackagesListBoxClick(self);
end;

Procedure TPackageCreationForm.LoadGamesList;
Var CheckedGames : TList;
    I : Integer;
begin
  CheckedGames:=TList.Create;
  try
    For I:=0 to GamesListView.Items.Count-1 do If GamesListView.Items[I].Checked then CheckedGames.Add(GamesListView.Items[I].Data);
    AddGamesToList(GamesListView,DummyImageList1,DummyImageList2,DFendReloadedMainForm.ImageList,GameDB,'','','',True,ListSortGames,ListSortGamesReverse,False,True,True,False);
    For I:=0 to GamesListView.Items.Count-1 do GamesListView.Items[I].Checked:=(CheckedGames.IndexOf(GamesListView.Items[I].Data)>=0);
  finally
    CheckedGames.Free;
  end;
end;

Procedure TPackageCreationForm.LoadAutoSetupsList;
Var CheckedGames : TList;
    I : Integer;
begin
  CheckedGames:=TList.Create;
  try
    For I:=0 to  AutoSetupListView.Items.Count-1 do If AutoSetupListView.Items[I].Checked then CheckedGames.Add(AutoSetupListView.Items[I].Data);
    AddGamesToList(AutoSetupListView,DummyImageList1,DummyImageList2,DFendReloadedMainForm.ImageList,AutoSetupDB,'','','',True,ListSortAutoSetups,ListSortAutoSetupsReverse,False,True,False,False);
     For I:=0 to AutoSetupListView.Items.Count-1 do AutoSetupListView.Items[I].Checked:=(CheckedGames.IndexOf(AutoSetupListView.Items[I].Data)>=0);
  finally
    CheckedGames.Free;
  end;
end;

procedure TPackageCreationForm.GamesListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSortGames,ListSortGamesReverse);
  LoadGamesList;
end;

procedure TPackageCreationForm.AutoSetupListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSortAutoSetups,ListSortAutoSetupsReverse);
  LoadAutoSetupsList;
end;

procedure TPackageCreationForm.ButtonWork(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TMenuItem then begin
    If (Sender as TMenuItem).Owner=GamesPopupMenu then SelectGamesByPopupMenu(Sender,GamesListView);
    If (Sender as TMenuItem).Owner=AutoSetupPopupMenu then SelectGamesByPopupMenu(Sender,AutoSetupListView);
    exit;
  end;

  Case (Sender as TComponent).Tag of
    0,1 : For I:=0 to GamesListView.Items.Count-1 do GamesListView.Items[I].Checked:=((Sender as TComponent).Tag=0);
      2 : begin
            P:=GamesPanel.ClientToScreen(Point(GamesSelectGenreButton.Left,GamesSelectGenreButton.Top));
            GamesPopupMenu.Popup(P.X+5,P.Y+5);
          end;
    3,4 : For I:=0 to AutoSetupListView.Items.Count-1 do AutoSetupListView.Items[I].Checked:=((Sender as TComponent).Tag=3);
      5 : begin
            P:=AutoSetupPanel.ClientToScreen(Point(AutoSetupSelectGenreButton.Left,AutoSetupSelectGenreButton.Top));
            AutoSetupPopupMenu.Popup(P.X+5,P.Y+5);
          end;
    6,7 : For I:=0 to IconsListView.Items.Count-1 do IconsListView.Items[I].Checked:=((Sender as TComponent).Tag=6);
    8,9 : For I:=0 to IconSetsListBox.Count-1 do IconSetsListBox.Checked[I]:=((Sender as TComponent).Tag=8);
  10,11 : For I:=0 to LanguageFilesListBox.Count-1 do LanguageFilesListBox.Checked[I]:=((Sender as TComponent).Tag=10);
     12 : begin
            OpenDialog.InitialDir:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
            If not OpenDialog.Execute then exit;
            PackagesListBox.ItemIndex:=PackagesListBox.Items.Add(OpenDialog.FileName);
            PackagesListBoxClick(self);
          end;
     13 : If PackagesListBox.ItemIndex>=0 then begin
          OpenDialog.InitialDir:=ExtractFilePath(PackagesListBox.Items[PackagesListBox.ItemIndex]);
          If not OpenDialog.Execute then exit;
          PackagesListBox.Items[PackagesListBox.ItemIndex]:=OpenDialog.FileName;
          end;
     14 : If PackagesListBox.ItemIndex>=0 then begin
            I:=PackagesListBox.ItemIndex;
            PackagesListBox.Items.Delete(I);
            If PackagesListBox.Items.Count>0 then PackagesListBox.ItemIndex:=Max(0,I-1);
            PackagesListBoxClick(self);
          end;
  end;
end;

procedure TPackageCreationForm.PackagesListBoxClick(Sender: TObject);
begin
  PackagesEditButton.Enabled:=(PackagesListBox.ItemIndex>=0);
  PackagesDelButton.Enabled:=(PackagesListBox.ItemIndex>=0);
end;

procedure TPackageCreationForm.PackagesListBoxDblClick(Sender: TObject);
begin
  ButtonWork(PackagesEditButton);
end;

procedure TPackageCreationForm.PackagesListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Case Key of
    VK_INSERT : ButtonWork(PackagesAddButton);
    VK_RETURN : ButtonWork(PackagesEditButton);
    VK_DELETE : ButtonWork(PackagesDelButton);
    else exit;
  End;
  Key:=0;
end;

procedure TPackageCreationForm.OutputFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(ExtractFilePath(OutputFileEdit.Text));
  If S='' then S:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);

  SaveDialog.Title:=LanguageSetup.PackageCreatorOutputTitle;
  SaveDialog.Filter:=LanguageSetup.PackageCreatorOutputFilter;
  If not SaveDialog.Execute then exit;

  OutputFileEdit.Text:=SaveDialog.FileName;
end;

Function IconSetFolderFromName(const Name : String) : String;
Var St,St2 : TStringList;
    I : Integer;
    S : String;
begin
  result:='';
  St:=TStringList.Create;
  St2:=TStringList.Create;
  try
    ListOfIconSets(St,St2,nil);
    I:=St2.IndexOf(Name); If I<0 then exit;
    S:=St[I];

    If DirectoryExists(PrgDataDir+IconSetsFolder+'\'+S) then begin result:=PrgDataDir+IconSetsFolder+'\'+S; exit; end;
    If PrgDir=PrgDataDir then exit;
    If DirectoryExists(PrgDir+IconSetsFolder+'\'+S) then result:=PrgDir+IconSetsFolder+'\'+S;
  finally
    St.Free;
    St2.Free;
  end;
end;

Function TPackageCreationForm.CreatePackageFile(const OutputDir : String) : TStringList;
Function CopyWithWithMsg(const Source, Dest : String) : Boolean;
begin
  result:=CopyFile(PChar(Source),PChar(Dest),False);
  if not result then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Source,Dest]),mtError,[mbOK],0);
end;
Var I : Integer;
    S,T : String;
    G : TGame;
begin
  result:=AddPackageDataHeader;

  {Games}
  For I:=0 to GamesListView.Items.Count-1 do If GamesListView.Items[I].Checked then begin
    G:=TGame(GamesListView.Items[I].Data);
    S:=OutputDir+ChangeFileExt(ExtractFileName(G.SetupFile),'.zip');
    BuildZipPackage(self,G,S);
    if not AddPackageDataZip(result,G,S) then begin FreeAndNil(result); exit; end;
  end;

  {AutoSetup}
  For I:=0 to AutoSetupListView.Items.Count-1 do If AutoSetupListView.Items[I].Checked then begin
    S:=TGame(AutoSetupListView.Items[I].Data).SetupFile;
    T:=OutputDir+ExtractFileName(S);
    If not CopyWithWithMsg(S,T) then begin FreeAndNil(result); exit; end;
    if not AddPackageDataAutoSetup(result,T) then begin FreeAndNil(result); exit; end;
  end;

  {Icons}
  For I:=0 to IconsListView.Items.Count-1 do If IconsListView.Items[I].Checked then begin
    S:=PrgDataDir+IconsSubDir+'\'+IconsListView.Items[I].Caption;
    T:=OutputDir+IconsListView.Items[I].Caption;
    If not CopyWithWithMsg(S,T) then begin FreeAndNil(result); exit; end;
    if not AddPackageDataIcon(result,T) then begin FreeAndNil(result); exit; end;
  end;

  {IconSets}
  For I:=0 to IconSetsListBox.Items.Count-1 do If IconSetsListBox.Checked[I] then begin
    S:=IconSetFolderFromName(IconSetsListBox.Items[I]); If S='' then continue;
    T:=OutputDir+MakeFileSysOKFolderName(IconSetsListBox.Items[I])+'.zip';
    if not CreateZipFile(self,T,S,dmNo,GetCompressStrengthFromPrgSetup) then exit;
    if not AddPackageDataIconSet(result,S+IconsConfFile,T) then begin FreeAndNil(result); exit; end;
  end;

  {Language files}
  For I:=0 to LanguageFilesListBox.Items.Count-1 do If LanguageFilesListBox.Checked[I] then begin
    S:=LanguageFileNameFromName(LanguageFilesListBox.Items[I]); If S='' then continue;
    T:=OutputDir+ExtractFileName(S);
    If not CopyWithWithMsg(S,T) then begin FreeAndNil(result); exit; end;
    If not AddPackageDataLanguage(result,T) then begin FreeAndNil(result); exit; end;
  end;

  {Games packages}
  For I:=0 to PackagesListBox.Items.Count-1 do begin
    If not AddPackageDataExe(result,PackagesListBox.Items[I]) then begin FreeAndNil(result); exit; end;
  end;

  AddPackageDataFooter(result);
end;

procedure TPackageCreationForm.OKButtonClick(Sender: TObject);
Var St : TStringList;
begin
  If Trim(OutputFileEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  St:=CreatePackageFile(IncludeTrailingPathDelimiter(ExtractFilePath(OutputFileEdit.Text)));
  If St=nil then exit;
  try
    try
      St.SaveToFile(OutputFileEdit.Text);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[OutputFileEdit.Text]),mtError,[mbOK],0);
      ModalResult:=mrNone; exit;
    end;
  finally
    St.Free;
  end;
end;

procedure TPackageCreationForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileExportPackageListCreator); 
end;

procedure TPackageCreationForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowPackageCreationDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
Var AutoSetupDB : TGameDB;
begin
  PackageCreationForm:=TPackageCreationForm.Create(AOwner);
  try
    AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
    try
      PackageCreationForm.GameDB:=AGameDB;
      PackageCreationForm.AutoSetupDB:=AutoSetupDB;
      result:=(PackageCreationForm.ShowModal=mrOK);
    finally
      AutoSetupDB.Free;
    end;
  finally
    PackageCreationForm.Free;
  end;
end;

end.
