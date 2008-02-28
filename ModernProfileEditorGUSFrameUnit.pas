unit ModernProfileEditorGUSFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorGUSFrame = class(TFrame, IModernProfileEditorFrame)
    ActivateGUSCheckBox: TCheckBox;
    AddressLabel: TLabel;
    AddressComboBox: TComboBox;
    SampleRateLabel: TLabel;
    SampleRateComboBox: TComboBox;
    Interrupt1ComboBox: TComboBox;
    Interrupt1Label: TLabel;
    Interrupt2ComboBox: TComboBox;
    Interrupt2Label: TLabel;
    DMA1ComboBox: TComboBox;
    DMA1Label: TLabel;
    DMA2ComboBox: TComboBox;
    DMA2Label: TLabel;
    PathEdit: TLabeledEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TFrame1 }

procedure TModernProfileEditorGUSFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup: PString);
Var St : TStringList;
begin
  NoFlicker(ActivateGUSCheckBox);
  NoFlicker(AddressComboBox);
  NoFlicker(SampleRateComboBox);
  NoFlicker(Interrupt1ComboBox);
  NoFlicker(Interrupt2ComboBox);
  NoFlicker(DMA1ComboBox);
  NoFlicker(DMA2ComboBox);
  NoFlicker(PathEdit);

  ActivateGUSCheckBox.Caption:=LanguageSetup.ProfileEditorSoundGUSEnabled;
  AddressLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSAddress;
  St:=ValueToList(GameDB.ConfOpt.GUSBase,';,'); try AddressComboBox.Items.AddStrings(St); finally St.Free; end;
  SampleRateLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSRate;
  St:=ValueToList(GameDB.ConfOpt.GUSRate,';,'); try SampleRateComboBox.Items.AddStrings(St); finally St.Free; end;
  Interrupt1Label.Caption:=LanguageSetup.ProfileEditorSoundGUSIRQ1;
  St:=ValueToList(GameDB.ConfOpt.IRQ1,';,'); try Interrupt1ComboBox.Items.AddStrings(St); finally St.Free; end;
  Interrupt2Label.Caption:=LanguageSetup.ProfileEditorSoundGUSIRQ2;
  St:=ValueToList(GameDB.ConfOpt.IRQ2,';,'); try Interrupt2ComboBox.Items.AddStrings(St); finally St.Free; end;
  DMA1Label.Caption:=LanguageSetup.ProfileEditorSoundGUSDMA1;
  St:=ValueToList(GameDB.ConfOpt.Dma1,';,'); try DMA1ComboBox.Items.AddStrings(St); finally St.Free; end;
  DMA2Label.Caption:=LanguageSetup.ProfileEditorSoundGUSDMA2;
  St:=ValueToList(GameDB.ConfOpt.Dma2,';,'); try DMA2ComboBox.Items.AddStrings(St); finally St.Free; end;
  PathEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSoundGUSPath;
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

procedure TModernProfileEditorGUSFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  ActivateGUSCheckBox.Checked:=Game.GUS;
  SetComboBox(AddressComboBox,IntToStr(Game.GUSBase),'240');
  SetComboBox(SampleRateComboBox,IntToStr(Game.GUSRate),'22050');
  SetComboBox(Interrupt1ComboBox,IntToStr(Game.GUSIRQ1),'5');
  SetComboBox(Interrupt2ComboBox,IntToStr(Game.GUSIRQ2),'5');
  SetComboBox(DMA1ComboBox,IntToStr(Game.GUSDMA1),'1');
  SetComboBox(DMA2ComboBox,IntToStr(Game.GUSDMA2),'1');
  PathEdit.Text:=Game.GUSUltraDir;
end;

function TModernProfileEditorGUSFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorGUSFrame.GetGame(const Game: TGame);
begin
  Game.GUS:=ActivateGUSCheckBox.Checked;
  try Game.GUSBase:=StrtoInt(AddressComboBox.Text); except end;
  try Game.GUSRate:=StrtoInt(SampleRateComboBox.Text); except end;
  try Game.GUSIRQ1:=StrtoInt(Interrupt1ComboBox.Text); except end;
  try Game.GUSIRQ2:=StrtoInt(Interrupt2ComboBox.Text); except end;
  try Game.GUSDMA1:=StrtoInt(DMA1ComboBox.Text); except end;
  try Game.GUSDMA2:=StrtoInt(DMA2ComboBox.Text); except end;
  Game.GUSUltraDir:=PathEdit.Text;
end;

end.
