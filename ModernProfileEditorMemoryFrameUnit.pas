unit ModernProfileEditorMemoryFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorMemoryFrame = class(TFrame, IModernProfileEditorFrame)
    MemoryLabel: TLabel;
    MemoryEdit: TSpinEdit;
    XMSCheckBox: TCheckBox;
    EMSCheckBox: TCheckBox;
    UMBCheckBox: TCheckBox;
    LoadFixCheckBox: TCheckBox;
    LoadFixLabel: TLabel;
    LoadFixEdit: TSpinEdit;
    DOS32ACheckBox: TCheckBox;
    DOS32AInfoLabel: TLabel;
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

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorMemoryFrame }

procedure TModernProfileEditorMemoryFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName: PString);
begin
  NoFlicker(MemoryEdit);

  MemoryLabel.Caption:=LanguageSetup.GameMemory;
  XMSCheckBox.Caption:=LanguageSetup.GameXMS;
  EMSCheckBox.Caption:=LanguageSetup.GameEMS;
  UMBCheckBox.Caption:=LanguageSetup.GameUMB;
  LoadFixCheckBox.Caption:=LanguageSetup.ProfileEditorLoadFix;
  LoadFixLabel.Caption:=LanguageSetup.ProfileEditorLoadFixMemory;
  DOS32ACheckBox.Caption:=LanguageSetup.GameDOS32A;
  DOS32AInfoLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    DOS32AInfoLabel.Font.Color:=clGrayText;
  end else begin
    DOS32AInfoLabel.Font.Color:=clRed;
  end;
end;

procedure TModernProfileEditorMemoryFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  MemoryEdit.Value:=Game.Memory;
  XMSCheckBox.Checked:=Game.XMS;
  EMSCheckBox.Checked:=Game.EMS;
  UMBCheckBox.Checked:=Game.UMB;
  LoadFixCheckBox.Checked:=Game.LoadFix;
  LoadFixEdit.Value:=Game.LoadFixMemory;
  DOS32ACheckBox.Checked:=Game.UseDOS32A;
end;

function TModernProfileEditorMemoryFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorMemoryFrame.GetGame(const Game: TGame);
begin
  Game.Memory:=MemoryEdit.Value;
  Game.XMS:=XMSCheckBox.Checked;
  Game.EMS:=EMSCheckBox.Checked;
  Game.UMB:=UMBCheckBox.Checked;
  Game.LoadFix:=LoadFixCheckBox.Checked;
  Game.LoadFixMemory:=LoadFixEdit.Value;
  Game.UseDOS32A:=DOS32ACheckBox.Checked;
end;

end.
