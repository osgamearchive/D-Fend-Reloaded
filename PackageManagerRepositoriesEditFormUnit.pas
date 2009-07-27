unit PackageManagerRepositoriesEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, ImgList, ToolWin, PackageDBUnit,
  Menus;

type
  TPackageManagerRepositoriesEditForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ActivateButton: TToolButton;
    AddButton: TToolButton;
    RemoveButton: TToolButton;
    ImageList: TImageList;
    BottomPanel: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    ListView: TListView;
    EditButton: TToolButton;
    PopupMenu: TPopupMenu;
    PopupActivate: TMenuItem;
    N1: TMenuItem;
    PopupAdd: TMenuItem;
    PopupEdit: TMenuItem;
    PopupRemove: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonWork(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    DBDir : String;
    UserPackageList : TPackageListFile;
    Procedure LoadList;
    Function GetDescription(const URL : String) : String;
  public
    { Public-Deklarationen }
  end;

var
  PackageManagerRepositoriesEditForm: TPackageManagerRepositoriesEditForm;

Function ShowPackageManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;

implementation

uses Math, CommonTools, PrgSetupUnit, VistaToolsUnit, LanguageSetupUnit,
     IconLoaderUnit, HelpConsts, PrgConsts, PackageDBToolsUnit, PackageDBLanguage;

{$R *.dfm}

procedure TPackageManagerRepositoriesEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LANG_RepositoriesEditor;
  ActivateButton.Caption:=LANG_RepositoriesEditorActivateSource;
  AddButton.Caption:=LANG_RepositoriesEditorAddSource;
  EditButton.Caption:=LANG_RepositoriesEditorEditSource;
  RemoveButton.Caption:=LANG_RepositoriesEditorRemoveSource;
  PopupActivate.Caption:=LANG_RepositoriesEditorPopupActivateSource;
  PopupAdd.Caption:=LANG_RepositoriesEditorPopupAddSource;
  PopupEdit.Caption:=LANG_RepositoriesEditorPopupEditSource;
  PopupRemove.Caption:=LANG_RepositoriesEditorPopupRemoveSource;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  //... Complete ImagesList customization in 0.9
  UserIconLoader.DialogImage(DI_Add,ImageList,1);
  UserIconLoader.DialogImage(DI_Edit,ImageList,2);
  UserIconLoader.DialogImage(DI_Delete,ImageList,3);

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  DBDir:=IncludeTrailingPathDelimiter(PrgDataDir+PackageDBSubFolder);

  UserPackageList:=TPackageListFile.Create;
  UserPackageList.LoadFromFile(DBDir+PackageDBUserFile);
end;

procedure TPackageManagerRepositoriesEditForm.FormShow(Sender: TObject);
Var C : TListColumn;
begin
  C:=ListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_RepositoriesEditorColumnURL;
  C:=ListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_RepositoriesEditorColumnDescription;
  LoadList;
end;

procedure TPackageManagerRepositoriesEditForm.FormDestroy(Sender: TObject);
begin
  UserPackageList.Free;
end;

Function TPackageManagerRepositoriesEditForm.GetDescription(const URL : String) : String;
Var PackageList : TPackageList;
    FileName : String;
begin
  result:='';

  FileName:=DBDir+ExtractFileNameFromURL(URL);
  If not FileExists(FileName) then exit;

  PackageList:=TPackageList.Create(URL);
  try
    PackageList.LoadFromFile(FileName);
    result:=PackageList.Name;
  finally
    PackageList.Free;
  end;
end;

procedure TPackageManagerRepositoriesEditForm.LoadList;
Var I : Integer;
    L : TListItem;
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    For I:=0 to UserPackageList.Count-1 do begin
      L:=ListView.Items.Add;
      L.Caption:=UserPackageList.URL[I];
      L.Checked:=UserPackageList.Active[I];
      L.SubItems.Add(GetDescription(UserPackageList.URL[I]));
      L.Data:=Pointer(I);
    end;
  finally
    ListView.Items.EndUpdate;
  end;

  For I:=0 to ListView.Columns.Count-1 do If ListView.Items.Count>0 then begin
    ListView.Column[I].Width:=-2;
    ListView.Column[I].Width:=-1;
  end else begin
    ListView.Column[I].Width:=-2;
  end;

  If ListView.Items.Count>0 then ListView.Selected:=ListView.Items[0];
  ListViewChange(self,ListView.Selected,ctState);
end;

procedure TPackageManagerRepositoriesEditForm.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  If ListView.Selected=nil then begin
    ActivateButton.Enabled:=False;
    ActivateButton.Caption:=LANG_RepositoriesEditorActivateSource;
    PopupActivate.Caption:=LANG_RepositoriesEditorPopupActivateSource;
  end else begin
    ActivateButton.Enabled:=True;
    If UserPackageList.Active[Integer(ListView.Selected.Data)] then begin
      ActivateButton.Caption:=LANG_RepositoriesEditorDeactivateSource;
      PopupActivate.Caption:=LANG_RepositoriesEditorPopupDeactivateSource;
    end else begin
      ActivateButton.Caption:=LANG_RepositoriesEditorActivateSource;
      PopupActivate.Caption:=LANG_RepositoriesEditorPopupActivateSource;
    end;
  end;
  PopupActivate.Enabled:=ActivateButton.Enabled;

  EditButton.Enabled:=(ListView.Selected<>nil);
  PopupEdit.Enabled:=(ListView.Selected<>nil);
  RemoveButton.Enabled:=(ListView.Selected<>nil);
  PopupRemove.Enabled:=(ListView.Selected<>nil);
end;

procedure TPackageManagerRepositoriesEditForm.ButtonWork(Sender: TObject);
Var I : Integer;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : If ListView.Selected<>nil then begin
          ListView.Selected.Checked:=not ListView.Selected.Checked;
          I:=Integer(ListView.Selected.Data);
          UserPackageList.Active[I]:=not UserPackageList.Active[I];
          ListViewChange(self,ListView.Selected,ctState);
        end;
    1 : begin
          S:='';
          If not InputQuery(LANG_RepositoriesEditorAddSourceCaption,LANG_RepositoriesEditorURL,S) then exit;
          UserPackageList.Add(S,True);
          LoadList;
          ListView.Selected:=ListView.Items[ListView.Items.Count-1];
        end;
    2 : If ListView.Selected<>nil then begin
          I:=Integer(ListView.Selected.Data);
          S:=UserPackageList.URL[I];
          If not InputQuery(LANG_RepositoriesEditorEditSourceCaption,LANG_RepositoriesEditorURL,S) then exit;
          UserPackageList.URL[I]:=S;
          ListView.Selected.Caption:=S;
          ListView.Selected.SubItems[0]:=GetDescription(S);
        end;
    3 : If ListView.Selected<>nil then begin
          If MessageDlg(LANG_RepositoriesEditorRemoveSourceConfirm,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          I:=ListView.ItemIndex;
          S:=DBDir+ExtractFileNameFromURL(UserPackageList.URL[Integer(ListView.Selected.Data)]);
          If FileExists(S) then ExtDeleteFile(S,ftTemp);
          UserPackageList.Delete(Integer(ListView.Selected.Data));
          LoadList;
          If ListView.Items.Count>0 then ListView.ItemIndex:=Max(0,I-1);
          ListViewChange(self,ListView.Selected,ctState);
        end;
  end;
end;

procedure TPackageManagerRepositoriesEditForm.ListViewDblClick(Sender: TObject);
begin
  ButtonWork(EditButton);
end;

procedure TPackageManagerRepositoriesEditForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_RETURN : ButtonWork(EditButton);
    VK_INSERT : ButtonWork(AddButton);
    VK_DELETE : ButtonWork(RemoveButton);
  end;
end;

procedure TPackageManagerRepositoriesEditForm.OKButtonClick(Sender: TObject);
begin
  UserPackageList.SaveToFile(self);
end;

procedure TPackageManagerRepositoriesEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TPackageManagerRepositoriesEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileImportDownload);
end;

{ global }

Function ShowPackageManagerRepositoriesEditDialog(const AOwner : TComponent) : Boolean;
begin
  PackageManagerRepositoriesEditForm:=TPackageManagerRepositoriesEditForm.Create(AOwner);
  try
    result:=(PackageManagerRepositoriesEditForm.ShowModal=mrOK);
  finally
    PackageManagerRepositoriesEditForm.Free;
  end;
end;

end.
