unit DOSBoxFailedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit;

type
  TDOSBoxFailedForm = class(TForm)
    OKButton: TBitBtn;
    InfoLabel: TLabel;
    CloseDOSBoxCheckBox: TCheckBox;
    RenderLabel: TLabel;
    RenderComboBox: TComboBox;
    DoNotShowAgainCheckBox: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
  end;

var
  DOSBoxFailedForm: TDOSBoxFailedForm;

Procedure ShowDOSBoxFailedDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame);

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit;

{$R *.dfm}

procedure TDOSBoxFailedForm.FormShow(Sender: TObject);
Var St : TStringList;
    S : String;
    I : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.DOSBoxStartFailed;
  InfoLabel.Caption:=LanguageSetup.DOSBoxStartFailedInfo;
  CloseDOSBoxCheckBox.Caption:=LanguageSetup.GameCloseDOSBoxAfterGameExit;
  RenderLabel.Caption:=LanguageSetup.GameRender;
  St:=ValueToList(GameDB.ConfOpt.Render,';,'); try RenderComboBox.Items.AddStrings(St); finally St.Free; end;
  DoNotShowAgainCheckBox.Caption:=LanguageSetup.DOSBoxStartFailedTurnOff;

  OKButton.Caption:=LanguageSetup.OK;
  UserIconLoader.DialogImage(DI_OK,OKButton);

  CloseDOSBoxCheckBox.Checked:=Game.CloseDosBoxAfterGameExit;
  S:=Trim(ExtUpperCase(Game.Render));
  RenderComboBox.ItemIndex:=0;
  For I:=0 to RenderComboBox.Items.Count-1 do If Trim(ExtUpperCase(RenderComboBox.Items[I]))=S then begin
    RenderComboBox.ItemIndex:=I; break;
  end;
  DoNotShowAgainCheckBox.Checked:=False;
end;

procedure TDOSBoxFailedForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Game.CloseDosBoxAfterGameExit:=CloseDOSBoxCheckBox.Checked;
  Game.Render:=RenderComboBox.Text;
  //... Game.NoDOSBoxFailedDialog:=DoNotShowAgainCheckBox.Checked;
  Game.StoreAllValues;
end;

{ global }

Procedure ShowDOSBoxFailedDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame);
begin
  //... If AGame.NoDOSBoxFailedDialog then exit;
  DOSBoxFailedForm:=TDOSBoxFailedForm.Create(AOwner);
  try
    DOSBoxFailedForm.GameDB:=AGameDB;
    DOSBoxFailedForm.Game:=AGame;
    DOSBoxFailedForm.ShowModal;
  finally
    DOSBoxFailedForm.Free;
  end;
end;

end.
