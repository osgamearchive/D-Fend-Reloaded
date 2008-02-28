unit ModernProfileEditorMouseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorMouseFrame = class(TFrame, IModernProfileEditorFrame)
    LockMouseCheckBox: TCheckBox;
    LockMouseLabel: TLabel;
    MouseSensitivityEdit: TSpinEdit;
    MouseSensitivityLabel: TLabel;
    Force2ButtonsCheckBox: TCheckBox;
    SwapButtonsCheckBox: TCheckBox;
    Force2ButtonsInfoLabel: TLabel;
    SwapButtonsInfoLabel: TLabel;
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

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorMouseFrame }

procedure TModernProfileEditorMouseFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup: PString);
begin
  NoFlicker(LockMouseCheckBox);
  NoFlicker(MouseSensitivityEdit);
  NoFlicker(Force2ButtonsCheckBox);
  NoFlicker(SwapButtonsCheckBox);

  LockMouseCheckBox.Caption:=LanguageSetup.GameAutoLockMouse;
  LockMouseLabel.Caption:=LanguageSetup.GameAutoLockMouseInfo;
  MouseSensitivityLabel.Caption:=LanguageSetup.GameMouseSensitivity;
  Force2ButtonsCheckBox.Caption:=LanguageSetup.GameForce2ButtonMouseMode;
  Force2ButtonsInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    Force2ButtonsInfoLabel.Font.Color:=clGrayText;
  end else begin
    Force2ButtonsInfoLabel.Font.Color:=clRed;
  end;
  SwapButtonsCheckBox.Caption:=LanguageSetup.GameSwapMouseButtons;
  SwapButtonsInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    SwapButtonsInfoLabel.Font.Color:=clGrayText;
  end else begin
    SwapButtonsInfoLabel.Font.Color:=clRed;
  end;
end;

procedure TModernProfileEditorMouseFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  LockMouseCheckBox.Checked:=Game.AutoLockMouse;
  MouseSensitivityEdit.Value:=Game.MouseSensitivity;
  Force2ButtonsCheckBox.Checked:=Game.Force2ButtonMouseMode;
  SwapButtonsCheckBox.Checked:=Game.SwapMouseButtons;
end;

function TModernProfileEditorMouseFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorMouseFrame.GetGame(const Game: TGame);
begin
  Game.AutoLockMouse:=LockMouseCheckBox.Checked;
  Game.MouseSensitivity:=MouseSensitivityEdit.Value;
  Game.Force2ButtonMouseMode:=Force2ButtonsCheckBox.Checked;
  Game.SwapMouseButtons:=SwapButtonsCheckBox.Checked;
end;

end.
