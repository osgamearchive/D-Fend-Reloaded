unit PackageDBUnit;
interface

uses Classes, XMLIntf, Forms;

Type TDownloadData=class
  protected
    FName, FURL, FPackageChecksum : String;
    FSize : Integer;
    FChecksumXMLName : String;
    FPackageFileURL : String;
    Function CheckAttributes(const N : IXMLNode; const Attr : Array of String) : Boolean;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; virtual;
    property Name : String read FName;
    property URL : String read FURL;
    property Size : Integer read FSize;
    property PackageChecksum : String read FPackageChecksum;
    property PackageFileURL : String read FPackageFileURL;
end;

Type TDownloadIconData=class(TDownloadData)
  public
    Constructor Create(const APackageFileURL : String);
end;

Type TDownloadAutoSetupData=class(TDownloadData)
  private
    FGenre, FDeveloper, FPublisher, FYear, FLanguage, FGameExeChecksum : String;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    property Genre : String read FGenre;
    property Developer : String read FDeveloper;
    property Publisher : String read FPublisher;
    property Year : String read FYear;
    property Language : String read FLanguage;
    property GameExeChecksum : String read FGameExeChecksum;
end;

Type TDownloadZipData=class(TDownloadAutoSetupData)
  private
    FLicense : String;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    property License : String read FLicense;
end;

Type TDownloadLanguageData=class(TDownloadData)
  private
    FVersion, FAuthor : String;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    property Version : String read FVersion;
    property Author : String read FAuthor;
end;

Type TDownloadExeData=class(TDownloadData)
  private
    FDescription : String;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    property Description : String read FDescription;
end;

Type TDownloadIconSetData=class(TDownloadData)
  private
    FVersion, FAuthor : String;
  public
    Constructor Create(const APackageFileURL : String);
    Function LoadFromXMLNode(const N : IXMLNode) : Boolean; override;
    property Version : String read FVersion;
    property Author : String read FAuthor;
end;

Type TPackageList=class
  private
    FUpdateDate : TDateTime;
    FName : String;
    FFileName, FURL : String;
    FGame, FAutoSetup, FLanguage, FExePackage, FIcon, FIconSet : TList;
    function GetCount(const Index: Integer): Integer;
    Function AddGame(const N : IXMLNode) : Boolean;
    Function AddAutoSetup(const N : IXMLNode) : Boolean;
    Function AddLanguage(const N : IXMLNode) : Boolean;
    Function AddExePackage(const N : IXMLNode) : Boolean;
    Function AddIcon(const N : IXMLNode) : Boolean;
    Function AddIconSet(const N : IXMLNode) : Boolean;
    function GetAutoSetup(I: Integer): TDownloadAutoSetupData;
    function GetExePackage(I: Integer): TDownloadExeData;
    function GetGame(I: Integer): TDownloadZipData;
    function GetLanguage(I: Integer): TDownloadLanguageData;
    function GetIcon(I: Integer): TDownloadIconData;
    function GetIconSet(I: Integer): TDownloadIconSetData;
  public
    Constructor Create(const AURL : String);
    Destructor Destroy; override;
    Procedure Clear;
    Function LoadFromFile(const AFileName : String) : Boolean;
    property FileName : String read FFileName;
    property Name : String read FName;
    property UpdateDate : TDateTime read FUpdateDate;
    property GamesCount : Integer index 0 read GetCount;
    property AutoSetupCount : Integer index 1 read GetCount;
    property LanguageCount : Integer index 2 read GetCount;
    property ExePackageCount : Integer index 3 read GetCount;
    property IconCount : Integer index 4 read GetCount;
    property IconSetCount : Integer index 5 read GetCount;
    property Game[I : Integer] : TDownloadZipData read GetGame;
    property AutoSetup[I : Integer] : TDownloadAutoSetupData read GetAutoSetup;
    property Language[I : Integer] : TDownloadLanguageData read GetLanguage;
    property ExePackage[I : Integer] : TDownloadExeData read GetExePackage;
    property Icon[I : Integer] : TDownloadIconData read GetIcon;
    property IconSet[I : Integer] : TDownloadIconSetData read GetIconSet;
end;

Type TPackageListFile=class
  private
    FUpdateDate : TDateTime;
    FURL : TStringList;
    FActive : TList;
    FFileName : String;
    function GetCount: Integer;
    function GetURL(I: Integer): String;
    function GetActive(I: Integer): Boolean;
    procedure SetActive(I: Integer; const Value: Boolean);
    procedure SetURL(I: Integer; const Value: String);
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;
    Function LoadFromFile(const AFileName : String) : Boolean;
    Procedure SaveToFile(const ParentForm : TForm);
    Procedure UpdateFromServer(const URL, TempFile : String);
    Procedure Add(const AURL : String; const AActive : Boolean);
    Procedure Delete(const Nr : Integer);
    property FileName : String read FFileName;
    property UpdateDate : TDateTime read FUpdateDate;
    property Count : Integer read GetCount;
    property URL[I : Integer] : String read GetURL write SetURL; default;
    property Active[I : Integer] : Boolean read GetActive write SetActive;
end;

Type TDownloadStatus=(dsStart,dsProgress,dsDone);
Type TDownloadEvent=Procedure(Sender : TObject; const Progress, Size : Integer; const Status : TDownloadStatus; var ContinueDownload : Boolean) of object;

Type TPackageDB=class
  private
    FPackageList : TList;
    FDBDir : String;
    FOnDownload : TDownloadEvent;
    Function InitDBDir : Boolean;
    Procedure InitPackageFiles(const MainFile, UserFile : TPackageListFile; const Update: Boolean);
    Function InitPackageFile(const URL : String; const Update : Boolean) : TPackageList;
    Function GetCount: Integer;
    Function GetPackageList(I: Integer): TPackageList;
    Function FileInUse(FileName : String) : Boolean;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;
    Procedure LoadDB(const Update : Boolean);
    property Count : Integer read GetCount;
    property List[I : Integer] : TPackageList read GetPackageList; default;
    property DBDir : String read FDBDir;
    property OnDownload : TDownloadEvent read FOnDownload write FOnDownload;
end;

implementation

uses Windows, SysUtils, Dialogs, XMLDom, XMLDoc, MSXMLDOM, PackageDBToolsUnit,
     CommonTools, PackageDBLanguage, PrgConsts, PrgSetupUnit, LanguageSetupUnit;

{ TDownloadData }

constructor TDownloadData.Create(const APackageFileURL : String);
begin
  inherited Create;
  FName:='';
  FURL:='';
  FPackageChecksum:='';
  FSize:=0;
  FPackageFileURL:=APackageFileURL;

  FChecksumXMLName:='PackageChecksum';
end;

Function TDownloadData.CheckAttributes(const N : IXMLNode; const Attr : Array of String) : Boolean;
Var I : Integer;
begin
  result:=False;
  For I:=Low(Attr) to High(Attr) do If not N.HasAttribute(Attr[I]) then exit;
  result:=True;
end;

function TDownloadData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not CheckAttributes(N,['Name',FChecksumXMLName,'Size']) then exit;
  FName:=N.Attributes['Name'];
  FPackageChecksum:=N.Attributes[FChecksumXMLName];
  if not TryStrToInt(N.Attributes['Size'],FSize) then FSize:=0;
  FURL:=N.NodeValue; If (FURL='') then exit;
  result:=True;
end;

{ TDownloadIconData }

constructor TDownloadIconData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FChecksumXMLName:='FileChecksum';
end;

{ TDownloadAutoSetupData }

constructor TDownloadAutoSetupData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FGenre:='';
  FDeveloper:='';
  FPublisher:='';
  FYear:='';
  FLanguage:='';
end;

function TDownloadAutoSetupData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['Genre','Developer','Publisher','Year','Language']) then exit;
  FGenre:=N.Attributes['Genre'];
  FDeveloper:=N.Attributes['Developer'];
  FPublisher:=N.Attributes['Publisher'];
  FYear:=N.Attributes['Year'];
  FLanguage:=N.Attributes['Language'];
  If N.HasAttribute('GameExeChecksum') then FGameExeChecksum:=N.Attributes['GameExeChecksum'] else FGameExeChecksum:='';
  result:=True;
end;

{ TDownloadZipData }

constructor TDownloadZipData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FLicense:='';
end;

function TDownloadZipData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['License']) then exit;
  FLicense:=N.Attributes['License'];
  result:=True;
end;

{ TDownloadLanguage }

constructor TDownloadLanguageData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FVersion:=''; FAuthor:='';
end;

function TDownloadLanguageData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  If not CheckAttributes(N,['Version','Author']) then exit;
  FVersion:=N.Attributes['Version'];
  FAuthor:=N.Attributes['Author'];
  result:=True;
end;

{ TDownloadExeData }

constructor TDownloadExeData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FDescription:='';
end;

function TDownloadExeData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  If not inherited LoadFromXMLNode(N) then exit;
  if not CheckAttributes(N,['Description']) then exit;
  FDescription:=N.Attributes['Description'];
  result:=True;
end;

{ TDownloadIconSetData }

constructor TDownloadIconSetData.Create(const APackageFileURL : String);
begin
  inherited Create(APackageFileURL);
  FChecksumXMLName:='FileChecksum';
  FVersion:=''; FAuthor:='';
end;

function TDownloadIconSetData.LoadFromXMLNode(const N: IXMLNode): Boolean;
begin
  result:=False;
  if not inherited LoadFromXMLNode(N) then exit;
  If not CheckAttributes(N,['Version','Author']) then exit;
  FVersion:=N.Attributes['Version'];
  FAuthor:=N.Attributes['Author'];
  result:=True;
end;

{ TPackageList }

constructor TPackageList.Create(const AURL : String);
begin
  inherited Create;
  FUpdateDate:=0;
  FFileName:='';
  FURL:=AURL;
  FGame:=TList.Create;
  FAutoSetup:=TList.Create;
  FLanguage:=TList.Create;
  FExePackage:=TList.Create;
  FIcon:=TList.Create;
  FIconSet:=TList.Create;
end;

destructor TPackageList.Destroy;
begin
  Clear;
  FGame.Free;
  FAutoSetup.Free;
  FLanguage.Free;
  FExePackage.Free;
  FIcon.Free;
  FIconSet.Free;
  inherited Destroy;
end;

Procedure TPackageList.Clear;
Var I : Integer;
begin
  For I:=0 to FGame.Count-1 do TDownloadZipData(FGame[I]).Free;
  FGame.Clear;
  For I:=0 to FAutoSetup.Count-1 do TDownloadAutoSetupData(FAutoSetup[I]).Free;
  FAutoSetup.Clear;
  For I:=0 to FLanguage.Count-1 do TDownloadLanguageData(FLanguage[I]).Free;
  FLanguage.Clear;
  For I:=0 to FExePackage.Count-1 do TDownloadExeData(FExePackage[I]).Free;
  FExePackage.Clear;
  For I:=0 to FIcon.Count-1 do TDownloadIconData(FIcon[I]).Free;
  FIcon.Clear;
  For I:=0 to FIconSet.Count-1 do TDownloadIconData(FIconSet[I]).Free;
  FIconSet.Clear;
end;

function TPackageList.GetCount(const Index: Integer): Integer;
begin
  Case Index of
    0 : result:=FGame.Count;
    1 : result:=FAutoSetup.Count;
    2 : result:=FLanguage.Count;
    3 : result:=FExePackage.Count;
    4 : result:=FIcon.Count;
    5 : result:=FIconSet.Count;
    else result:=0;
  end;
end;

function TPackageList.GetGame(I: Integer): TDownloadZipData;
begin
  If (I<0) or (I>=FGame.Count) then result:=nil else result:=TDownloadZipData(FGame[I]);
end;

function TPackageList.GetAutoSetup(I: Integer): TDownloadAutoSetupData;
begin
  If (I<0) or (I>=FAutoSetup.Count) then result:=nil else result:=TDownloadAutoSetupData(FAutoSetup[I]);
end;

function TPackageList.GetLanguage(I: Integer): TDownloadLanguageData;
begin
  If (I<0) or (I>=FLanguage.Count) then result:=nil else result:=TDownloadLanguageData(FLanguage[I]);
end;

function TPackageList.GetExePackage(I: Integer): TDownloadExeData;
begin
  If (I<0) or (I>=FExePackage.Count) then result:=nil else result:=TDownloadExeData(FExePackage[I]);
end;

function TPackageList.GetIcon(I: Integer): TDownloadIconData;
begin
  If (I<0) or (I>=FIcon.Count) then result:=nil else result:=TDownloadIconData(FIcon[I]);
end;

function TPackageList.GetIconSet(I: Integer): TDownloadIconSetData;
begin
  If (I<0) or (I>=FIconSet.Count) then result:=nil else result:=TDownloadIconSetData(FIconSet[I]);
end;

Function TPackageList.AddGame(const N : IXMLNode) : Boolean;
Var DownloadZipData : TDownloadZipData;
begin
  DownloadZipData:=TDownloadZipData.Create(FURL);
  result:=DownloadZipData.LoadFromXMLNode(N);
  if result then FGame.Add(DownloadZipData) else DownloadZipData.Free;
end;

Function TPackageList.AddAutoSetup(const N : IXMLNode) : Boolean;
Var DownloadAutoSetupData : TDownloadAutoSetupData;
begin
  DownloadAutoSetupData:=TDownloadAutoSetupData.Create(FURL);
  result:=DownloadAutoSetupData.LoadFromXMLNode(N);
  if result then FAutoSetup.Add(DownloadAutoSetupData) else DownloadAutoSetupData.Free;
end;

Function TPackageList.AddLanguage(const N : IXMLNode) : Boolean;
Var DownloadLanguageData : TDownloadLanguageData;
begin
  DownloadLanguageData:=TDownloadLanguageData.Create(FURL);
  result:=DownloadLanguageData.LoadFromXMLNode(N);
  if result then FLanguage.Add(DownloadLanguageData) else DownloadLanguageData.Free;
end;

Function TPackageList.AddExePackage(const N : IXMLNode) : Boolean;
Var DownloadExeData : TDownloadExeData;
begin
  DownloadExeData:=TDownloadExeData.Create(FURL);
  result:=DownloadExeData.LoadFromXMLNode(N);
  if result then FExePackage.Add(DownloadExeData) else DownloadExeData.Free;
end;

Function TPackageList.AddIcon(const N : IXMLNode) : Boolean;
Var DownloadIconData : TDownloadIconData;
begin
  DownloadIconData:=TDownloadIconData.Create(FURL);
  result:=DownloadIconData.LoadFromXMLNode(N);
  if result then FIcon.Add(DownloadIconData) else DownloadIconData.Free;
end;

Function TPackageList.AddIconSet(const N : IXMLNode) : Boolean;
Var DownloadIconSetData : TDownloadIconSetData;
begin
  DownloadIconSetData:=TDownloadIconSetData.Create(FURL);
  result:=DownloadIconSetData.LoadFromXMLNode(N);
  if result then FIconSet.Add(DownloadIconSetData) else DownloadIconSetData.Free;
end;

function TPackageList.LoadFromFile(const AFileName: String): Boolean;
Var XMLDoc : TXMLDocument;
    I : Integer;
    N : IXMLNode;
begin
  result:=False;
  FFileName:=AFileName;
  Clear;

  XMLDoc:=LoadXMLDoc(AFileName); if XMLDoc=nil then exit;
  try
    If XMLDoc.DocumentElement.NodeName<>'DFRPackagesFile' then exit;
    If not XMLDoc.DocumentElement.HasAttribute('Name') then exit;
    FName:=XMLDoc.DocumentElement.Attributes['Name'];
    If not XMLDoc.DocumentElement.HasAttribute('LastUpdateDate') then FUpdateDate:=0 else begin
      FUpdateDate:=DecodeUpdateDate(XMLDoc.DocumentElement.Attributes['LastUpdateDate']);
    end;
    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do begin
      N:=XMLDoc.DocumentElement.ChildNodes[I];
      If N.NodeName='Game' then AddGame(N);
      If N.NodeName='AutoSetup' then AddAutoSetup(N);
      If N.NodeName='Language' then AddLanguage(N);
      If N.NodeName='ExePackage' then AddExePackage(N);
      If N.NodeName='Icon' then AddIcon(N);
      If N.NodeName='IconSet' then AddIconSet(N);
    end;
  finally
    XMLDoc.Free;
  end;

  result:=True;
end;

{ TMainPackageFile }

constructor TPackageListFile.Create;
begin
  inherited Create;
  FUpdateDate:=0;
  FURL:=TStringList.Create;
  FActive:=TList.Create;
  FFileName:='';
end;

destructor TPackageListFile.Destroy;
begin
  FURL.Free;
  FActive.Free;
  inherited Destroy;
end;

Procedure TPackageListFile.Clear;
begin
  FURL.Clear;
  FActive.Clear;
end;

function TPackageListFile.GetCount: Integer;
begin
  result:=FURL.Count;
end;

function TPackageListFile.GetURL(I: Integer): String;
begin
  If (I<0) or (I>=FURL.Count) then result:='' else result:=FURL[I];
end;

procedure TPackageListFile.SetURL(I: Integer; const Value: String);
begin
  If (I<0) or (I>=FURL.Count) then exit;
  FURL[I]:=Value;
end;

function TPackageListFile.GetActive(I: Integer): Boolean;
begin
  If (I<0) or (I>=FURL.Count) then result:=False else result:=(Integer(FActive[I])<>0);
end;

procedure TPackageListFile.SetActive(I: Integer; const Value: Boolean);
begin
  If (I<0) or (I>=FURL.Count) then exit;
  If Value then FActive[I]:=Pointer(1) else FActive[I]:=Pointer(0);
end;

procedure TPackageListFile.Add(const AURL: String; const AActive: Boolean);
begin
  FURL.Add(AURL);
  If AActive then FActive.Add(Pointer(1)) else FActive.Add(Pointer(0));
end;

procedure TPackageListFile.Delete(const Nr: Integer);
begin
  If (Nr<0) or (Nr>=FURL.Count) then exit;
  FURL.Delete(Nr);
  FActive.Delete(Nr);
end;

function TPackageListFile.LoadFromFile(const AFileName: String): Boolean;
Var XMLDoc : TXMLDocument;
    I : Integer;
begin
  Clear;
  FFileName:=AFileName;
  result:=False;

  XMLDoc:=LoadXMLDoc(AFileName);
  try
    If (XMLDoc=nil) or (XMLDoc.DocumentElement.NodeName<>'DFRPackagesList') then exit;
    If not XMLDoc.DocumentElement.HasAttribute('LastUpdateDate') then FUpdateDate:=0 else begin
      FUpdateDate:=DecodeUpdateDate(XMLDoc.DocumentElement.Attributes['LastUpdateDate']);
    end;
    For I:=0 to XMLDoc.DocumentElement.ChildNodes.Count-1 do If XMLDoc.DocumentElement.ChildNodes[I].NodeName='DFRPackagesFile' then begin
      If XMLDoc.DocumentElement.ChildNodes[I].HasAttribute('URL') then FURL.Add(XMLDoc.DocumentElement.ChildNodes[I].Attributes['URL']);
      If XMLDoc.DocumentElement.ChildNodes[I].HasAttribute('Active') then begin
        If Trim(ExtUpperCase(XMLDoc.DocumentElement.ChildNodes[I].Attributes['Active']))='YES' then FActive.Add(Pointer(1)) else FActive.Add(Pointer(0));
      end else begin
        FActive.Add(Pointer(1));
      end; 
    end;
  finally
    XMLDoc.Free;
  end;

  result:=True;
end;

procedure TPackageListFile.SaveToFile(const ParentForm : TForm);
Var Doc : TXMLDocument;
    I : Integer;
    N : IXMLNode;
begin
  Doc:=TXMLDocument.Create(ParentForm);
  try
    try
      Doc.DOMVendor:=MSXML_DOM;
      Doc.Active:=True;
    except
      on E : Exception do begin MessageDlg(E.Message,mtError,[mbOK],0); exit; end;
    end;
    Doc.DocumentElement:=Doc.CreateNode('DFRPackagesList');
    Doc.DocumentElement.Attributes['LastUpdateDate']:=EncodeUpdateDate(FUpdateDate);
    For I:=0 to FURL.Count-1 do begin
      N:=Doc.DocumentElement.AddChild('DFRPackagesFile');
      N.Attributes['URL']:=FURL[I];
      If Integer(FActive[I])<>0 then N.Attributes['Active']:='Yes' else N.Attributes['Active']:='No';
    end;
    SaveXMLDoc(Doc,['<!DOCTYPE DFRPackagesList SYSTEM "http:/'+'/dfendreloaded.sourceforge.net/Packages/DFRPackagesList.dtd">'],FFileName,False);
  finally
    Doc.Free;
  end;
end;

Procedure TPackageListFile.UpdateFromServer(const URL, TempFile : String);
Var TempMainFile : TPackageListFile;
begin
  if not DownloadFile(URL,TempFile) then exit;

  TempMainFile:=TPackageListFile.Create;
  try
    if not TempMainFile.LoadFromFile(TempFile) then exit;
    If TempMainFile.UpdateDate<=UpdateDate then exit;
    Clear;
    ExtDeleteFile(FileName,ftTemp);
    RenameFile(TempFile,FileName);
    LoadFromFile(FileName);
  finally
    TempMainFile.Free;
    ExtDeleteFile(TempFile,ftTemp);
  end;
end;

{ TPackageDB }

constructor TPackageDB.Create;
begin
  inherited Create;
  FOnDownload:=nil;
  FPackageList:=TList.Create;
end;

destructor TPackageDB.Destroy;
begin
  inherited Destroy;
  Clear;
  FPackageList.Free;
end;

procedure TPackageDB.Clear;
Var I : Integer;
begin
  for I:=0 to FPackageList.Count-1 do TPackageList(FPackageList[I]).Free;
  FPackageList.Clear;
end;

function TPackageDB.GetCount: Integer;
begin
  result:=FPackageList.Count;
end;

function TPackageDB.GetPackageList(I: Integer): TPackageList;
begin
  If (I<0) or (I>=FPackageList.Count) then result:=nil else result:=TPackageList(FPackageList[I]);
end;

function TPackageDB.InitDBDir: Boolean;
begin
  result:=False;

  FDBDir:=IncludeTrailingPathDelimiter(PrgDataDir+PackageDBSubFolder);

  If not DirectoryExists(FDBDir) then begin
    if not ForceDirectories(FDBDir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[FDBDir]),mtError,[mbOK],0);
      exit;
    end;
  end;

  result:=True;
end;

function TPackageDB.InitPackageFile(const URL: String; const Update: Boolean): TPackageList;
Var TempList : TPackageList;
begin
  result:=TPackageList.Create(URL);
  result.LoadFromFile(DBDir+ExtractFileNameFromURL(URL));

  If not Update then exit;

  if not DownloadFile(URL,DBDir+PackageDBTempFile) then exit;

  TempList:=TPackageList.Create(URL);
  try
    if not TempList.LoadFromFile(DBDir+PackageDBTempFile) then exit;
    If TempList.UpdateDate<=result.UpdateDate then exit;

    result.Free;
    FreeAndNil(TempList);
    ExtDeleteFile(DBDir+ExtractFileNameFromURL(URL),ftTemp);
    RenameFile(DBDir+PackageDBTempFile,DBDir+ExtractFileNameFromURL(URL));
    result:=TPackageList.Create(URL);
    result.LoadFromFile(DBDir+ExtractFileNameFromURL(URL));
  finally
    TempList.Free;
    ExtDeleteFile(DBDir+PackageDBTempFile,ftTemp);
  end;
end;

Function TPackageDB.FileInUse(FileName : String) : Boolean;
Var I : Integer;
begin
  result:=True;
  FileName:=ExtUpperCase(ExtractFileName(FileName));
  If FileName=ExtUpperCase(PackageDBMainFile) then exit;
  If FileName=ExtUpperCase(PackageDBUserFile) then exit;
  For I:=0 to FPackageList.Count-1 do begin
    If FileName=ExtUpperCase(ExtractFileName(TPackageList(FPackageList[I]).FileName)) then exit;
  end;
  result:=False;
end;

procedure TPackageDB.InitPackageFiles(const MainFile, UserFile: TPackageListFile; const Update: Boolean);
Var I,C1,C2 : Integer;
    P : TPackageList;
    Rec : TSearchRec;
    ContinueDownload : Boolean;
begin
  If Assigned(FOnDownload) then FOnDownload(self,0,MainFile.Count+UserFile.Count,dsStart,ContinueDownload);
  ContinueDownload:=True;
  try
    {Load and update files}

    C1:=0; For I:=0 to MainFile.Count-1 do If MainFile.Active[I] then inc(C1);
    C2:=0; For I:=0 to UserFile.Count-1 do If UserFile.Active[I] then inc(C2);

    For I:=0 to MainFile.Count-1 do If MainFile.Active[I] then begin
      If Assigned(FOnDownload) then FOnDownload(self,I,C1+C2,dsProgress,ContinueDownload);
      P:=InitPackageFile(MainFile[I],Update);
      If P<>nil then FPackageList.Add(P);
      If not ContinueDownload then break;
    end;
    If ContinueDownload then For I:=0 to UserFile.Count-1 do If UserFile.Active[I] then begin
      ContinueDownload:=True;
      If Assigned(FOnDownload) then FOnDownload(self,C1+I,C1+C2,dsProgress,ContinueDownload);
      P:=InitPackageFile(UserFile[I],Update);
      If P<>nil then FPackageList.Add(P);
    end;
  finally
    If Assigned(FOnDownload) then FOnDownload(self,MainFile.Count+UserFile.Count,MainFile.Count+UserFile.Count,dsDone,ContinueDownload);
  end;

  {Delete unused files}
  I:=FindFirst(DBDir+'*.xml',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin
        If not FileInUse(Rec.Name) then ExtDeleteFile(DBDir+Rec.Name,ftTemp);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TPackageDB.LoadDB(const Update: Boolean);
Var MainFile, UserFile : TPackageListFile;
begin
  Clear;
  If not InitDBDir then exit;

  MainFile:=TPackageListFile.Create;
  try
    MainFile.LoadFromFile(DBDir+PackageDBMainFile);
    If Update then MainFile.UpdateFromServer(PackageDBMainFileURL,DBDir+PackageDBTempFile);
    UserFile:=TPackageListFile.Create;
    try
      UserFile.LoadFromFile(DBDir+PackageDBUserFile);
      InitPackageFiles(MainFile,UserFile,Update);
    finally
      UserFile.Free;
    end;
  finally
    MainFile.Free;
  end;
end;

end.
