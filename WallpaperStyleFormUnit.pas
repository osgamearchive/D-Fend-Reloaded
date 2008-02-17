unit WallpaperStyleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CommonTools;

type
  TWallpaperStyleForm = class(TForm)
    TileRadioButton: TRadioButton;
    CenterRadioButton: TRadioButton;
    StretchRadioButton: TRadioButton;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  WallpaperStyleForm: TWallpaperStyleForm;

Function ShowWallpaperStyleDialog(const AOwner : TComponent; var WPStyle : TWallpaperStyle) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit;

{$R *.dfm}

procedure TWallpaperStyleForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.WallpaperCaption;
  TileRadioButton.Caption:=LanguageSetup.WallpaperTile;
  CenterRadioButton.Caption:=LanguageSetup.WallpaperCenter;
  StretchRadioButton.Caption:=LanguageSetup.WallpaperStretch;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
end;

{ global }

Function ShowWallpaperStyleDialog(const AOwner : TComponent; var WPStyle : TWallpaperStyle) : Boolean;
begin
  WallpaperStyleForm:=TWallpaperStyleForm.Create(AOwner);
  try
    result:=(WallpaperStyleForm.ShowModal=mrOK);
    if result then begin
      If WallpaperStyleForm.TileRadioButton.Checked then WPStyle:=WSTile;
      If WallpaperStyleForm.CenterRadioButton.Checked then WPStyle:=WSCenter;
      If WallpaperStyleForm.StretchRadioButton.Checked then WPStyle:=WSStretch;
    end;
  finally
    WallpaperStyleForm.Free;
  end;
end;

end.
