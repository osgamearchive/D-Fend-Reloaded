unit DataReaderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DataReaderUnit;

type
  TDataReaderForm = class(TForm)
    GameNameEdit: TLabeledEdit;
    SearchButton: TBitBtn;
    SearchResultsLabel: TLabel;
    ListBox: TListBox;
    GameDataBox: TGroupBox;
    InsertButton: TBitBtn;
    CancelButton: TBitBtn;
    GenreCheckBox: TCheckBox;
    DeveloperCheckBox: TCheckBox;
    PublisherCheckBox: TCheckBox;
    YearCheckBox: TCheckBox;
    DownloadCoverCheckBox: TCheckBox;
    GenreLabel: TLabel;
    DeveloperLabel: TLabel;
    PublisherLabel: TLabel;
    YearLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchButtonClick(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure InsertButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    GenreSt, DeveloperSt, PublisherSt, YearSt, CoverSt : TStringList;
    DataReader : TDataReader;
    ShowCompleted : Boolean;
  public
    { Public-Deklarationen }
    ConfigOK : Boolean;
    CaptureDir : String;
    Genre, Developer, Publisher, Year, Internet : String;
  end;

var
  DataReaderForm: TDataReaderForm;

Function ShowDataReaderDialog(const AOwner : TComponent; const AGameName : String; var Genre, Developer, Publisher, Year, Internet : String; const CaptureDir : String) : Boolean;

implementation

uses LanguageSetupUnit, CommonTools, VistaToolsUnit, InternetDataWaitFormUnit,
     PrgSetupUnit, PrgConsts, IconLoaderUnit;

{$R *.dfm}

procedure TDataReaderForm.FormCreate(Sender: TObject);
begin
  ShowCompleted:=False;
  GenreSt:=TStringList.Create;
  DeveloperSt:=TStringList.Create;
  PublisherSt:=TStringList.Create;
  YearSt:=TStringList.Create;
  CoverSt:=TStringList.Create;
  DataReader:=TDataReader.Create;

  ConfigOK:=ShowDataReaderInternetConfigWaitDialog(Owner,DataReader,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
end;

procedure TDataReaderForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  GenreLabel.Font.Style:=[fsBold];
  DeveloperLabel.Font.Style:=[fsBold];
  PublisherLabel.Font.Style:=[fsBold];
  YearLabel.Font.Style:=[fsBold];
  GenreLabel.Caption:='';
  DeveloperLabel.Caption:='';
  PublisherLabel.Caption:='';
  YearLabel.Caption:='';

  Caption:=LanguageSetup.DataReader;
  GameNameEdit.EditLabel.Caption:=LanguageSetup.GameName;
  SearchButton.Caption:=LanguageSetup.Search;
  SearchResultsLabel.Caption:=LanguageSetup.DataReaderSearchResults;
  GameDataBox.Caption:=LanguageSetup.DataReaderNoSearchResults;
  GenreCheckBox.Caption:=LanguageSetup.GameGenre;
  DeveloperCheckBox.Caption:=LanguageSetup.GameDeveloper;
  PublisherCheckBox.Caption:=LanguageSetup.GamePublisher;
  YearCheckBox.Caption:=LanguageSetup.GameYear;
  DownloadCoverCheckBox.Caption:=LanguageSetup.DataReaderCoverCheckbox;

  InsertButton.Caption:=LanguageSetup.DataReaderInsert;
  CancelButton.Caption:=LanguageSetup.Cancel;


  UserIconLoader.DialogImage(DI_FindFile,SearchButton);
  UserIconLoader.DialogImage(DI_OK,InsertButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  If Trim(GameNameEdit.Text)<>'' then SearchButtonClick(Sender);
  ShowCompleted:=True;
end;

procedure TDataReaderForm.FormDestroy(Sender: TObject);
begin
  GenreSt.Free;
  DeveloperSt.Free;
  PublisherSt.Free;
  YearSt.Free;
  CoverSt.Free;
  DataReader.Free;
end;

procedure TDataReaderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Key<>VK_RETURN then exit;

  If GameNameEdit.Focused then begin
    SearchButtonClick(Sender);
  end else begin
    ModalResult:=mrOK;
    InsertButtonClick(Sender);
  end;
end;

procedure TDataReaderForm.SearchButtonClick(Sender: TObject);
Var I : Integer;
    O : TComponent;
begin
  ListBox.Items.Clear;
  GenreSt.Clear;
  DeveloperSt.Clear;
  PublisherSt.Clear;
  YearSt.Clear;
  CoverSt.Clear;

  try
    Enabled:=False;
    try
      If ShowCompleted then O:=self else O:=Owner;
      If not ShowDataReaderInternetListWaitDialog(O,DataReader,GameNameEdit.Text,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError) then exit;
    finally
      Enabled:=True;
    end;
    For I:=0 to DataReader.GameNames.Count-1 do begin
      ListBox.Items.Add(DataReader.GameNames[I]);
      GenreSt.Add('');
      DeveloperSt.Add('');
      PublisherSt.Add('');
      YearSt.Add('');
      CoverSt.Add('');
    end;
  finally
    If ListBox.Items.Count>0 then ListBox.ItemIndex:=0;
    ListBoxClick(Sender);
    If ListBox.Items.Count>0 then ActiveControl:=ListBox;
  end;
end;

Function ProcessGenre(const S : String) : String;
Var I : Integer;
begin
  result:=S;
  For I:=1 to length(result) do if result[I]=',' then result[I]:=';';
end;

procedure TDataReaderForm.ListBoxClick(Sender: TObject);
Var DataReaderGameDataThread : TDataReaderGameDataThread;
    Nr : Integer;
    O : TComponent;
begin
  Nr:=ListBox.ItemIndex;
  If Nr<0 then begin
    GameDataBox.Caption:=LanguageSetup.DataReaderNoSearchResults;
    InsertButton.Enabled:=False;
    GenreCheckBox.Enabled:=False;
    GenreLabel.Caption:='';
    DeveloperCheckBox.Enabled:=False;
    DeveloperLabel.Caption:='';
    PublisherCheckBox.Enabled:=False;
    PublisherLabel.Caption:='';
    YearCheckBox.Enabled:=False;
    YearLabel.Caption:='';
    DownloadCoverCheckBox.Enabled:=False;
    exit;
  end;

  If (Trim(GenreSt[Nr])='') and (Trim(DeveloperSt[Nr])='') and (Trim(PublisherSt[Nr])='') and (Trim(YearSt[Nr])='') and (Trim(CoverSt[Nr])='') then begin
    Enabled:=False;
    try
      If ShowCompleted then O:=self else O:=Owner;
      DataReaderGameDataThread:=ShowDataReaderInternetDataWaitDialog(O,DataReader,Nr,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
    finally
      Enabled:=True;
    end;
    If DataReaderGameDataThread<>nil then try
      GenreSt[Nr]:=GetCustomGenreName(ProcessGenre(DataReaderGameDataThread.Genre));
      DeveloperSt[Nr]:=DataReaderGameDataThread.Developer;
      PublisherSt[Nr]:=DataReaderGameDataThread.Publisher;
      YearSt[Nr]:=DataReaderGameDataThread.Year;
      CoverSt[Nr]:=DataReaderGameDataThread.ImageURL;
    finally
      DataReaderGameDataThread.Free;
    end;
  end;

  GameDataBox.Caption:=ListBox.Items[Nr];
  GenreCheckBox.Enabled:=(Trim(GenreSt[Nr])<>'');
  GenreLabel.Caption:=GenreSt[Nr];
  DeveloperCheckBox.Enabled:=(Trim(DeveloperSt[Nr])<>'');
  DeveloperLabel.Caption:=DeveloperSt[Nr];
  PublisherCheckBox.Enabled:=(Trim(PublisherSt[Nr])<>'');
  PublisherLabel.Caption:=PublisherSt[Nr];
  YearCheckBox.Enabled:=(Trim(YearSt[Nr])<>'');
  YearLabel.Caption:=YearSt[Nr];
  DownloadCoverCheckBox.Enabled:=(Trim(CoverSt[Nr])<>'');
  InsertButton.Enabled:=(Trim(GenreSt[Nr])<>'') or (Trim(DeveloperSt[Nr])<>'') or (Trim(PublisherSt[Nr])<>'') or (Trim(YearSt[Nr])<>'') or (Trim(CoverSt[Nr])<>'');
end;

procedure TDataReaderForm.InsertButtonClick(Sender: TObject);
begin
  Genre:='';
  Developer:='';
  Publisher:='';
  Year:='';

  If GenreCheckBox.Enabled and GenreCheckBox.Checked then Genre:=GenreLabel.Caption;
  If DeveloperCheckBox.Enabled and DeveloperCheckBox.Checked then Developer:=DeveloperLabel.Caption;
  If PublisherCheckBox.Enabled and PublisherCheckBox.Checked then Publisher:=PublisherLabel.Caption;
  If YearCheckBox.Enabled and YearCheckBox.Checked then Year:=YearLabel.Caption;

  If DownloadCoverCheckBox.Enabled and DownloadCoverCheckBox.Checked and (CaptureDir<>'') then
    ShowDataReaderInternetCoverWaitDialog(self,DataReader,CoverSt[ListBox.ItemIndex],CaptureDir,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
end;

{ global }

Function ShowDataReaderDialog(const AOwner : TComponent; const AGameName : String; var Genre, Developer, Publisher, Year, Internet : String; const CaptureDir : String) : Boolean;
begin
  DataReaderForm:=TDataReaderForm.Create(AOwner);
  try
    If not DataReaderForm.ConfigOk then begin result:=False; exit; end;
    DataReaderForm.GameNameEdit.Text:=AGameName;
    DataReaderForm.CaptureDir:=CaptureDir;
    result:=(DataReaderForm.ShowModal=mrOK);
    if result then begin
      Genre:=DataReaderForm.Genre;
      Developer:=DataReaderForm.Developer;
      Publisher:=DataReaderForm.Publisher;
      Year:=DataReaderForm.Year;
      Internet:=DataReaderForm.Internet;
    end;
  finally
    DataReaderForm.Free;
  end;
end;

end.
