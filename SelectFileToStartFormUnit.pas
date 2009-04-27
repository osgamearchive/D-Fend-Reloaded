unit SelectFileToStartFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TSelectFileToStartForm = class(TForm)
    InfoLabel: TLabel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    GameExeLabel: TLabel;
    GameExeComboBox: TComboBox;
    SetupExeLabel: TLabel;
    SetupExeComboBox: TComboBox;
    MoreButton: TBitBtn;
    FolderEdit: TLabeledEdit;
    TemplateComboBox: TComboBox;
    TemplateLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure MoreButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    SaveButtonTop, SaveClientHeight : Integer;
  public
    { Public-Deklarationen }
    FileToStart, SetupFileToStart : String;
    StartableFiles : TStringList;
    FolderName : String;
    TemplateNr : Integer;
  end;

var
  SelectFileToStartForm: TSelectFileToStartForm;

Function ShowSelectFileToStartDialog(const AOwner : TComponent; var AFileToStart, ASetupFileToStart : String; const AStartableFiles : TStringList; var AFolderName : String; var ATemplateNr : Integer) : Boolean;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, GameDBUnit,
     PrgSetupUnit, PrgConsts;

{$R *.dfm}

procedure TSelectFileToStartForm.FormShow(Sender: TObject);
Var I1,I2,I3,I4,I : Integer;
    S : String;
    TemplateDB : TGameDB;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  S:=LanguageSetup.MenuFileImportZIPCaption;
  While (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
  Caption:=S;
  InfoLabel.Caption:=LanguageSetup.MessageZipImportConfirm;
  GameExeLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  SetupExeLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  FolderEdit.EditLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolder;
  TemplateLabel.Caption:=LanguageSetup.MenuFileImportZIPTemplateToUse;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  MoreButton.Caption:=LanguageSetup.MenuFileImportZIPMoreSettings;

  If StartableFiles.Count>1 then begin
    GameExeComboBox.Items.Clear;
    GameExeComboBox.Items.AddStrings(StartableFiles);
    SetupExeComboBox.Items.Clear;
    SetupExeComboBox.Items.Add('');
    SetupExeComboBox.Items.AddStrings(StartableFiles);
    GameExeComboBox.ItemIndex:=Max(0,GameExeComboBox.Items.IndexOf(FileToStart));
    SetupExeComboBox.ItemIndex:=Max(0,SetupExeComboBox.Items.IndexOf(SetupFileToStart));
  end else begin
    GameExeLabel.Visible:=False;
    GameExeComboBox.Visible:=False;
    SetupExeLabel.Visible:=False;
    SetupExeComboBox.Visible:=False;
    I1:=TemplateLabel.Top-FolderEdit.Top;
    I2:=TemplateComboBox.Top-TemplateLabel.Top;
    I3:=OKButton.Top-TemplateComboBox.Top;
    I4:=ClientHeight-OKButton.Top;
    FolderEdit.Top:=GameExeComboBox.Top;
    TemplateLabel.Top:=FolderEdit.Top+I1;
    TemplateComboBox.Top:=TemplateLabel.Top+I2;
    OKButton.Top:=TemplateComboBox.Top+I3;
    CancelButton.Top:=OKButton.Top;
    MoreButton.Top:=OKButton.Top;
    ClientHeight:=OKButton.Top+I4;
  end;

  SaveButtonTop:=OKButton.Top;
  SaveClientHeight:=ClientHeight;
  OKButton.Top:=FolderEdit.Top;
  CancelButton.Top:=OKButton.Top;
  MoreButton.Top:=OKButton.Top;
  ClientHeight:=OKButton.Top+(SaveClientHeight-SaveButtonTop);

  FolderEdit.Text:=FolderName;

  TemplateComboBox.Items.Clear;
  TemplateComboBox.Items.AddObject(LanguageSetup.TemplateFormDefault,TObject(-1));
  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    For I:=0 to TemplateDB.Count-1 do TemplateComboBox.Items.AddObject(TemplateDB[I].Name,TObject(I));
  finally
    TemplateDB.Free;
  end;
  TemplateComboBox.ItemIndex:=0;
  For I:=0 to TemplateComboBox.Items.Count-1 do If Integer(TemplateComboBox.Items.Objects[I])=TemplateNr then begin
    TemplateComboBox.ItemIndex:=I; exit;
  end;
end;

procedure TSelectFileToStartForm.MoreButtonClick(Sender: TObject);
begin
  FolderEdit.Visible:=True;
  TemplateLabel.Visible:=True;
  TemplateComboBox.Visible:=True;

  OKButton.Top:=SaveButtonTop;
  CancelButton.Top:=OKButton.Top;
  MoreButton.Top:=OKButton.Top;
  ClientHeight:=SaveClientHeight;

  MoreButton.Visible:=False;
end;

procedure TSelectFileToStartForm.OKButtonClick(Sender: TObject);
begin
  If StartableFiles.Count>1 then begin
    FileToStart:=GameExeComboBox.Items[GameExeComboBox.ItemIndex];
    SetupFileToStart:=SetupExeComboBox.Items[SetupExeComboBox.ItemIndex];
  end;
  FolderName:=FolderEdit.Text;
  If TemplateComboBox.ItemIndex=-1 then TemplateNr:=-1 else TemplateNr:=Integer(TemplateComboBox.Items.Objects[TemplateComboBox.ItemIndex]);
end;

{ global }

Function ShowSelectFileToStartDialog(const AOwner : TComponent; var AFileToStart, ASetupFileToStart : String; const AStartableFiles : TStringList; var AFolderName : String; var ATemplateNr : Integer) : Boolean;
begin
  SelectFileToStartForm:=TSelectFileToStartForm.Create(AOwner);
  try
    SelectFileToStartForm.FileToStart:=AFileToStart;
    SelectFileToStartForm.SetupFileToStart:=ASetupFileToStart;
    SelectFileToStartForm.StartableFiles:=AStartableFiles;
    SelectFileToStartForm.FolderName:=AFolderName;
    SelectFileToStartForm.TemplateNr:=ATemplateNr;
    result:=(SelectFileToStartForm.ShowModal=mrOK);
    If result then begin
      AFileToStart:=SelectFileToStartForm.FileToStart;
      ASetupFileToStart:=SelectFileToStartForm.SetupFileToStart;
      AFolderName:=SelectFileToStartForm.FolderName;
      ATemplateNr:=SelectFileToStartForm.TemplateNr;
    end;
  finally
    SelectFileToStartForm.Free;
  end;
end;

end.
