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
  NoFlicker(Command2CheckBox);
  NoFlicker(Command2Edit);

  Command1CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunBefore;
  Command1Edit.EditLabel.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunBeforeEditLabel;
  Command2CheckBox.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunAfter;
  Command2Edit.EditLabel.Caption:=LanguageSetup.ProfileEditorHelperProgramsRunAfterEditLabel;

  HelpContext:=ID_ProfileEditHelperPrograms;
end;

procedure TModernProfileEditorHelperProgramsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var S : String;
begin
  S:=Trim(Game.CommandBeforeExecution);
  Command1CheckBox.Checked:=(S<>'');
  Command1Edit.Text:=S;

  S:=Trim(Game.CommandAfterExecution);
  Command2CheckBox.Checked:=(S<>'');
  Command2Edit.Text:=S;
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
  If Command2CheckBox.Checked then Game.CommandAfterExecution:=Trim(Command2Edit.Text) else Game.CommandAfterExecution:='';
end;

end.
