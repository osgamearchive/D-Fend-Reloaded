unit ModernProfileEditorNetworkFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorNetworkFrame = class(TFrame, IModernProfileEditorFrame)
    ActivateCheckBox: TCheckBox;
    ConnectionsRadioGroup: TRadioGroup;
    ServerAddressEdit: TLabeledEdit;
    PortLabel: TLabel;
    PortEdit: TSpinEdit;
    procedure ActivateCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorNetworkFrame }

procedure TModernProfileEditorNetworkFrame.InitGUI(var InitData : TModernProfileEditorInitData);
begin
  NoFlicker(ActivateCheckBox);
  NoFlicker(ConnectionsRadioGroup);
  NoFlicker(ServerAddressEdit);
  NoFlicker(PortEdit);

  ActivateCheckBox.Caption:=LanguageSetup.GameIPX;
  ConnectionsRadioGroup.Caption:=LanguageSetup.GameIPXEstablishConnection;
  ConnectionsRadioGroup.Items[0]:=LanguageSetup.GameIPXEstablishConnectionNone;
  ConnectionsRadioGroup.Items[1]:=LanguageSetup.GameIPXEstablishConnectionClient;
  ConnectionsRadioGroup.Items[2]:=LanguageSetup.GameIPXEstablishConnectionServer;
  ServerAddressEdit.EditLabel.Caption:=LanguageSetup.GameIPXAddress;
  PortLabel.Caption:=LanguageSetup.GameIPXPort;

  //... 1.1: NE2000 settings
  {
[ne2000]
ne2000=true (Enable Ethernet passthrough. Requires [Win]Pcap.)
nicbase=300 (The base address of the NE2000 board.)
nicirq=3 (The interrupt it uses. Note serial2 uses IRQ3 as default.)
macaddr=AC:DE:48:88:99:AA (The physical address the emulator will use on your network.
#          If you have multiple DOSBoxes running on your network,
#          this has to be changed for each. AC:DE:48 is an address range reserved for
#          private use, so modify the last three number blocks.
#          I.e. AC:DE:48:88:99:AB.)
realnic=list (Specifies which of your network interfaces is used.
#          Write 'list' here to see the list of devices in the
#          Status Window. Then make your choice and put either the
#          interface number (2 or something) or a part of your adapters
#          name, e.g. VIA here.)
  }

  HelpContext:=ID_ProfileEditNetwork;
end;

procedure TModernProfileEditorNetworkFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
    I : Integer;
begin
 ActivateCheckBox.Checked:=Game.IPX;
 ConnectionsRadioGroup.ItemIndex:=0;
 S:=Trim(ExtUpperCase(Game.IPXType));
 If (S='') or (S='NONE') then ConnectionsRadioGroup.ItemIndex:=0;
 If S='CLIENT' then ConnectionsRadioGroup.ItemIndex:=1;
 If S='SERVER' then ConnectionsRadioGroup.ItemIndex:=2;
 ServerAddressEdit.Text:=Game.IPXAddress;
 If TryStrToInt(Game.IPXPort,I) then PortEdit.Value:=I else PortEdit.Value:=1;

  ActivateCheckBoxClick(self);
end;

procedure TModernProfileEditorNetworkFrame.ActivateCheckBoxClick(Sender: TObject);
begin
  ConnectionsRadioGroup.Enabled:=ActivateCheckBox.Checked;
  ServerAddressEdit.Enabled:=ActivateCheckBox.Checked and (ConnectionsRadioGroup.ItemIndex=1);
  PortEdit.Enabled:=ActivateCheckBox.Checked;
end;

procedure TModernProfileEditorNetworkFrame.GetGame(const Game: TGame);
begin
  Game.IPX:=ActivateCheckBox.Checked;
  Case ConnectionsRadioGroup.ItemIndex of
    0 : Game.IPXType:='none';
    1 : Game.IPXType:='client';
    2 : Game.IPXType:='server';
  end;
  Game.IPXAddress:=ServerAddressEdit.Text;
  Game.IPXPort:=IntToStr(PortEdit.Value);
end;

end.
