unit RunPrgManagerUnit;
interface

uses ExtCtrls, GameDBUnit;

Type TRunPrgRecord=record
  Command : String;
  CommandMinimized : Boolean;
  WaitHandle : THandle;
end;

Type TRunPrgManager=class
  private
    Timer : TTimer;
    List : Array of TRunPrgRecord;
    Function GetCount : Integer;
    Procedure TimerWork(Sender : TObject);
    function GetData(I: Integer): TRunPrgRecord;
    Procedure RunCommand(const Command : String; const Wait, Minimized : Boolean);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure RunBeforeExecutionCommand(const AGame : TGame);
    Procedure AddCommand(const AGame : TGame; const AHandle : THandle);
    property Count : Integer read GetCount;
    property Data[I : Integer] : TRunPrgRecord read GetData;
end;

var RunPrgManager : TRunPrgManager;

implementation

uses Windows, Dialogs, SysUtils, LanguageSetupUnit;

{ TRunPrgManager }

constructor TRunPrgManager.Create;
begin
  inherited Create;
  Timer:=TTimer.Create(nil);
  with Timer do begin
    OnTimer:=TimerWork;
    Interval:=1000;
    Enabled:=True;
  end;
end;

destructor TRunPrgManager.Destroy;
begin
  Timer.Free;
  inherited Destroy;
end;

procedure TRunPrgManager.RunBeforeExecutionCommand(const AGame: TGame);
Var S : String;
begin
  S:=Trim(AGame.CommandBeforeExecution);
  If S='' then exit;
  RunCommand(S,AGame.CommandBeforeExecutionWait,AGame.CommandBeforeExecutionMinimized);
end;

procedure TRunPrgManager.AddCommand(const AGame: TGame; const AHandle: THandle);
Var S : String;
    I : Integer;
    NewHandle : THandle;
begin
  S:=Trim(AGame.CommandAfterExecution);
  If S='' then exit;

  I:=length(List);
  SetLength(List,I+1);
  List[I].Command:=S;
  List[I].CommandMinimized:=AGame.CommandAfterExecutionMinimized;
  DuplicateHandle(GetCurrentProcess,AHandle,GetCurrentProcess,@NewHandle,0,False,DUPLICATE_SAME_ACCESS);
  List[I].WaitHandle:=NewHandle;
end;

function TRunPrgManager.GetCount: Integer;
begin
  result:=length(List);
end;

function TRunPrgManager.GetData(I: Integer): TRunPrgRecord;
begin
  result:=List[I];
end;

procedure TRunPrgManager.TimerWork(Sender: TObject);
Var I,J : Integer;
begin
  Timer.Enabled:=False;
  try
    I:=0;
    while I<length(List) do begin
      If (List[I].WaitHandle<>INVALID_HANDLE_VALUE) and (WaitForSingleObject(List[I].WaitHandle,0)=WAIT_OBJECT_0) then begin
        RunCommand(List[I].Command,False,List[I].CommandMinimized);
        For J:=I+1 to length(List)-1 do List[J-1]:=List[J];
        SetLength(List,length(List)-1);
        continue;
      end;
      inc(I);
    end;
  finally
    Timer.Enabled:=True;
  end;
end;

Procedure TRunPrgManager.RunCommand(const Command : String; const Wait, Minimized : Boolean);
Var StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;

  If Minimized then begin
    StartupInfo.dwFlags:=StartupInfo.dwFlags or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow:=SW_MINIMIZE;
  end;

  If not CreateProcess(nil,PChar(Command),nil,nil,False,0,nil,nil,StartupInfo,ProcessInformation) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[Command]),mtError,[mbOK],0);
    exit;
  end;

  If Wait then WaitForSingleObject(ProcessInformation.hThread,INFINITE);
  CloseHandle(ProcessInformation.hThread);
  CloseHandle(ProcessInformation.hProcess);
end;

initialization
  RunPrgManager:=TRunPrgManager.Create;
finalization
  RunPrgManager.Free;
end.
