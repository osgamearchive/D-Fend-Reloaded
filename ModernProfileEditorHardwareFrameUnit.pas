unit ModernProfileEditorHardwareFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls;

type
  TModernProfileEditorHardwareFrame = class(TFrame, IModernProfileEditorFrame)
    InfoLabel: TLabel;
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

uses LanguageSetupUnit;

{$R *.dfm}

{ TModernProfileEditorHardwareFrame }

procedure TModernProfileEditorHardwareFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup: PString);
begin
  InfoLabel.Caption:=LanguageSetup.ProfileEditorHardwareInfo;
end;

procedure TModernProfileEditorHardwareFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
end;

function TModernProfileEditorHardwareFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorHardwareFrame.GetGame(const Game: TGame);
begin
end;

end.
