unit DOSBoxLangStartFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TDOSBoxLangStartForm = class(TForm)
    NewFileRadioButton: TRadioButton;
    NewFileLabel: TLabel;
    NewFileComboBox: TComboBox;
    EditFileRadioButton: TRadioButton;
    EditFileComboBox: TComboBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    NewFileEdit: TLabeledEdit;
    HelpButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NewFileEditChange(Sender: TObject);
    procedure EditFileComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    Names, Files : TStringList;
  public
    { Public-Deklarationen }
    LoadFileName, SaveFileName : String;
  end;

var
  DOSBoxLangStartForm: TDOSBoxLangStartForm;

Function ShowDOSBoxLangStartDialog(const AOwner : TComponent; var LoadFileName, SaveFileName : String) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, IconLoaderUnit,
     PrgSetupUnit, DOSBoxLangTools, PrgConsts, HelpConsts;

{$R *.dfm}

procedure TDOSBoxLangStartForm.FormCreate(Sender: TObject);
begin
  LoadFileName:='';
  SaveFileName:='';
end;

procedure TDOSBoxLangStartForm.FormShow(Sender: TObject);
Var S : String;
    I,J : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.DOSBoxLangEditor;
  NewFileRadioButton.Caption:=LanguageSetup.DOSBoxLangEditorStartNew;
  NewFileEdit.EditLabel.Caption:=LanguageSetup.DOSBoxLangEditorStartNewName;
  NewFileLabel.Caption:=LanguageSetup.DOSBoxLangEditorStartNewTemplate;
  EditFileRadioButton.Caption:=LanguageSetup.DOSBoxLangEditorStartEdit;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);

  Names:=TStringList.Create;
  Files:=TStringList.Create;
  GetDOSBoxLangNamesAndFiles(PrgSetup.DOSBoxSettings[0].DOSBoxDir,Names,Files,False);

  NewFileComboBox.Items.AddStrings(Names);
  EditFileComboBox.Items.AddStrings(Names);

  If NewFileComboBox.Items.Count=0 then begin
    MessageDlg(LanguageSetup.DOSBoxLangEditorStartNoFiles,mtError,[mbOK],0);
    PostMessage(Handle,WM_CLOSE,0,0);
  end else begin
    S:=ExtUpperCase(ExtractFileName(PrgSetup.DOSBoxSettings[0].DosBoxLanguage));
    J:=0; for I:=0 to Names.Count-1 do if ExtUpperCase(ExtractFileName(Files[I]))=S then begin J:=I; break; end;
    NewFileComboBox.ItemIndex:=J;
    EditFileComboBox.ItemIndex:=J;
  end;
end;

procedure TDOSBoxLangStartForm.OKButtonClick(Sender: TObject);
Var S : String;
begin
  If NewFileRadioButton.Checked then begin
    LoadFileName:=Files[NewFileComboBox.ItemIndex];
    S:=RemoveIllegalFileNameChars(Trim(NewFileEdit.Text));
    If S='' then begin
      MessageDlg(LanguageSetup.DOSBoxLangEditorStartNoName,mtError,[mbOK],0);
      ModalResult:=mrNone;
      exit;
    end;
    SaveFileName:=PrgDataDir+LanguageSubDir+'\'+S+'.lng';
  end else begin
    LoadFileName:=Files[EditFileComboBox.ItemIndex];
    If (OperationMode=omUserDir) and (Copy(ExtUpperCase(LoadFileName),1,length(PrgDataDir))<>ExtUpperCase(PrgDataDir)) then begin
      SaveFileName:=PrgDataDir+LanguageSubDir+'\'+ExtractFileName(LoadFileName);
    end else begin
      SaveFileName:=LoadFileName;
    end;
  end;
end;

procedure TDOSBoxLangStartForm.FormDestroy(Sender: TObject);
begin
  Names.Free;
  Files.Free;
end;

procedure TDOSBoxLangStartForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasDOSBoxLanguageEditor);
end;

procedure TDOSBoxLangStartForm.NewFileEditChange(Sender: TObject);
begin
  NewFileRadioButton.Checked:=True;
end;

procedure TDOSBoxLangStartForm.EditFileComboBoxChange(Sender: TObject);
begin
  EditFileRadioButton.Checked:=True;
end;

procedure TDOSBoxLangStartForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowDOSBoxLangStartDialog(const AOwner : TComponent; var LoadFileName, SaveFileName : String) : Boolean;
Var DOSBoxLangStartForm : TDOSBoxLangStartForm;
begin
  DOSBoxLangStartForm:=TDOSBoxLangStartForm.Create(AOwner);
  try
    result:=(DOSBoxLangStartForm.ShowModal=mrOK);
    if result then begin
      LoadFileName:=DOSBoxLangStartForm.LoadFileName;
      SaveFileName:=DOSBoxLangStartForm.SaveFileName;
    end;
  finally
    DOSBoxLangStartForm.Free;
  end;
end;

end.
