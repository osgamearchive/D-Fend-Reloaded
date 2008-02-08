unit CommonTools;
interface

uses Windows, Classes, Graphics;

Function ExtUpperCase(const S : String) : String;

Function StrToFloatEx(S : String) : Double;

Function ValueToList(Value : String; Divider : String = ';') : TStringList;
Function ListToValue(const St : TStrings; Divider : Char =';') : String;

Function StringToStringList(S : String) : TStringList; {"[13][10]" as Divider}
Function StringListToString(const St : TStrings) : String; {"[13][10]" as Divider}
Function Replace(const S, FromSub, ToSub : String) : String;

Function PrgDir : String;
Function TempDir : String;

Function MakeRelPath(Path, Rel : String) : String;
Function MakeAbsPath(Path, Rel : String) : string;

function SelectDirectory(const AOwner : THandle; const Caption: string; var Directory: String): Boolean;
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;

Function GetFileVersionEx(const AFileName: string) : Cardinal;
Function GetFileVersionAsString : String;
Function GetNormalFileVersionAsString : String;
Function GetShortFileVersionAsString : String;

Function GetFileDateAsString : String;

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile : String);
Procedure SetStartWithWindows(const Enabled : Boolean);

Function LoadImageFromFile(const FileName : String) : TPicture;
Procedure SaveImageToFile(const Picture : TPicture; const FileName : String);

Var TempPrgDir : String = ''; {Temporary overwrite normal PrgDir}

implementation

uses SysUtils, Forms, ShlObj, ActiveX, Math, ComObj, Registry, JPEG, GIFImage,
     PNGImage;

Function ExtUpperCase(const S : String) : String;
Var I : Integer;
begin
  result:=Trim(S);
  For I:=1 to length(result) do case result[I] of
    'a'..'z' : result[I]:=chr(ord(result[I])-(ord('a')-ord('A')));
    'ä' : result[I]:='Ä';
    'ö' : result[I]:='Ö';
    'ü' : result[I]:='Ü';
  end;
end;

Function StrToFloatEx(S : String) : Double;
Var I : Integer;
begin
  For I:=1 to length(S) do If (S[I]='.') or (S[I]=',') then S[I]:=DecimalSeparator;
  result:=StrToFloat(S);
end;

Function ValueToList(Value : String; Divider : String) : TStringList;
Var I,J : Integer;
begin
  result:=TStringList.Create;
  Value:=Trim(Value);
  while Value<>'' do begin
    I:=Pos(Divider[1],Value);
    For J:=2 to length(Divider) do If I=0 then I:=Pos(Divider[J],Value) else begin
      If Pos(Divider[J],Value)>0 then I:=Min(I,Pos(Divider[J],Value));
    end;
    If I>0 then begin
      result.Add(Trim(Copy(Value,1,I-1)));
      Value:=Trim(Copy(Value,I+1,MaxInt));
    end else begin
      result.Add(Trim(Value));
      Value:='';
    end;
  end;
end;

Function ListToValue(const St : TStrings; Divider : Char) : String;
Var I : Integer;
    S : String;
begin
  result:='';
  For I:=0 to St.Count-1 do begin
    S:=Trim(St[I]); If S='' then continue;
    If result<>'' then result:=result+Divider;
    result:=result+S;
  end;
end;

Function StringToStringList(S : String) : TStringList;
Var T : String;
    I,J : Integer;
begin
  T:='';
  while S<>'' do begin
    I:=Pos('[',S);
    If I=0 then begin T:=T+S; S:=''; continue; end;
    T:=T+Copy(S,1,I-1); S:=Copy(S,I+1,MaxInt);
    I:=Pos(']',S);
    If I=0 then begin T:=T+'['+S; S:=''; continue; end;
    if (not TryStrToInt(Copy(S,1,I-1),J)) or (J<0) or (J>255) then begin T:=T+'['; continue; end;
    T:=T+chr(J); S:=Copy(S,I+1,MaxInt);
  end;

  result:=TStringList.Create;
  result.Text:=T;
end;

Function StringListToString(const St : TStrings) : String;
Var I : Integer;
    S : String;
begin
  S:=St.Text;
  result:='';

  result:='';
  For I:=1 to length(S)-1 do
    If S[I]<#32 then result:=result+'['+IntToStr(Ord(S[I]))+']' else result:=result+S[I];
end;

Function Replace(const S, FromSub, ToSub : String) : String;
Var I : Integer;
begin
  I:=Pos(FromSub,S);
  if I=0 then result:=S else result:=Copy(S,1,I-1)+ToSub+Copy(S,I+length(FromSub),MaxInt);  
end;

Function PrgDir : String;
begin
  If TempPrgDir<>''
    then result:=TempPrgDir
    else result:=IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(Application.ExeName)));
end;

Function TempDir : String;
begin
  SetLength(result,255);
  GetTempPath(250,PChar(result));
  SetLength(result,StrLen(PChar(result)));
  result:=IncludeTrailingPathDelimiter(result);
end;

Function MakeRelPath(Path, Rel : String) : String;
Var FileName : String;
begin
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  If DirectoryExists(Path) then begin
    FileName:='';
    Path:=IncludeTrailingPathDelimiter(Path);
  end else begin
    FileName:=ExtractFileName(Path);
    Path:=IncludeTrailingPathDelimiter(ExtractFilePath(Path));
  end;

  If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  If Path='.\' then Path:='';
  result:=Path+FileName;
end;

Function MakeAbsPath(Path, Rel : String) : string;
begin
  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  If (length(Path)>=2) and (Path[2]=':') then begin result:=Path; exit; end;

  Path:=Trim(Path);
  If Copy(Path,1,2)='.\' then Path:=Trim(Copy(Path,3,MaxInt));

  result:=Rel+Path;
end;

function bffCallback(DlgHandle: HWND; Msg: Integer; lParam: Integer; lpData: Integer) : Integer; stdcall;
begin
  if Msg = BFFM_INITIALIZED then
  SendMessage(DlgHandle, BFFM_SETSELECTION, Integer(LongBool(True)), lpData);
  result:=0;
end;

function SelectDirectory(const AOwner : THandle; const Caption: string; var Directory: String): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
begin
  Result := False;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      with BrowseInfo do
      begin
        hwndOwner := AOwner;
        pidlRoot := nil;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        lpfn:=@bffCallback;
        lParam:=Integer(@(Directory[1]));
      end;

      ItemIDList := ShBrowseForFolder(BrowseInfo);
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

{
CSIDL_COOKIES              Cookies
CSIDL_DESKTOPDIRECTORY     Desktop
CSIDL_FAVORITES            Favoriten
CSIDL_HISTORY              Internet-Verlauf
CSIDL_INTERNET_CACHE       "Temporary Internet Files"
CSIDL_PERSONAL             Eigene Dateien
CSIDL_PROGRAMS             "Programme" im Startmenü
CSIDL_RECENT               "Dokumente" im Startmenü
CSIDL_SENDTO               "Senden an" im Kontextmenü
CSIDL_STARTMENU            Startmenü
CSIDL_STARTUP              Autostart
}
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;
var pMalloc: IMalloc;
    pidl: PItemIDList;
    Path: PChar;
begin
  result:='';
  if SHGetMalloc(pMalloc) <> S_OK then exit;

  SHGetSpecialFolderLocation(hWindow, Folder, pidl);
  GetMem(Path, MAX_PATH);
  SHGetPathFromIDList(pidl, Path);
  Result := Path;
  FreeMem(Path);

  pMalloc.Free(pidl);
end;

Function GetFileVersionEx(const AFileName: string) : Cardinal;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := Cardinal(-1);
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result:= FI.dwFileVersionLS;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

Function GetFileVersionAsString : String;
Var I,J : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  J:=GetFileVersionEx(ExpandFileName(Application.ExeName));
  result:=Format('Version %d.%d.%d (Build %d)',[I div 65536,I mod 65536, J div 65536, J mod 65536]);
end;

Function GetNormalFileVersionAsString : String;
Var I,J : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  J:=GetFileVersionEx(ExpandFileName(Application.ExeName));
  result:=Format('%d.%d.%d',[I div 65536,I mod 65536, J div 65536]);
end;

Function GetShortFileVersionAsString : String;
Var I : Integer;
begin
  I:=GetFileVersion(ExpandFileName(Application.ExeName));
  result:=Format('%d.%d',[I div 65536,I mod 65536]);
end;

Function GetFileDateAsString : String;
Var hFile : THandle;
    CreationTime, AccessTime, WriteTime : TFileTime;
    SystemTime : TSystemTime;
begin
  result:='';

  hFile:=CreateFile(PChar(ExpandFileName(Application.ExeName)),GENERIC_READ,FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);
  if hFile=INVALID_HANDLE_VALUE then exit;
  try
    if not GetFileTime(hFile,@CreationTime,@AccessTime,@WriteTime) then exit;
    if not FileTimeToSystemTime(CreationTime,SystemTime) then exit;
    result:=DateToStr(SystemTimeToDateTime(SystemTime));
  finally
    CloseHandle(hFile);
  end;
end;

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile : String);
Var IObject : IUnknown;
   ISLink : IShellLink;
   IPFile : IPersistFile;
   WLinkFile : WideString;
begin
   IObject:=CreateComObject(CLSID_ShellLink);
   ISLink:=IObject as IShellLink;
   IPFile:=IObject as IPersistFile;

   with ISLink do begin
     SetPath(PChar(TargetName));
     SetWorkingDirectory(PChar(ExtractFilePath(TargetName)));
     SetArguments(PChar(Parameters));
     If IconFile<>'' then SetIconLocation(PChar(IconFile),0);
   end;

   WLinkFile:=LinkFile;
   IPFile.Save(PWChar(WLinkFile), false) ;
end;

Procedure SetStartWithWindows(const Enabled : Boolean);
Var Reg : TRegistry;
begin
  Reg:=TRegistry.Create;
  try
  Reg.RootKey:=HKEY_CURRENT_USER;
    If not Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True) then exit;
    If Enabled then begin
      Reg.WriteString('D-Fend Reloaded',ExpandFileName(Application.ExeName));
    end else begin
      Reg.DeleteValue('D-Fend Reloaded');
    end;
  finally
    Reg.Free;
  end;
end;

Procedure SaveImageToFile(const Picture : TPicture; const FileName : String);
Var Ext : String;
    JPEGImage : TJPEGImage;
    Bitmap : TBitmap;
    GifImage : TGIFImage;
    PNGObject : TPNGObject;
begin
  Ext:=Trim(ExtUpperCase(ExtractFileExt(FileName)));

  Bitmap:=TBitmap.Create;
  try
    Bitmap.Assign(Picture.Graphic);

  If (Ext='.JPG') or (Ext='.JPEG') then begin
    JPEGImage:=TJPEGImage.Create;
    try
      JPEGImage.Assign(Bitmap);
      JPEGImage.CompressionQuality:=95;
      JPEGImage.SaveToFile(FileName);
    finally
      JPEGImage.Free;
    end;
    exit;
  end;

  If (Ext='.BMP') then begin
    Bitmap.SaveToFile(FileName);
    exit;
  end;

  If (Ext='.GIF') then begin
    GifImage:=TGIFImage.Create;
    try
      GifImage.ColorReduction:=rmQuantizeWindows;
      GifImage.Assign(Bitmap);
      GifImage.SaveToFile(FileName);
    finally
      GifImage.Free;
    end;
    exit;
  end;

  If (Ext='.PNG') then begin
    PNGObject:=TPNGObject.Create;
    try
      PNGObject.Assign(Bitmap);
      PNGObject.SaveToFile(FileName);
    finally
      PNGObject.Free;
    end;
    exit;
  end;

    Picture.SaveToFile(FileName);
  finally
    Bitmap.Free;
  end;
end;

Function LoadImageFromFile(const FileName : String) : TPicture;
Var Ext : String;
    GIFImage : TGIFImage;
begin
  Ext:=Trim(ExtUpperCase(ExtractFileExt(FileName)));

  If Ext='.GIF' then begin
    GIFImage:=TGIFImage.Create;
    try
      GIFImage.LoadFromFile(FileName);
      result:=TPicture.Create;
      result.Assign(GIFImage);
    finally
      GIFImage.Free;
    end;
    exit;
  end;

  result:=TPicture.Create;
  result.LoadFromFile(FileName);
end;

end.
