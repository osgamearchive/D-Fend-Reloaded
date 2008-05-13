unit SetupFrameSurfaceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, SetupFormUnit;

type
  TSetupFrameSurface = class(TFrame, ISetupFrame)
    StartSizeLabel: TLabel;
    StartSizeComboBox: TComboBox;
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

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit;

{$R *.dfm}

{ TSetupFrameSurface }

function TSetupFrameSurface.GetName: String;
begin
  result:=LanguageSetup.SetupFormGUI;
end;

procedure TSetupFrameSurface.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(StartSizeComboBox);

  StartSizeComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.StartWindowSize));
end;

procedure TSetupFrameSurface.LoadLanguage;
Var I : Integer;
begin
  StartSizeLabel.Caption:=LanguageSetup.SetupFormStartSizeLabel;
  I:=StartSizeComboBox.ItemIndex;
  StartSizeComboBox.Items[0]:=LanguageSetup.SetupFormStartSizeNormal;
  StartSizeComboBox.Items[1]:=LanguageSetup.SetupFormStartSizeLast;
  StartSizeComboBox.Items[2]:=LanguageSetup.SetupFormStartSizeMinimized;
  StartSizeComboBox.Items[3]:=LanguageSetup.SetupFormStartSizeMaximized;
  StartSizeComboBox.ItemIndex:=I;
end;

procedure TSetupFrameSurface.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameSurface.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameSurface.RestoreDefaults;
begin
  StartSizeComboBox.ItemIndex:=0;
end;

procedure TSetupFrameSurface.SaveSetup;
begin
  PrgSetup.StartWindowSize:=StartSizeComboBox.ItemIndex;
end;


end.
