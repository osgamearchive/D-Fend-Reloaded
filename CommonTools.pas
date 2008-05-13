unit CommonTools;
interface

uses Windows, Classes, Graphics, StdCtrls;

Function ExtUpperCase(const S : String) : String;

Function StrToFloatEx(S : String) : Double;

Function ValueToList(Value : String; Divider : String = ';') : TStringList;
Function ListToValue(const St : TStrings; Divider : Char =';') : String;

Function StringToStringList(S : String) : TStringList; {"[13][10]" as Divider}
Function StringListToString(const St : TStrings) : String; {"[13][10]" as Divider}
Function Replace(const S, FromSub, ToSub : String) : String;

Function FindStringInFile(const FileName, SearchString : String) : Boolean;

Function PrgDir : String;
Function TempDir : String;

Function MakeRelPath(Path, Rel : String) : String;
Function MakeAbsPath(Path, Rel : String) : string;
Function MakeFileSysOKFolderName(const AName : String) : String;
Function MakeAbsIconName(const Icon : String) : String;

function SelectDirectory(const AOwner : THandle; const Caption: string; var Directory: String): Boolean;
function GetSpecialFolder(hWindow: HWND; Folder: Integer): String;

Function GetFileVersionEx(const AFileName: string) : Cardinal;
Function GetFileVersionAsString : String;
Function GetNormalFileVersionAsString : String;
Function GetShortFileVersionAsString : String;

Function CheckDOSBoxVersion(const Path : String = '') : String;
Function OldDOSBoxVersion(const Version : String) : Boolean;

Function GetFileDateAsString : String;

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile, Description : String);
Procedure SetStartWithWindows(const Enabled : Boolean);

Function LoadImageFromFile(const FileName : String) : TPicture;
Procedure SaveImageToFile(const Picture : TPicture; const FileName : String);

Type TWallpaperStyle=(WSTile=0,WSCenter=1,WSStretch=2);

Procedure SetDesktopWallpaper(const FileName : String; const WPStyle : TWallpaperStyle);

Function CharsetNameToFontCharSet(const Name : String) : TFontCharset;

Type TPathType=(ptMount,ptScreenshot,ptMapper,ptDOSBox);

Function UnmapDrive(const Path : String; const PathType : TPathType) : String;

Function GetScreensaverAllowStatus : Boolean;
Procedure SetScreensaverAllowStatus(const Enable : Boolean);

procedure SetComboHint(Combo: TComboBox);
procedure SetComboDropDownDropDownWidth(Combo: TComboBox);

Var TempPrgDir : String = ''; {Temporary overwrite normal PrgDir}

implementation

uses SysUtils, Forms, ShlObj, ActiveX, Messages, Math, ComObj, Registry, JPEG,
     GIFImage, PNGImage, LanguageSetupUnit, PrgSetupUnit, PrgConsts;

Function ExtUpperCase(const S : String) : String;
Var I,J : Integer;
begin
  result:=Trim(S);
  For I:=1 to length(result) do begin
    If (result[I]>='a') and (result[I]<='z') then begin
      result[I]:=chr(ord(result[I])-(ord('a')-ord('A')));
      continue;
    end;
    J:=Pos(result[I],LanguageSpecialLowerCase);
    If J>0 then result[I]:=LanguageSpecialUpperCase[J];
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
  For I:=1 to length(S) do
    If S[I]<#32 then result:=result+'['+IntToStr(Ord(S[I]))+']' else result:=result+S[I];
end;

Function Replace(const S, FromSub, ToSub : String) : String;
Var I : Integer;
begin
  I:=Pos(FromSub,S);
  if I=0 then result:=S else result:=Copy(S,1,I-1)+ToSub+Copy(S,I+length(FromSub),MaxInt);
end;

Type TByteArray=Array[0..MaxInt-1] of Byte;

Function FindStringInFile(const FileName, SearchString : String) : Boolean;
Var MSt : TMemoryStream;
    I,J : Integer;
begin
  result:=False;
  If not FileExists(FileName) then exit;
  MSt:=TMemoryStream.Create;
  try
    try MSt.LoadFromFile(FileName); except exit; end;
      For I:=0 to MSt.Size-length(SearchString) do If TByteArray(MSt.Memory^)[I]=Byte(SearchString[1]) then begin
        for J:=2 to length(SearchString) do If TByteArray(MSt.Memory^)[I+J-1]=Byte(SearchString[J]) then begin result:=True; exit; end;
      end;
  finally
    MSt.Free;
  end;
end;

Function PrgDir : String;
begin
  If TempPrgDir<>''
    then result:=TempPrgDir
    else result:=IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(Application.ExeName)));
end;

Function TempDir : String;
begin
  SetLength(result,515);
  GetTempPath(512,PChar(result));
  SetLength(result,StrLen(PChar(result)));
  result:=IncludeTrailingPathDelimiter(result);
end;

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

Function MakeRelPath(Path, Rel : String) : String;
Var FileName : String;
begin
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  If DirectoryExists(Path) then begin
    FileName:='';
    Path:=IncludeTrailingPathDelimiter(Path);
  end else begin
    FileName:=ExtractFileName(Path);
    Path:=IncludeTrailingPathDelimiter(ExtractFilePath(Path));
  end;

  If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then begin
    Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end else begin
    Rel:=IncludeTrailingPathDelimiter(ShortName(Rel));
    If (length(Path)>=length(Rel)) and (ExtUpperCase(Copy(Path,1,length(Rel)))=ExtUpperCase(Rel)) then
      Path:='.\'+Copy(Path,length(Rel)+1,MaxInt);
  end;
  If Path='.\' then Path:='';
  result:=Path+FileName;
end;

Function MakeAbsPath(Path, Rel : String) : string;
begin
  If (ExtUpperCase(Copy(Trim(Path),1,7))='DOSBOX:') or (Trim(Path)='') then begin result:=Path; exit; end;

  Rel:=Trim(Rel); if Rel='' then begin result:=Path; exit; end;
  Rel:=IncludeTrailingPathDelimiter(Rel);

  If (length(Path)>=2) and (Path[2]=':') then begin result:=Path; exit; end;

  Path:=Trim(Path);
  If Copy(Path,1,2)='.\' then Path:=Trim(Copy(Path,3,MaxInt));

  result:=Rel+Path;
end;

Function MakeFileSysOKFolderName(const AName : String) : String;
const AllowedCharsDefault='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyzäöüß01234567890-_=.,;!()';
Var I : Integer;
    AllowedChars : String;
begin
  result:='';
  AllowedChars:=LanguageSetup.CharsetAllowedFileNameChars;
  If AllowedChars='' then AllowedChars:=AllowedCharsDefault;
  AllowedChars:=AllowedChars+' ';
  For I:=1 to length(AName) do if Pos(AName[I],AllowedChars)>0 then result:=result+AName[I];
  if result='' then result:='Game';
end;

Function MakeAbsIconName(const Icon : String) : String;
Var S : String;
begin
  If Trim(Icon)='' then begin result:=''; exit; end;
  S:=ExtractFilePath(Icon);
  If S=''
    then result:=PrgDataDir+IconsSubDir+'\'+Icon
    else result:=MakeAbsPath(Icon,PrgSetup.BaseDir);
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

Function CheckDOSBoxVersion(const Path : String) : String;
Var DOSBoxPath : String;
    St : TStringList;
    I : Integer;
    S : String;
begin
  result:='';

  If Trim(Path)='' then DOSBoxPath:=PrgSetup.DosBoxDir else DOSBOXPath:=Path;
  DOSBOXPath:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBOXPath,PrgSetup.BaseDir));
  If not FileExists(DOSBoxPath+'Readme.txt') then exit;

  S:='';
  St:=TStringList.Create;
  try
    try St.LoadFromFile(DOSBoxPath+'Readme.txt'); except exit; end;
    For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin S:=St[I]; break; end;
  finally
    St.Free;
  end;

  For I:=1 to length(S) do If ((S[I]>='0') and (S[I]<='9')) or (S[I]='.') then result:=result+S[I];
end;

Function OldDOSBoxVersion(const Version : String) : Boolean;
Var D : Double;
begin
  result:=False;
  try D:=StrToFloat(Version); except exit; end;
  result:=(D<0.72);
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

Procedure CreateLink(const TargetName, Parameters, LinkFile, IconFile, Description : String);
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
     SetDescription(PChar(Description));
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

const CLSID_ActiveDesktop : TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';

Procedure SetDesktopWallpaper(const FileName : String; const WPStyle : TWallpaperStyle);
Var S : String;
    P : TPicture;
    WS: PWideChar;
    ActiveDesktop: IActiveDesktop;
    WallpaperOptions: TWallpaperOpt;
begin
  S:=FileName;

  If ExtUpperCase(ExtractFileExt(S))='.PNG' then begin
    P:=LoadImageFromFile(FileName);
    try
      S:=TempDir+ChangeFileExt(ExtractFileName(S),'.bmp');
      SaveImageToFile(P,S);
    finally
      P.Free;
    end;
  end;

  ActiveDesktop:=CreateComObject(CLSID_ActiveDesktop) as IActiveDesktop;
  WS:=AllocMem(MAX_PATH);
  try
    StringToWideChar(S,WS,MAX_PATH);
    if not ActiveDesktop.SetWallpaper(WS,0)=S_OK then exit;
    WallpaperOptions.dwSize:=SizeOf(TWallpaperOpt);
    case WPStyle of
      WSTile    : WallpaperOptions.dwStyle:=WPSTYLE_TILE;
      WSCenter  : WallpaperOptions.dwStyle:=WPSTYLE_CENTER;
      WSStretch : WallpaperOptions.dwStyle:=WPSTYLE_STRETCH;
      else        WallpaperOptions.dwStyle:=WPSTYLE_CENTER;
    end;
    ActiveDesktop.SetWallpaperOptions(WallpaperOptions,0);
    ActiveDesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
  finally
    FreeMem(WS);
  end;
end;

Type TCharsetNameRecord=record
  Name : String;
  Nr : Integer;
end;

const  CharsetNamesList : Array[0..16] of TCharsetNameRecord=(
  (Name: 'ANSI_CHARSET'; Nr: 0),
  (Name: 'DEFAULT_CHARSET'; Nr: 1),
  (Name: 'SYMBOL_CHARSET'; Nr: 2),
  (Name: 'SHIFTJIS_CHARSET'; Nr: $80),
  (Name: 'HANGEUL_CHARSET'; Nr: 129),
  (Name: 'GB2312_CHARSET'; Nr: 134),
  (Name: 'CHINESEBIG5_CHARSET'; Nr: 136),
  (Name: 'OEM_CHARSET'; Nr: 255),
  (Name: 'JOHAB_CHARSET'; Nr: 130),
  (Name: 'HEBREW_CHARSET'; Nr: 177),
  (Name: 'ARABIC_CHARSET'; Nr: 178),
  (Name: 'GREEK_CHARSET'; Nr: 161),
  (Name: 'TURKISH_CHARSET'; Nr: 162),
  (Name: 'VIETNAMESE_CHARSET'; Nr: 163),
  (Name: 'THAI_CHARSET'; Nr: 222),
  (Name: 'EASTEUROPE_CHARSET'; Nr: 238),
  (Name: 'RUSSIAN_CHARSET'; Nr: 204)
);

Function CharsetNameToFontCharSet(const Name : String) : TFontCharset;
Var S : String;
    I,Nr : Integer;
begin
  result:=DEFAULT_CHARSET;

  S:=Trim(ExtUpperCase(Name));
  If not TryStrToInt(S,Nr) then Nr:=-1;
  For I:=Low(CharsetNamesList) to High(CharsetNamesList) do If (Trim(ExtUpperCase(CharsetNamesList[I].Name))=S) or (CharsetNamesList[I].Nr=Nr) then begin
    result:=CharsetNamesList[I].Nr; exit;
  end;
end;

Function UnmapDrive(const Path : String; const PathType : TPathType) : String;
Var C : Char;
    S : String;
    I : Integer;
begin
  result:=Path;
  If not WineSupportEnabled then exit;
  Case PathType of
    ptMount      : if not PrgSetup.RemapMounts then exit;
    ptScreenshot : if not PrgSetup.RemapScreenShotFolder then exit;
    ptMapper     : if not PrgSetup.RemapMapperFile then exit;
    ptDOSBox     : if not PrgSetup.RemapDOSBoxFolder then exit;
  end;

  If (length(Path)<2) or (Path[2]<>':') then exit;
  C:=UpCase(Path[1]);
  If (C<'A') or (C>'Z') then exit;
  S:=PrgSetup.LinuxRemap[C];
  If S='' then exit;

  For I:=1 to length(result) do If result[I]='\' then result[I]:='/';
  If S[length(S)]<>'/' then S:=S+'/';
  result:=S+copy(result,4,MaxInt);
  If copy(result,length(result)-1,2)='/'+'/' then result:=Copy(result,1,length(result)-1);
end;

Function GetScreensaverAllowStatus : Boolean;
begin
  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE,0,@result,0);
end;

Procedure SetScreensaverAllowStatus(const Enable : Boolean);
begin
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,Cardinal(Enable),nil,0);
end;

function GetTextSize( const hfnt: HFONT; var str: String ):SIZE;
{by Alexander Katz (skatz@svitonline.com)}
var
 hdc0: HDC;
 hfnt_saved: HFONT;
 txt_size : SIZE;
begin
  hdc0 := GetDC(0);
  try
    hfnt_saved := SelectObject(hdc0,hfnt);
    txt_size.cx:=0;
    txt_size.cy:=0;
    GetTextExtentPoint32( hdc0 , PChar(str), Length(str), txt_size );
    SelectObject(hdc0,hfnt_saved);
  finally
    ReleaseDC(0,hdc0);
  end;
  Result:=txt_size;
end;

procedure SetComboHint(Combo: TComboBox);
{by Alexander Katz (skatz@svitonline.com)}
var
 str: String;
 VisWidth: Integer;
begin
  if Combo.ItemIndex>=0 then str:=Combo.Items[Combo.ItemIndex]
  else str:=Combo.Text;
  VisWidth:=Combo.Width-4;
  if Combo.Style<>csSimple then VisWidth:=VisWidth-GetSystemMetrics(SM_CXHSCROLL);
  if GetTextSize(Combo.Font.Handle, str).cx+2<=VisWidth then str:='';
  Combo.Hint:=str;
  Combo.ShowHint:=str<>'';
end;

procedure SetComboDropDownDropDownWidth(Combo: TComboBox);
{by Alexander Katz (skatz@svitonline.com)}
var
 DroppedWidth: Integer;
 ScreenRight: Integer;
 pnt: TPoint;
 rect_size : SIZE;
 item_str : String;
 hdc0 :HDC;
 hfnt : HFONT;
 i : Integer;
 cur_width : Integer;
begin
  rect_size.cx:=0;
  rect_size.cy:=0;
  DroppedWidth := 0;
  hdc0 := GetDC(0);
  try
    hfnt := SelectObject(hdc0,Combo.Font.Handle);
    for i:=0 to Combo.Items.Count-1 do
    begin
        item_str := Combo.Items[i];
        GetTextExtentPoint32( hdc0 , PChar(item_str), Length(item_str), rect_size );
        cur_width := rect_size.cx+8;
        if cur_width > DroppedWidth then DroppedWidth := cur_width;
    end;
    SelectObject(hdc0,hfnt);
  finally
    ReleaseDC(0,hdc0);
  end;

  if Combo.Items.Count>Combo.DropDownCount then
      DroppedWidth := DroppedWidth + GetSystemMetrics(SM_CXVSCROLL);
  pnt.x:=0;
  pnt.y:=0;
  pnt := Combo.ClientToScreen(pnt);
  ScreenRight := Screen.DesktopLeft+Screen.DesktopWidth;
  if pnt.x+DroppedWidth>ScreenRight then
  begin
    if ScreenRight - pnt.x > Combo.Width then
      DroppedWidth := ScreenRight - pnt.x
    else
      DroppedWidth := Combo.Width;
  end;
  SendMessage( Combo.Handle, CB_SETDROPPEDWIDTH, DroppedWidth, 0 );
end;

end.
