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
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit;

{$R *.dfm}

{ TModernProfileEditorSerialPortsFrame }

procedure TModernProfileEditorSerialPortsFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName : PString);
begin
  InfoLabel.Caption:=LanguageSetup.ProfileEditorSerialPortsInfo;
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
