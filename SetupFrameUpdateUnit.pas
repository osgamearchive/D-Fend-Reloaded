unit SetupFrameUpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, SetupFormUnit, StdCtrls;

type
  TSetupFrameUpdate = class(TFrame, ISetupFrame)
    Update0RadioButton: TRadioButton;
    Update1RadioButton: TRadioButton;
    Update2RadioButton: TRadioButton;
    Update3RadioButton: TRadioButton;
    UpdateCheckBox: TCheckBox;
    UpdateLabel: TLabel;
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

{ TSetupFrameUpdate }

function TSetupFrameUpdate.GetName: String;
begin
  result:=LanguageSetup.MenuHelpUpdates;
  While (result<>'') and (result[length(result)]='.') do SetLength(result,length(result)-1);
end;

procedure TSetupFrameUpdate.InitGUIAndLoadSetup(InitData: TInitData);
begin
  case PrgSetup.CheckForUpdates of
    0 : Update0RadioButton.Checked:=True;
    1 : Update1RadioButton.Checked:=True;
    2 : Update2RadioButton.Checked:=True;
    3 : Update3RadioButton.Checked:=True;
  end;
  UpdateCheckBox.Checked:=PrgSetup.VersionSpecificUpdateCheck;
end;

procedure TSetupFrameUpdate.LoadLanguage;
begin
  Update0RadioButton.Caption:=LanguageSetup.SetupFormUpdate0;
  Update1RadioButton.Caption:=LanguageSetup.SetupFormUpdate1;
  Update2RadioButton.Caption:=LanguageSetup.SetupFormUpdate2;
  Update3RadioButton.Caption:=LanguageSetup.SetupFormUpdate3;
  UpdateCheckBox.Caption:=LanguageSetup.SetupFormUpdateVersionSpecific;
  UpdateLabel.Caption:=LanguageSetup.SetupFormUpdateInfo;

  HelpContext:=ID_FileOptionsSearchForUpdates;
end;

procedure TSetupFrameUpdate.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameUpdate.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameUpdate.RestoreDefaults;
begin
  Update0RadioButton.Checked:=True;
  UpdateCheckBox.Checked:=True;
end;

procedure TSetupFrameUpdate.SaveSetup;
begin
  If Update0RadioButton.Checked then PrgSetup.CheckForUpdates:=0;
  If Update1RadioButton.Checked then PrgSetup.CheckForUpdates:=1;
  If Update2RadioButton.Checked then PrgSetup.CheckForUpdates:=2;
  If Update3RadioButton.Checked then PrgSetup.CheckForUpdates:=3;
  PrgSetup.VersionSpecificUpdateCheck:=UpdateCheckBox.Checked;
end;

end.
