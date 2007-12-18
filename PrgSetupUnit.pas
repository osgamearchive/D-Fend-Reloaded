unit PrgSetupUnit;
interface

uses CommonComponents;

Type TOperationMode=(omPrgDir, omUserDir, omPortable);

var OperationMode : TOperationMode;

{
omPrgDir=Data is stored in Programfolder; XP with User is Admin
omUserDir=Data is stored in User-Data-Folder; Vista with normal User
omPortable=like omPrgDir, but DosBoxDir, BaseDir, GameDir and DataDir are stored relative to PrgDir
}

Type TPrgSetup=class(TBasePrgSetup)
  private
    Procedure InitDirs;
    Procedure DoneDirs;
  public
    Constructor Create(const SetupFile : String = '');
    Destructor Destroy; override;

    property DosBoxDir : String index 0 read GetString write SetString;
    property DosBoxMapperFile : String index 1 read GetString write SetString;
    property GameDir : String index 2 read GetString write SetString;
    property BaseDir : String index 3 read GetString write SetString;
    property DataDir : String index 4 read GetString write SetString;
    property DosBoxLanguage : String index 5 read GetString write SetString;
    property Language : String index 6 read GetString write SetString;
    property ColOrder : String index 7 read GetString write SetString;
    property ColVisible : String index 8 read GetString write SetString;
    property ListViewStyle : String index 9 read GetString write SetString;
    property SDLVideodriver : String index 10 read GetString write SetString;

    property AskBeforeDelete : Boolean index 0 read GetBoolean write SetBoolean;
    property ReopenLastProfileEditorTab : Boolean index 1 read GetBoolean write SetBoolean;
    property HideDosBoxConsole : Boolean index 2 read GetBoolean write SetBoolean;
    property MinimizeOnDosBoxStart : Boolean index 3 read GetBoolean write SetBoolean;
    property RestoreWindowSize : Boolean index 4 read GetBoolean write SetBoolean;
    property MainMaximized : Boolean index 5 read GetBoolean write SetBoolean;
    property MinimizeToTray : Boolean index 6 read GetBoolean write SetBoolean;
    property DeleteOnlyInBaseDir : Boolean index 7 read GetBoolean write SetBoolean;
    property ShowScreenshots : Boolean index 8 read GetBoolean write SetBoolean;
    property ShowTree : Boolean index 9 read GetBoolean write SetBoolean;
    property ShowSearchBox : Boolean index 10 read GetBoolean write SetBoolean;
    property ShowExtraInfo : Boolean index 11 read GetBoolean write SetBoolean;

    property MainLeft : Integer index 0 read GetInteger write SetInteger;
    property MainTop : Integer index 1 read GetInteger write SetInteger;
    property MainWidth : Integer index 2 read GetInteger write SetInteger;
    property MainHeight : Integer index 3 read GetInteger write SetInteger;
    property TreeWidth : Integer index 4 read GetInteger write SetInteger;
    property ScreenshotHeight : Integer index 5 read GetInteger write SetInteger;
    property ScreenshotPreviewSize : Integer index 6 read GetInteger write SetInteger;
end;

var PrgSetup : TPrgSetup;

Function PrgDataDir : String;

implementation

uses ShlObj, Classes, SysUtils, Forms, CommonTools, PrgConsts;

{ TPrgSetup }

constructor TPrgSetup.Create(const SetupFile : String);
begin
  If SetupFile=''
    then inherited Create(PrgDataDir+MainSetupFile)
    else inherited Create(SetupFile);

  AddStringRec(0,'ProgramSets','Location','');
  AddStringRec(1,'ProgramSets','LocationMap','.\mapper.txt');
  AddStringRec(2,'ProgramSets','DefGameLoc',PrgDataDir+'VirtualHD\');
  AddStringRec(3,'ProgramSets','DefLoc',PrgDataDir);
  AddStringRec(4,'ProgramSets','DefDataLoc',PrgDataDir+'GameData\');
  AddStringRec(5,'ProgramSets','DosBoxLanguageFile','');
  AddStringRec(6,'ProgramSets','LanguageFile','English.ini');
  AddStringRec(7,'ProgramSets','ColOrder','123456');
  AddStringRec(8,'ProgramSets','ColVisible','111111');
  AddStringRec(9,'ProgramSets','ILVS','List');
  AddStringRec(10,'ProgramSets','SDLVideodriver','DirectX');

  AddBooleanRec(0,'ProgramSets','AskBeforeDelete',True);
  AddBooleanRec(1,'ProgramSets','ShowLastTab',False);
  AddBooleanRec(2,'ProgramSets','Hideconsole',True);
  AddBooleanRec(3,'ProgramSets','Minimize',False);
  AddBooleanRec(4,'ProgramSets','RestoreWindowSize',False);
  AddBooleanRec(5,'ProgramSets','MainMaximized',False);
  AddBooleanRec(6,'ProgramSets','MinimizeToTray',False);
  AddBooleanRec(7,'ProgramSets','DeleteOnlyInBaseDir',True);
  AddBooleanRec(8,'ProgramSets','ShowThumbNails',True);
  AddBooleanRec(9,'ProgramSets','ShowFilterTree',True);
  AddBooleanRec(10,'ProgramSets','ShowSearchBox',True);
  AddBooleanRec(11,'ProgramSets','ShowExtrainfo',True);

  AddIntegerRec(0,'ProgramSets','MainLeft',-1);
  AddIntegerRec(1,'ProgramSets','MainTop',-1);
  AddIntegerRec(2,'ProgramSets','MainWidth',-1);
  AddIntegerRec(3,'ProgramSets','MainHeight',-1);
  AddIntegerRec(4,'ProgramSets','TreeWidth',-1);
  AddIntegerRec(5,'ProgramSets','ScreenshotHeight',-1);
  AddIntegerRec(6,'ProgramSets','ScreenshotPreviewHeight',100);

  InitDirs;
end;

destructor TPrgSetup.Destroy;
begin
  DoneDirs;
  inherited Destroy;
end;

Procedure TPrgSetup.InitDirs;
begin
  If BaseDir='' then BaseDir:=PrgDataDir;
  If GameDir='' then GameDir:=BaseDir+'VirtualHD\';
  If DataDir='' then DataDir:=BaseDir+'GameData\';

  If OperationMode=omPortable then begin
    BaseDir:=MakeAbsPath(BaseDir,PrgDir);
    GameDir:=MakeAbsPath(GameDir,PrgDir);
    DataDir:=MakeAbsPath(DataDir,PrgDir);
    DosBoxDir:=MakeAbsPath(DosBoxDir,PrgDir);
  end;
end;

procedure TPrgSetup.DoneDirs;
begin
  If OperationMode=omPortable then begin
    BaseDir:=MakeRelPath(BaseDir,PrgDir);
    GameDir:=MakeRelPath(GameDir,PrgDir);
    DataDir:=MakeRelPath(DataDir,PrgDir);
    DosBoxDir:=MakeRelPath(DosBoxDir,PrgDir);
  end;
end;

Procedure ReadOperationMode;
Var St : TStringList;
    I : Integer;
    S : String;
begin
  OperationMode:=omPrgDir;
  if not FileExists(PrgDir+OperationModeConfig) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(PrgDir+OperationModeConfig); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OperationMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OperationMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OperationMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

Function PrgDataDir : String;
begin
  If OperationMode=omUserDir then begin
    result:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    result:=PrgDir;
  end;
end;

initialization
  ReadOperationMode;
  PrgSetup:=TPrgSetup.Create;
finalization
  PrgSetup.Free;
end.
