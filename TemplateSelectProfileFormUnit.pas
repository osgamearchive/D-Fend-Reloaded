unit TemplateSelectProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, GameDBUnit, ImgList;

type
  TTemplateSelectProfileForm = class(TForm)
    ListView: TListView;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ImageList: TImageList;
    ListViewImageList: TImageList;
    ListviewIconImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
  end;

var
  TemplateSelectProfileForm: TTemplateSelectProfileForm;

Function SelectProfile(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;

implementation

uses VistaToolsUnit, LanguageSetupUnit, GameDBToolsUnit;

{$R *.dfm}

procedure TTemplateSelectProfileForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.TemplateFormNewFromProfileCaption;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
end;

procedure TTemplateSelectProfileForm.FormShow(Sender: TObject);
begin
  InitListViewForGamesList(ListView,True);
  AddGamesToList(ListView,ListViewImageList,ListviewIconImageList,ImageList,GameDB,'','','',True);
  Game:=nil;
end;

procedure TTemplateSelectProfileForm.OKButtonClick(Sender: TObject);
begin
  If (ListView.Selected=nil) or (ListView.Selected.Data=nil) then begin
    MessageDlg(LanguageSetup.MessageNoGameSelected,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  Game:=TGame(ListView.Selected.Data);
end;

Function SelectProfile(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
begin
  TemplateSelectProfileForm:=TTemplateSelectProfileForm.Create(AOwner);
  try
    TemplateSelectProfileForm.GameDB:=AGameDB;
    If TemplateSelectProfileForm.ShowModal=mrOK then begin
      result:=TemplateSelectProfileForm.Game;
    end else begin
      result:=nil;
    end;
  finally
    TemplateSelectProfileForm.Free;
  end;
end;

end.
