unit SelectTemplateForZipImportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ExtCtrls;

type
  TSelectTemplateForZipImportForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    TemplateType1RadioButton: TRadioButton;
    TemplateType2RadioButton: TRadioButton;
    TemplateType3RadioButton: TRadioButton;
    ProfileNameEdit: TLabeledEdit;
    TemplateComboBox: TComboBox;
    TemplateLabel: TLabel;
    ProgramFileLabel: TLabel;
    ProgramFileComboBox: TComboBox;
    FolderEdit: TLabeledEdit;
    SetupFileComboBox: TComboBox;
    SetupFileLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TypeSelectClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TemplateComboBoxChange(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
  public
    { Public-Deklarationen }
    ArchivFileName : String;
    AutoSetupDB, TemplateDB : TGameDB;
    PrgFiles, Templates : TStringList;
    FileToStart, SetupFileToStart, ProfileName, ProfileFolder : String;
    TemplateNr : Integer;
  end;

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer) : Boolean;

var
  SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm;

implementation

uses Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, IconLoaderUnit,
     HelpConsts;

{$R *.dfm}

procedure TSelectTemplateForZipImportForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TSelectTemplateForZipImportForm.FormCreate(Sender: TObject);
Var S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  S:=LanguageSetup.MenuFileImportZIPCaption; While (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1); Caption:=S;
  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.AutoDetectProfileEditProfileName;
  FolderEdit.EditLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolder;
  TemplateType1RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup2;
  TemplateType2RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeAutoSetup1;
  TemplateType3RadioButton.Caption:=LanguageSetup.AutoDetectProfileEditTemplateTypeUser;
  TemplateLabel.Caption:=LanguageSetup.AutoDetectProfileEditTemplate;
  ProgramFileLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  SetupFileLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  JustChanging:=False;
end;

procedure TSelectTemplateForZipImportForm.FormShow(Sender: TObject);
begin
  JustChanging:=True;
  try
    ProgramFileComboBox.Items.AddStrings(PrgFiles);
    If ProgramFileComboBox.Items.Count>0 then ProgramFileComboBox.ItemIndex:=0;

    SetupFileComboBox.Items.Add('');
    SetupFileComboBox.Items.AddStrings(PrgFiles);
    SetupFileComboBox.ItemIndex:=0;

    If Templates.Count>0 then begin
      TemplateType1RadioButton.Checked:=True;
      ProfileNameEdit.Text:=AutoSetupDB[Integer(Templates.Objects[0])].Name;
      FileToStart:=Templates[0];
      TemplateNr:=0;
    end else begin
      TemplateType1RadioButton.Enabled:=False;
      TemplateType3RadioButton.Checked:=True;
      ProfileNameEdit.Text:=ChangeFileExt(ExtractFileName(ArchivFileName),'');
      If PrgFiles.Count>0 then FileToStart:=PrgFiles[0];
      TemplateNr:=-1;
    end;
    FolderEdit.Text:=MakeFileSysOKFolderName(ProfileNameEdit.Text);
  finally
    JustChanging:=False;
  end;

  TypeSelectClick(Sender);
end;

procedure TSelectTemplateForZipImportForm.TypeSelectClick(Sender: TObject);
Var I,J,K : Integer;
begin
  If JustChanging then exit;

  JustChanging:=True;
  try

    If TemplateType1RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        J:=0;
        For I:=0 to Templates.Count-1 do begin
          K:=Integer(Templates.Objects[I]);
          TemplateComboBox.Items.AddObject(AutoSetupDB[K].CacheName,Pointer(K));
          If K=TemplateNr then J:=I;
        end;
        TemplateComboBox.ItemIndex:=J;
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=(TemplateComboBox.Items.Count>1);
      ProgramFileComboBox.Visible:=False;
      SetupFileComboBox.Visible:=False;
    end;

    If TemplateType2RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        For I:=0 to AutoSetupDB.Count-1 do TemplateComboBox.Items.AddObject(AutoSetupDB[I].CacheName,Pointer(I));
        If TemplateNr<0 then begin
          If Templates.Count>0 then TemplateNr:=Integer(Templates.Objects[0]) else TemplateNr:=0;
        end;
        TemplateComboBox.ItemIndex:=Min(TemplateComboBox.Items.Count-1,Max(0,TemplateNr));
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=True;
      ProgramFileComboBox.Visible:=(ProgramFileComboBox.Items.Count>1);
      SetupFileComboBox.Visible:=(SetupFileComboBox.Items.Count>2);
    end;

    If TemplateType3RadioButton.Checked then begin
      TemplateComboBox.Items.BeginUpdate;
      try
        TemplateComboBox.Items.Clear;
        TemplateComboBox.Items.Add(LanguageSetup.TemplateFormDefault);
        For I:=0 to TemplateDB.Count-1 do TemplateComboBox.Items.Add(TemplateDB[I].CacheName);
        TemplateComboBox.ItemIndex:=Min(TemplateComboBox.Items.Count-1,Max(0,-TemplateNr-1));
      finally
        TemplateComboBox.Items.EndUpdate;
      end;
      TemplateComboBox.Visible:=True;
      ProgramFileComboBox.Visible:=(ProgramFileComboBox.Items.Count>1);
      SetupFileComboBox.Visible:=(SetupFileComboBox.Items.Count>2);
    end;

  finally
    JustChanging:=False;
  end;

  TemplateLabel.Visible:=TemplateComboBox.Visible;
  ProgramFileLabel.Visible:=ProgramFileComboBox.Visible;
  SetupFileLabel.Visible:=SetupFileComboBox.Visible;

  TemplateComboBoxChange(Sender);
end;

procedure TSelectTemplateForZipImportForm.TemplateComboBoxChange(Sender: TObject);
begin
  If JustChanging then exit;

  If TemplateType3RadioButton.Checked then begin
    TemplateNr:=-TemplateComboBox.ItemIndex-1;
  end else begin
    TemplateNr:=Integer(TemplateComboBox.Items.Objects[TemplateComboBox.ItemIndex]);
  end;
end;

procedure TSelectTemplateForZipImportForm.OKButtonClick(Sender: TObject);
begin
  ProfileName:=ProfileNameEdit.Text;
  ProfileFolder:=FolderEdit.Text;
  FileToStart:=ProgramFileComboBox.Text;
  SetupFileToStart:=SetupFileComboBox.Text;

  If TemplateType3RadioButton.Checked then begin
    TemplateNr:=-TemplateComboBox.ItemIndex-1;
  end else begin
    TemplateNr:=Integer(TemplateComboBox.Items.Objects[TemplateComboBox.ItemIndex]);
  end;
end;

procedure TSelectTemplateForZipImportForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileImportZip);
end;

procedure TSelectTemplateForZipImportForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer) : Boolean;
begin
  SelectTemplateForZipImportForm:=TSelectTemplateForZipImportForm.Create(AOwner);
  try
    SelectTemplateForZipImportForm.ArchivFileName:=AArchivFileName;
    SelectTemplateForZipImportForm.AutoSetupDB:=AAutoSetupDB;
    SelectTemplateForZipImportForm.TemplateDB:=ATemplateDB;
    SelectTemplateForZipImportForm.PrgFiles:=APrgFiles;
    SelectTemplateForZipImportForm.Templates:=ATemplates;
    result:=(SelectTemplateForZipImportForm.ShowModal=mrOK);
    if result then begin
      AFileToStart:=SelectTemplateForZipImportForm.FileToStart;
      ASetupFileToStart:=SelectTemplateForZipImportForm.SetupFileToStart;
      ATemplateNr:=SelectTemplateForZipImportForm.TemplateNr;
      AProfileName:=SelectTemplateForZipImportForm.ProfileName;
      AFolder:=SelectTemplateForZipImportForm.ProfileFolder;
    end;
  finally
    SelectTemplateForZipImportForm.Free;
  end;
end;

end.
