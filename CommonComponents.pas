unit CommonComponents;
interface

uses Windows, Classes, IniFiles, Math, Variants;

Type ConfigRec=record
  Nr : Integer;
  Section, Key : String;
  DefaultBool : Boolean;
  DefaultInteger : Integer;
  DefaultString : String;
  Cached : Boolean;
  CacheValueBool : Boolean;
  CacheValueInteger : Integer;
  CacheValueString : String;
end;

Type TConfigRecArray=Array of ConfigRec;
     TConfigIndexArray=Array of Integer;

Type TBasePrgSetup=class
  private
    FSetupFile : String;
    FFirstRun : Boolean;
    Ini : TMemIniFile;
    OwnINI : Boolean;
    BooleanList, IntegerList, StringList : TConfigRecArray;
    BooleanIndex, IntegerIndex, StringIndex : TConfigIndexArray;
    FStoreConfigOnExit : Boolean;
    FOnChanged : TNotifyEvent;
    FLastTimeStamp : DWord;
    Procedure ClearLists;
    Function IndexOf(const Nr : Integer; const List : TConfigRecArray; var Index : TConfigIndexArray) : Integer; inline;
    Procedure AddRec(const Nr : Integer; const Section, Key : String; const Default : Variant; var List : TConfigRecArray);
    Procedure ReadStringFromINI(const I : Integer);
  protected
    Procedure AddBooleanRec(const Nr : Integer; const Section, Key : String; const Default : Boolean);
    Procedure AddIntegerRec(const Nr : Integer; const Section, Key : String; const Default : Integer);
    Procedure AddStringRec(const Nr : Integer; const Section, Key : String; const Default : String);
    function GetBoolean(const Index: Integer): Boolean;
    function GetInteger(const Index: Integer): Integer;
    function GetString(const Index: Integer): String; inline;
    procedure SetBoolean(const Index: Integer; const Value: Boolean);
    procedure SetInteger(const Index, Value: Integer);
    procedure SetString(const Index: Integer; const Value: String);
  public
    Constructor Create(const ASetupFile : String); overload;
    Constructor Create(const ABasePrgSetup : TBasePrgSetup); overload;
    Destructor Destroy; override;
    Procedure AssignFrom(const ABasePrgSetup : TBasePrgSetup);
    Procedure StoreAllValues;
    Procedure ResetToDefault;
    Function CheckAndUpdateTimeStamp : Boolean; {True=changed}
    Procedure ReloadINI;
    Procedure RenameINI(const NewFile : String);
    property SetupFile : String read FSetupFile;
    property FirstRun : Boolean read FFirstRun;
    property StoreConfigOnExit : Boolean read FStoreConfigOnExit write FStoreConfigOnExit;
    property OnChanged : TNotifyEvent read FOnChanged write FOnChanged;
end;

implementation

uses SysUtils, CommonTools;

{ TBasePrgSetup }

Function GetSimpleFileTime(const FileName : String) : DWord;
Var hFile : THandle;
    FileTime1, FileTime2, FileTime3 : TFileTime;
    FatDate, FatTime : Word;
begin
  hFile:=CreateFile(PChar(FileName),GENERIC_READ,FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  If hFile=INVALID_HANDLE_VALUE then begin result:=0; exit; end;
  try
    GetFileTime(hFile,@FileTime1,@FileTime2,@FileTime3);
  finally
    CloseHandle(hFile)
  end;
  FileTimeToDosDateTime(FileTime3,FatDate,FatTime);
  result:=FatDate*65536+FatTime;
end;

constructor TBasePrgSetup.Create(const ASetupFile: String);
begin
  inherited Create;
  FSetupFile:=ASetupFile;
  FLastTimeStamp:=0;
  FFirstRun:=not FileExists(ASetupFile);
  OwnINI:=True;
  If ASetupFile<>'' then begin
    Ini:=TMemIniFile.Create(ASetupFile);
    CheckAndUpdateTimeStamp;
  end else begin
    Ini:=nil; OwnIni:=False;
  end;
  ClearLists;
  FStoreConfigOnExit:=True;
end;

constructor TBasePrgSetup.Create(const ABasePrgSetup: TBasePrgSetup);
begin
  inherited Create;
  OwnINI:=False;
  FFirstRun:=False;
  Ini:=ABasePrgSetup.Ini;
  ClearLists;
  FStoreConfigOnExit:=True;
end;

destructor TBasePrgSetup.Destroy;
Var St,St2 : TStringList;
    I : Integer;
begin
  If OwnINI then begin

    St:=TStringList.Create;
    St2:=TStringList.Create;
    try
      Ini.ReadSections(St);
      For I:=0 to St.Count-1 do begin
        St2.Clear;
        Ini.ReadSection(St[I],St2);
        If St2.Count=0 then Ini.EraseSection(St[I]);
      end;
    finally
      St.Free;
      St2.Free;
    end;

    ClearLists;
    try
      If FStoreConfigOnExit then begin
        ForceDirectories(ExtractFilePath(Ini.FileName));
        Ini.UpdateFile;
      end;
    except end;
    Ini.Free;
  end else begin
    try
      If FStoreConfigOnExit and (Ini<>nil) then begin
        ForceDirectories(ExtractFilePath(Ini.FileName));
        Ini.UpdateFile;
      end;
    except end;
  end;
  
  inherited Destroy;
end;

function TBasePrgSetup.CheckAndUpdateTimeStamp: Boolean;
Var NewFileTime : DWord;
begin
  If FSetupFile='' then begin result:=False; exit; end;

  If not FileExists(FSetupFile) then begin
    ForceDirectories(ExtractFilePath(FSetupFile));
    Ini.UpdateFile;
    FLastTimeStamp:=GetSimpleFileTime(FSetupFile);
    result:=False;
    exit;
  end;

  NewFileTime:=GetSimpleFileTime(FSetupFile);
  result:=(NewFileTime<>FLastTimeStamp);
  FLastTimeStamp:=NewFileTime;
end;

Procedure TBasePrgSetup.ReloadINI;
Var I : Integer;
begin
  Ini.Free;
  Ini:=TMemIniFile.Create(FSetupFile);
  for I:=0 to length(BooleanList)-1 do BooleanList[I].Cached:=False;
  for I:=0 to length(IntegerList)-1 do IntegerList[I].Cached:=False;
  for I:=0 to length(StringList)-1 do StringList[I].Cached:=False;
end;

procedure TBasePrgSetup.RenameINI(const NewFile: String);
begin
  Ini.UpdateFile;
  Ini.Free;
  if RenameFile(FSetupFile,NewFile) then FSetupFile:=NewFile;
  Ini:=TMemIniFile.Create(FSetupFile); 
end;

procedure TBasePrgSetup.ClearLists;
begin
  SetLength(BooleanList,0);
  SetLength(IntegerList,0);
  SetLength(StringList,0);
end;

procedure TBasePrgSetup.AssignFrom(const ABasePrgSetup: TBasePrgSetup);
Var I : Integer;
begin
  For I:=0 to length(BooleanList)-1 do begin
    BooleanList[I].Cached:=True;
    BooleanList[I].CacheValueBool:=ABasePrgSetup.GetBoolean(BooleanList[I].Nr);
  end;
  For I:=0 to length(IntegerList)-1 do begin
    IntegerList[I].Cached:=True;
    IntegerList[I].CacheValueInteger:=ABasePrgSetup.GetInteger(IntegerList[I].Nr);
  end;
  For I:=0 to length(StringList)-1 do begin
    StringList[I].Cached:=True;
    StringList[I].CacheValueString:=ABasePrgSetup.GetString(StringList[I].Nr);
  end;

  StoreAllValues;
end;

Function TBasePrgSetup.IndexOf(const Nr : Integer; const List : TConfigRecArray; var Index : TConfigIndexArray) : Integer;
Var I,J : Integer;
begin
  If length(Index)=0 then begin
    J:=0; For I:=0 to length(List)-1 do J:=Max(J,List[I].Nr);
    SetLength(Index,J+1);
    For I:=0 to length(Index)-1 do Index[I]:=-1;
    For I:=0 to length(List)-1 do Index[List[I].Nr]:=I;
  end;
  result:=Index[Nr];
end;

procedure TBasePrgSetup.StoreAllValues;
Var I : Integer;
begin
  if Ini=nil then exit;

  For I:=0 to length(BooleanList)-1 do
    Ini.WriteBool(BooleanList[I].Section,BooleanList[I].Key,GetBoolean(BooleanList[I].Nr));

  For I:=0 to length(IntegerList)-1 do
    Ini.WriteInteger(IntegerList[I].Section,IntegerList[I].Key,GetInteger(IntegerList[I].Nr));

  For I:=0 to length(StringList)-1 do
    Ini.WriteString(StringList[I].Section,StringList[I].Key,GetString(StringList[I].Nr));

  try Ini.UpdateFile; except end; {Language Files may be read only in program foldes}

  CheckAndUpdateTimeStamp;
end;

procedure TBasePrgSetup.ResetToDefault;
Var I : Integer;
begin
  For I:=0 to length(BooleanList)-1 do
    SetBoolean(BooleanList[I].Nr,BooleanList[I].DefaultBool);

  For I:=0 to length(IntegerList)-1 do
    SetInteger(IntegerList[I].Nr,IntegerList[I].DefaultInteger);

  For I:=0 to length(StringList)-1 do
    SetString(StringList[I].Nr,StringList[I].DefaultString);

  try Ini.UpdateFile; except end; {Language Files may be read only in program foldes}

  CheckAndUpdateTimeStamp;
end;

procedure TBasePrgSetup.AddRec(const Nr: Integer; const Section, Key: String; const Default : Variant; var List: TConfigRecArray);
Var I,J : Integer;
begin
  I:=length(List);
  SetLength(List,I+1);

  J:=length(List)-1;
  For I:=0 to length(List)-2 do begin
    If Nr<List[I].Nr then begin J:=I; break; end;
  end;

  For I:=length(List)-2 downto J do List[I+1]:=List[I];

  List[J].Nr:=Nr;
  List[J].Section:=Section;
  List[J].Key:=Key;
  List[J].Cached:=False;
  If VarIsType(Default,varBoolean) then begin List[J].DefaultBool:=Default; end;
  If VarIsType(Default,varInteger) then begin List[J].DefaultInteger:=Default; end;
  If VarIsType(Default,varString) then begin List[J].DefaultString:=Default; end;
end;

procedure TBasePrgSetup.AddBooleanRec(const Nr: Integer; const Section, Key: String; const Default : Boolean);
begin
  AddRec(Nr,Section,Key,Default,BooleanList);
end;

procedure TBasePrgSetup.AddIntegerRec(const Nr: Integer; const Section, Key: String; const Default : Integer);
begin
  AddRec(Nr,Section,Key,Default,IntegerList);
end;

procedure TBasePrgSetup.AddStringRec(const Nr: Integer; const Section, Key: String; const Default : String);
begin
  AddRec(Nr,Section,Key,Default,StringList);
end;

function TBasePrgSetup.GetBoolean(const Index: Integer): Boolean;
Var I : Integer;
    S : String;
    B : Boolean;
begin
  I:=IndexOf(Index,BooleanList,BooleanIndex);
  if I<0 then begin result:=False; exit; end;
  with BooleanList[I] do begin
    If Cached then begin result:=CacheValueBool; exit; end;

    If DefaultBool then S:='true' else S:='false';
    If Ini<>nil then S:=Trim(ExtUpperCase(Ini.ReadString(Section,Key,S)));
    B:=False; result:=False;
    If (S='0') or (S='FALSE') then begin result:=False; B:=True; end;
    If (S='1') or (S='TRUE') then begin result:=True; B:=True; end;
    If not B then result:=DefaultBool;

    Cached:=True;
    CacheValueBool:=result;
  end;
end;

function TBasePrgSetup.GetInteger(const Index: Integer): Integer;
Var I : Integer;
begin
  I:=IndexOf(Index,IntegerList,IntegerIndex);
  Assert(I>=0,'Es gibt keinen Eintrag in der Integer-Liste mit der Nummer '+IntToStr(Index));
  if I<0 then begin result:=0; exit; end;
  with IntegerList[I] do begin
    If Cached then begin result:=CacheValueInteger; exit; end;
    If Ini<>nil then result:=Ini.ReadInteger(Section,Key,DefaultInteger) else result:=DefaultInteger;
    Cached:=True;
    CacheValueInteger:=result;
  end;
end;

Procedure TBasePrgSetup.ReadStringFromINI(const I : Integer);
begin
  with StringList[I] do begin
    Cached:=True;
    if Ini<>nil then CacheValueString:=Ini.ReadString(Section,Key,DefaultString) else CacheValueString:=DefaultString;
  end;
end;

function TBasePrgSetup.GetString(const Index: Integer): String;
Var I : Integer;
begin
  I:=IndexOf(Index,StringList,StringIndex);
  if I<0 then begin result:=''; exit; end;
  with StringList[I] do begin
    If not Cached then ReadStringFromINI(I);
    result:=CacheValueString;
  end;
end;

procedure TBasePrgSetup.SetBoolean(const Index: Integer; const Value: Boolean);
Var I : Integer;
begin
  I:=IndexOf(Index,BooleanList,BooleanIndex);
  if I<0 then exit;
  with BooleanList[I] do begin
    If DefaultBool=Value then Ini.DeleteKey(Section,Key) else Ini.WriteBool(Section,Key,Value);
    Cached:=True;
    CacheValueBool:=Value;
  end;
end;

procedure TBasePrgSetup.SetInteger(const Index, Value: Integer);
Var I : Integer;
begin
  I:=IndexOf(Index,IntegerList,IntegerIndex);
  if I<0 then exit;
  with IntegerList[I] do begin
    If DefaultInteger=Value then Ini.DeleteKey(Section,Key) else Ini.WriteInteger(Section,Key,Value);
    Cached:=True;
    CacheValueInteger:=Value;
  end;
end;

procedure TBasePrgSetup.SetString(const Index: Integer; const Value: String);
Var I : Integer;
begin
  I:=IndexOf(Index,StringList,StringIndex);
  if I<0 then exit;
  with StringList[I] do begin
    If DefaultString=Value then Ini.DeleteKey(Section,Key) else Ini.WriteString(Section,Key,Value);
    Cached:=True;
    CacheValueString:=Value;
  end;
end;

end.
