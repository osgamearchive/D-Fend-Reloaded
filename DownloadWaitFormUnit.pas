unit DownloadWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, IdHTTP, IdComponent;

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
  end;

var
  DownloadWaitForm: TDownloadWaitForm = nil;

Procedure InitDownloadWaitForm(const AOwner : TComponent; const MaxPos : Integer);
Function StepDownloadWaitForm(const Pos : Integer) : Boolean;
Procedure DoneDownloadWaitForm;

Function DownloadFile(const AOwner : TComponent; const Size : Integer; const AbsBase, URL, DestFile : String) : Boolean;

implementation

uses Math, CommonTools, VistaToolsUnit, LanguageSetupUnit, PackageDBLanguage;

{$R *.dfm}

{ TDownloadWaitForm }

procedure TDownloadWaitForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Canceled:=False;
  HTTP:=nil;

  AbortButton.DoubleBuffered:=True;
end;

procedure TDownloadWaitForm.AbortButtonClick(Sender: TObject);
begin
  Canceled:=True;
  AbortButton.Enabled:=False;
end;

procedure TDownloadWaitForm.WorkEvent(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
begin
  ProgressBar.Position:=AWorkCount;
  DownloadWaitForm.Caption:=LANG_Downloading+' ['+IntToStr(100*AWorkCount div ProgressBar.Max)+'%]';
  Invalidate;
  Paint;
  Application.ProcessMessages;

  If Canceled and Assigned(HTTP) then HTTP.Disconnect;
end;

{ global }

Procedure InitDownloadWaitForm(const AOwner : TComponent; const MaxPos : Integer);
begin
  If not Assigned(DownloadWaitForm) then DownloadWaitForm:=TDownloadWaitForm.Create(AOwner);
  DownloadWaitForm.ProgressBar.Position:=0;
  DownloadWaitForm.ProgressBar.Max:=MaxPos;
  DownloadWaitForm.Caption:=LANG_Downloading;
  DownloadWaitForm.Show;
  DownloadWaitForm.Invalidate;
  DownloadWaitForm.Paint;
  Application.ProcessMessages;
end;

Function StepDownloadWaitForm(const Pos : Integer) : Boolean;
begin
  result:=True;
  If not Assigned(DownloadWaitForm) then exit;
  DownloadWaitForm.ProgressBar.Position:=Pos;
  DownloadWaitForm.Caption:=LANG_Downloading+' ['+IntToStr(100*Pos div DownloadWaitForm.ProgressBar.Max)+'%]';
  DownloadWaitForm.Invalidate;
  DownloadWaitForm.Paint;
  Application.ProcessMessages;
  result:=not DownloadWaitForm.Canceled;
end;

Procedure DoneDownloadWaitForm;
begin
  If Assigned(DownloadWaitForm) then FreeAndNil(DownloadWaitForm);
end;

Function DownloadFileFromInternet(const AOwner : TComponent; const Size : Integer; const URL, DestFile : String) : Boolean;
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
        HTTP.OnWork:=DownloadWaitForm.WorkEvent;
        HTTP.HandleRedirects:=True;
        HTTP.Get(URL,MSt);
        If DownloadWaitForm.Canceled then exit;
        MSt.SaveToFile(DestFile);
        result:=True;
      finally
        MSt.Free;
      end;
    finally
      HTTP.Free;
    end;
  finally
    DoneDownloadWaitForm;
  end;
end;

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
    I : Integer;
begin
  result:=False;
  If (length(URL)<2) or (URL[2]<>':') then exit;

  repeat
    For C:='A' to 'Z' do begin
      I:=GetDriveType(PChar(C+':\'));
      If (I<>DRIVE_REMOVABLE) and (I<>DRIVE_FIXED) and (I<>DRIVE_CDROM) and (I<>DRIVE_RAMDISK) then continue;
      If FileExists(C+Copy(URL,2,MaxInt)) then begin
        result:=CopyFileWithDialog(AOwner,C+Copy(URL,2,MaxInt),DestFile);
        If result then exit;
      end;
    end;
    if MessageDlg(Format(LANG_MenuUpdateListsLocal,[ExtractFileName(URL)]),mtInformation,[mbOK,mbCancel],0)<>mrOK then exit;
  until False;
end;

Function DownloadFile(const AOwner : TComponent; const Size : Integer; const AbsBase, URL, DestFile : String) : Boolean;
Var S : String;
begin
  If ExtUpperCase(Copy(AbsBase,1,7))='HTTP://' then begin
    If ExtUpperCase(Copy(URL,1,7))<>'HTTP://' then begin
      S:=AbsBase; While (S<>'') and (S[length(S)]<>'/') do SetLength(S,length(S)-1);
      If (URL<>'') and (URL[1]<>'/') then begin
        S:=S+URL;
      end else begin
        S:=S+Copy(URL,2,MaxInt);
      end;
    end else begin
      S:=URL;
    end;
    result:=DownloadFileFromInternet(AOwner,Size,S,DestFile);
  end else begin
    S:=IncludeTrailingPathDelimiter(ExtractFilePath(AbsBase));
    S:=MakeAbsPath(URL,S);
    result:=GetLocalFile(AOwner,Size,S,DestFile);

  end;
end;

end.
