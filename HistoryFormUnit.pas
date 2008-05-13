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
    procedure FormShow(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  HistoryForm: THistoryForm;

Procedure ShowHistoryDialog(const AOwner : TComponent);

implementation

uses GameDBToolsUnit, LanguageSetupUnit, VistaToolsUnit, CommonTools;

{$R *.dfm}

procedure THistoryForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.HistoryForm;
  CloseButton.Caption:=LanguageSetup.Close;
  ClearButton.Caption:=LanguageSetup.Clear;

  LoadHistory(ListView);
end;

procedure THistoryForm.ClearButtonClick(Sender: TObject);
begin
  ClearHistory;
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
