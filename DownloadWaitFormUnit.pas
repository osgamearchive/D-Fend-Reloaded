unit DownloadWaitFormUnit;

interface

{$DEFINE UseBackgroundThread}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, IdHTTP, IdComponent, IdFTP;

type
  TDownloadWaitForm = class(TForm)
    ProgressBar: TProgressBar;
    AbortButton: TButton;
    procedure AbortButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure WorkEvent(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
  public
    { Public-Deklarationen }
    Canceled : Boolean;
    HTTP : TIdHTTP;
    FTP : TIdFTP;
  end;

var
  DownloadWaitForm: TDownloadWaitForm = nil;

Procedure InitDownloadWaitForm(const AOwner : TComponent; const MaxPos : Integer);
Function StepDownloadWaitForm(const Pos : Integer) : Boolean;
Procedure DoneDownloadWaitForm;

Function DownloadFileWithDialog(const AOwner : TComponent; const Size : Integer; const AbsBase, URL, Referer, DestFile : String) : Boolean;
Function MetaLinkDownload(const AOwner : TComponent; const ASize : Integer; const AbsBase, MetaLinkURL, Referer, DestFile : String) : Boolean;

implementation

uses XMLDoc, XMLIntf, Math, CommonTools, VistaToolsUnit, LanguageSetupUnit,
     PackageDBToolsUnit, PrgConsts, GameDBToolsUnit;

{$R *.dfm}

{ TDownloadWaitForm }

procedure TDownloadWaitForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Canceled:=False;
  HTTP:=nil;
  FTP:=nil;

  AbortButton.DoubleBuffered:=True;
  AbortButton.Caption:=LanguageSetup.MsgDlgAbort;
end;

procedure TDownloadWaitForm.AbortButtonClick(Sender: TObject);
begin
  Canceled:=True;
  AbortButton.Enabled:=False;
end;

procedure TDownloadWaitForm.WorkEvent(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  ProgressBar.Position:=AWorkCount;
  If DownloadWaitForm.ProgressBar.Max>1 then begin
    ProgressBar.Position:=AWorkCount;
    Caption:=LanguageSetup.PackageManagerDownloading+' ['+IntToStr(100*Int64(AWorkCount) div Int64(ProgressBar.Max))+'%]';
  end;
  Invalidate;
  Paint;
  Application.ProcessMessages;

  If Canceled then begin
    If Assigned(FTP) then FTP.Abort else begin If Assigned(HTTP) then HTTP.Disconnect; end;
  end;
end;

{ global }

Procedure InitDownloadWaitForm(const AOwner : TComponent; const MaxPos : Integer);
begin
  If not Assigned(DownloadWaitForm) then DownloadWaitForm:=TDownloadWaitForm.Create(AOwner);
  DownloadWaitForm.ProgressBar.Position:=0;
  DownloadWaitForm.ProgressBar.Max:=Max(1,MaxPos);
  DownloadWaitForm.Caption:=LanguageSetup.PackageManagerDownloading;
  DownloadWaitForm.Show;
  DownloadWaitForm.Invalidate;
  DownloadWaitForm.Paint;
  Application.ProcessMessages;
end;

Function StepDownloadWaitForm(const Pos : Integer) : Boolean;
begin
  result:=True;
  If not Assigned(DownloadWaitForm) then exit;
  If DownloadWaitForm.ProgressBar.Max>1 then begin
    DownloadWaitForm.ProgressBar.Position:=Pos;
    DownloadWaitForm.Caption:=LanguageSetup.PackageManagerDownloading+' ['+IntToStr(100*Pos div DownloadWaitForm.ProgressBar.Max)+'%]';
  end;
  DownloadWaitForm.Invalidate;
  DownloadWaitForm.Paint;
  Application.ProcessMessages;
  result:=not DownloadWaitForm.Canceled;
end;

Procedure DoneDownloadWaitForm;
begin
  If Assigned(DownloadWaitForm) then FreeAndNil(DownloadWaitForm);
end;

Function SimpleFileCheck(const MSt : TMemoryStream; const DestFile : String) : Boolean;
Type TCharArray=Array[0..MaxInt div 2-1] of Char;
Var Ext : String;
begin
  result:=True;
  Ext:=Trim(ExtUpperCase(ExtractFileExt(DestFile)));
  If (Ext<>'.ZIP') and (Ext<>'.EXE') then exit;
  If Ext='.ZIP' then result:=(TCharArray(MSt.Memory^)[0]='P') and(TCharArray(MSt.Memory^)[1]='K');
  If Ext='.EXE' then result:=(TCharArray(MSt.Memory^)[0]='M') and(TCharArray(MSt.Memory^)[1]='Z');
end;

Function CalcReferer(const URL, Referer : String) : String;
Var I : Integer;
    S,T : String;
begin
  If ExtUpperCase(Referer)='AUTOMATIC' then begin
    If Pos('SOURCEFORGE',ExtUpperCase(URL))=0 then begin
      I:=Pos('/'+'/',URL); If I=0 then begin S:=''; T:=URL; end else begin S:=Copy(URL,1,I+1); T:=Copy(URL,I+2,MaxInt); end;
      I:=Pos('/',T); If I>0 then T:=Copy(T,1,I);
      result:=S+T;
    end else begin
      result:='';
    end;
  end else begin
    result:=Referer;
  end;
end;

Type THTTPThread=class(TThread)
  private
    FURL, FReferer, FDestFile : String;
    FSuccess : Boolean;
    FWorkEvent1Sender : TObject;
    FWorkEvent1WorkMode : TWorkMode;
    FWorkEvent1WorkCount, FWorkEvent1WorkSize : Integer;
    FTPDownloadHandled : Boolean;
    HTTP : TIdHTTP;
    FTP : TIdFTP;
    Procedure WorkEvent1(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    Procedure WorkEvent2;
    Procedure RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
  protected
    Procedure Execute; override;
  public
    Constructor Create(const AOwner : TComponent; const AURL, AReferer, ADestFile : String; const ASize : Integer);
    Destructor Destroy; override;
    property Success : Boolean read FSuccess;
end;

Constructor THTTPThread.Create(const AOwner : TComponent; const AURL, AReferer, ADestFile : String; const ASize : Integer);
begin
  inherited Create(True);
  FURL:=AURL;
  FReferer:=AReferer;
  FDestFile:=ADestFile;
  FSuccess:=False;
  FTPDownloadHandled:=False;
  InitDownloadWaitForm(AOwner,ASize);
  HTTP:=nil; FTP:=nil;
  Resume;
end;

Destructor THTTPThread.Destroy;
begin
  DoneDownloadWaitForm;
end;

Procedure THTTPThread.Execute;
Var MSt : TMemoryStream;
    I : Integer;
    B: Boolean;
    V : TIdHTTPMethod;
begin
  If ExtUpperCase(Copy(FURL,1,6))='FTP:/'+'/' then begin
    I:=0; B:=True; V:='GET';
    RedirectEvent(self,FURL,I,B,V);
    FSuccess:=FTPDownloadHandled;
    exit;
  end;

  HTTP:=TIdHTTP.Create(Application.MainForm);
  try
    MSt:=TMemoryStream.Create;
    try
      DownloadWaitForm.HTTP:=HTTP;
      HTTP.Request.UserAgent:='User-Agent=Mozilla/5.0 (Windows; U; Windows NT 6.0)';
      HTTP.Request.AcceptLanguage:='en';
      HTTP.Request.Referer:=CalcReferer(FURL,FReferer);
      HTTP.OnWork:=WorkEvent1;
      HTTP.OnRedirect:=RedirectEvent;
      HTTP.HandleRedirects:=True;
      HTTP.ConnectTimeout:=10*1000;
      try
        HTTP.Get(FURL,MSt);
      except
        If not FTPDownloadHandled then exit;
      end;
      If not FTPDownloadHandled then begin
        If not SimpleFileCheck(MSt,FDestFile) then exit;
        If DownloadWaitForm.Canceled then exit;
        MSt.SaveToFile(FDestFile);
      end;
      FSuccess:=True;
    finally
      MSt.Free;
    end;
  finally
    DownloadWaitForm.HTTP:=nil;
    HTTP.Free;
  end;
end;

Procedure THTTPThread.WorkEvent1(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  FWorkEvent1Sender:=ASender;
  FWorkEvent1WorkMode:=AWorkMode;
  FWorkEvent1WorkCount:=AWorkCount;
  If Assigned(HTTP) and (not Assigned(FTP)) then FWorkEvent1WorkSize:=Max(1,HTTP.Response.ContentLength);
  Synchronize(WorkEvent2);
end;

Procedure THTTPThread.WorkEvent2;
begin
  If DownloadWaitForm.ProgressBar.Max=1 then begin
    DownloadWaitForm.ProgressBar.Max:=FWorkEvent1WorkSize;
  end;
  DownloadWaitForm.WorkEvent(FWorkEvent1Sender,FWorkEvent1WorkMode,FWorkEvent1WorkCount);
end;

{Procedure THTTPThread.RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
Var MSt : TMemoryStream;
    S : String;
    I : Integer;
begin
  If ExtUpperCase(Copy(dest,1,6))<>'FTP:/'+'/' then exit;

  MSt:=TMemoryStream.Create;
  try
    FTP:=TIdFTP.Create(Application.MainForm);
    try
      try
        DownloadWaitForm.FTP:=FTP;
        S:=Copy(dest,7,MaxInt); I:=Pos('/',S); If I>0 then S:=Copy(S,1,I-1);
        FTP.OnWork:=WorkEvent1;
        FTP.Host:=S;
        FTP.Username:='anonymous';
        FTP.Password:='sorry@nomail.com';
        FTP.Port:=21;
        FTP.Passive:=True;
        FTP.ConnectTimeout:=10*1000;
        FTP.Connect;
        S:=Copy(dest,7,MaxInt); I:=Pos('/',S); If I>0 then S:=Copy(S,I,MaxInt);
        FWorkEvent1WorkSize:=FTP.Size(S);
        FTP.Get(S,MSt);
      except
        exit;
      end;
    finally
      DownloadWaitForm.FTP:=nil;
      FTP.Free;
    end;
    If not SimpleFileCheck(MSt,FDestFile) then exit;
    If DownloadWaitForm.Canceled then exit;
    MSt.SaveToFile(FDestFile);
    Handled:=False;
    FTPDownloadHandled:=True;
  finally
    MSt.Free;
  end;
end;}

Procedure THTTPThread.RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
{by Alexander Katz (skatz@svitonline.com)}
Var MSt : TMemoryStream;
    S, S1 : String;
    I : Integer;
begin
  If ExtUpperCase(Copy(dest,1,6))<>'FTP:/'+'/' then exit;

  MSt:=TMemoryStream.Create;
  try
    FTP:=TIdFTP.Create(Application.MainForm);
    try
      try
        DownloadWaitForm.FTP:=FTP;
        S:=Copy(dest,7,MaxInt); I:=Pos('/',S); If I>0 then S:=Copy(S,1,I-1);
        FTP.OnWork:=WorkEvent1;
        I:=Pos('@',S);
        If I>0 then
        begin
          S1:=Copy(S,1,I-1);
          Delete(S,1,I);
          I:=Pos(':',S1);
          if I>0 then
          begin
            FTP.Username:=Copy(S1,1,I-1);
            FTP.Password:=Copy(S1,I+1,MaxInt);
          end
          else
          begin
            FTP.Username:=S1;
            FTP.Password:='';
          end;
        end
        else
        begin
          FTP.Username:='anonymous';
          FTP.Password:='sorry@nomail.com';
        end;
        I:=Pos(':',S);
        if I>0  then
        begin
          FTP.Port:=StrToIntDef(Copy(S,I+1,MaxInt),21);
          Delete(S,I+1,MaxInt);
        end
        else FTP.Port:=21;
        FTP.Host:=S;
        FTP.Passive:=True;
        FTP.ConnectTimeout:=10*1000;
        FTP.Connect;
        S:=Copy(dest,7,MaxInt); I:=Pos('/',S); If I>0 then S:=Copy(S,I,MaxInt);
        FWorkEvent1WorkSize:=FTP.Size(S);
        FTP.Get(S,MSt);
      except
        exit;
      end;
    finally
      DownloadWaitForm.FTP:=nil;
      FTP.Free;
    end;
    If not SimpleFileCheck(MSt,FDestFile) then exit;
    If DownloadWaitForm.Canceled then exit;
    MSt.SaveToFile(FDestFile);
    Handled:=False;
    FTPDownloadHandled:=True;
  finally
    MSt.Free;
  end;
end;

Function DownloadFileFromInternet(const AOwner : TComponent; const Size : Integer; const URL, Referer, DestFile : String) : Boolean;
{$IFDEF UseBackgroundThread}
Var HTTPThread : THTTPThread;
begin
  HTTPThread:=THTTPThread.Create(AOwner,DecodeHTMLSymbols(URL),DecodeHTMLSymbols(Referer),DestFile,Size);
  try
    While WaitForSingleObject(HTTPThread.Handle,100)<>WAIT_OBJECT_0 do begin
      Application.ProcessMessages;
    end;
    result:=HTTPThread.Success;
  finally
    HTTPThread.Free;
  end;
end;
{$ELSE}
Var HTTP : TIdHTTP;
    MSt : TMemoryStream;
begin
  result:=False;
  InitDownloadWaitForm(AOwner,Size);
  try
    HTTP:=TIdHTTP.Create(Application.MainForm);
    try
      MSt:=TMemoryStream.Create;
      try
        DownloadWaitForm.HTTP:=HTTP;
        HTTP.Request.UserAgent:='User-Agent=Mozilla/5.0 (Windows; U; Windows NT 6.0)';
        HTTP.Request.AcceptLanguage:='en';
        HTTP.Request.Referer:=CalcReferer(URL,Referer);
        HTTP.OnWork:=DownloadWaitForm.WorkEvent;
        HTTP.HandleRedirects:=True;
        HTTP.ConnectTimeout:=10*1000;
        HTTP.Get(ProcessURL(URL),MSt);
        If not SimpleFileCheck(MSt,DestFile) then exit;
        If DownloadWaitForm.Canceled then exit;
        MSt.SaveToFile(DestFile);
        result:=True;
      finally
        MSt.Free;
      end;
    finally
      DownloadWaitForm.HTTP:=nil;
      HTTP.Free;
    end;
  finally
    DoneDownloadWaitForm;
  end;
end;
{$ENDIF}

Function CopyFileWithDialog(const AOwner : TComponent; const SourceFile, DestinationFile : String) : Boolean;
const BufSize=1024*1224;
Var FSt1, FSt2 : TFileStream;
    Buffer : Pointer;
    C,D : Int64;
    I : Integer;
begin
  result:=False;
  GetMem(Buffer,BufSize);
  try
    try FSt1:=TFileStream.Create(SourceFile,fmOpenRead); except exit; end;
    try
      try FSt2:=TFileStream.Create(DestinationFile,fmCreate); except exit; end;
      try
        C:=FSt1.Size; D:=0;
        InitDownloadWaitForm(AOwner,C);
        try
          While C>0 do begin
            I:=Min(C,BufSize);
            FSt1.ReadBuffer(Buffer^,I);
            FSt2.WriteBuffer(Buffer^,I);
            dec(C,I); inc(D,I);
            StepDownloadWaitForm(D);
          end;
        except
          exit;
        end;
      finally
        DoneDownloadWaitForm;
        FSt2.Free;
      end;
    finally
      FSt1.Free;
    end;
  finally
    FreeMem(Buffer);
  end;
  result:=True;
end;

Function GetLocalFile(const AOwner : TComponent; const Size : Integer; const URL, DestFile : String) : Boolean;
Var C : Char;
    I, SaveErrorMode : Integer;
    AlternateURL : String;
begin
  result:=False;
  If (length(URL)<2) or (URL[2]<>':') then exit;

  AlternateURL:=Replace(URL,'%20',' ');

  repeat
    For C:='A' to 'Z' do begin
      I:=GetDriveType(PChar(C+':\'));
      If (I<>DRIVE_REMOVABLE) and (I<>DRIVE_FIXED) and (I<>DRIVE_CDROM) and (I<>DRIVE_RAMDISK) then continue;
      SaveErrorMode:=SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        If FileExists(C+Copy(URL,2,MaxInt)) then begin
          result:=CopyFileWithDialog(AOwner,C+Copy(URL,2,MaxInt),DestFile);
          If result then exit;
        end;
        If FileExists(C+Copy(AlternateURL,2,MaxInt)) then begin
          result:=CopyFileWithDialog(AOwner,C+Copy(AlternateURL,2,MaxInt),DestFile);
          If result then exit;
        end;
      finally
        SetErrorMode(SaveErrorMode);
      end;
    end;
    if MessageDlg(Format(LanguageSetup.PackageManagerMenuUpdateListsLocal,[ExtractFileName(URL)]),mtInformation,[mbOK,mbCancel],0)<>mrOK then exit;
  until False;
end;

Function IsInternetURL(const URL : String) : Boolean;
Var S : String;
begin
  S:=ExtUpperCase(URL);
  result:=(Copy(S,1,7)='HTTP:/'+'/') or (Copy(S,1,8)='HTTPS:/'+'/') or (Copy(S,1,6)='FTP:/'+'/');
end;

Function DownloadFileWithDialog(const AOwner : TComponent; const Size : Integer; const AbsBase, URL, Referer, DestFile : String) : Boolean;
Var S : String;
begin
  If IsInternetURL(URL) or IsInternetURL(AbsBase) then begin
    If not IsInternetURL(URL) then begin
      S:=AbsBase; While (S<>'') and (S[length(S)]<>'/') do SetLength(S,length(S)-1);
      If (URL<>'') and (URL[1]<>'/') then S:=S+URL else S:=S+Copy(URL,2,MaxInt);
    end else begin
      S:=URL;
    end;
    result:=DownloadFileFromInternet(AOwner,Size,S,Referer,DestFile);
  end else begin
    S:=IncludeTrailingPathDelimiter(ExtractFilePath(AbsBase));
    S:=MakeAbsPath(URL,S);
    result:=GetLocalFile(AOwner,Size,S,DestFile);
  end;
end;

Function GetDownloadLinksFromMetaLink(const XMLFileName : String) : TStringList;
Var XML : TXMLDocument;
    N1,N2 : IXMLNode;
    I : Integer;
begin
  result:=TStringList.Create;
  XML:=LoadXMLDoc(XMLFileName); If XML=nil then exit;
  try
    N1:=XML.DocumentElement;
    If N1.NodeName<>'metalink' then exit;

    N2:=nil;
    For I:=0 to N1.ChildNodes.Count-1 do If N1.ChildNodes[I].NodeName='files' then begin N2:=N1.ChildNodes[I]; break; end;
    If N2=nil then exit;

    N1:=nil;
    For I:=0 to N2.ChildNodes.Count-1 do If N2.ChildNodes[I].NodeName='file' then begin N1:=N2.ChildNodes[I]; break; end;
    If N1=nil then exit;

    N2:=nil;
    For I:=0 to N1.ChildNodes.Count-1 do If N1.ChildNodes[I].NodeName='resources' then begin N2:=N1.ChildNodes[I]; break; end;
    If N2=nil then exit;

    For I:=0 to N2.ChildNodes.Count-1 do If N2.ChildNodes[I].NodeName='url' then result.Add(N2.ChildNodes[I].NodeValue);
  finally
    XML.Free;
  end;
end;

Function MetaLinkProcessor(const AOwner : TComponent; const ASize : Integer; const XMLFileName, DestFile : String) : Boolean;
Var St : TStringList;
    I : Integer;
begin
  result:=False;
  St:=GetDownloadLinksFromMetaLink(XMLFileName);
  try
    While St.Count>0 do begin
      I:=Random(St.Count);
      result:=DownloadFileWithDialog(AOwner,ASize,'',St[I],'',DestFile);
      If result then exit;
      St.Delete(I);
    end;
  finally
    St.Free;
  end;
end;

Function MetaLinkDownload(const AOwner : TComponent; const ASize : Integer; const AbsBase, MetaLinkURL, Referer, DestFile : String) : Boolean;
Var TempXMLFile : String;
begin
  result:=False;
  TempXMLFile:=TempDir+PackageDBTempFile;
  If not DownloadFileWithDialog(AOwner,0,AbsBase,MetaLinkURL,Referer,TempXMLFile) then exit;
  try
    result:=MetaLinkProcessor(AOwner,ASize,TempXMLFile,DestFile);
  finally
    ExtDeleteFile(TempXMLFile,ftTemp);
  end;
end;

end.
