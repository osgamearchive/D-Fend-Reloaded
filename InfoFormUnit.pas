unit InfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TInfoForm = class(TForm)
    PageControl: TPageControl;
    MainSheet: TTabSheet;
    LicenseSheet: TTabSheet;
    CompLicenseSheet: TTabSheet;
    BitBtn1: TBitBtn;
    VersionLabel: TLabel;
    Label1: TLabel;
    WrittenByLabel: TLabel;
    eMailLabel: TLabel;
    CompLicenseMemo: TRichEdit;
    LicenseMemo: TRichEdit;
    HomepageLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure HomepageLabelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  InfoForm: TInfoForm;

Procedure ShowInfoDialog(const AOwner : TComponent);

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

procedure TInfoForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.InfoForm;
  MainSheet.Caption:=LanguageSetup.InfoFormMain;
  LicenseSheet.Caption:=LanguageSetup.InfoFormLicense;
  CompLicenseSheet.Caption:=LanguageSetup.InfoFormCompLicense;
  VersionLabel.Caption:=GetFileVersionAsString+' ('+GetFileDateAsString+')';
  WrittenByLabel.Caption:=LanguageSetup.InfoFormWrittenBy+' Alexander Herzog';
  eMailLabel.Caption:='Alexander dot Herzog at gmx dot de';

  try LicenseMemo.Lines.LoadFromFile(PrgDir+'License.txt'); except end;
  try CompLicenseMemo.Lines.LoadFromFile(PrgDir+'LicenseComponents.txt'); except end;
end;

procedure TInfoForm.HomepageLabelClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar(HomepageLabel.Caption),nil,nil,SW_SHOW);
end;

{ global }

Procedure ShowInfoDialog(const AOwner : TComponent);
begin
  InfoForm:=TInfoForm.Create(AOwner);
  try
    InfoForm.ShowModal;
  finally
    InfoForm.Free;
  end;
end;

end.
