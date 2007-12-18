unit ProgressFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls;

type
  TProgressForm = class(TForm)
    ProgressBar: TProgressBar;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ProgressForm: TProgressForm = nil;

Procedure InitProgressWindow(const AOwner : TComponent; const Steps : Integer);
Procedure StepProgressWindow;
Procedure DoneProgressWindow;

implementation

uses VistaToolsUnit, LanguageSetupUnit;

{$R *.dfm}

procedure TProgressForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.ProgressFormCaption;
end;

Procedure InitProgressWindow(const AOwner : TComponent; const Steps : Integer);
begin
  ProgressForm:=TProgressForm.Create(AOwner);
  ProgressForm.ProgressBar.Max:=Steps;
  ProgressForm.ProgressBar.Position:=0;
  ProgressForm.DoubleBuffered:=True;
  ProgressForm.ProgressBar.DoubleBuffered:=True;
  ProgressForm.Show;
  ProgressForm.BringToFront;
  ProgressForm.Repaint;
  Application.ProcessMessages;  
end;

Procedure StepProgressWindow;
begin
  ProgressForm.ProgressBar.StepBy(1);
  ProgressForm.BringToFront;
  ProgressForm.Repaint;
  Application.ProcessMessages;
end;

Procedure DoneProgressWindow;
begin
  If Assigned(ProgressForm) then FreeAndNil(ProgressForm);
end;

end.
