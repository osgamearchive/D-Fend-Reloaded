unit BuildImageFromFolderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TBuildImageFromFolderForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    FolderEdit: TLabeledEdit;
    FileNameEdit: TLabeledEdit;
    FileNameButton: TSpeedButton;
    FolderButton: TSpeedButton;
    MakeBootableCheckBox: TCheckBox;
    MakeBootableWithKeyboardDriverCheckBox: TCheckBox;
    SaveDialog: TSaveDialog;
    WriteToFloppyCheckBox: TCheckBox;
    MakeBootableWithMouseDriverCheckBox: TCheckBox;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure MakeBootableCheckBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  BuildImageFromFolderForm: TBuildImageFromFolderForm;

Function ShowBuildImageFromFolderDialog(const AOwner : TComponent) : Boolean;

implementation

Uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     CreateISOImageFormUnit, GameDBUnit, DOSBoxUnit, PrgConsts, CreateImageUnit,
     HelpConsts;

{$R *.dfm}

procedure TBuildImageFromFolderForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  Caption:=LanguageSetup.ImageFromFolderCaption;
  FolderEdit.EditLabel.Caption:=LanguageSetup.ImageFromFolderSourceFolder;
  FolderButton.Hint:=LanguageSetup.ChooseFolder;
  FileNameEdit.EditLabel.Caption:=LanguageSetup.ImageFromFolderImageFile;
  FileNamebutton.Hint:=LanguageSetup.ChooseFile;
  MakeBootableCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootable;
  MakeBootableWithKeyboardDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithKeyboardDriver;
  MakeBootableWithMouseDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMouseDriver;
  WriteToFloppyCheckBox.Caption:=LanguageSetup.ImageFromFolderWriteToFloppy;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SaveDialog.Title:=LanguageSetup.ImageFromFolderSaveDialogTitle;
  SaveDialog.Filter:=LanguageSetup.ImageFromFolderSaveDialogFilter;
end;

procedure TBuildImageFromFolderForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=Trim(FolderEdit.Text);
          If S='' then S:=PrgSetup.BaseDir else S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
          If SelectDirectory(Handle,LanguageSetup.ExtractImageFolderTitle,S) then FolderEdit.Text:=S;
        end;
    1 : begin
          S:=Trim(FileNameEdit.Text);
          If S='' then S:=PrgSetup.BaseDir else S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
          SaveDialog.InitialDir:=S;
          If SaveDialog.Execute then FileNameEdit.Text:=SaveDialog.FileName;
        end;
  end;
end;

procedure TBuildImageFromFolderForm.MakeBootableCheckBoxClick(Sender: TObject);
begin
  MakeBootableWithKeyboardDriverCheckBox.Enabled:=MakeBootableCheckBox.Checked;
  MakeBootableWithMouseDriverCheckBox.Enabled:=MakeBootableCheckBox.Checked;
end;

procedure TBuildImageFromFolderForm.OKButtonClick(Sender: TObject);
Var FileName, Dir, FreeDOS : String;
begin
  FreeDOS:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOS<>'' then FreeDOS:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOS,PrgSetup.BaseDir));
  If (FreeDOS='') or (not DirectoryExists(FreeDOS)) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

  Dir:=Trim(FolderEdit.Text);
  If Dir='' then begin
    MessageDlg(LanguageSetup.MessageNoFolderName,mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;
  Dir:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(Dir),PrgSetup.BaseDir));
  If not DirectoryExists(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Dir]),mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;

  FileName:=Trim(FileNameEdit.Text);
  If FileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOk],0);
    ModalResult:=mrNone; exit;
  end;
  FileName:=MakeAbsPath(FileName,PrgSetup.BaseDir);

  If not BuildStandardFloppyImage(FileName) then begin
    ModalResult:=mrNone;
    exit;
  end;

  if not MakeFloppyBootable(FileName,MakeBootableCheckBox.Checked,MakeBootableWithKeyboardDriverCheckBox.Checked,MakeBootableWithMouseDriverCheckBox.Checked,Dir) then begin
    ModalResult:=mrNone;
    exit;
  end;
end;

procedure TBuildImageFromFolderForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateFromFolder);
end;

procedure TBuildImageFromFolderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowBuildImageFromFolderDialog(const AOwner : TComponent) : Boolean;
begin
  BuildImageFromFolderForm:=TBuildImageFromFolderForm.Create(AOwner);
  try
    result:=(BuildImageFromFolderForm.ShowModal=mrOK);
    if result and BuildImageFromFolderForm.WriteToFloppyCheckBox.Checked then begin
      result:=ShowWriteIMGImageDialog(AOwner,BuildImageFromFolderForm.FileNameEdit.Text);
    end;
  finally
    BuildImageFromFolderForm.Free;
  end;
end;

end.
