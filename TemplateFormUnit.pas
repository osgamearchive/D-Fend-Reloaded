unit TemplateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, Menus, GameDBUnit, GameDBToolsUnit;

type
  TTemplateForm = class(TForm)
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    PopupUse: TMenuItem;
    N1: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDel: TMenuItem;
    ListViewImageList: TImageList;
    UsePopupMenu: TPopupMenu;
    PopupUseProfile: TMenuItem;
    PopupUseDefault: TMenuItem;
    PopupUseProfile2: TMenuItem;
    PopupUseDefault2: TMenuItem;
    AddPopupMenu: TPopupMenu;
    PopupAddNew: TMenuItem;
    PopupAddFromProfile: TMenuItem;
    PopupCopy: TMenuItem;
    ListviewIconImageList: TImageList;
    PageControl: TPageControl;
    TemplateTab: TTabSheet;
    ListView: TListView;
    AutoSetupSheet: TTabSheet;
    ListView2: TListView;
    AddPopupMenu2: TPopupMenu;
    PopupAddNew2: TMenuItem;
    PopupAddFromProfile2: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupEdit2: TMenuItem;
    PopupCopy2: TMenuItem;
    PopupDel2: TMenuItem;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFileUse: TMenuItem;
    N2: TMenuItem;
    MenuFileClose: TMenuItem;
    MenuEdit: TMenuItem;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton7: TToolButton;
    UseButton: TToolButton;
    ToolButton3: TToolButton;
    AddButton: TToolButton;
    EditButton: TToolButton;
    DeleteButton: TToolButton;
    CoolBar1: TCoolBar;
    ToolBar2: TToolBar;
    CloseButton2: TToolButton;
    ToolButton2: TToolButton;
    AddButton2: TToolButton;
    EditButton2: TToolButton;
    DeleteButton2: TToolButton;
    MenuFileUseAsProfile: TMenuItem;
    MenuFileUseAsDefault: TMenuItem;
    MenuEditAdd: TMenuItem;
    MenuEditEdit: TMenuItem;
    MenuEditEditMultipleTemplates: TMenuItem;
    MenuEditDelete2: TMenuItem;
    MenuEditAdd2: TMenuItem;
    MenuEditEdit2: TMenuItem;
    MenuEditDelete: TMenuItem;
    MenuEditEditMultipleTemplates2: TMenuItem;
    MenuEditAddNewTemplate: TMenuItem;
    MenuEditAddTemplateFromProfile: TMenuItem;
    MenuEditAdd2NewTemplate: TMenuItem;
    MenuEditAdd2TemplateFromProfile: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure PageControlChange(Sender: TObject);
  private
    { Private-Deklarationen }
    TemplateDB, AutoSetupDB : TGameDB;
    DefaultTemplate : TGame;
    ListSort, ListSort2 : TSortListBy;
    ListSortReverse, ListSortReverse2 : Boolean;
    Procedure LoadList;
    Procedure LoadList2;
    procedure SelectGame(const AGame: TGame);
    procedure SelectGame2(const AGame: TGame);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Template : TGame;
  end;

var
  TemplateForm: TTemplateForm;

Function ShowTemplateDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     ProfileEditorFormUnit, PrgSetupUnit, TemplateSelectProfileFormUnit,
     ModernProfileEditorFormUnit, SelectProfilesFormUnit, ChangeProfilesFormUnit;

{$R *.dfm}

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  DoubleBuffered:=True;
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  
  NoFlicker(PageControl);
  NoFlicker(ToolBar);
  NoFlicker(ListView);

  ListSort:=slbName;
  ListSortReverse:=False;
  ListSort2:=slbName;
  ListSortReverse2:=False;

  Template:=nil;

  Caption:=LanguageSetup.TemplateForm;
  TemplateTab.Caption:=LanguageSetup.TemplateForm;
  AutoSetupSheet.Caption:=LanguageSetup.TemplateFormAutoSetupCaption;

  { Menu }

  MenuFile.Caption:=LanguageSetup.MenuFile;
  MenuFileUseAsProfile.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  MenuFileUseAsDefault.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  MenuFileUse.Caption:=LanguageSetup.Use;
  MenuFileClose.Caption:=LanguageSetup.Close;
  MenuEdit.Caption:=LanguageSetup.Edit;
  MenuEditAdd.Caption:=LanguageSetup.MenuProfileAdd;
  MenuEditAddNewTemplate.Caption:=LanguageSetup.TemplateFormNewTemplate;
  MenuEditAddTemplateFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;
  MenuEditAdd2.Caption:=LanguageSetup.MenuProfileAdd;
  MenuEditAdd2NewTemplate.Caption:=LanguageSetup.TemplateFormNewTemplate;
  MenuEditAdd2TemplateFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;
  MenuEditEditMultipleTemplates.Caption:=LanguageSetup.TemplateFormEditMultipleTemplates;
  MenuEditEdit.Caption:=LanguageSetup.MenuProfileEdit;
  MenuEditEdit2.Caption:=LanguageSetup.MenuProfileEdit;
  MenuEditEditMultipleTemplates2.Caption:=LanguageSetup.TemplateFormEditMultipleTemplates;
  MenuEditDelete.Caption:=LanguageSetup.Del;
  MenuEditDelete2.Caption:=LanguageSetup.Del;

  { Template sheet }

  CloseButton.Caption:=LanguageSetup.Close;
  UseButton.Caption:=LanguageSetup.Use;
  PopupUseProfile2.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault2.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  AddButton.Caption:=LanguageSetup.Add;
  EditButton.Caption:=LanguageSetup.Edit;
  DeleteButton.Caption:=LanguageSetup.Del;

  PopupUse.Caption:=LanguageSetup.Use;
  PopupUseProfile.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault.Caption:=LanguageSetup.TemplateFormUseAsDefault;
  PopupEdit.Caption:=LanguageSetup.Edit;
  PopupCopy.Caption:=LanguageSetup.TemplateFormCopy;
  PopupDel.Caption:=LanguageSetup.Del;

  PopupUseProfile2.Caption:=LanguageSetup.TemplateFormUseAsProfile;
  PopupUseDefault2.Caption:=LanguageSetup.TemplateFormUseAsDefault;

  PopupAddNew.Caption:=LanguageSetup.TemplateFormNewTemplate;
  PopupAddFromProfile.Caption:=LanguageSetup.TemplateFormNewFromProfile;

  { AutoSetup sheet }

  CloseButton2.Caption:=LanguageSetup.Close;
  AddButton2.Caption:=LanguageSetup.Add;
  EditButton2.Caption:=LanguageSetup.Edit;
  DeleteButton2.Caption:=LanguageSetup.Del;

  PopupEdit2.Caption:=LanguageSetup.Edit;
  PopupCopy2.Caption:=LanguageSetup.TemplateFormCopy;
  PopupDel2.Caption:=LanguageSetup.Del;

  PopupAddNew2.Caption:=LanguageSetup.TemplateFormNewTemplate;
  PopupAddFromProfile2.Caption:=LanguageSetup.TemplateFormNewFromProfile;

  { Init lists }

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
  PrgSetup.UpdateFile;
  DefaultTemplate:=TGame.Create(PrgSetup);
  If DefaultTemplate.Name<>'' then DefaultTemplate.Name:='';

  InitListViewForGamesList(ListView,True);
  InitListViewForGamesList(ListView2,True);
  LoadList;
  LoadList2;
  PageControlChange(Sender);
end;

procedure TTemplateForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
  DefaultTemplate.Free;
end;

procedure TTemplateForm.SelectGame(const AGame: TGame);
Var I : Integer;
begin
    For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data)=AGame then begin ListView.Selected:=ListView.Items[I]; break; end;
    ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

procedure TTemplateForm.SelectGame2(const AGame: TGame);
Var I : Integer;
begin
    For I:=0 to ListView2.Items.Count-1 do If TGame(ListView2.Items[I].Data)=AGame then begin ListView2.Selected:=ListView2.Items[I]; break; end;
    ListView2SelectItem(self,ListView2.Selected,ListView2.Selected<>nil);
end;

procedure TTemplateForm.LoadList;
Var G : TGame;
begin
  DefaultTemplate.Free;
  DefaultTemplate:=TGame.Create(PrgSetup);

  ListView.Items.BeginUpdate;
  try
    If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
    ListView.Items.Clear;
    AddGamesToList(ListView,ListViewImageList,ListViewIconImageList,ImageList,TemplateDB,DefaultTemplate,RemoveUnderline(LanguageSetup.All),'','',True,ListSort,ListSortReverse);
    SelectGame(G);
    If (ListView.Selected=nil) and (ListView.Items.Count>0) then ListView.Selected:=ListView.Items[0];

    StatusBar.Panels[0].Text:=IntToStr(ListView.Items.Count)+' '+LanguageSetup.StatisticsNumberTemplates;
  finally
    ListView.Items.EndUpdate;
  end;
end;

procedure TTemplateForm.LoadList2;
Var G : TGame;
begin
  ListView2.Items.BeginUpdate;
  try
    If ListView2.Selected<>nil then G:=TGame(ListView2.Selected.Data) else G:=nil;
    ListView2.Items.Clear;
    AddGamesToList(ListView2,ListViewImageList,ListViewIconImageList,ImageList,AutoSetupDB,RemoveUnderline(LanguageSetup.All),'','',True,ListSort2,ListSortReverse2);
    SelectGame2(G);
    If (ListView2.Selected=nil) and (ListView2.Items.Count>0) then ListView2.Selected:=ListView2.Items[0];

    StatusBar.Panels[1].Text:=IntToStr(ListView2.Items.Count)+' '+LanguageSetup.StatisticsNumberAutoSetupTemplates;
  finally
    ListView2.Items.EndUpdate;
  end;
end;

procedure TTemplateForm.PageControlChange(Sender: TObject);
begin
  CoolBar.Visible:=(PageControl.ActivePageIndex=0);
  CoolBar1.Visible:=(PageControl.ActivePageIndex=1);

  MenuFileUse.Visible:=CoolBar.Visible;
  MenuEditAdd.Visible:=CoolBar.Visible;
  MenuEditEdit.Visible:=CoolBar.Visible;
  MenuEditEditMultipleTemplates.Visible:=CoolBar.Visible;
  MenuEditDelete.Visible:=CoolBar.Visible;

  MenuEditAdd2.Visible:=CoolBar1.Visible;
  MenuEditEdit2.Visible:=CoolBar1.Visible;
  MenuEditEditMultipleTemplates2.Visible:=CoolBar1.Visible;
  MenuEditDelete2.Visible:=CoolBar1.Visible;
end;

procedure TTemplateForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B,B2 : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  B2:=B and (TGame(Item.Data)<>DefaultTemplate);

  UseButton.Enabled:=B;
  EditButton.Enabled:=B;
  DeleteButton.Enabled:=B2;

  PopupUse.Enabled:=B;
  PopupEdit.Enabled:=B;
  PopupDel.Enabled:=B2;

  PopupUseDefault.Enabled:=B2;
  PopupUseDefault2.Enabled:=B2;

  MenuFileUse.Enabled:=B;
  MenuFileUseAsDefault.Enabled:=B2;
  MenuEditEdit.Enabled:=B;
  MenuEditDelete.Enabled:=B;
end;

procedure TTemplateForm.ListView2SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  EditButton2.Enabled:=B;
  DeleteButton2.Enabled:=B;

  PopupEdit2.Enabled:=B;
  PopupDel2.Enabled:=B;

  MenuEditEdit2.Enabled:=B;
  MenuEditDelete2.Enabled:=B;
end;

procedure TTemplateForm.ListViewAdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  DefaultDraw:=True;
  If (Item<>nil) and (Item.Data<>nil) and (TGame(Item.Data)=DefaultTemplate) then TListview(Sender).Canvas.Font.Color:=clBlue else TListview(Sender).Canvas.Font.Color:=clWindowText;
end;

procedure TTemplateForm.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort,ListSortReverse);
  LoadList;
end;

procedure TTemplateForm.ListView2ColumnClick(Sender: TObject; Column: TListColumn);
begin
  SetSortTypeByListViewCol(Column.Index,ListSort2,ListSortReverse2);
  LoadList2;
end;

procedure TTemplateForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(EditButton); exit; end;
  if Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(AddButton);
    VK_DELETE : ButtonWork(DeleteButton);
    VK_F2     : ButtonWork(EditButton);
  end;
end;

procedure TTemplateForm.ListView2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(EditButton2); exit; end;
  if Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(AddButton2);
    VK_DELETE : ButtonWork(DeleteButton2);
    VK_F2     : ButtonWork(EditButton2);
  end;
end;

procedure TTemplateForm.ButtonWork(Sender: TObject);
Var G,G2 : TGame;
    P : TPoint;
    S : String;
    L : TList;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          {Template: Use button}
          P:=ToolBar.ClientToScreen(Point(UseButton.Left+5,UseButton.Top+5));
          UsePopupMenu.Popup(P.X,P.Y);
        end;
    2 : begin
          {Template: Add button}
          P:=ToolBar.ClientToScreen(Point(AddButton.Left+5,AddButton.Top+5));
          AddPopupMenu.Popup(P.X,P.Y);
        end;
    3 : begin
          {Template: Edit button}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          L:=TList.Create;
          try
            For I:=0 to ListView.Items.Count-1 do L.Add(ListView.Items[I].Data);
            G:=TGame(ListView.Selected.Data);
            If PrgSetup.DFendStyleProfileEditor then begin
              if not EditGameTemplate(self,TemplateDB,G,nil,L) then exit;
            end else begin
              if not ModernEditGameTemplate(self,TemplateDB,G,nil,L) then exit;
            end;
            G.LoadCache;
            LoadList;
            SelectGame(G);
          finally
            L.Free;
          end;
        end;
    4 : begin
          {Template: Delete buton}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          If PrgSetup.AskBeforeDelete then begin
            if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecord,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;
          if not TemplateDB.Delete(G) then exit;
          LoadList;
        end;
    5 : begin
          {Template: Use for new profile}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
             MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
           end;
           Template:=TGame(ListView.Selected.Data); Close;
        end;
    6 : begin
          {Template: Use a new default template}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
             MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
           end;
           DefaultTemplate.AssignFrom(TGame(ListView.Selected.Data));
           DefaultTemplate.Name:='';
           LoadList;
        end;
    7 : begin
          {Template: Add new}
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,TemplateDB,G,DefaultTemplate) then exit;
          end else begin
            if not ModernEditGameTemplate(self,TemplateDB,G,DefaultTemplate) then exit;
          end;
          G.LoadCache;
          LoadList;
          SelectGame(G);
        end;
    8 : begin
          {Template: Add from profile}
          G2:=SelectProfile(self,GameDB);
          If G2=nil then exit;
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,TemplateDB,G,G2) then exit;
          end else begin
            if not ModernEditGameTemplate(self,TemplateDB,G,G2) then exit;
          end;
          G.LoadCache;
          LoadList;
          SelectGame(G);
        end;
    9 : begin
          {Template: Copy}
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
          G:=TemplateDB[TemplateDB.Add(S)];
          G.AssignFrom(TGame(ListView.Selected.Data));
          G.Name:=S;
          G.LoadCache;
          G.StoreAllValues;
          LoadList;
          SelectGame(G);
        end;
   10 : begin
          {AutoSetup: Add button}
          P:=ToolBar.ClientToScreen(Point(AddButton2.Left+5,AddButton2.Top+5));
          AddPopupMenu2.Popup(P.X,P.Y);
        end;
   11 : begin
          {AutoSetup: Edit button}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          L:=TList.Create;
          try
            For I:=0 to ListView2.Items.Count-1 do L.Add(ListView2.Items[I].Data);
            G:=TGame(ListView2.Selected.Data);
            If PrgSetup.DFendStyleProfileEditor then begin
              if not EditGameTemplate(self,AutoSetupDB,G,nil,L) then exit;
            end else begin
              if not ModernEditGameTemplate(self,AutoSetupDB,G,nil,L) then exit;
            end;
            G.LoadCache;
            LoadList2;
            SelectGame2(G);
          finally
            L.Free;
          end;
        end;
   12 : begin
          {AutoSetup: Del button}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView2.Selected.Data);
          If PrgSetup.AskBeforeDelete then begin
            if MessageDlg(Format(LanguageSetup.MessageConfirmationDeleteRecord,[G.Name]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;
          if not AutoSetupDB.Delete(G) then exit;
          LoadList2;
        end;
   13 : begin
          {AutoSetup: Add new}
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameTemplate(self,AutoSetupDB,G,DefaultTemplate) then exit;
          end else begin
            if not ModernEditGameTemplate(self,AutoSetupDB,G,DefaultTemplate) then exit;
          end;
          G.LoadCache;
          LoadList2;
          SelectGame(G);
        end;
   14 : begin
          {AutoSetup: Add from profile}
          if not ShowSelectProfilesDialog(self,GameDB,L) then exit;
          try
            For I:=0 to L.Count-1 do begin
              {Create Checksums if there are none}
              CreateGameCheckSum(TGame(L[I]),False);
              CreateSetupCheckSum(TGame(L[I]),False);

              {Copy to template}
              G:=AutoSetupDB[AutoSetupDB.Add(TGame(L[I]).Name)];
              G.AssignFrom(TGame(L[I]));

              {Delete not template-useable values}
              If Trim(G.GameExe)<>'' then G.GameExe:=ExtractFileName(G.GameExe);
              If Trim(G.SetupExe)<>'' then G.SetupExe:=ExtractFileName(G.SetupExe);
              G.CaptureFolder:='';
              G.DataDir:='';
              G.ExtraDirs:='';
              G.ExtraFiles:='';
              G.CustomDOSBoxDir:='';
              G.LoadCache;
              G.StoreAllValues;
            end;
            LoadList2;
          finally
            L.Free;
          end;
        end;
   15 : begin
          {AutoSetup: Copy}
          If (ListView2.Selected=nil) or (ListView2.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
          G:=AutoSetupDB[AutoSetupDB.Add(S)];
          G.AssignFrom(TGame(ListView2.Selected.Data));
          G.Name:=S;
          G.LoadCache;
          G.StoreAllValues;
          LoadList2;
          SelectGame2(G);
        end;
   16 : begin
          {Template: Multi edit}
          ShowChangeProfilesDialog(self,TemplateDB,True);
          If ListView.Selected=nil then G:=nil else G:=TGame(ListView.Selected.Data);
          LoadList;
          SelectGame(G);
        end;
   17 : begin
          {AutoSetup: Multi edit}
          ShowChangeProfilesDialog(self,AutoSetupDB,True);
          If ListView2.Selected=nil then G:=nil else G:=TGame(ListView2.Selected.Data);
          LoadList2;
          SelectGame2(G);
        end;
  end;
end;

{ global }

Function ShowTemplateDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
begin
  result:=nil;
  TemplateForm:=TTemplateForm.Create(AOwner);
  try
    TemplateForm.GameDB:=AGameDB;
    TemplateForm.ShowModal;
    if TemplateForm.Template=nil then exit;
    If PrgSetup.DFendStyleProfileEditor then begin
      EditGameProfil(AOwner,AGameDB,result,TemplateForm.Template);
    end else begin
      ModernEditGameProfil(AOwner,AGameDB,result,TemplateForm.Template);
    end;
  finally
    TemplateForm.Free;
  end;
end;

end.
