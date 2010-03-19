unit LoggingUnit;
interface

{DEFINE TurnStartupLoggingOn}

Procedure LogInfo(const Info : String; const ContinueLogging : Boolean = True);

implementation

uses SysUtils, Forms;

{$IFDEF TurnStartupLoggingOn}
var StartupLogFile : String ='';
{$ENDIF}

Procedure LogInfo(const Info : String; const ContinueLogging : Boolean);
{$IFDEF TurnStartupLoggingOn} Var F : TextFile; {$ENDIF}
begin
  {$IFDEF TurnStartupLoggingOn}
  If StartupLogFile='' then exit;
  If not FileExists(StartupLogFile) then begin StartupLogFile:=''; exit; end;
  AssignFile(F,StartupLogFile);
  Append(F);
  try
    Writeln(F,TimeToStr(Now)+' '+Info);
  finally
    CloseFile(F);
  end;
  If not ContinueLogging then StartupLogFile:='';
  {$ENDIF}
end;

initialization
  {$IFDEF TurnStartupLoggingOn}
  StartupLogFile:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'DFR-Log.txt';
  {$ENDIF}
end.
