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
    procedure FormCreate(Sender: TObject);
    procedure LanguageNameEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  LanguageEditorStartForm: TLanguageEditorStartForm;

Function ShowLanguageEditorStartDialog(const AOwner : TComponent; var LanguageFile : String) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts, CommonTools;

{$R *.dfm}

procedure TLanguageEditorStartForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;

  Caption:=LanguageSetup.LanguageEditorCaption;
  EditThisRadioButton.Caption:=LanguageSetup.LanguageEditorEditThisLanguage;
  EditNewRadioButton.Caption:=LanguageSetup.LanguageEditorEditNewLanguage;
end;

procedure TLanguageEditorStartForm.LanguageNameEditChange(Sender: TObject);
begin
  EditNewRadioButton.Checked:=True;
end;

{ global }

Function ShowLanguageEditorStartDialog(const AOwner : TComponent; var LanguageFile : String) : Boolean;
begin
  LanguageFile:='';

  LanguageEditorStartForm:=TLanguageEditorStartForm.Create(AOwner);
  try
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
