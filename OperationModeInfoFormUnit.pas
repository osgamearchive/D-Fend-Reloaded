unit OperationModeInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, ValEdit;

type
  TOperationModeInfoForm = class(TForm)
    TopLabel: TLabel;
    OpModeLabel: TLabel;
    OKButton: TBitBtn;
    PrgDirEdit: TLabeledEdit;
    PrgDataDirEdit: TLabeledEdit;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  OperationModeInfoForm: TOperationModeInfoForm;

Procedure ShowOperationModeInfoDialog(const AOwner : TComponent);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

procedure TOperationModeInfoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  OpModeLabel.Font.Style:=[fsBold];

  Caption:='D-Fend Reloaded operation mode';
  OKButton.Caption:=LanguageSetup.OK;

  Case OperationMode of
    omPrgDir   : begin
                   OpModeLabel.Caption:='Program directroy mode';
                   CheckBox1.Checked:=True;
                   CheckBox2.Checked:=False;
                   CheckBox3.Checked:=True;
                   CheckBox4.Checked:=False;
                   CheckBox5.Checked:=False;
                 end;
    omUserDir  : begin
                   OpModeLabel.Caption:='User directroy mode';
                   CheckBox1.Checked:=False;
                   CheckBox2.Checked:=True;
                   CheckBox3.Checked:=False;
                   CheckBox4.Checked:=True;
                   CheckBox5.Checked:=False;
                 end;
    omPortable : begin
                   OpModeLabel.Caption:='Portable mode';
                   CheckBox1.Checked:=True;
                   CheckBox2.Checked:=False;
                   CheckBox3.Checked:=True;
                   CheckBox4.Checked:=True;
                   CheckBox5.Checked:=True;
                 end;
  end;

  PrgDirEdit.EditLabel.Caption:='Directory for D-Fend Reloaded program files';
  PrgDirEdit.Text:=PrgDir;

  PrgDataDirEdit.EditLabel.Caption:='Directory for data files (games, profiles, settings, etc.)';
  PrgDataDirEdit.Text:=PrgDataDir;
end;

{ global }

Procedure ShowOperationModeInfoDialog(const AOwner : TComponent);
begin
  OperationModeInfoForm:=TOperationModeInfoForm.Create(AOwner);
  try
    OperationModeInfoForm.ShowModal;
  finally
    OperationModeInfoForm.Free;
  end;
end;

end.
