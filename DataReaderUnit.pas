unit DataReaderUnit;
interface

uses Classes, DataReaderConfigUnit;

Type TDataReader=class
  private
    FConfig : TDataReaderConfig;
    FGameNames, FGameURLs : TStringList;
    FLastListRequest : String;
    Function DownloadConfigFile(const DestFile : String) : Boolean;
    Function ReadListGlobalPart(const Lines : String; const NextElement : THTMLStructureElement) : Boolean;
    Procedure ReadListPerGamePart(const Lines : String; const NextElement : THTMLStructureElement; var GameName, GameURL : String);
    Procedure GetGameDataFromLines(const Lines : String; const NextElement : THTMLStructureElement; var Genre, Developer, Publisher, Year, ImagePageURL : String);
    Procedure GetGameCoverFromLines(const Lines : String; const NextElement : THTMLStructureElement; var ImageURL : String);
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadConfig(const AConfigFile : String; const UpdateCheck : Boolean) : Boolean;
    Procedure OpenListPage(const ASearchString : String);
    Function ReadList(const ASearchString : String) : Boolean;
    Function GetGameData(const Nr : Integer; var Genre, Developer, Publisher, Year, ImagePageURL : String) : Boolean;
    Function GetGameCover(const CoverPageURL : String; var ImageURL : String) : Boolean;
    property Config : TDataReaderConfig read FConfig;
    property GameNames : TStringList read FGameNames;
end; 

Type TDataReaderThread=class(TThread)
  protected
    FDataReader : TDataReader;
    FSuccess : Boolean;
  public
    Constructor Create(const ADataReader : TDataReader);
    property Success : Boolean read FSuccess;
end;

Type TDataReaderLoadConfigThread=class(TDataReaderThread)
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader);
end;

Type TDataReaderGameListThread=class(TDataReaderThread)
  private
    FName : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const AName : String);
end;

Type TDataReaderGameDataThread=class(TDataReaderThread)
  private
    FNr : Integer;
    FGenre, FDeveloper, FPublisher, FYear, FImageURL : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const ANr : Integer);
    property Genre : String read FGenre;
    property Developer : String read FDeveloper;
    property Publisher : String read FPublisher;
    property Year : String read FYear;
    property ImageURL : String read FImageURL;
end;

Type TDataReaderGameCoverThread=class(TDataReaderThread)
  private
    FDownloadURL, FDestFolder : String;
  protected
    Procedure Execute; override;
  public
    Constructor Create(const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String);
end;

implementation

uses Windows, SysUtils, Forms, ShellAPI, ActiveX, CommonTools,
     DataReaderToolsUnit, PrgConsts, PrgSetupUnit;

{ TDataReader }

constructor TDataReader.Create;
begin
  inherited Create;
  FConfig:=nil;
  FGameNames:=TStringList.Create;
  FGameURLs:=TStringList.Create;
  FLastListRequest:='';
end;

destructor TDataReader.Destroy;
begin
  If Assigned(FConfig) then FConfig.Free;
  FGameNames.Free;
  FGameURLs.Free;
  inherited Destroy;
end;

function TDataReader.LoadConfig(const AConfigFile : String; const UpdateCheck : Boolean): Boolean;
Var TempConfig : TDataReaderConfig;
    I : Integer;
begin
  result:=False;

  If (not FileExists(AConfigFile)) and (not DownloadConfigFile(AConfigFile)) then exit;

  repeat
    FConfig:=TDataReaderConfig.Create(AConfigFile);
    result:=FConfig.ConfigOK;
    If not result then begin
      FreeAndNil(FConfig);
      If not DownloadConfigFile(AConfigFile) then exit;
    end;
  until result;

  if UpdateCheck and DownloadConfigFile(TempDir+ExtractFileName(AConfigFile)) then begin
    try
      TempConfig:=TDataReaderConfig.Create(TempDir+ExtractFileName(AConfigFile));
      try
        If TempConfig.ConfigOK then I:=TempConfig.Version else I:=-1;
      finally
        TempConfig.Free;
      end;
      If I>FConfig.Version then begin
        FConfig.Free;
        CopyFile(PChar(TempDir+ExtractFileName(AConfigFile)),PChar(AConfigFile),False);
        FConfig:=TDataReaderConfig.Create(AConfigFile);
        result:=FConfig.ConfigOK; if not result then exit;
      end;
    finally
      ExtDeleteFile(TempDir+ExtractFileName(AConfigFile),ftTemp);
    end;
  end;
end;

function TDataReader.DownloadConfigFile(const DestFile: String): Boolean;
begin
  result:=DownloadFileToDisk(DataReaderUpdateURL,DestFile);
end;

Procedure TDataReader.OpenListPage(const ASearchString : String);
Var URL : String;
begin
  If PrgSetup.DataReaderAllPlatforms then URL:=FConfig.GamesListURL else URL:=FConfig.GamesListAllPlatformsURL;
  ShellExecute(Application.Handle,'open',PChar(Format(URL,[EncodeName(ASearchString)])),nil,nil,SW_SHOW);
end;

function TDataReader.ReadList(const ASearchString: String): Boolean;
Var Lines,URL : String;
begin
  FGameNames.Clear;
  FGameURLs.Clear;
  FLastListRequest:='';
  result:=False;
  If not Assigned(FConfig) then exit;
  If PrgSetup.DataReaderAllPlatforms then URL:=FConfig.GamesListAllPlatformsURL else URL:=FConfig.GamesListURL;
  if not DownloadTextFile(Format(URL,[EncodeName(ASearchString)]),Lines) then exit;
  result:=ReadListGlobalPart(Lines,FConfig.GamesList);
  if result then FLastListRequest:=Format(URL,[EncodeName(ASearchString)]);
end;

function TDataReader.ReadListGlobalPart(const Lines: String; const NextElement: THTMLStructureElement): Boolean;
Var St : TStringList;
    I : Integer;
    S,T : String;
begin
  result:=False;

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      result:=ReadListGlobalPart(S,TElement(NextElement).Child);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TPerGameBlock then begin
    St:=GetTagContents(Lines,1,TPerGameBlock(NextElement).ElementType,TPerGameBlock(NextElement).AttributeKey,TPerGameBlock(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      result:=True;
      For I:=0 to St.Count-1 do begin
        ReadListPerGamePart(St[I],TPerGameBlock(NextElement).Child,S,T);
        If (S<>'') and (T<>'') then begin FGameNames.Add(DecodeName(S)); FGameURLs.Add(T); end;
      end;
    finally
      St.Free;
    end;
    exit;
  end;
end;

Procedure TDataReader.ReadListPerGamePart(const Lines : String; const NextElement : THTMLStructureElement; var GameName, GameURL : String);
Var St,St2 : TStringList;
    I : Integer;
    S : String;
begin
  GameName:=''; GameURL:='';

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      ReadListPerGamePart(S,TElement(NextElement).Child,GameName,GameURL);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TLink then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'a',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'href',St2);
      try
        If St.Count=0 then exit;
        GameName:=St[0]; GameURL:=St2[0];
        If TLink(NextElement).Nr<>0 then begin
          I:=TLink(NextElement).Nr;
          If (I>0) and (St.Count>=I) then begin GameName:=St[I-1]; GameURL:=St2[I-1]; end;
          If (I<0) and (St.Count>=-I) then begin GameName:=St[St.Count-I]; GameURL:=St2[St.Count-I]; end;
        end;
        S:=Trim(TLink(NextElement).HrefSubstring);
        If (S<>'') and (Pos(ExtUpperCase(S),ExtUpperCase(GameURL))=0) then begin GameName:=''; GameURL:=''; end;
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;
end;

function TDataReader.GetGameData(const Nr: Integer; var Genre, Developer, Publisher, Year, ImagePageURL: String): Boolean;
Var S,T,Lines : String;
begin
  result:=False;
  Genre:=''; Developer:=''; Publisher:=''; Year:=''; ImagePageURL:='';
  If (Nr<0) or (Nr>=FGameNames.Count) then exit;

  S:=FConfig.GameRecordBaseURL;
  If (S<>'') and (S[length(S)]<>'/') then S:=S+'/';
  T:=FGameURLs[Nr];
  If (T<>'') and (T[1]='/') then T:=Copy(T,2,MaxInt);

  if not DownloadTextFile(S+T,Lines,FLastListRequest) then exit;
  result:=True;
  GetGameDataFromLines(Lines,FConfig.GameRecord,Genre,Developer,Publisher,Year,ImagePageURL);
end;

Function ExtDecodeName(const S : String) : String;
Var St : TStringList;
    I : Integer;
begin
  result:='';
  St:=GetPlainText(S);
  try
    For I:=0 to St.Count-1 do If Trim(St[I])=',' then result:=result+';' else result:=result+DecodeName(St[I]);
  finally
    St.Free;
  end;
end;

procedure TDataReader.GetGameDataFromLines(const Lines: String; const NextElement: THTMLStructureElement; var Genre, Developer, Publisher, Year, ImagePageURL: String);
Var St,St2 : TStringList;
    S,T : String;
    I,J : Integer;
    S1,S2,S3,S4 : String;
begin
  If NextElement is TLink then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'a',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'href',St2);
      try
        If St.Count=0 then exit;
        If ExtUpperCase(Copy(St[0],1,4))<>'<IMG' then exit;
        T:=Trim(ExtUpperCase(TLink(NextElement).HrefSubstring));
        If T<>'' then begin
          S:='';
          For I:=0 to St2.Count-1 do If (Pos(T,ExtUpperCase(St2[I]))<>0) then begin S:=St2[I]; break; end;
        end else begin
          S:=St2[0];
          If TLink(NextElement).Nr<>0 then begin
            I:=TLink(NextElement).Nr;
            If (I>0) and (St.Count>=I) then S:=St2[I-1];
            If (I<0) and (St.Count>=-I) then S:=St2[St.Count-I];
          end;
        end;
        If S<>'' then ImagePageURL:=S;
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;

  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      For I:=0 to TElement(NextElement).ChildCount-1 do
        GetGameDataFromLines(S,TElement(NextElement).Children[I],Genre,Developer,Publisher,Year,ImagePageURL);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TSearchGameData then begin
    S1:=Trim(ExtUpperCase(TSearchGameData(NextElement).Genre));
    S2:=Trim(ExtUpperCase(TSearchGameData(NextElement).Developer));
    S3:=Trim(ExtUpperCase(TSearchGameData(NextElement).Publisher));
    S4:=Trim(ExtUpperCase(TSearchGameData(NextElement).Year));

    {Simple mode (fallback)}
    St:=GetPlainText(Lines);
    try
      For I:=0 to St.Count-2 do begin
        S:=ExtUpperCase(St[I]);
        If (S1<>'') and (Pos(S1,S)<>0) then Genre:=DecodeName(St[I+1]);
        If (S2<>'') and (Pos(S2,S)<>0) then Developer:=DecodeName(St[I+1]);
        If (S3<>'') and (Pos(S3,S)<>0) then Publisher:=DecodeName(St[I+1]);
        If (S4<>'') and (Pos(S4,S)<>0) then Year:=DecodeName(St[I+1]);
      end;
    finally
      St.Free;
    end;

    {Complex mode for detecting multiple values}

    St:=GetTagContents(Lines,1,'div','','');
    try
      If (St.Count=1) and (Copy(St[0],1,1)='<') then begin
        St2:=GetTagContents(St[0],1,'div','',''); St.Free; St:=St2;
      end;
      For I:=0 to St.Count-2 do begin
        St2:=GetPlainText(St[I]);
        try
          If St2.Count>0 then S:=St2[0];
          For J:=1 to St2.Count-1 do S:=S+' '+St2[J];
        finally
          St2.Free;
        end;
        S:=ExtUpperCase(S);
        If (S1<>'') and (Pos(S1,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Genre:=T; end;
        If (S2<>'') and (Pos(S2,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Developer:=T; end;
        If (S3<>'') and (Pos(S3,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Publisher:=T; end;
        If (S4<>'') and (Pos(S4,S)<>0) then begin T:=ExtDecodeName(St[I+1]); If T<>'' then Year:=T; end;
      end;
    finally
      St.Free;
    end;
  end;
end;

function TDataReader.GetGameCover(const CoverPageURL : String; var ImageURL: String): Boolean;
Var S,T,Lines : String;
begin
  result:=False;
  ImageURL:='';
  If Trim(CoverPageURL)='' then begin result:=True; exit; end;

  S:=FConfig.CoverRecordBaseURL;
  If (S<>'') and (S[length(S)]<>'/') then S:=S+'/';
  T:=CoverPageURL;
  If (T<>'') and (T[1]='/') then T:=Copy(T,2,MaxInt);

  if not DownloadTextFile(S+T,Lines) then exit;
  result:=True;
  GetGameCoverFromLines(Lines,FConfig.CoverRecord,ImageURL);

  If ImageURL<>'' then begin
    T:=Trim(ExtUpperCase(ImageURL));
    If (Copy(T,1,7)<>'HTTP:/'+'/') and (Copy(T,1,8)<>'HTTPS:/'+'/') then begin
      T:=ImageURL;
      If (T<>'') and (T[1]='/') then T:=Copy(T,2,MaxInt);
      ImageURL:=S+T;
    end;
  end;
end;

procedure TDataReader.GetGameCoverFromLines(const Lines: String; const NextElement: THTMLStructureElement; var ImageURL: String);
Var St,St2 : TStringList;
    I : Integer;
    S : String;
begin
  If NextElement is TElement then begin
    St:=GetTagContents(Lines,1,TElement(NextElement).ElementType,TElement(NextElement).AttributeKey,TElement(NextElement).AttributeValue);
    try
      If St.Count=0 then exit;
      S:=St[0];
      If TElement(NextElement).Nr<>0 then begin
        I:=TElement(NextElement).Nr;
        If (I>0) and (St.Count>=I) then S:=St[I-1];
        If (I<0) and (St.Count>=-I) then S:=St[St.Count-I];
      end;
      GetGameCoverFromLines(S,TElement(NextElement).Child,ImageURL);
    finally
      St.Free;
    end;
    exit;
  end;

  If NextElement is TImg then begin
    St2:=TStringList.Create;
    try
      St:=GetTagContents(Lines,1,'img',TLink(NextElement).AttributeKey,TLink(NextElement).AttributeValue,'src',St2);
      try
        If St.Count=0 then exit;
        S:=St2[0];
        If TLink(NextElement).Nr<>0 then begin
          I:=TLink(NextElement).Nr;
          If (I>0) and (St.Count>=I) then S:=St2[I-1];
          If (I<0) and (St.Count>=-I) then S:=St2[St.Count-I];
        end;
        If S<>'' then ImageURL:=S;
      finally
        St.Free;
      end;
    finally
      St2.Free;
    end;
    exit;
  end;
end;

{ TDataReaderThread }

constructor TDataReaderThread.Create(const ADataReader: TDataReader);
begin
  inherited Create(True);
  FDataReader:=ADataReader;
  FSuccess:=False;
end;

{ TDataReaderLoadConfigThread }

constructor TDataReaderLoadConfigThread.Create(const ADataReader: TDataReader);
begin
  inherited Create(ADataReader);
  Resume;
end;

procedure TDataReaderLoadConfigThread.Execute;
Var DoUpdateCheck : Boolean;
begin
  CoInitialize(nil);
  DoUpdateCheck:=False;
  Case PrgSetup.DataReaderCheckForUpdates of
    0 : DoUpdateCheck:=False;
    1 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+7);
    2 : DoUpdateCheck:=(Round(Int(Date))>=PrgSetup.LastDataReaderUpdateCheck+1);
    3 : DoUpdateCheck:=True;
  End;
  FSuccess:=FDataReader.LoadConfig(PrgDataDir+SettingsFolder+'\'+DataReaderConfigFile,DoUpdateCheck);
  If DoUpdateCheck and FSuccess then PrgSetup.LastDataReaderUpdateCheck:=Round(Int(Date));
end;

{ TDataReaderGameListThread }

constructor TDataReaderGameListThread.Create(const ADataReader: TDataReader; const AName: String);
begin
  inherited Create(ADataReader);
  FName:=AName;
  Resume;
end;

procedure TDataReaderGameListThread.Execute;
begin
  FSuccess:=FDataReader.ReadList(FName);
end;

{ TDataReaderGameDataThread }

constructor TDataReaderGameDataThread.Create(const ADataReader: TDataReader; const ANr: Integer);
begin
  inherited Create(ADataReader);
  FNr:=ANr;
  FGenre:=''; FDeveloper:=''; FPublisher:=''; FYear:=''; FImageURL:='';
  Resume;
end;

procedure TDataReaderGameDataThread.Execute;
Var S : String;
begin
  FSuccess:=FDataReader.GetGameData(fNr,FGenre,FDeveloper,FPublisher,FYear,S);
  If FSuccess then FSuccess:=FDataReader.GetGameCover(S,FImageURL);
end;

{ TDataReaderGameCoverThread }

constructor TDataReaderGameCoverThread.Create(const ADataReader: TDataReader; const ADownloadURL, ADestFolder: String);
begin
  inherited Create(ADataReader);
  FDownloadURL:=ADownloadURL;
  FDestFolder:=ADestFolder;
  Resume;
end;

procedure TDataReaderGameCoverThread.Execute;
Var FileName,Path : String;
    I : Integer;
begin
  FSuccess:=False;

  FileName:=FDownloadURL;
  I:=Pos('/',FileName); While I>0 do begin FileName:=Copy(FileName,I+1,MaxInt); I:=Pos('/',FileName); end;
  Path:=IncludeTrailingPathDelimiter(FDestFolder);
  If FileExists(Path+FileName) then begin FSuccess:=True; exit; end;

  FSuccess:=DownloadFileToDisk(FDownloadURL,Path+FileName);
end;

end.
