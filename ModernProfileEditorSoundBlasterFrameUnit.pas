unit ModernProfileEditorSoundBlasterFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorSoundBlasterFrame = class(TFrame, IModernProfileEditorFrame)
    TypeLabel: TLabel;
    TypeComboBox: TComboBox;
    AddressComboBox: TComboBox;
    AddressLabel: TLabel;
    InterruptComboBox: TComboBox;
    InterruptLabel: TLabel;
    DMAComboBox: TComboBox;
    DMALabel: TLabel;
    HDMAComboBox: TComboBox;
    HDMALabel: TLabel;
    OplModeComboBox: TComboBox;
    OplModeLabel: TLabel;
    OplSampleRateComboBox: TComboBox;
    OplSampleRateLabel: TLabel;
    UseMixerCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TModernProfileEditorSoundBlasterFrame }

procedure TModernProfileEditorSoundBlasterFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName: PString);
Var St : TStringList;
begin
  NoFlicker(TypeComboBox);
  NoFlicker(AddressComboBox);
  NoFlicker(InterruptComboBox);
  NoFlicker(DMAComboBox);
  NoFlicker(HDMAComboBox);
  NoFlicker(OplModeComboBox);
  NoFlicker(OplSampleRateComboBox);
  NoFlicker(UseMixerCheckBox);

  TypeLabel.Caption:=LanguageSetup.ProfileEditorSoundSBType;
  St:=ValueToList(GameDB.ConfOpt.Sblaster,';,'); try TypeComboBox.Items.AddStrings(St); finally St.Free; end;
  AddressLabel.Caption:=LanguageSetup.ProfileEditorSoundSBAddress;
  St:=ValueToList(GameDB.ConfOpt.SBBase,';,'); try AddressComboBox.Items.AddStrings(St); finally St.Free; end;
  InterruptLabel.Caption:=LanguageSetup.ProfileEditorSoundSBIRQ;
  St:=ValueToList(GameDB.ConfOpt.IRQ,';,'); try InterruptComboBox.Items.AddStrings(St); finally St.Free; end;
  DMALabel.Caption:=LanguageSetup.ProfileEditorSoundSBDMA;
  St:=ValueToList(GameDB.ConfOpt.DMA,';,'); try DMAComboBox.Items.AddStrings(St); finally St.Free; end;
  HDMALabel.Caption:=LanguageSetup.ProfileEditorSoundSBHDMA;
  St:=ValueToList(GameDB.ConfOpt.HDMA,';,'); try HDMAComboBox.Items.AddStrings(St); finally St.Free; end;
  OplModeLabel.Caption:=LanguageSetup.ProfileEditorSoundSBOplMode;
  St:=ValueToList(GameDB.ConfOpt.Oplmode,';,'); try OplModeComboBox.Items.AddStrings(St); finally St.Free; end;
  OplSampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundSBOplRate;
  St:=ValueToList(GameDB.ConfOpt.OPLRate,';,'); try OplSampleRateComboBox.Items.AddStrings(St); finally St.Free; end;
  UseMixerCheckBox.Caption:=LanguageSetup.ProfileEditorSoundSBUseMixer;
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

procedure TModernProfileEditorSoundBlasterFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SetComboBox(TypeComboBox,Game.SBType,'sb16');
  SetComboBox(AddressComboBox,IntToStr(Game.SBBase),'220');
  SetComboBox(InterruptComboBox,IntToStr(Game.SBIRQ),'7');
  SetComboBox(DMAComboBox,IntToStr(Game.SBDMA),'1');
  SetComboBox(HDMAComboBox,IntToStr(Game.SBHDMA),'5');
  SetComboBox(OplModeComboBox,Game.SBOplMode,'auto');
  SetComboBox(OplSampleRateComboBox,IntToStr(Game.SBOplRate),'22050');
  UseMixerCheckBox.Checked:=Game.SBMixer;
end;

function TModernProfileEditorSoundBlasterFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorSoundBlasterFrame.GetGame(const Game: TGame);
begin
  Game.SBType:=TypeComboBox.Text;
  try Game.SBBase:=StrToInt(AddressComboBox.Text); except end;
  try Game.SBIRQ:=StrToInt(InterruptComboBox.Text); except end;
  try Game.SBDMA:=StrToInt(DMAComboBox.Text); except end;
  try Game.SBHDMA:=StrToInt(HDMAComboBox.Text); except end;
  Game.SBOplMode:=OplModeComboBox.Text;
  try Game.SBOplRate:=StrToInt(OplSampleRateComboBox.Text); except end;
  Game.SBMixer:=UseMixerCheckBox.Checked;
end;

end.
