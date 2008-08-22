unit SetupFrameSecurityUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameSecurity = class(TFrame, ISetupFrame)
    AskBeforeDeleteCheckBox: TCheckBox;
    DeleteProectionCheckBox: TCheckBox;
    DeleteProectionLabel: TLabel;
    UseChecksumsCheckBox: TCheckBox;
    UseChecksumsLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameSecurity }

function TSetupFrameSecurity.GetName: String;
begin
  result:=LanguageSetup.SetupFormSecuritySheet;
end;

procedure TSetupFrameSecurity.InitGUIAndLoadSetup(InitData: TInitData);
begin
  AskBeforeDeleteCheckBox.Checked:=PrgSetup.AskBeforeDelete;
  DeleteProectionCheckBox.Checked:=PrgSetup.DeleteOnlyInBaseDir;
  UseChecksumsCheckBox.Checked:=PrgSetup.UseCheckSumsForProfiles;
end;

procedure TSetupFrameSecurity.LoadLanguage;
begin
  NoFlicker(AskBeforeDeleteCheckBox);
  NoFlicker(DeleteProectionCheckBox);
  NoFlicker(UseChecksumsCheckBox);

  AskBeforeDeleteCheckBox.Caption:=LanguageSetup.SetupFormAskBeforeDelete;
  DeleteProectionCheckBox.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDir;
  DeleteProectionLabel.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDirLabel;
  UseChecksumsCheckBox.Caption:=LanguageSetup.SetupFormUseChecksums;
  UseChecksumsLabel.Caption:=LanguageSetup.SetupFormUseChecksumsInfo;

  HelpContext:=ID_FileOptionsSecurity;
end;

procedure TSetupFrameSecurity.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameSecurity.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameSecurity.RestoreDefaults;
begin
  AskBeforeDeleteCheckBox.Checked:=True;
  DeleteProectionCheckBox.Checked:=True;
  UseChecksumsCheckBox.Checked:=True;
end;

procedure TSetupFrameSecurity.SaveSetup;
begin
  PrgSetup.AskBeforeDelete:=AskBeforeDeleteCheckBox.Checked;
  PrgSetup.DeleteOnlyInBaseDir:=DeleteProectionCheckBox.Checked;
  PrgSetup.UseCheckSumsForProfiles:=UseChecksumsCheckBox.Checked;
end;

end.
