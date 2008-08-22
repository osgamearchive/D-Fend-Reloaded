unit ModernProfileEditorMIDIFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorMIDIFrame = class(TFrame, IModernProfileEditorFrame)
    TypeLabel: TLabel;
    TypeComboBox: TComboBox;
    DeviceLabel: TLabel;
    DeviceComboBox: TComboBox;
    AdditionalSettingsEdit: TLabeledEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorMIDIFrame }

procedure TModernProfileEditorMIDIFrame.InitGUI(const InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(TypeComboBox);
  NoFlicker(DeviceComboBox);
  NoFlicker(AdditionalSettingsEdit);

  TypeLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIType;
  St:=ValueToList(InitData.GameDB.ConfOpt.MPU401,';,'); try TypeComboBox.Items.AddStrings(St); finally St.Free; end;
  DeviceLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIDevice;
  St:=ValueToList(InitData.GameDB.ConfOpt.MIDIDevice,';,'); try DeviceComboBox.Items.AddStrings(St); finally St.Free; end;
  AdditionalSettingsEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigInfo;

  HelpContext:=ID_ProfileEditSoundMIDI;
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : Integer); overload;
Var S : String;
    I : Integer;
begin
  try ComboBox.ItemIndex:=Default; except end;
  S:=Trim(ExtUpperCase(Value));
  For I:=0 to ComboBox.Items.Count-1 do If Trim(ExtUpperCase(ComboBox.Items[I]))=S then begin
    ComboBox.ItemIndex:=I; break;
  end;
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : String); overload;
begin
  SetComboBox(ComboBox,Default,0);
  SetComboBox(ComboBox,Value,ComboBox.ItemIndex);
end;

procedure TModernProfileEditorMIDIFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SetComboBox(TypeComboBox,Game.MIDIType,'intelligent');
  SetComboBox(DeviceComboBox,Game.MIDIDevice,'default');
  AdditionalSettingsEdit.Text:=Game.MIDIConfig;
end;

procedure TModernProfileEditorMIDIFrame.ShowFrame;
begin
end;

function TModernProfileEditorMIDIFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorMIDIFrame.GetGame(const Game: TGame);
begin
  Game.MIDIType:=TypeComboBox.Text;
  Game.MIDIDevice:=DeviceComboBox.Text;
  Game.MIDIConfig:=AdditionalSettingsEdit.Text;
end;

end.
