unit CheatSearchFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, CheatDBSearchUnit, CheatDBUnit;

type
  TCheatSearchForm = class(TForm)
    Notebook: TNotebook;
    SearchStartLabel: TLabel;
    SearchStartRadioButton1: TRadioButton;
    SearchNameEdit: TLabeledEdit;
    SearchStartRadioButton2: TRadioButton;
    SearchNameComboBox: TComboBox;
    NextButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    DoSearchLabel: TLabel;
    ValueTypeRadioButton1: TRadioButton;
    ValueEdit: TLabeledEdit;
    ValueTypeRadioButton2: TRadioButton;
    ValueComboBox: TComboBox;
    FileNameEdit: TLabeledEdit;
    FileNameButton: TSpeedButton;
    ActionLabel: TLabel;
    OpenDialog: TOpenDialog;
    AddressEdit: TLabeledEdit;
    BytesComboBox: TComboBox;
    BytesLabel: TLabel;
    GameNameLabel: TLabel;
    GameNameComboBox: TComboBox;
    DescriptionEdit: TLabeledEdit;
    FileMaskEdit: TLabeledEdit;
    NewValueEdit: TLabeledEdit;
    UseDialogCheckBox: TCheckBox;
    UseDialogEdit: TLabeledEdit;
    SearchNameDeleteButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SearchNameChange(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchValueChange(Sender: TObject);
    procedure FileNameButtonClick(Sender: TObject);
    procedure UseDialogEditChange(Sender: TObject);
    procedure SearchNameDeleteButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    SearchFiles, SearchNames : TStringList;
    AddressSearcher : TAddressSearcher;
    ResultAddress,ResultSize : Integer;
    CheatDB : TCheatDB;
    Procedure InitPage(const Nr : Integer);
  public
    { Public-Deklarationen }
  end;

var
  CheatSearchForm: TCheatSearchForm;

Procedure ShowCheatSearchDialog(const AOwner : TComponent);

implementation

uses CommonTools, VistaToolsUnit, LanguageSetupUnit, IconLoaderUnit, HelpConsts,
     PrgSetupUnit, CheatDBToolsUnit, StatisticsFormUnit;

{$R *.dfm}

procedure TCheatSearchForm.FormCreate(Sender: TObject);
begin
  SearchFiles:=TStringList.Create;
  SearchNames:=TStringList.Create;
  GetAddressSearchFiles(SearchFiles,SearchNames);
  AddressSearcher:=nil;
  CheatDB:=nil;
end;

procedure TCheatSearchForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.SearchAddress;
  SearchStartLabel.Caption:=LanguageSetup.SearchAddressStart;
  SearchStartRadioButton1.Caption:=LanguageSetup.SearchAddressStartNew;
  SearchNameEdit.EditLabel.Caption:=LanguageSetup.SearchAddressStartNewName;
  SearchStartRadioButton2.Caption:=LanguageSetup.SearchAddressStartContinue;

  DoSearchLabel.Caption:=LanguageSetup.SearchAddressData;
  ValueTypeRadioButton1.Caption:=LanguageSetup.SearchAddressDataKnown;
  ValueEdit.EditLabel.Caption:=LanguageSetup.SearchAddressDataKnownValue;
  ValueTypeRadioButton2.Caption:=LanguageSetup.SearchAddressDataUnknown;
  ValueComboBox.Items.Clear;
  ValueComboBox.Items.Add(LanguageSetup.SearchAddressDataUnknownIncreased);
  ValueComboBox.Items.Add(LanguageSetup.SearchAddressDataUnknownDescreased);
  FileNameEdit.EditLabel.Caption:=LanguageSetup.SearchAddressDataFileName;
  OpenDialog.Filter:=LanguageSetup.SearchAddressDataFileNameFilter;
  OpenDialog.Title:=LanguageSetup.SearchAddressDataFileNameTitle;
  FileNameButton.Hint:=LanguageSetup.ChooseFile;
  ActionLabel.Caption:=LanguageSetup.SearchAddressResult;
  AddressEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultAddress;
  NewValueEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultNewValue;
  NewValueEdit.Hint:=LanguageSetup.SearchAddressResultNewValueHint;
  BytesLabel.Caption:=LanguageSetup.SearchAddressResultBytes;
  GameNameLabel.Caption:=LanguageSetup.SearchAddressResultGameName;
  DescriptionEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultDescription;
  FileMaskEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultFileMask;
  UseDialogCheckBox.Caption:=LanguageSetup.SearchAddressResultUseDialog;
  UseDialogEdit.EditLabel.Caption:=LanguageSetup.SearchAddressResultUseDialogPrompt;
  NextButton.Caption:=LanguageSetup.Next;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_SelectFile,FileNameButton);

  InitPage(0);
end;

procedure TCheatSearchForm.FormDestroy(Sender: TObject);
begin
  SearchFiles.Free;
  SearchNames.Free;
  If Assigned(AddressSearcher) then AddressSearcher.Free;
  If Assigned(CheatDB) then CheatDB.Free;
end;

procedure TCheatSearchForm.InitPage(const Nr: Integer);
Var I : Integer;
begin
  Case Nr of
    0 : begin
          SearchNameComboBox.Items.Clear;
          SearchNameComboBox.Items.AddStrings(SearchNames);
          If SearchNames.Count>0 then begin
            SearchNameComboBox.ItemIndex:=0;
            SearchStartRadioButton2.Checked:=True;
          end else begin
            SearchStartRadioButton2.Enabled:=False;
            SearchNameDeleteButton.Enabled:=False;
            SearchNameComboBox.Enabled:=False;
            SearchStartRadioButton1.Checked:=True;
          end;
        end;
    1 : begin
          If SearchStartRadioButton2.Checked then begin
            AddressSearcher:=TAddressSearcher.Create;
            AddressSearcher.LoadFromFile(SearchFiles[SearchNameComboBox.ItemIndex]);
            FileNameEdit.Text:=AddressSearcher.LastSavedGameFileName;
            ValueComboBox.ItemIndex:=0;
          end else begin
            ValueComboBox.ItemIndex:=-1;
            ValueComboBox.Enabled:=False;
          end;
          ValueTypeRadioButton1.Checked:=True;
        end;
    2 : begin
          CheatDB:=SmartLoadCheatsDB;
          GameNameComboBox.Items.BeginUpdate;
          try
            GameNameComboBox.Items.Clear;
            For I:=0 to CheatDB.Count-1 do GameNameComboBox.Items.AddObject(CheatDB[I].Name,CheatDB[I]);
          finally
            GameNameComboBox.Items.EndUpdate;
          end;
          If GameNameComboBox.Items.Count>0 then GameNameComboBox.ItemIndex:=0;

          AddressSearcher.GetResult(ResultAddress,ResultSize);
          BytesComboBox.Items.Clear;
          BytesComboBox.Items.Add('1');
          If ResultSize>=2 then BytesComboBox.Items.Add('2');
          If ResultSize=4 then BytesComboBox.Items.Add('4');
          BytesComboBox.ItemIndex:=BytesComboBox.Items.Count-1;

          AddressEdit.Text:=IntToStr(ResultAddress)+'d'+IntToHex(ResultAddress,1)+'h';
          AddressEdit.Color:=Color;

          Case ResultSize of
            1 : NewValueEdit.Text:='$FF';
            2 : NewValueEdit.Text:='$FFFF';
            4 : NewValueEdit.Text:='$FFFFFFFF';
          End;
        end;
  end;
end;

procedure TCheatSearchForm.SearchNameChange(Sender: TObject);
begin
  If Sender=SearchNameEdit then SearchStartRadioButton1.Checked:=True;
  If Sender=SearchNameComboBox then SearchStartRadioButton2.Checked:=True;
end;

procedure TCheatSearchForm.SearchNameDeleteButtonClick(Sender: TObject);
begin
  If SearchNameComboBox.ItemIndex<0 then exit;

  ExtDeleteFile(SearchFiles[SearchNameComboBox.ItemIndex],ftTemp);
  SearchFiles.Delete(SearchNameComboBox.ItemIndex);
  SearchNames.Delete(SearchNameComboBox.ItemIndex);

  InitPage(0);
end;

procedure TCheatSearchForm.SearchValueChange(Sender: TObject);
begin
  If Sender=ValueEdit then ValueTypeRadioButton1.Checked:=True;
  If Sender=ValueComboBox then ValueTypeRadioButton2.Checked:=True;
end;

procedure TCheatSearchForm.UseDialogEditChange(Sender: TObject);
begin
  UseDialogCheckBox.Checked:=True;
end;

procedure TCheatSearchForm.FileNameButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FileNameEdit.Text)<>'' then S:=ExtractFilePath(FileNameEdit.Text) else S:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);
  OpenDialog.InitialDir:=S;
  If not OpenDialog.Execute then exit;
  FileNameEdit.Text:=OpenDialog.FileName;
end;

procedure TCheatSearchForm.NextButtonClick(Sender: TObject);
Var Value,I,J : Integer;
    R : TResultStatus;
    SavedGameFileName : String;
    ValueChangeType : TValueChangeType;
    GameRecord : TCheatGameRecord;
    CheatAction : TCheatAction;
    CheatActionStep : TCheatActionStep;
    St : TStringList;
begin
  Case Notebook.PageIndex of
    0 : begin
          If SearchStartRadioButton1.Checked and (Trim(SearchNameEdit.Text)='') then begin
            MessageDlg(LanguageSetup.SearchAddressStartNewNameMessage,mtError,[mbOK],0);
            exit;
          end;
          Notebook.PageIndex:=1;
          InitPage(1);
        end;
    1 : begin
          If ValueTypeRadioButton1.Checked and not TryStrToInt(ValueEdit.Text,Value) then begin
            MessageDlg(LanguageSetup.SearchAddressDataKnownValueMessage,mtError,[mbOK],0);
            exit;
          end;
          If Trim(FileNameEdit.Text)='' then begin
            MessageDlg(LanguageSetup.SearchAddressDataFileNameMessage,mtError,[mbOK],0);
            exit;
          end;
          SavedGameFileName:=MakeAbsPath(FileNameEdit.Text,PrgSetup.BaseDir);
          If not FileExists(SavedGameFileName) then begin
            MessageDlg(Format(LanguageSetup.MessageFileNotFound,[SavedGameFileName]),mtError,[mbOK],0);
            exit;
          end;

          If not Assigned(AddressSearcher) then begin
            AddressSearcher:=TAddressSearcher.Create;
            AddressSearcher.Name:=SearchNameEdit.Text;
          end;
          If ValueTypeRadioButton1.Checked then begin
            AddressSearcher.SearchAddress(SavedGameFileName,StrToInt(ValueEdit.Text));
          end else begin
            If ValueComboBox.Enabled then begin
              If ValueComboBox.ItemIndex=0 then ValueChangeType:=vctUp else ValueChangeType:=vctDown;
              AddressSearcher.SearchAddressIndirect(SavedGameFileName,ValueChangeType);
            end else begin
              AddressSearcher.LoadSavedGameFile(SavedGameFileName)
            end;
          end;

          R:=AddressSearcher.GetResult(I,J);
          If (R=rsNoResultsYet) or (R=rsMultipleAddresses) then AddressSearcher.SaveToFile('');

          If R=rsNoResultsYet then begin
            MessageDlg(LanguageSetup.SearchAddressResultMessageStart,mtInformation,[mbOK],0);
            Close; exit;
          end;
          If R=rsMultipleAddresses then begin
            If MessageDlg(LanguageSetup.SearchAddressResultMessageMultipleAddresses,mtInformation,[mbYes,mbNo],0)=mrYes then begin
              St:=AddressSearcher.GetList;
              try
                ShowInfoTextDialog(self,LanguageSetup.SearchAddressResultMessageMultipleAddressesSearchResults,St,False);
              finally
                St.Free;
              end;
            end;
            Close; exit;
          end;
          If R=rsNoAddress then begin
            MessageDlg(LanguageSetup.SearchAddressResultMessageNotFound,mtInformation,[mbOK],0);
            ExtDeleteFile(AddressSearcher.SearchDataFileName,ftTemp);
            Close; exit;
          end;
          InitPage(2);
        end;
    2 : begin
          If Trim(GameNameComboBox.Text)='' then begin
            MessageDlg(LanguageSetup.SearchAddressResultGameNameMessage,mtError,[mbOK],0);
            exit;
          end;
          If Trim(DescriptionEdit.Text)='' then begin
            MessageDlg(LanguageSetup.SearchAddressResultDescriptionMessage,mtError,[mbOK],0);
            exit;
          end;
          If Trim(NewValueEdit.Text)='' then begin
            MessageDlg(LanguageSetup.SearchAddressResultNewValueMessage,mtError,[mbOK],0);
            exit;
          end;
          If not ExtTryStrToInt(NewValueEdit.Text,I) then begin
            MessageDlg(LanguageSetup.SearchAddressResultNewValueMessageInvalid,mtError,[mbOK],0);
            exit;
          end;
          If Trim(FileMaskEdit.Text)='' then begin
            MessageDlg(LanguageSetup.SearchAddressResultFileMaskMessage,mtError,[mbOK],0);
            exit;
          end;
          If Trim(FileMaskEdit.Text)='*.*' then begin
            If MessageDlg(LanguageSetup.SearchAddressResultFileMaskMessageAllFiles,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
          end;

          If GameNameComboBox.ItemIndex<0 then begin
            GameRecord:=TCheatGameRecord.Create(nil);
            CheatDB.Add(GameRecord);
            GameRecord.Name:=GameNameComboBox.Text;
          end else begin
            GameRecord:=TCheatGameRecord(GameNameComboBox.Items.Objects[GameNameComboBox.ItemIndex]);
          end;

          CheatAction:=TCheatAction.Create(nil);
          GameRecord.Add(CheatAction);
          CheatAction.Name:=DescriptionEdit.Text;
          CheatAction.FileMask:=FileNameEdit.Text;

          If UseDialogCheckBox.Checked then begin
            CheatActionStep:=TCheatActionStepChangeAddressWithDialog.Create(nil);
            TCheatActionStepChangeAddressWithDialog(CheatActionStep).Addresses:=IntToStr(ResultAddress);
            TCheatActionStepChangeAddressWithDialog(CheatActionStep).Bytes:=ResultSize;
            TCheatActionStepChangeAddressWithDialog(CheatActionStep).DefaultValue:=Trim(NewValueEdit.Text);
            TCheatActionStepChangeAddressWithDialog(CheatActionStep).DialogPrompt:=UseDialogEdit.Text;
          end else begin
            CheatActionStep:=TCheatActionStepChangeAddress.Create(nil);
            TCheatActionStepChangeAddress(CheatActionStep).Addresses:=IntToStr(ResultAddress);
            TCheatActionStepChangeAddress(CheatActionStep).Bytes:=ResultSize;
            TCheatActionStepChangeAddress(CheatActionStep).NewValue:=Trim(NewValueEdit.Text);
          end;
          CheatAction.Add(CheatActionStep);

          SmartSaveCheatsDB(CheatDB,self);
          ExtDeleteFile(AddressSearcher.SearchDataFileName,ftTemp);

          MessageDlg(LanguageSetup.SearchAddressResultSuccess,mtInformation,[mbOK],0);
          Close;
        end;
  end;
end;

procedure TCheatSearchForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasSearchAddress);
end;

procedure TCheatSearchForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Procedure ShowCheatSearchDialog(const AOwner : TComponent);
begin
  CheatSearchForm:=TCheatSearchForm.Create(AOwner);
  try
    CheatSearchForm.ShowModal;
  finally
    CheatSearchForm.Free;
  end;
end;

end.
