unit WindowsProfileUnit;
interface

uses GameDBUnit;

Procedure RunWindowsGame(const Game : TGame; const RunSetup : Boolean = False);
Procedure RunWindowssExtraFile(const Game : TGame; Nr : Integer);

implementation

uses Windows, SysUtils, Dialogs, Forms, ShellAPI, LanguageSetupUnit, CommonTools,
     PrgSetupUnit, GameDBToolsUnit, DOSBoxUnit;

Procedure RunFile(const FileName, Parameters : String);
begin
  ShellExecute(Application.MainForm.Handle,'open',PChar(FileName),PChar(Parameters),PChar(IncludeTrailingPathDelimiter((ExtractFilePath(FileName)))),SW_SHOW);

  If PrgSetup.MinimizeOnDosBoxStart then begin
    Sleep(1000);
    MinimizedAtDOSBoxStart:=True;
  end;
end;

Function WindowsRunCheck(var FileName : String) : Boolean;
begin
  result:=False;

  If FileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;
  FileName:=MakeAbsPath(FileName,PrgSetup.BaseDir);

  If not FileExists(FileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[FileName]),mtError,[mbOK],0);
    exit;
  end;

  If IsDOSExe(FileName) then begin
    MessageDlg(Format(LanguageSetup.MessageDOSExeExecuteWarning,[FileName]),mtError,[mbOK],0);
  end;

  result:=True;
end;

Procedure RunWindowsGame(const Game : TGame; const RunSetup : Boolean);
Var S,T : String;
begin
  If RunSetup then begin
    S:=Trim(Game.SetupExe);
    T:=Game.GameParameters;
  end else begin
    S:=Trim(Game.GameExe);
    T:=Game.SetupParameters;
  end;

  If not WindowsRunCheck(S) then exit;
  if not RunCheck(Game,RunSetup) then exit;
  AddToHistory(Game.Name);
  RunFile(S,T);
end;

Procedure RunWindowssExtraFile(const Game : TGame; Nr : Integer);
Var S,T : String;
    I : Integer;
begin
  S:=Trim(Game.ExtraPrgFile[Nr]); I:=Pos(';',S);
  If (S='') or (I=0) then begin
    S:=Trim(Game.GameExe); T:=Game.GameParameters;
  end else begin
    S:=Copy(S,I+1,MaxInt);
    T:='';
  end;

  If not WindowsRunCheck(S) then exit;
  if not RunCheck(Game,False,Nr) then exit;
  AddToHistory(Game.Name);
  RunFile(S,T);
end;

end.
