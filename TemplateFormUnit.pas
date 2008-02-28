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
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton7: TToolButton;
    UseButton: TToolButton;
    ToolButton3: TToolButton;
    AddButton: TToolButton;
    EditButton: TToolButton;
    DeleteButton: TToolButton;
    ListView: TListView;
    AutoSetupSheet: TTabSheet;
    CoolBar1: TCoolBar;
    ToolBar2: TToolBar;
    CloseButton2: TToolButton;
    ToolButton2: TToolButton;
    AddButton2: TToolButton;
    EditButton2: TToolButton;
    DeleteButton2: TToolButton;
    ListView2: TListView;
    AddPopupMenu2: TPopupMenu;
    PopupAddNew2: TMenuItem;
    PopupAddFromProfile2: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupEdit2: TMenuItem;
    PopupCopy2: TMenuItem;
    PopupDel2: TMenuItem;
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
  private
    { Private-Deklarationen }
    TemplateDB, AutoSetupDB : TGameDB;
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
     ModernProfileEditorFormUnit, SelectProfilesFormUnit;

{$R *.dfm}

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  DoubleBuffered:=True;
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

  //AutoSetupSheet.Caption:=LanguageSetup.TemplateFormAutoSetupCaption;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then AutoSetupSheet.Caption:='Autosetup Vorlagen'
    else AutoSetupSheet.Caption:='Auto setup '+LowerCase(LanguageSetup.TemplateForm);
  AutoSetupSheet.TabVisible:=PrgSetup.ShowAutoSetupTemplateEdit;

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

  InitListViewForGamesList(ListView,True);
  InitListViewForGamesList(ListView2,True);
  LoadList;
  LoadList2;
end;

procedure TTemplateForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
  AutoSetupDB.Free;
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
  ListView.Items.BeginUpdate;
  try
    If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
    ListView.Items.Clear;
    AddGamesToList(ListView,ListViewImageList,ListViewIconImageList,ImageList,TemplateDB,RemoveUnderline(LanguageSetup.All),'','',True,ListSort,ListSortReverse);
    SelectGame(G);
    If (ListView.Selected=nil) and (ListView.Items.Count>0) then ListView.Selected:=ListView.Items[0];
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
  finally
    ListView2.Items.EndUpdate;
  end;
end;

procedure TTemplateForm.ListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  UseButton.Enabled:=B;
  EditButton.Enabled:=B;
  DeleteButton.Enabled:=B;

  PopupUse.Enabled:=B;
  PopupEdit.Enabled:=B;
  PopupDel.Enabled:=B;
end;

procedure TTemplateForm.ListView2SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
Var B : Boolean;
begin
  B:=Selected and (Item<>nil) and (Item.Data<>nil);

  EditButton2.Enabled:=B;
  DeleteButton2.Enabled:=B;

  PopupEdit2.Enabled:=B;
  PopupDel2.Enabled:=B;
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
Var G, DefaultGame : TGame;
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
              if not EditGameProfil(self,TemplateDB,G,nil,L) then exit;
            end else begin
              if not ModernEditGameProfil(self,TemplateDB,G,nil,L) then exit;
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
           DefaultGame:=TGame.Create(PrgSetup);
           try
             DefaultGame.AssignFrom(TGame(ListView.Selected.Data));
           finally
             DefaultGame.Free;
           end;
           Close;
        end;
    7 : begin
          {Template: Add new}
          G:=nil;
          DefaultGame:=TGame.Create(PrgSetup);
          try
            If PrgSetup.DFendStyleProfileEditor then begin
              if not EditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
            end else begin
              if not ModernEditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
            end;
          finally
            DefaultGame.Free;
          end;
          G.LoadCache;
          LoadList;
          SelectGame(G);
        end;
    8 : begin
          {Template: Add from profile}
          DefaultGame:=SelectProfile(self,GameDB);
          If DefaultGame=nil then exit;
          G:=nil;
          If PrgSetup.DFendStyleProfileEditor then begin
            if not EditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
          end else begin
            if not ModernEditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
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
              if not EditGameProfil(self,AutoSetupDB,G,nil,L) then exit;
            end else begin
              if not ModernEditGameProfil(self,AutoSetupDB,G,nil,L) then exit;
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
          DefaultGame:=TGame.Create(PrgSetup);
          try
            If PrgSetup.DFendStyleProfileEditor then begin
              if not EditGameProfil(self,AutoSetupDB,G,DefaultGame) then exit;
            end else begin
              if not ModernEditGameProfil(self,AutoSetupDB,G,DefaultGame) then exit;
            end;
          finally
            DefaultGame.Free;
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
              G.CaptureFolder:='';
              G.DataDir:='';
              G.ExtraDirs:='';
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
