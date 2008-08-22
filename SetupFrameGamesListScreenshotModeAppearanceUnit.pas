unit SetupFrameGamesListScreenshotModeAppearanceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, SetupFormUnit;

type
  TSetupFrameGamesListScreenshotModeAppearance = class(TFrame, ISetupFrame)
    WidthLabel: TLabel;
    HeightLabel: TLabel;
    WidthEdit: TSpinEdit;
    HeightEdit: TSpinEdit;
    UseFirstScreenshotCheckBox: TCheckBox;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TSetupFrameGamesListScreenshotModeAppearance }

function TSetupFrameGamesListScreenshotModeAppearance.GetName: String;
begin
  result:=LanguageSetup.SetupFormListViewSheet2b;
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(WidthEdit);
  NoFlicker(HeightEdit);
  NoFlicker(UseFirstScreenshotCheckBox);

  WidthEdit.Value:=PrgSetup.ScreenshotListViewWidth;
  HeightEdit.Value:=PrgSetup.ScreenshotListViewHeight;
  UseFirstScreenshotCheckBox.Checked:=PrgSetup.ScreenshotListUseFirstScreenshot;
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.LoadLanguage;
begin
  WidthLabel.Caption:=LanguageSetup.ScreenshotListViewWidth;
  HeightLabel.Caption:=LanguageSetup.ScreenshotListViewHeight;
  UseFirstScreenshotCheckBox.Caption:=LanguageSetup.ScreenshotListViewUseFirstScreenshot;

  HelpContext:=ID_FileOptionsListInScreenshotMode;
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.RestoreDefaults;
begin
  WidthEdit.Value:=150;
  HeightEdit.Value:=100;
  UseFirstScreenshotCheckBox.Checked:=True;
end;

procedure TSetupFrameGamesListScreenshotModeAppearance.SaveSetup;
begin
  PrgSetup.ScreenshotListViewWidth:=WidthEdit.Value;
  PrgSetup.ScreenshotListViewHeight:=HeightEdit.Value;
  PrgSetup.ScreenshotListUseFirstScreenshot:=UseFirstScreenshotCheckBox.Checked;
end;

end.
