unit ModernProfileEditorSerialPortsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorSerialPortsFrame = class(TFrame, IModernProfileEditorFrame)
    InfoLabel: TLabel;
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

uses LanguageSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorSerialPortsFrame }

procedure TModernProfileEditorSerialPortsFrame.InitGUI(const InitData : TModernProfileEditorInitData);
begin
  InfoLabel.Caption:=LanguageSetup.ProfileEditorSerialPortsInfo;

  HelpContext:=ID_ProfileEditSerialPorts;
end;

procedure TModernProfileEditorSerialPortsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
end;

procedure TModernProfileEditorSerialPortsFrame.ShowFrame;
begin
end;

function TModernProfileEditorSerialPortsFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorSerialPortsFrame.GetGame(const Game: TGame);
begin
end;

end.
