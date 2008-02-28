unit ModernProfileEditorKeyboardFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorKeyboardFrame = class(TFrame, IModernProfileEditorFrame)
    KeyboardLayoutLabel: TLabel;
    KeyboardLayoutComboBox: TComboBox;
    UseScancodesCheckBox: TCheckBox;
    KeyboardLayoutInfoLabel: TLabel;
    NumLockRadioGroup: TRadioGroup;
    CapsLockRadioGroup: TRadioGroup;
    ScrollLockRadioGroup: TRadioGroup;
    KeyLockInfoLabel: TLabel;
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

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorKeyboardFrame }

procedure TModernProfileEditorKeyboardFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup: PString);
Var St : TStringList;
begin
  NoFlicker(UseScancodesCheckBox);
  NoFlicker(KeyboardLayoutComboBox);
  NoFlicker(NumLockRadioGroup);
  NoFlicker(CapsLockRadioGroup);
  NoFlicker(ScrollLockRadioGroup);

  KeyboardLayoutLabel.Caption:=LanguageSetup.GameKeyboardLayout;
  St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try KeyboardLayoutComboBox.Items.AddStrings(St); finally St.Free; end;
  KeyboardLayoutInfoLabel.Caption:=LanguageSetup.GameKeyboardLayoutInfo;
  UseScancodesCheckBox.Caption:=LanguageSetup.GameUseScanCodes;
  with NumLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardNumLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  with CapsLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardCapsLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  with ScrollLockRadioGroup do begin
    Caption:=LanguageSetup.GameKeyboardScrollLock;
    Items[0]:=LanguageSetup.DoNotChange;
    Items[1]:=LanguageSetup.Off;
    Items[2]:=LanguageSetup.On;
  end;
  KeyLockInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    KeyLockInfoLabel.Font.Color:=clGrayText;
  end else begin
    KeyLockInfoLabel.Font.Color:=clRed;
  end;
end;

procedure TModernProfileEditorKeyboardFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
    I : Integer;
begin
  If Game.KeyboardLayout<>'' then S:=Game.KeyboardLayout else S:='default';
  S:=Trim(ExtUpperCase(S));
  KeyboardLayoutComboBox.ItemIndex:=1;
  For I:=0 to KeyboardLayoutComboBox.Items.Count-1 do If Trim(ExtUpperCase(KeyboardLayoutComboBox.Items[I]))=S then begin
    KeyboardLayoutComboBox.ItemIndex:=I; break;
  end;
  UseScancodesCheckBox.Checked:=Game.UseScanCodes;
  S:=Trim(ExtUpperCase(Game.NumLockStatus));
  with NumLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;
  S:=Trim(ExtUpperCase(Game.CapsLockStatus));
  with CapsLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;
  S:=Trim(ExtUpperCase(Game.ScrollLockStatus));
  with ScrollLockRadioGroup do begin
    ItemIndex:=0;
    If (S='OFF') or (S='0') or (S='FALSE') then ItemIndex:=1;
    If (S='ON') or (S='1') or (S='TRUE') then ItemIndex:=2;
  end;
end;

function TModernProfileEditorKeyboardFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorKeyboardFrame.GetGame(const Game: TGame);
begin
  Game.KeyboardLayout:=KeyboardLayoutComboBox.Text;
  Game.UseScanCodes:=UseScancodesCheckBox.Checked;
  Case NumLockRadioGroup.ItemIndex of
    0 : Game.NumLockStatus:='';
    1 : Game.NumLockStatus:='off';
    2 : Game.NumLockStatus:='on';
  end;
  Case CapsLockRadioGroup.ItemIndex of
    0 : Game.CapsLockStatus:='';
    1 : Game.CapsLockStatus:='off';
    2 : Game.CapsLockStatus:='on';
  end;
  Case ScrollLockRadioGroup.ItemIndex of
    0 : Game.ScrollLockStatus:='';
    1 : Game.ScrollLockStatus:='off';
    2 : Game.ScrollLockStatus:='on';
  end;
end;

end.
