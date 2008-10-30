unit ModernProfileEditorHelperProgramsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorHelperProgramsFrame = class(TFrame, IModernProfileEditorFrame)
    Command1Edit: TLabeledEdit;
    Command2Edit: TLabeledEdit;
    Command1CheckBox: TCheckBox;
    Command2CheckBox: TCheckBox;
    RunMinimized1CheckBox: TCheckBox;
    Wait1CheckBox: TCheckBox;
    RunMinimized2CheckBox: TCheckBox;
    procedure Command1EditChange(Sender: TObject);
    procedure Command2EditChange(Sender: TObject);
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

uses VistaToolsUnit, LanguageSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorHelperProgramsFrame }

procedure TModernProfileEditorHelperProgramsFrame.InitGUI(const InitData: TModernProfileEditorInitData);
begin
  NoFlicker(Command1CheckBox);
  NoFlicker(Command1Edit);
  NoFlicker(RunMinimized1CheckBox);
  NoFlicker(Wait1CheckBox);
  NoFlicker(Command2CheckBox);
  NoFlicker(Command2Edit);
  NoFlicker(RunMinimized2CheckBox);

  Command1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunBefore;
  Command1Edit.EditLabel.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunBeforeEditLabel;
  RunMinimized1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunMinimized;
  Wait1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunWait;
  Command2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunAfter;
  Command2Edit.EditLabel.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunAfterEditLabel;
  RunMinimized2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunMinimized;

  HelpContext:=ID_ProfileEditHelperPrograms;
end;

procedure TModernProfileEditorHelperProgramsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
begin
  S:=Trim(Game.CommandBeforeExecution);
  Command1CheckBox.Checked:=(S<>'');
  Command1Edit.Text:=S;
  RunMinimized1CheckBox.Checked:=Game.CommandBeforeExecutionMinimized;
  Wait1CheckBox.Checked:=Game.CommandBeforeExecutionWait;

  S:=Trim(Game.CommandAfterExecution);
  Command2CheckBox.Checked:=(S<>'');
  Command2Edit.Text:=S;
  RunMinimized2CheckBox.Checked:=Game.CommandAfterExecutionMinimized;
end;

procedure TModernProfileEditorHelperProgramsFrame.ShowFrame;
begin
end;

function TModernProfileEditorHelperProgramsFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorHelperProgramsFrame.Command1EditChange(Sender: TObject);
begin
  Command1CheckBox.Checked:=(Trim(Command1Edit.Text)<>'');
end;

procedure TModernProfileEditorHelperProgramsFrame.Command2EditChange(Sender: TObject);
begin
  Command2CheckBox.Checked:=(Trim(Command2Edit.Text)<>'');
end;

procedure TModernProfileEditorHelperProgramsFrame.GetGame(const Game: TGame);
begin
  If Command1CheckBox.Checked then Game.CommandBeforeExecution:=Trim(Command1Edit.Text) else Game.CommandBeforeExecution:='';
  Game.CommandBeforeExecutionMinimized:=RunMinimized1CheckBox.Checked;
  Game.CommandBeforeExecutionWait:=Wait1CheckBox.Checked;
  If Command2CheckBox.Checked then Game.CommandAfterExecution:=Trim(Command2Edit.Text) else Game.CommandAfterExecution:='';
  Game.CommandAfterExecutionMinimized:=RunMinimized2CheckBox.Checked;
end;

end.
