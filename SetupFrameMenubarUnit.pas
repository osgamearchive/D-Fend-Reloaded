unit SetupFrameMenubarUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameMenubar = class(TFrame, ISetupFrame)
    ShowMenubarCheckBox: TCheckBox;
    ShowMenubarLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     HelpConsts;

{$R *.dfm}

{ TSetupFrameMenubar }

function TSetupFrameMenubar.GetName: String;
begin
  result:=LanguageSetup.SetupFormShowMenubar;
end;

procedure TSetupFrameMenubar.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(ShowMenubarCheckBox);

  ShowMenubarCheckBox.Checked:=PrgSetup.ShowMainMenu;
end;

procedure TSetupFrameMenubar.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameMenubar.LoadLanguage;
begin
  ShowMenubarCheckBox.Caption:=LanguageSetup.MenuViewShowMenubar;
  ShowMenubarLabel.Caption:=LanguageSetup.MenuViewShowMenubarRestoreInfo;

  HelpContext:=ID_FileOptionsMenubar;
end;

procedure TSetupFrameMenubar.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameMenubar.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameMenubar.HideFrame;
begin
end;

procedure TSetupFrameMenubar.RestoreDefaults;
begin
  ShowMenubarCheckBox.Checked:=True;
end;

procedure TSetupFrameMenubar.SaveSetup;
begin
  PrgSetup.ShowMainMenu:=ShowMenubarCheckBox.Checked;
end;

end.
