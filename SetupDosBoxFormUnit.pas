unit SetupDosBoxFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TSetupDosBoxForm = class(TForm)
    InfoLabel: TLabel;
    AbortButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);
    Procedure StartSearch(var Msg : TMessage); message WM_USER+1;
  private
    { Private-Deklarationen }
    Aborted : Boolean;
    Count : Integer;
    Function SearchDir(const Dir : String) : Boolean;
  public
    { Public-Deklarationen }
  end;

var
  SetupDosBoxForm: TSetupDosBoxForm;

Function SearchDosBox(const AOwner : TComponent) : Boolean;

implementation

uses PrgSetupUnit, LanguageSetupUnit, PrgConsts, CommonTools, VistaToolsUnit;

{$R *.dfm}

procedure TSetupDosBoxForm.FormShow(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TSetupDosBoxForm.StartSearch(var Msg: TMessage);
Var C : Char;
begin
  Aborted:=False;
  Count:=0;

  Caption:=LanguageSetup.SetupDosBoxForm;
  AbortButton.Caption:=LanguageSetup.Abort;

  try
    If SearchDir(PrgDir) then begin ModalResult:=mrOK; exit; end;
    If PrgDataDir<>PrgDir then begin
      If SearchDir(PrgDataDir) then begin ModalResult:=mrOK; exit; end;
    end;
    If Aborted then begin ModalResult:=mrAbort; exit; end;

    For C:='C' to 'Z' do if GetDriveType(PChar(C+':\'))<>DRIVE_NO_ROOT_DIR then begin
       If SearchDir(C+':\') then begin ModalResult:=mrOK; exit; end;
       If Aborted then begin ModalResult:=mrAbort; exit; end;
    end;

    ModalResult:=mrAbort;
  finally
    Close;
  end;
end;

function TSetupDosBoxForm.SearchDir(const Dir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=FileExists(Dir+DosBoxFileName);
  if result then begin
    PrgSetup.DosBoxDir:=Dir;
    exit;
  end;

  inc(Count);
  If Count mod 2000=0 then begin
    InfoLabel.Caption:=Dir;
    Application.ProcessMessages;
    If Aborted then exit;
  end;

  I:=FindFirst(Dir+'*.*',faDirectory,Rec);
  try
    while I=0 do begin
      If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        result:=SearchDir(Dir+Rec.Name+'\');
        if result or Aborted then exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TSetupDosBoxForm.AbortButtonClick(Sender: TObject);
begin
  Aborted:=True;
end;

{ global }

Function SearchDosBox(const AOwner : TComponent) : Boolean;
begin
  If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName) then begin
    result:=True;
    exit;
  end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try
    result:=(SetupDosBoxForm.ShowModal=mrOK);
  finally
    SetupDosBoxForm.Free;
  end;
end;

end.
