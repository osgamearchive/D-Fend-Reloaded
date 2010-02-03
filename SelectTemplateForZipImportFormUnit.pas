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
    WarningLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TypeSelectClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TemplateComboBoxChange(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
    procedure FolderEditChange(Sender: TObject);
    procedure ProfileNameEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
    Procedure InitialFolderCheck;
    Procedure SelectFilesFromAutoSetupTemplate;
  public
    { Public-Deklarationen }
    ProfileNameChanged : Boolean;
    ArchivFileName : String;
    AutoSetupDB, TemplateDB : TGameDB;
    PrgFiles, Templates : TStringList;
    FileToStart, SetupFileToStart, ProfileName, ProfileFolder : String;
    TemplateNr : Integer;
    Procedure Prepare(const DoNotCopyFolder : Boolean);
  end;

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean) : Boolean;

var
  SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm;

implementation

uses Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, IconLoaderUnit,
     HelpConsts, PrgSetupUnit;

{$R *.dfm}

procedure TSelectTemplateForZipImportForm.FormCreate(Sender: TObject);
Var S : String;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  WarningLabel.Font.Color:=clRed;

  S:=LanguageSetup.MenuFileImportZIPCaption; While (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1); Caption:=S;
  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.AutoDetectProfileEditProfileName;
  FolderEdit.EditLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolder;
  WarningLabel.Caption:=LanguageSetup.MenuFileImportZIPDestinationFolderWarning;
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
  ProfileNameChanged:=False;
end;

Function AvoidSomeNames(const St : TStringList; const SetupNumber : Integer) : String;
const Avoid : Array[1..14] of String = ('README','DECIDE','CATALOG','LIST','LHARC','ARJ','UNARJ','UNZIP','HELPME','ORDER','DEALERS','ULTRAMID','PRINTME','UNIVBE');
var I,J : Integer;
    OK : Boolean;
    S : String;
begin
  For I:=0 to St.Count-1 do if I<>SetupNumber then begin
    OK:=True; S:=ExtUpperCase(ChangeFileExt(St[I],''));
    For J:=Low(Avoid) to High(Avoid) do if S=Avoid[J] then begin OK:=False; break; end;
    If OK then begin result:=St[I]; exit; end;
  end;

  For I:=0 to St.Count-1 do if I<>SetupNumber then begin result:=St[I]; exit; end;

  If St.Count>0 then result:=St[0] else result:='';
end;

Procedure TSelectTemplateForZipImportForm.Prepare(const DoNotCopyFolder : Boolean);
Var I,Nr : Integer;
    S : String;
begin
  JustChanging:=True;
  try
    If DoNotCopyFolder then begin
      FolderEdit.Visible:=False;
      ClientHeight:=ClientHeight-40;
    end;

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

      SelectFilesFromAutoSetupTemplate;
      I:=ProgramFileComboBox.Items.IndexOf(FileToStart); If I>=0 then ProgramFileComboBox.ItemIndex:=I;
      I:=SetupFileComboBox.Items.IndexOf(SetupFileToStart); If I>=0 then SetupFileComboBox.ItemIndex:=I;
    end else begin
      TemplateType1RadioButton.Enabled:=False;
      TemplateType3RadioButton.Checked:=True;
      If Trim(ArchivFileName)<>'' then ProfileNameEdit.Text:=ChangeFileExt(ExtractFileName(ArchivFileName),'');

      If PrgFiles.Count>0 then begin
        If PrgFiles.Count=1 then begin
          FileToStart:=PrgFiles[0];
          SetupFileToStart:='';
        end else begin
          Nr:=-1;
          For I:=0 to PrgFiles.Count-1 do begin
            S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
            If (S='SETUP') or (S='CONFIG') or (S='SETSOUND') or (S='SETSND') or (S='SETBLAST') or (S='XINSTALL') then begin Nr:=I; break; end;
          end;
          If Nr<0 then begin
            For I:=0 to PrgFiles.Count-1 do begin
              S:=ExtUpperCase(ChangeFileExt(PrgFiles[I],''));
              If (S='INSTALL') then begin Nr:=I; break; end;
            end;
          end;
          If Nr<0 then begin
            FileToStart:=AvoidSomeNames(PrgFiles,-1);
            SetupFileToStart:='';
          end else begin
            FileToStart:=AvoidSomeNames(PrgFiles,Nr);
            SetupFileToStart:=PrgFiles[Nr];
          end;

          I:=ProgramFileComboBox.Items.IndexOf(FileToStart);
          If I>=0 then ProgramFileComboBox.ItemIndex:=I;
          I:=SetupFileComboBox.Items.IndexOf(SetupFileToStart);
          If I>=0 then SetupFileComboBox.ItemIndex:=I;
        end;
      end;
      TemplateNr:=-1;
    end;
    InitialFolderCheck;
    FolderEdit.Text:=ProfileFolder;
  finally
    JustChanging:=False;
  end;

  FolderEditChange(self);
  TypeSelectClick(self);
  ProfileNameChanged:=False;
end;

procedure TSelectTemplateForZipImportForm.ProfileNameEditChange(Sender: TObject);
begin
  ProfileNameChanged:=True;
end;

procedure TSelectTemplateForZipImportForm.SelectFilesFromAutoSetupTemplate;
Var I : Integer;
    S : String;
    St : TStringList;
begin
  FileToStart:=Templates[0];
  SetupFileToStart:='';
  S:=AutoSetupDB[Integer(Templates.Objects[0])].SetupExe;
  If Trim(S)<>'' then begin
    S:=ExtUpperCase(S);
    For I:=0 to PrgFiles.Count-1 do If ExtUpperCase(PrgFiles[I])=S then begin SetupFileToStart:=PrgFiles[I]; exit; end;
  end;

  St:=TStringList.Create;
  try
    St.AddStrings(PrgFiles);
    S:=ExtUpperCase(FileToStart);
    For I:=0 to St.Count-1 do If ExtUpperCase(St[I])=S then begin St.Delete(I); exit; end;
    If St.Count>0 then SetupFileToStart:=St[0];
  finally
    St.Free;
  end;
end;

procedure TSelectTemplateForZipImportForm.InitialFolderCheck;
Var GamesDir : String;
    I : Integer;
begin
  ProfileFolder:=MakeFileSysOKFolderName(ProfileNameEdit.Text);
  GamesDir:=MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir);

  If (not DirectoryExists(GamesDir+ProfileFolder)) or PrgSetup.IgnoreDirectoryCollisions then exit;
  I:=0; repeat inc(I); until not DirectoryExists(GamesDir+ProfileFolder+IntToStr(I));
  ProfileFolder:=ProfileFolder+IntToStr(I);
end;

procedure TSelectTemplateForZipImportForm.FolderEditChange(Sender: TObject);
Var B : Boolean;
begin
  If JustChanging then exit;
  B:=DirectoryExists(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)+MakeFileSysOKFolderName(FolderEdit.Text));
  OKButton.Enabled:=not (FolderEdit.Visible and B);
  WarningLabel.Visible:=FolderEdit.Visible and B;
end;

procedure TSelectTemplateForZipImportForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
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
        For I:=0 to AutoSetupDB.Count-1 do If TemplateComboBox.Items.IndexOf(AutoSetupDB[I].CacheName)<0 then
          TemplateComboBox.Items.AddObject(AutoSetupDB[I].CacheName,Pointer(I));
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

  If (not TemplateType3RadioButton.Checked) and (not ProfileNameChanged) then begin
    ProfileNameEdit.Text:=TemplateComboBox.Text;
    ProfileNameChanged:=False;
  end;
end;

procedure TSelectTemplateForZipImportForm.OKButtonClick(Sender: TObject);
begin
  ProfileName:=ProfileNameEdit.Text;
  ProfileFolder:=FolderEdit.Text;
  If TemplateType1RadioButton.Checked then begin
    SelectFilesFromAutoSetupTemplate;
  end else begin
    FileToStart:=ProgramFileComboBox.Text;
    SetupFileToStart:=SetupFileComboBox.Text;
  end;

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

Function ShowSelectTemplateForZipImportDialog(const AOwner : TComponent; const AAutoSetupDB, ATemplateDB : TGameDB; const APrgFiles, ATemplates : TStringList; const AArchivFileName : String; var AProfileName, AFileToStart, ASetupFileToStart, AFolder : String; var ATemplateNr : Integer; const NoDialogIfAutoSetupIsAvailable, DoNotCopyFolder : Boolean) : Boolean;
begin
  SelectTemplateForZipImportForm:=TSelectTemplateForZipImportForm.Create(AOwner);
  try
    SelectTemplateForZipImportForm.ArchivFileName:=AArchivFileName;
    SelectTemplateForZipImportForm.AutoSetupDB:=AAutoSetupDB;
    SelectTemplateForZipImportForm.TemplateDB:=ATemplateDB;
    SelectTemplateForZipImportForm.PrgFiles:=APrgFiles;
    SelectTemplateForZipImportForm.Templates:=ATemplates;
    SelectTemplateForZipImportForm.Prepare(DoNotCopyFolder);
    If SelectTemplateForZipImportForm.TemplateType1RadioButton.Checked and (NoDialogIfAutoSetupIsAvailable or PrgSetup.ImportZipWithoutDialogIfPossible) then begin
      result:=True;
      SelectTemplateForZipImportForm.OKButtonClick(SelectTemplateForZipImportForm);
    end else begin
      result:=(SelectTemplateForZipImportForm.ShowModal=mrOK);
    end;
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
