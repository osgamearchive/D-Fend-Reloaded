unit PackageDBToolsUnit;
interface

uses Classes, XMLDoc, XMLIntf;

Function LoadXMLDoc(const FileName : String; var XMLDoc : TXMLDocument) : String; overload;
Function LoadXMLDoc(const FileName : String) : TXMLDocument; overload;

Procedure SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Datei : String; const Standalone : Boolean);

Function DecodeUpdateDate(S : String) : TDateTime;
Function EncodeUpdateDate(const Date : TDateTime) : String;

function DownloadFile(const URL: String): TMemoryStream; overload;
function DownloadFile(const URL, FileName: String): Boolean; overload;

Function GetNiceFileSize(const Size : Integer) : String;

Function ExtractFileNameFromURL(const URL : String) : String;
Function URLFileNameFromFileName(const FileName : String) : String;
Function ReplaceBRs(const S : String) : String;

Procedure ClearPackageCache;

implementation

uses Windows, SysUtils, Forms, Dialogs, Controls, IdHTTP, PackageDBLanguage,
     LanguageSetupUnit, CommonTools, PrgConsts, PrgSetupUnit;

Function LoadXMLDoc(const FileName : String; var XMLDoc : TXMLDocument) : String;
Var MSt : TMemoryStream;
begin
  result:=''; XMLDoc:=nil;

  if not FileExists(FileName) then exit;

  XMLDoc:=TXMLDocument.Create(Application.MainForm);

  MSt:=TMemoryStream.Create;
  try
    try
      MSt.LoadFromFile(FileName);
    except
      result:=Format(LanguageSetup.MessageCouldNotOpenFile,[FileName]);
      FreeAndNil(XMLDoc);
      exit;
    end;
    XMLDoc.LoadFromStream(MSt);
  finally
    MSt.Free;
  end;
  XMLDoc.FileName:=FileName;

  If not XMLDoc.Active then begin
    result:=Format(LANG_CouldNotActivateXML,[FileName]);
    FreeAndNil(XMLDoc);
    exit;
  end;
end;

Function LoadXMLDoc(const FileName : String) : TXMLDocument;
Var S : String;
begin
  S:=LoadXMLDoc(FileName,result);
  If S<>'' then MessageDlg(S,mtError,[mbOk],0);
end;

Procedure SaveXMLDoc(const Doc : IXMLDocument; const Lines : Array of String; const Datei : String; const Standalone : Boolean);
Var St : TStringList;
    S : String;
    X : Integer;
begin
  Doc.Version:='1.0';
  If Standalone then Doc.StandAlone:='yes' else Doc.StandAlone:='no';
  Doc.Encoding:='ISO-8859-1';
  Doc.NodeIndentStr:='  ';

  Doc.SaveToXML(S);
  S:=FormatXMLData(S);
  St:=TStringList.Create;
  try
    St.Text:=S;
    If Standalone
      then St[0]:='<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>'
      else St[0]:='<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>';
    For X:=Low(Lines) to High(Lines) do St.Insert(1+X-Low(Lines),Lines[X]);
    St.SaveToFile(Datei);
  finally
    St.Free;
  end;
end;

Function DecodeUpdateDate(S : String) : TDateTime;
Var I: Integer;
    D,M,Y : Integer;
begin
  result:=0;

  I:=Pos('/',S); If I=0 then exit;
  try M:=StrToInt(Copy(S,1,I-1)); except exit; end;
  S:=Copy(S,I+1,MaxInt);

  I:=Pos('/',S); If I=0 then exit;
  try D:=StrToInt(Copy(S,1,I-1)); except exit; end;
  S:=Copy(S,I+1,MaxInt);

  try Y:=StrToInt(S); except exit; end;

  try result:=EncodeDate(Y,M,D); except exit; end;
end;

Function EncodeUpdateDate(const Date : TDateTime) : String;
Var Y,M,D : Word;
    S1,S2,S3 : String;
begin
  DecodeDate(Date,Y,M,D);
  S1:=IntToStr(M); if length(S1)<2 then S1:='0'+S1;
  S2:=IntToStr(D); if length(S2)<2 then S2:='0'+S2;
  S3:=IntToStr(Y); if length(S3)<2 then S3:='0'+S3;
  result:=S1+'/'+S2+'/'+S3;
end;

function DownloadFileFromInternet(const URL: String): TMemoryStream;
Var HTTP: TIdHTTP;
begin
  result:=nil;

  HTTP:=TIdHTTP.Create(Application.MainForm);
  try
    result:=TMemoryStream.Create;
    try
      HTTP.Get(URL,result);
    except
      FreeAndNil(result);
    end;
  finally
    HTTP.Free;
  end;
end;

Function GetFileFromAnyDrive(const Path : String) : TMemoryStream;
Var C : Char;
    I : Integer;
begin
  result:=nil;
  If (length(Path)<2) or (Path[2]<>':') then exit;

  For C:='A' to 'Z' do begin
    I:=GetDriveType(PChar(C+':\'));
    If (I<>DRIVE_REMOVABLE) and (I<>DRIVE_FIXED) and (I<>DRIVE_CDROM) and (I<>DRIVE_RAMDISK) then continue;
    If FileExists(C+Copy(Path,2,MaxInt)) then begin
      result:=TMemoryStream.Create;
      try
        result.LoadFromFile(C+Copy(Path,2,MaxInt));
        result.Position:=0;
        exit;
      except
        FreeAndNil(result);
      end;
    end;
  end;
end;

Function GetFileFromLocalPath(const Path : String) : TMemoryStream;
begin
  repeat
    result:=GetFileFromAnyDrive(Path);
    If result<>nil then exit;
    if MessageDlg(Format(LANG_MenuUpdateListsLocal,[ExtractFileName(Path)]),mtInformation,[mbOK,mbCancel],0)<>mrOK then exit;
  until False;
end;

function DownloadFile(const URL: String): TMemoryStream;
begin
  If ExtUpperCase(Copy(URL,1,7))='HTTP:/'+'/' then begin
    result:=DownloadFileFromInternet(URL);
  end else begin
    result:=GetFileFromLocalPath(URL);
  end;
end;

function DownloadFile(const URL, FileName: String): Boolean;
Var MSt : TMemoryStream;
begin
  result:=False;
  MSt:=DownloadFile(URL);
  If MSt=nil then exit;
  try
    try
      MSt.SaveToFile(FileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[FileName]),mtError,[mbOK],0);
      exit;
    end;
    result:=True;
  finally
    MSt.Free;
  end;
end;

Function GetNiceFileSize(const Size : Integer) : String;
begin
  If Size<1024 then begin result:=IntToStr(Size)+' '+LANG_Bytes; exit; end;
  If Size<1024*1024 then begin result:=IntToStr(Size div 1024)+' '+LANG_KBytes; exit; end;
  result:=IntToStr(Size div 1024 div 1024)+' '+LANG_MBytes;
end;

Function Replace(const S, FromStr, ToStr : String) : String;
Var I : Integer;
begin
  result:=S;
  I:=Pos(FromStr,result);
  while I>0 do begin
    result:=Copy(result,1,I-1)+ToStr+Copy(result,I+length(FromStr),MaxInt);
    I:=Pos(FromStr,result);
  end;
end;

Function ExtractFileNameFromURL(const URL : String) : String;
{Var I : Integer;}
begin
  result:=URL;

  If ExtUpperCase(Copy(URL,1,7))='HTTP:/'+'/' then begin
    result:=Copy(result,8,MaxInt);
    {I:=Pos('/',result); while I>0 do begin result:=Copy(result,I+1,MaxInt); I:=Pos('/',result); end;}
    result:=Replace(result,'/','-');
    result:=Replace(result,'%20',' ');
  end else begin
    result:=Replace(result,':','-');
    result:=Replace(result,'\','-');
    If ExtUpperCase(Copy(result,length(result)-3,4))='.XML' then result:=Trim(Copy(result,1,length(result)-4));
  end;

  result:=MakeFileSysOKFolderName(result);
end;

Function URLFileNameFromFileName(const FileName : String) : String;
begin
  result:=Replace(FileName,' ','%20');
end;

Function ReplaceBRs(const S : String) : String;
begin
  result:=Replace(S,'\\',#13);
end;

Procedure ClearPackageCache;
Var I : Integer;
    Rec : TSearchRec;
    UserUpper : String;
    B : Boolean;
begin
  I:=FindFirst(PrgDataDir+PackageDBSubFolder+'\*.xml',faAnyFile,Rec);
  UserUpper:=ExtUpperCase(PackageDBUserFile);
  try
    While I=0 do begin
      B:=True;
      If ((Rec.Attr and faDirectory)=0) and (ExtUpperCase(Rec.Name)<>UserUpper) then ExtDeleteFile(PrgDataDir+PackageDBSubFolder+'\'+Rec.Name,ftTemp,True,B);
      if not B then exit;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  ExtDeleteFolder(PrgDataDir+PackageDBCacheSubFolder,ftTemp);
end;

end.
