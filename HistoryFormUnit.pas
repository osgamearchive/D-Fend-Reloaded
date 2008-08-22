unit HistoryFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  THistoryForm = class(TForm)
    ListView: TListView;
    CloseButton: TBitBtn;
    ClearButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  HistoryForm: THistoryForm;

Procedure ShowHistoryDialog(const AOwner : TComponent);

implementation

uses GameDBToolsUnit, LanguageSetupUnit, VistaToolsUnit, CommonTools,
     HelpConsts;

{$R *.dfm}

procedure THistoryForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.HistoryForm;
  CloseButton.Caption:=LanguageSetup.Close;
  ClearButton.Caption:=LanguageSetup.Clear;
  HelpButton.Caption:=LanguageSetup.Help;

  LoadHistory(ListView);
end;

procedure THistoryForm.ClearButtonClick(Sender: TObject);
begin
  ClearHistory;
end;

procedure THistoryForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasViewHistory);
end;

procedure THistoryForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure ShowHistoryDialog(const AOwner : TComponent);
begin
  HistoryForm:=THistoryForm.Create(AOwner);
  try
    HistoryForm.ShowModal;
  finally
    HistoryForm.Free;
  end;
end;

end.
