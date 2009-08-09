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
