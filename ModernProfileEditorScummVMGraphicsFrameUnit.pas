unit ModernProfileEditorScummVMGraphicsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorScummVMGraphicsFrame = class(TFrame, IModernProfileEditorFrame)
    FilterLabel: TLabel;
    FilterComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    KeepAspectRatioCheckBox: TCheckBox;
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

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TModernProfileEditorScummVMGraphicsFrame }

procedure TModernProfileEditorScummVMGraphicsFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName : PString);
Var St : TStringList;
begin
  NoFlicker(FilterComboBox);
  NoFlicker(StartFullscreenCheckBox);
  NoFlicker(KeepAspectRatioCheckBox);

  FilterLabel.Caption:=LanguageSetup.ProfileEditorScummVMFilter;
  St:=ValueToList(GameDB.ConfOpt.ScummVMFilter,';,'); try FilterComboBox.Items.AddStrings(St); finally St.Free; end;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  KeepAspectRatioCheckBox.Caption:=LanguageSetup.GameAspectCorrection;
end;

procedure TModernProfileEditorScummVMGraphicsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S,T : String;
    I : Integer;
begin
  S:=Trim(ExtUpperCase(Game.ScummVMFilter));
  FilterComboBox.ItemIndex:=0;
  For I:=0 to FilterComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(FilterComboBox.Items[I]));
    If Pos('(',T)=0 then continue;
    T:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',T)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If Trim(T)=S then begin FilterComboBox.ItemIndex:=I; break; end;
  end;
  StartFullscreenCheckBox.Checked:=Game.StartFullscreen;
  KeepAspectRatioCheckBox.Checked:=Game.AspectCorrection;
end;

procedure TModernProfileEditorScummVMGraphicsFrame.ShowFrame;
begin
end;

function TModernProfileEditorScummVMGraphicsFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorScummVMGraphicsFrame.GetGame(const Game: TGame);
Var S : String;
begin
  S:=FilterComboBox.Text;
  If Pos('(',S)=0 then Game.Scale:='' else begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then Game.Scale:=''  else Game.Scale:=Copy(S,1,Pos(')',S)-1);
  end;
  Game.StartFullscreen:=StartFullscreenCheckBox.Checked;
  Game.AspectCorrection:=KeepAspectRatioCheckBox.Checked;
end;

end.
