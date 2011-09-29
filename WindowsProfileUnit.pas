unit WindowsProfileUnit;
interface

uses GameDBUnit;

Procedure RunWindowsGame(const Game : TGame; const RunSetup : Boolean = False);
Procedure RunWindowssExtraFile(const Game : TGame; Nr : Integer);

Var MinimizedAtWindowsGameStart : Boolean = False;
    MinimizedAtWindowsGameStartTime : TDateTime;

implementation

uses Windows, SysUtils, Dialogs, Forms, ShellAPI, LanguageSetupUnit,
     CommonTools, PrgSetupUnit, GameDBToolsUnit, DOSBoxUnit, RunPrgManagerUnit,
     DOSBoxCountUnit, HistoryUnit;

Function RunFile(const FileName, Parameters : String) : THandle;
Var StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  {ShellExecute(Application.MainForm.Handle,'open',PChar(FileName),PChar(Parameters),PChar(IncludeTrailingPathDelimiter((ExtractFilePath(FileName)))),SW_SHOW);}

  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    lpReserved:=nil;
    lpDesktop:=nil;
    lpTitle:=nil;
    dwFlags:=0;
    cbReserved2:=0;
    lpReserved2:=nil;
  end;

  if not CreateProcess(
    PChar(FileName),
    PChar('"'+FileName+'" '+Parameters),
    nil,
    nil,
    False,
    0,
    nil,
    PChar(ExtractFilePath(FileName)),
    StartupInfo,
    ProcessInformation
  ) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[FileName]),mtError,[mbOK],0);
    result:=INVALID_HANDLE_VALUE;
    exit;
  end;

  result:=ProcessInformation.hProcess;
  CloseHandle(ProcessInformation.hThread);

  If PrgSetup.MinimizeOnWindowsGameStart then begin
    Sleep(1000);
    {MinimizedAtWindowsGameStart:=True; -> RunWindowsGame/RunWindowssExtraFile}
  end;

  WindowsGameCounter.Add(result);
end;

Function WindowsRunCheck(var FileName : String) : Boolean;
begin
  result:=False;

  If FileName='' then begin
    Application.Restore;
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;
  FileName:=MakeAbsPath(FileName,PrgSetup.BaseDir);

  If not FileExists(FileName) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[FileName]),mtError,[mbOK],0);
    exit;
  end;

  If IsDOSExe(FileName) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageDOSExeExecuteWarning,[FileName]),mtError,[mbOK],0);
  end;

  result:=True;
end;

Procedure RunWindowsGame(const Game : TGame; const RunSetup : Boolean);
Var S,T : String;
    Handle : THandle;
    AlreadyMinimized : Boolean;
begin
  AlreadyMinimized:=False;

  If RunSetup then begin
    S:=Trim(Game.SetupExe);
    T:=Game.SetupParameters;
  end else begin
    S:=Trim(Game.GameExe);
    T:=Game.GameParameters;
  end;

  If not WindowsRunCheck(S) then exit;
  if not RunCheck(Game,RunSetup) then exit;
  History.Add(Game.Name);

  try
    RunPrgManager.RunBeforeExecutionCommand(Game);

    If PrgSetup.MinimizeOnWindowsGameStart then begin
      AlreadyMinimized:=(Application.MainForm.WindowState=wsMinimized);
      Application.Minimize;
    end;

    Handle:=RunFile(S,T);
    try
      RunPrgManager.AddCommand(Game,Handle);
    finally
      CloseHandle(Handle);
    end;
  finally
    If PrgSetup.MinimizeOnWindowsGameStart and (not AlreadyMinimized) then begin
      MinimizedAtWindowsGameStart:=True;
      MinimizedAtWindowsGameStartTime:=Now;
    end;
  end;
end;

Procedure RunWindowssExtraFile(const Game : TGame; Nr : Integer);
Var S,T : String;
    I : Integer;
    Handle : THandle;
    AlreadyMinimized : Boolean;
begin
  AlreadyMinimized:=False;

  S:=Trim(Game.ExtraPrgFile[Nr]); I:=Pos(';',S);
  If (S='') or (I=0) then begin
    S:=Trim(Game.GameExe); T:=Game.GameParameters;
  end else begin
    S:=Copy(S,I+1,MaxInt);
    T:=Game.ExtraPrgFileParameter[Nr];
  end;

  If not WindowsRunCheck(S) then exit;
  if not RunCheck(Game,False,Nr) then exit;
  History.Add(Game.Name);

  try
    RunPrgManager.RunBeforeExecutionCommand(Game);

    If PrgSetup.MinimizeOnWindowsGameStart then begin
      AlreadyMinimized:=(Application.MainForm.WindowState=wsMinimized);
      Application.Minimize;
    end;

    Handle:=RunFile(S,T);
    try
      RunPrgManager.AddCommand(Game,Handle);
    finally
      CloseHandle(Handle);
    end;
  finally
    If PrgSetup.MinimizeOnWindowsGameStart and (not AlreadyMinimized) then begin
      MinimizedAtWindowsGameStart:=True;
      MinimizedAtWindowsGameStartTime:=Now;
    end;
  end;
end;

end.
