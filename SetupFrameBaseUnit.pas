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
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools;

{$R *.dfm}

{ TSetupFrameBase }

function TSetupFrameBase.GetName: String;
begin
  result:=LanguageSetup.SetupFormGeneralSheet;
end;

procedure TSetupFrameBase.InitGUIAndLoadSetup(InitData : TInitData);
begin
  NoFlicker(MinimizeToTrayCheckBox);
  NoFlicker(StartWithWindowsCheckBox);

  MinimizeToTrayCheckBox.Checked:=PrgSetup.MinimizeToTray;
  StartWithWindowsCheckBox.Checked:=PrgSetup.StartWithWindows;
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
