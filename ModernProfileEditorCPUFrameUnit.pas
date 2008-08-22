unit ModernProfileEditorCPUFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorCPUFrame = class(TFrame, IModernProfileEditorFrame)
    CPUCoreRadioGroup: TRadioGroup;
    CPUCyclesGroupBox: TGroupBox;
    CyclesAutoRadioButton: TRadioButton;
    CyclesMaxRadioButton: TRadioButton;
    CyclesValueRadioButton: TRadioButton;
    CyclesComboBox: TComboBox;
    CyclesUpLabel: TLabel;
    CyclesDownLabel: TLabel;
    CyclesUpEdit: TSpinEdit;
    CyclesDownEdit: TSpinEdit;
    CyclesInfoLabel: TLabel;
  private
    { Private-Deklarationen }
    SaveCycles : String;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses CommonTools, LanguageSetupUnit, VistaToolsUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorCPUFrame }

procedure TModernProfileEditorCPUFrame.InitGUI(const InitData : TModernProfileEditorInitData);
Var St : TStringList;
    I : Integer;
    S : String;
begin
  NoFlicker(CPUCoreRadioGroup);
  NoFlicker(CPUCyclesGroupBox);
  NoFlicker(CyclesAutoRadioButton);
  NoFlicker(CyclesMaxRadioButton);
  NoFlicker(CyclesValueRadioButton);
  NoFlicker(CyclesUpEdit);
  NoFlicker(CyclesDownEdit);

  CPUCoreRadioGroup.Caption:=LanguageSetup.GameCore;
  CPUCyclesGroupBox.Caption:=LanguageSetup.GameCycles;
  CyclesValueRadioButton.Caption:=LanguageSetup.Value;

  St:=ValueToList(InitData.GameDB.ConfOpt.Core,';,'); try CPUCoreRadioGroup.Items.AddStrings(St); finally St.Free; end;
  CPUCoreRadioGroup.ItemIndex:=0;

  St:=ValueToList(InitData.GameDB.ConfOpt.Cycles,';,');
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If (S='AUTO') or (S='MAX') then continue;
      CyclesComboBox.Items.Add(St[I]);
    end;
    CyclesComboBox.Text:='3000';
  finally
    St.Free;
  end;

  CyclesUpLabel.Caption:=LanguageSetup.GameCyclesUp;
  CyclesDownLabel.Caption:=LanguageSetup.GameCyclesDown;
  CyclesInfoLabel.Caption:=LanguageSetup.GameCyclesInfo;

  HelpContext:=ID_ProfileEditCPU;
end;

procedure TModernProfileEditorCPUFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S : String;
begin
  S:=Trim(ExtUpperCase(Game.Core));
  For I:=0 to CPUCoreRadioGroup.Items.Count-1 do begin
    If Trim(ExtUpperCase(CPUCoreRadioGroup.Items[I]))=S then begin CPUCoreRadioGroup.ItemIndex:=I; break; end;
  end;

  SaveCycles:=Game.Cycles;
  S:=Trim(ExtUpperCase(Game.Cycles));
  CyclesAutoRadioButton.Checked:=(S='AUTO');
  CyclesMaxRadioButton.Checked:=(S='MAX');
  If (S<>'AUTO') and (S<>'MAX') then begin
    CyclesValueRadioButton.Checked:=True;
    CyclesComboBox.Text:=Game.Cycles;
  end;

  CyclesUpEdit.Value:=Game.CyclesUp;
  CyclesDownEdit.Value:=Game.CyclesDown;
end;

procedure TModernProfileEditorCPUFrame.ShowFrame;
begin
end;

function TModernProfileEditorCPUFrame.CheckValue: Boolean;
Var I : Integer;
    B : Boolean;
    S : String;
begin
  result:=True;

  If CyclesValueRadioButton.Checked then begin
    B:=TryStrToInt(CyclesComboBox.Text,I);
    If not B then begin
      S:=Trim(ExtUpperCase(CyclesComboBox.Text));
      For I:=0 to CyclesComboBox.Items.Count-1 do If Trim(ExtUpperCase(CyclesComboBox.Items[I]))=S then begin B:=True; break; end;
    end;
    if not B then begin
      If MessageDlg(Format(LanguageSetup.MessageInvalidValue,[CyclesComboBox.Text,LanguageSetup.GameCycles,SaveCycles]),mtWarning,[mbYes,mbNo],0)<>mrYes then begin
        result:=False;
        exit;
      end else begin
        CyclesComboBox.Text:=SaveCycles;
      end;
    end;
  end;
end;

procedure TModernProfileEditorCPUFrame.GetGame(const Game: TGame);
begin
  Game.Core:=CPUCoreRadioGroup.Items[CPUCoreRadioGroup.ItemIndex];

  If CyclesAutoRadioButton.Checked then Game.Cycles:='auto';
  If CyclesMaxRadioButton.Checked then Game.Cycles:='max';
  If CyclesValueRadioButton.Checked then Game.Cycles:=CyclesComboBox.Text;

  Game.CyclesUp:=CyclesUpEdit.Value;
  Game.CyclesDown:=CyclesDownEdit.Value;
end;

end.
