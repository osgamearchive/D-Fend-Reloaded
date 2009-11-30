unit InternetDataWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DataReaderUnit;

type
  TInternetDataWaitForm = class(TForm)
    Animate: TAnimate;
    Timer: TTimer;
    InfoLabel: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Thread : TThread;
  end;

var
  InternetDataWaitForm: TInternetDataWaitForm;

Function ShowDataReaderInternetConfigWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ACaption, AInfo, AError : String) : Boolean;
Function ShowDataReaderInternetListWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AName : String; const ACaption, AInfo, AError : String) : Boolean;
Function ShowDataReaderInternetDataWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ANr : Integer; const ACaption, AInfo, AError : String) : TDataReaderGameDataThread;
Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String; const ACaption, AInfo, AError : String);

Function DomainOnly(const S : String) : String;

implementation

uses ShellAnimations, VistaToolsUnit, CommonTools, LanguageSetupUnit, PrgConsts;

{$R *.dfm}

procedure TInternetDataWaitForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
end;

procedure TInternetDataWaitForm.TimerTimer(Sender: TObject);
begin
  If Assigned(Thread) and (WaitForSingleObject(Thread.Handle,0)=WAIT_OBJECT_0) then ModalResult:=mrOK;
end;

{ global }

Procedure ShowInternetWaitDialog(const AOwner : TComponent; const AThread : TThread; const ACaption, AInfo : String);
begin
  InternetDataWaitForm:=TInternetDataWaitForm.Create(AOwner);
  try
    InternetDataWaitForm.Caption:=ACaption;
    InternetDataWaitForm.InfoLabel.Caption:=AInfo;
    InternetDataWaitForm.Thread:=AThread;
    InternetDataWaitForm.ShowModal;
  finally
    InternetDataWaitForm.Free;
  end;
end;

Function ShowDataReaderInternetWaitDialog(const AOwner : TComponent; const AThread : TDataReaderThread; const ACaption, AInfo, AError : String) : Boolean;
begin
  ShowInternetWaitDialog(AOwner,AThread,ACaption,AInfo);
  result:=AThread.Success;
  If not result then begin MessageDlg(AError,mtError,[mbOK],0); FreeAndNil(result); end;
end;

Function ShowDataReaderInternetConfigWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ACaption, AInfo, AError : String) : Boolean;
Var DataReaderLoadConfigThread : TDataReaderLoadConfigThread;
begin
  DataReaderLoadConfigThread:=TDataReaderLoadConfigThread.Create(ADataReader);
  try
    result:=ShowDataReaderInternetWaitDialog(AOwner,DataReaderLoadConfigThread,ACaption,Format(AInfo,[DomainOnly(DataReaderUpdateURL)]),Format(AError,[DomainOnly(DataReaderUpdateURL)]));
  finally
    DataReaderLoadConfigThread.Free;
  end;
end;

Function ShowDataReaderInternetListWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const AName : String; const ACaption, AInfo, AError : String) : Boolean;
Var DataReaderGameListThread : TDataReaderGameListThread;
begin
  DataReaderGameListThread:=TDataReaderGameListThread.Create(ADataReader,AName);
  try
    result:=ShowDataReaderInternetWaitDialog(AOwner,DataReaderGameListThread,ACaption,Format(AInfo,[DomainOnly(ADataReader.Config.GamesListURL)]),Format(AError,[DomainOnly(ADataReader.Config.GamesListURL)]));
  finally
    DataReaderGameListThread.Free;
  end;
end;

Function ShowDataReaderInternetDataWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ANr : Integer; const ACaption, AInfo, AError : String) : TDataReaderGameDataThread;
begin
  result:=TDataReaderGameDataThread.Create(ADataReader,ANr);
  If not ShowDataReaderInternetWaitDialog(AOwner,result,ACaption,Format(AInfo,[DomainOnly(ADataReader.Config.GameRecordBaseURL)]),Format(AError,[DomainOnly(ADataReader.Config.GameRecordBaseURL)])) then FreeAndNil(result);
end;

Procedure ShowDataReaderInternetCoverWaitDialog(const AOwner : TComponent; const ADataReader : TDataReader; const ADownloadURL, ADestFolder : String; const ACaption, AInfo, AError : String);
Var DataReaderGameCoverThread : TDataReaderGameCoverThread;
begin
  DataReaderGameCoverThread:=TDataReaderGameCoverThread.Create(ADataReader,ADownloadURL,ADestFolder);
  try
    ShowDataReaderInternetWaitDialog(AOwner,DataReaderGameCoverThread,ACaption,Format(AInfo,[DomainOnly(ADataReader.Config.GameRecordBaseURL)]),Format(AError,[DomainOnly(ADataReader.Config.GameRecordBaseURL)]));
  finally
    DataReaderGameCoverThread.Free;
  end;
end;

Function DomainOnly(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  I:=Pos(':/'+'/',result); If I>0 then result:=Copy(result,I+3,MaxInt);
  I:=Pos('/',result); If I>0 then result:=Copy(result,1,I-1);
end;

end.
