unit ImageCacheUnit;
interface

uses Classes, Graphics;

Type TImageData=class
  private
    FPath : String;
    FPicture : TPicture;
    FIcon : TIcon;
  public
    Constructor Create;
    Destructor Destroy; override;
    Function LoadPicture(const AFileName : String) : Boolean;
    Function LoadIcon(const AFileName : String) : Boolean;
    property Picture : TPicture read FPicture;
    property Icon : TIcon read FIcon;
    property Path : String read FPath;
end;

Type TImageCache=class
  private
    FImageList : TStringList;
    Function LoadPicture(const AFileName : String) : Integer;
    Function LoadIcon(const AFileName : String) : Integer;
    Function FindFile(const AFileName : String) : Integer;
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Clear;
    Function GetIcon(const AFileName : String) : TIcon;
    Function GetPicture(const AFileName : String) : TPicture;
end;

var IconCache : TImageCache = nil;
    PictureCache : TImageCache = nil;

implementation

uses Windows, SysUtils, ShellAPI, CommonTools;

{ TImageData }

constructor TImageData.Create;
begin
  inherited Create;
  FPicture:=nil;
  FIcon:=nil;
end;

destructor TImageData.Destroy;
begin
  If Assigned(FIcon) then FIcon.Free;
  If Assigned(FPicture) then FPicture.Free;
  inherited Destroy;
end;

function TImageData.LoadIcon(const AFileName: String): Boolean;
Var FileInfo: SHFILEINFO;
    I : Integer;
begin
  result:=False;
  If not FileExists(AFileName) then exit;
  FIcon:=TIcon.Create;
  try
    If ExtUpperCase(ExtractFileExt(AFileName))='.EXE' then begin
      If SHGetFileInfo(PChar(AFileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_LARGEICON)<>0 then FIcon.Handle:=FileInfo.hIcon;
    end else begin
      I:=16;
      while I<=256 do begin
        FIcon.Handle:=LoadImage(0,PChar(AFileName),IMAGE_ICON,I,I,LR_LOADFROMFILE);
        I:=I*2;
      end;
    end;
  except
    FreeAndNil(FIcon);
    exit;
  end;
  FPath:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));
  result:=True;
end;

function TImageData.LoadPicture(const AFileName: String): Boolean;
begin
  result:=False;
  If not FileExists(AFileName) then exit;
  try FPicture:=LoadImageFromFile(AFileName); except FreeAndNil(FPicture); exit; end;
  FPath:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));
  result:=True;
end;

{ TImageCache }

constructor TImageCache.Create;
begin
  inherited Create;
  FImageList:=TStringList.Create;
  FImageList.Sorted:=True;
  FImageList.Duplicates:=dupAccept;
end;

destructor TImageCache.Destroy;
begin
  Clear;
  FImageList.Free;
  inherited Destroy;
end;

function TImageCache.LoadIcon(const AFileName: String): Integer;
Var AImageData : TImageData;
begin
  result:=-1;
  AImageData:=TImageData.Create;
  if not AImageData.LoadIcon(AFileName) then begin AImageData.Free; exit; end;
  result:=FImageList.AddObject(ExtUpperCase(ExtractFileName(AFileName)),AImageData);
end;

function TImageCache.LoadPicture(const AFileName: String): Integer;
Var AImageData : TImageData;
begin
  result:=-1;
  AImageData:=TImageData.Create;
  if not AImageData.LoadPicture(AFileName) then begin AImageData.Free; exit; end;
  result:=FImageList.AddObject(ExtUpperCase(ExtractFileName(AFileName)),AImageData);
end;

function TImageCache.FindFile(const AFileName: String): Integer;
Var S,T : String;
    MinPos,I : Integer;
begin
  result:=-1;
  S:=ExtUpperCase(ExtractFileName(AFileName));
  T:=IncludeTrailingPathDelimiter(ExtUpperCase(ExtractFilePath(AFileName)));

  MinPos:=FImageList.IndexOf(S);
  If MinPos<0 then exit;
  While (MinPos>0) and (FImageList[MinPos-1]=S) do dec(MinPos);
  For I:=MinPos to FImageList.Count-1 do If (FImageList[I]=S) and (TImageData(FImageList.Objects[I]).Path=T) then begin result:=I; exit; end;
end;

function TImageCache.GetIcon(const AFileName: String): TIcon;
Var Nr : Integer;
begin
  result:=nil;

  Nr:=FindFile(AFileName);
  If Nr<0 then begin
    Nr:=LoadIcon(AFileName);
    if Nr<0 then exit;
  end;

  If Nr>=0 then result:=TImageData(FImageList.Objects[Nr]).Icon;
end;

function TImageCache.GetPicture(const AFileName: String): TPicture;
Var Nr : Integer;
begin
  result:=nil;

  Nr:=FindFile(AFileName);
  If Nr<0 then begin
    Nr:=LoadPicture(AFileName);
    if Nr<0 then exit;
  end;

  If Nr>=0 then result:=TImageData(FImageList.Objects[Nr]).Picture;
end;

procedure TImageCache.Clear;
Var I : Integer;
begin
  For I:=0 to FImageList.Count-1 do TImageData(FImageList.Objects[I]).Free;
  FImageList.Clear;
end;

initialization
  IconCache:=TImageCache.Create;
  PictureCache:=TImageCache.Create;
finalization
  IconCache.Free;
  PictureCache.Free;
end.
