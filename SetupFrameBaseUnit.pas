unit SetupFrameBaseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Spin, StdCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameBase = class(TFrame, ISetupFrame)
    MinimizeToTrayCheckBox: TCheckBox;
    StartWithWindowsCheckBox: TCheckBox;
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
    Procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TSetupFrameBase }

function TSetupFrameBase.GetName: String;
begin
  result:=LanguageSetup.SetupFormGeneralSheet;
end;

procedure TSetupFrameBase.InitGUIAndLoadSetup(var InitData : TInitData);
begin
  NoFlicker(MinimizeToTrayCheckBox);
  NoFlicker(StartWithWindowsCheckBox);

  MinimizeToTrayCheckBox.Checked:=PrgSetup.MinimizeToTray;
  StartWithWindowsCheckBox.Checked:=PrgSetup.StartWithWindows;

  HelpContext:=ID_FileOptionsGeneral;
end;

procedure TSetupFrameBase.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameBase.LoadLanguage;
begin
  MinimizeToTrayCheckBox.Caption:=LanguageSetup.SetupFormMinimizeToTray;
  StartWithWindowsCheckBox.Caption:=LanguageSetup.SetupFormStartWithWindows;
end;

procedure TSetupFrameBase.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameBase.ShowFrame(const AdvencedMode: Boolean);
begin
  StartWithWindowsCheckBox.Visible:=AdvencedMode;
end;

procedure TSetupFrameBase.HideFrame;
begin
end;

procedure TSetupFrameBase.RestoreDefaults;
begin
  MinimizeToTrayCheckBox.Checked:=False;
  StartWithWindowsCheckBox.Checked:=False;
end;

procedure TSetupFrameBase.SaveSetup;
begin
  PrgSetup.MinimizeToTray:=MinimizeToTrayCheckBox.Checked;
  PrgSetup.StartWithWindows:=StartWithWindowsCheckBox.Checked;
  SetStartWithWindows(PrgSetup.StartWithWindows);
end;

end.
