unit TemplateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, Menus, GameDBUnit;

type
  TTemplateForm = class(TForm)
    ListView: TListView;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    PopupUse: TMenuItem;
    N1: TMenuItem;
    PopupEdit: TMenuItem;
    PopupDel: TMenuItem;
    ListViewImageList: TImageList;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton7: TToolButton;
    UseButton: TToolButton;
    ToolButton3: TToolButton;
    AddButton: TToolButton;
    EditButton: TToolButton;
    DeleteButton: TToolButton;
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
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private-Deklarationen }
    TemplateDB : TGameDB;
    Procedure LoadList;
    procedure SelectGame(const AGame: TGame);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Template : TGame;
  end;

var
  TemplateForm: TTemplateForm;

Function ShowTemplateDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts, GameDBToolsUnit,
     ProfileEditorFormUnit, PrgSetupUnit, TemplateSelectProfileFormUnit;

{$R *.dfm}

procedure TTemplateForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  ToolBar.DoubleBuffered:=True;
  SetVistaFonts(self);

  Template:=nil;

  Caption:=LanguageSetup.TemplateForm;
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

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);

  InitListViewForGamesList(ListView,True);
  LoadList;
end;

procedure TTemplateForm.FormDestroy(Sender: TObject);
begin
  TemplateDB.Free;
end;

procedure TTemplateForm.SelectGame(const AGame: TGame);
Var I : Integer;
begin
    For I:=0 to ListView.Items.Count-1 do If TGame(ListView.Items[I].Data)=AGame then begin ListView.Selected:=ListView.Items[I]; break; end;
    ListViewSelectItem(self,ListView.Selected,ListView.Selected<>nil);
end;

procedure TTemplateForm.LoadList;
Var G : TGame;
begin
  ListView.Items.BeginUpdate;
  try
    If ListView.Selected<>nil then G:=TGame(ListView.Selected.Data) else G:=nil;
    ListView.Items.Clear;
    AddGamesToList(ListView,ListViewImageList,ListViewIconImageList,ImageList,TemplateDB,RemoveUnderline(LanguageSetup.All),'','',True);
    SelectGame(G);
  finally
    ListView.Items.EndUpdate;
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

procedure TTemplateForm.ButtonWork(Sender: TObject);
Var G, DefaultGame : TGame;
    P : TPoint;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          P:=ToolBar.ClientToScreen(Point(UseButton.Left+5,UseButton.Top+5));
          UsePopupMenu.Popup(P.X,P.Y);
        end;
    2 : begin
          P:=ToolBar.ClientToScreen(Point(AddButton.Left+5,AddButton.Top+5));
          AddPopupMenu.Popup(P.X,P.Y);
        end;
    3 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          G:=TGame(ListView.Selected.Data);
          if not EditGameProfil(self,TemplateDB,G,nil) then exit;
          LoadList;
          SelectGame(G);
        end;
    4 : begin
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
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
             MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
           end;
           Template:=TGame(ListView.Selected.Data); Close;
        end;
    6 : begin
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
          G:=nil;
          DefaultGame:=TGame.Create(PrgSetup);
          try
            if not EditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
          finally
            DefaultGame.Free;
          end;
          LoadList;
          SelectGame(G);
        end;
    8 : begin
          DefaultGame:=SelectProfile(self,GameDB);
          G:=nil;
          if not EditGameProfil(self,TemplateDB,G,DefaultGame) then exit;
          LoadList;
          SelectGame(G);
        end;
    9 : begin
          If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
            MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0); exit;
          end;
          If not InputQuery(LanguageSetup.MenuProfileCopyTitle,LanguageSetup.MenuProfileCopyPrompt,S) then exit;
          G:=TemplateDB[TemplateDB.Add(S)];
          G.AssignFrom(TGame(ListView.Selected.Data));
          G.Name:=S;
          LoadList;
          SelectGame(G);
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
    EditGameProfil(AOwner,AGameDB,result,TemplateForm.Template);
  finally
    TemplateForm.Free;
  end;
end;

end.
