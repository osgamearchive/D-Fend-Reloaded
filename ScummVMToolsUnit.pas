unit ScummVMToolsUnit;
interface

uses Classes;

Type TScummVMGamesList=class
  private
    FName, FLongName : TStringList;
    Procedure LoadConfig;
    Procedure SaveConfig;
    function GetCount: Integer;
    Function LoadListFromScummVMFile(const ScummVMPrgFile : String) : Boolean;
    Function LoadListFromScummVMStringList(const St : TStringList) : Boolean;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadListFromScummVM(const WarnIfScummVMNotFound : Boolean; const CustomScummVMPath : String ='') : Boolean;
    Function NameFromDescription(const Description : String) : String;
    property Count : Integer read GetCount;
    property NamesList : TStringList read FName;
    property DescriptionList : TStringList read FLongName;
end;

Var ScummVMGamesList : TScummVMGamesList;

implementation

uses Windows, SysUtils, Dialogs, IniFiles, PrgSetupUnit, PrgConsts,
     LanguageSetupUnit, CommonTools;

{ TScummVMGamesList }

constructor TScummVMGamesList.Create;
begin
  inherited Create;

  FName:=TStringList.Create;
  FLongName:=TStringList.Create;
  LoadConfig;
end;

destructor TScummVMGamesList.Destroy;
begin
  SaveConfig;
  FName.Free;
  FLongName.Free;
  inherited Destroy;
end;

procedure TScummVMGamesList.LoadConfig;
Var Ini : TIniFile;
    I : Integer;
begin
  Ini:=TIniFile.Create(PrgDataDir+ScummVMConfOptFile);
  try
    Ini.ReadSections(FName);
    For I:=0 to FName.Count-1 do FLongName.Add(Ini.ReadString(FName[I],'Description',''));
  finally
    Ini.Free;
  end;
end;

procedure TScummVMGamesList.SaveConfig;
Var Ini : TIniFile;
    I : Integer;
begin
  If FName.Count=0 then begin
    DeleteFile(PrgDataDir+ScummVMConfOptFile);
    exit;
  end;

  Ini:=TIniFile.Create(PrgDataDir+ScummVMConfOptFile);
  try
    For I:=0 to FName.Count-1 do Ini.WriteString(FName[I],'Description',FLongName[I]);
  finally
    Ini.Free;
  end;
end;

function TScummVMGamesList.GetCount: Integer;
begin
  result:=FName.Count;
end;

Function TScummVMGamesList.LoadListFromScummVM(const WarnIfScummVMNotFound : Boolean; const CustomScummVMPath : String) : Boolean;
Var S : String;
begin
  result:=False;

  FName.Clear;
  FLongName.Clear;

  If Trim(CustomScummVMPath)<>'' then begin
    S:=IncludeTrailingPathDelimiter(Trim(CustomScummVMPath))+ScummPrgFile;
  end else begin
    S:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile;
  end;
  If not FileExists(S) then begin
    if WarnIfScummVMNotFound then MessageDlg(Format(LanguageSetup.MessageFileNotFound,[S]),mtError,[mbOK],0);
    exit;
  end;

  result:=LoadListFromScummVMFile(S);
end;

Procedure RunAndWait(const PrgFile, Path : String);
Var StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;
  CreateProcess(PChar(PrgFile),PChar('"'+PrgFile+'"'),nil,nil,False,0,nil,PChar(Path),StartupInfo,ProcessInformation);

  WaitForSingleObject(ProcessInformation.hThread,INFINITE);
  CloseHandle(ProcessInformation.hThread);
  CloseHandle(ProcessInformation.hProcess);
end;

function TScummVMGamesList.LoadListFromScummVMFile(const ScummVMPrgFile: String): Boolean;
Var St : TStringList;
    TempList, TempBat : String;
begin
  result:=False;

  TempList:=TempDir+'D-Fend-Reloaded-List.txt';
  TempBat:=TempDir+'D-Fend-Reloaded-List.bat';

  { Create batch file to run }
  try
    St:=TStringList.Create;
    try
      St.Add('"'+ScummVMPrgFile+'" -z > "'+TempList+'"');
      St.SaveToFile(TempBat);
    finally
      St.Free;
    end;
  except
    MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[TempBat]),mtError,[mbOK],0);
    exit;
  end;

  { Run ScummVM }
  RunAndWait(TempBat,ExtractFilePath(ScummVMPrgFile));
  DeleteFile(TempBat);

  { Read list file }
  If not FileExists(TempList) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[TempList]),mtError,[mbOK],0);
    exit;
  end;

  St:=TStringList.Create;
  try
    try
      St.LoadFromFile(TempList);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[TempList]),mtError,[mbOK],0);
      exit;
    end;
    result:=LoadListFromScummVMStringList(St);
  finally
    St.Free;
  end;
end;

function TScummVMGamesList.LoadListFromScummVMStringList(const St: TStringList): Boolean;
Var I,Mode,J : Integer;
begin
  result:=False;
  Mode:=0; J:=10;
  For I:=0 to St.Count-1 do Case Mode of
    0 : If Copy(St[I],1,3)='---' then begin J:=Pos(' ',St[I]); Mode:=1; end;
    1 : begin FName.Add(Trim(Copy(St[I],1,J-1))); FLongName.Add(Trim(Copy(St[I],J+1,MaxInt))); end;
  end;
end;

function TScummVMGamesList.NameFromDescription(const Description: String): String;
Var I : Integer;
begin
  result:='';
  I:=FLongName.IndexOf(Description);
  If I>=0 then result:=FName[I];
end;

initialization
  ScummVMGamesList:=TScummVMGamesList.Create;
finalization
  ScummVMGamesList.Free;
end.
