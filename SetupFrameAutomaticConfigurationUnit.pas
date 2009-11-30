unit SetupFrameAutomaticConfigurationUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameAutomaticConfiguration = class(TFrame, ISetupFrame)
    ZipImportGroupBox: TGroupBox;
    WizardRadioGroup: TRadioGroup;
    ZipImportCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Math, PrgSetupUnit, LanguageSetupUnit, VistaToolsUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameAutomaticConfiguration }

function TSetupFrameAutomaticConfiguration.GetName: String;
begin
  result:=LanguageSetup.SetupFormAutomaticConfiguration;
end;

procedure TSetupFrameAutomaticConfiguration.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  WizardRadioGroup.Items.Clear;
  For I:=0 to 2 do WizardRadioGroup.Items.Add('');

  NoFlicker(ZipImportGroupBox);
  NoFlicker(ZipImportCheckBox);
  NoFlicker(WizardRadioGroup);

  ZipImportCheckBox.Checked:=PrgSetup.ImportZipWithoutDialogIfPossible;
  WizardRadioGroup.ItemIndex:=Max(0,Min(2,PrgSetup.LastWizardMode));
end;

procedure TSetupFrameAutomaticConfiguration.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameAutomaticConfiguration.LoadLanguage;
Var I : Integer;
begin
  ZipImportGroupBox.Caption:=LanguageSetup.SetupFormAutomaticConfigurationArchiveImport;
  ZipImportCheckBox.Caption:=LanguageSetup.SetupFormAutomaticConfigurationArchiveImportNoDialog;
  I:=WizardRadioGroup.ItemIndex;
  WizardRadioGroup.Caption:=LanguageSetup.WizardFormWizardMode;
  WizardRadioGroup.Items[0]:=LanguageSetup.WizardFormWizardModeAlwaysAutomatically;
  WizardRadioGroup.Items[1]:=LanguageSetup.WizardFormWizardModeAutomaticallyIfAutoSetupTemplateExists;
  WizardRadioGroup.Items[2]:=LanguageSetup.WizardFormWizardModeAlwaysAllPages;
  WizardRadioGroup.ItemIndex:=I;

  HelpContext:=ID_FileOptionsAutomaticConfiguration;
end;

procedure TSetupFrameAutomaticConfiguration.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameAutomaticConfiguration.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameAutomaticConfiguration.HideFrame;
begin
end;

procedure TSetupFrameAutomaticConfiguration.RestoreDefaults;
begin
  PrgSetup.ImportZipWithoutDialogIfPossible:=True;
  PrgSetup.LastWizardMode:=1;
end;

procedure TSetupFrameAutomaticConfiguration.SaveSetup;
begin
  PrgSetup.ImportZipWithoutDialogIfPossible:=ZipImportCheckBox.Checked;
  PrgSetup.LastWizardMode:=WizardRadioGroup.ItemIndex;
end;

end.
