unit LanguageEditorStartFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TLanguageEditorStartForm = class(TForm)
    EditThisRadioButton: TRadioButton;
    EditNewRadioButton: TRadioButton;
    LanguageNameEdit: TEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure LanguageNameEditChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  LanguageEditorStartForm: TLanguageEditorStartForm;

Function ShowLanguageEditorStartDialog(const AOwner : TComponent; var LanguageFile : String; const NewOnly : Boolean = False) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts, CommonTools,
     HelpConsts;

{$R *.dfm}

procedure TLanguageEditorStartForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  Caption:=LanguageSetup.LanguageEditorCaption;
  EditThisRadioButton.Caption:=LanguageSetup.LanguageEditorEditThisLanguage;
  EditNewRadioButton.Caption:=LanguageSetup.LanguageEditorEditNewLanguage;
end;

procedure TLanguageEditorStartForm.LanguageNameEditChange(Sender: TObject);
begin
  EditNewRadioButton.Checked:=True;
end;

procedure TLanguageEditorStartForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_HelpLanguageEditor);
end;

procedure TLanguageEditorStartForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowLanguageEditorStartDialog(const AOwner : TComponent; var LanguageFile : String; const NewOnly : Boolean) : Boolean;
begin
  LanguageFile:='';

  LanguageEditorStartForm:=TLanguageEditorStartForm.Create(AOwner);
  try
    If NewOnly then begin
      LanguageEditorStartForm.EditThisRadioButton.Enabled:=False;
      LanguageEditorStartForm.EditNewRadioButton.Checked:=True;
    end;
    result:=(LanguageEditorStartForm.ShowModal=mrOK);
    if result then begin
      If LanguageEditorStartForm.EditThisRadioButton.Checked then begin
        LanguageFile:=LanguageSetup.SetupFile;
      end else begin
        ForceDirectories(PrgDataDir+LanguageSubDir);
        LanguageFile:=PrgDataDir+LanguageSubDir+'\'+LanguageEditorStartForm.LanguageNameEdit.Text+'.ini';
      end;
      If (PrgDir<>PrgDataDir) and (ExtUpperCase(PrgDir)=ExtUpperCase(Copy(LanguageFile,1,length(PrgDir)))) then begin
        result:=(MessageDlg(LanguageSetup.LanguageEditorPrgDirWarning,mtWarning,[mbYes,mbNo],0)=mrYes);
      end;
    end;
  finally
    LanguageEditorStartForm.Free;
  end;
end;

end.
