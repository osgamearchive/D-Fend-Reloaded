unit SetupDosBoxFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

Type TSearchType=(stDOSBox, stOggEnc, stLame, stScummVM, stQBasic);

type
  TSetupDosBoxForm = class(TForm)
    InfoLabel: TLabel;
    AbortButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);
    Procedure StartSearch(var Msg : TMessage); message WM_USER+1;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    Aborted : Boolean;
    Count : Integer;
    Function SearchDir(const Dir : String) : Boolean;
  public
    { Public-Deklarationen }
    SearchType : TSearchType;
  end;

var
  SetupDosBoxForm: TSetupDosBoxForm;

Function SearchDosBox(const AOwner : TComponent) : Boolean;
Function SearchOggEnc(const AOwner : TComponent) : Boolean;
Function SearchLame(const AOwner : TComponent) : Boolean;
Function SearchScummVM(const AOwner : TComponent) : Boolean;
Function SearchQBasicVM(const AOwner : TComponent) : Boolean;

implementation

uses ShlObj, PrgSetupUnit, LanguageSetupUnit, PrgConsts, CommonTools, VistaToolsUnit;

{$R *.dfm}

procedure TSetupDosBoxForm.FormCreate(Sender: TObject);
begin
  SearchType:=stDOSBox;
end;

procedure TSetupDosBoxForm.FormShow(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TSetupDosBoxForm.StartSearch(var Msg: TMessage);
Var C : Char;
begin
  Aborted:=False;
  Count:=0;

  Case SearchType of
    stDOSBox  : Caption:=LanguageSetup.SetupDosBoxForm;
    stOggEnc  : Caption:=LanguageSetup.SetupDosBoxFormOggEnc;
    stLame    : Caption:=LanguageSetup.SetupDosBoxFormLame;
    stScummVM : Caption:=LanguageSetup.SetupDosBoxFormScummVM;
    stQBasic : Caption:=LanguageSetup.SetupDosBoxFormQBasic;
  end;
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
  result:=False;

  Case SearchType of
    stDOSBox  : begin result:=FileExists(Dir+DosBoxFileName); if result then begin PrgSetup.DosBoxDir:=Dir; exit; end; end;
    stOggEnc  : begin result:=FileExists(Dir+OggEncPrgFile); if result then begin PrgSetup.WaveEncOgg:=Dir+OggEncPrgFile; exit; end; end;
    stLame    : begin result:=FileExists(Dir+LamePrgFile); if result then begin PrgSetup.WaveEncMp3:=Dir+LamePrgFile; exit; end; end;
    stScummVM : begin result:=FileExists(Dir+ScummPrgFile); if result then begin PrgSetup.ScummVMPath:=Dir; exit; end; end;
    stQBasic  : begin
                  result:=FileExists(Dir+QBasicPrgFile); if result then begin PrgSetup.QBasic:=Dir+QBasicPrgFile; exit; end;
                  result:=FileExists(Dir+QB45PrgFile); if result then begin PrgSetup.QBasic:=Dir+QB45PrgFile; exit; end;
                  result:=FileExists(Dir+QB71PrgFile); if result then begin PrgSetup.QBasic:=Dir+QB71PrgFile; exit; end;
                end;
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
Var S : String;
begin
  If FileExists(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir)+DosBoxFileName) then begin
    result:=True;
    exit;
  end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Application.Handle,CSIDL_PROGRAM_FILES))+'DOSBox\';
  If FileExists(S+DosBoxFileName) then begin PrgSetup.DosBoxDir:=S; result:=True; exit; end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try

    If SetupDosBoxForm.SearchDir(PrgDir) then begin result:=True; exit; end;
    If PrgDataDir<>PrgDir then begin
      If SetupDosBoxForm.SearchDir(PrgDataDir) then begin result:=True; exit; end;
    end;
    result:=(SetupDosBoxForm.ShowModal<>mrAbort);
  finally
    SetupDosBoxForm.Free;
  end;
end;

Function SearchOggEnc(const AOwner : TComponent) : Boolean;
begin
  If FileExists(PrgSetup.WaveEncOgg) then begin
    result:=True;
    exit;
  end;

  If FileExists(PrgDir+OggEncPrgFile) then begin
    PrgSetup.WaveEncOgg:=PrgDir+OggEncPrgFile;
    result:=True;
    exit;
  end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try
    SetupDosBoxForm.SearchType:=stOggEnc;
    result:=(SetupDosBoxForm.ShowModal<>mrAbort);
  finally
    SetupDosBoxForm.Free;
  end;
end;

Function SearchLame(const AOwner : TComponent) : Boolean;
Var S : String;
begin
  If FileExists(PrgSetup.WaveEncMp3) then begin
    result:=True;
    exit;
  end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES))+'Lame\'+LamePrgFile;
  If FileExists(S) then begin PrgSetup.WaveEncMp3:=S; result:=True; exit; end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try
    SetupDosBoxForm.SearchType:=stLame;
    result:=(SetupDosBoxForm.ShowModal<>mrAbort);
  finally
    SetupDosBoxForm.Free;
  end;
end;

Function SearchScummVM(const AOwner : TComponent) : Boolean;
Var S : String;
begin
  If DirectoryExists(PrgSetup.ScummVMPath) then begin
    result:=True;
    exit;
  end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES))+'ScummVM\';
  If FileExists(S+ScummPrgFile) then begin PrgSetup.ScummVMPath:=S; result:=True; exit; end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try
    SetupDosBoxForm.SearchType:=stScummVM;
    result:=(SetupDosBoxForm.ShowModal<>mrAbort);
  finally
    SetupDosBoxForm.Free;
  end;
end;

Function SearchQBasicVM(const AOwner : TComponent) : Boolean;
Var S : String;
begin
  If FileExists(PrgSetup.QBasic) then begin
    result:=True;
    exit;
  end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES))+'QBasic\';
  If FileExists(S+QBasicPrgFile) then begin PrgSetup.QBasic:=S+QBasicPrgFile; result:=True; exit; end;

  SetupDosBoxForm:=TSetupDosBoxForm.Create(AOwner);
  try
    SetupDosBoxForm.SearchType:=stQBasic;
    result:=(SetupDosBoxForm.ShowModal<>mrAbort);
  finally
    SetupDosBoxForm.Free;
  end;
end;

end.
