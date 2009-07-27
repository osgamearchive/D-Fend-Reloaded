unit PackageCreationFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, ComCtrls, ImgList, ExtCtrls;

type
  TPackageCreationForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    ImageList: TImageList;
    TabSheet6: TTabSheet;
    OutputFileEdit: TLabeledEdit;
    OutputFileButton: TSpeedButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
    procedure OutputFileButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB, AutoSetupDB : TGameDB;
  end;

var
  PackageCreationForm: TPackageCreationForm;

Function ShowPackageCreationDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, CommonTools, LanguageSetupUnit, VistaToolsUnit, PackageDBLanguage,
     HelpConsts, PrgSetupUnit, PrgConsts, PackageBuilderUnit;

{$R *.dfm}

procedure TPackageCreationForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(OutputFileEdit);
  NoFlicker(OKButton);
  NoFlicker(CancelButton);
  NoFlicker(HelpButton);
  
  Caption:=LANG_PackageCreator;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  TabSheet1.Caption:=LANG_PageGames;
  TabSheet2.Caption:=LANG_PageAutoSetups;
  TabSheet3.Caption:=LANG_PageIcons;
  TabSheet5.Caption:=LANG_PageIconSets;
  TabSheet4.Caption:=LANG_PageLanguages;
  TabSheet5.Caption:=LANG_PageExePackages;

  OutputFileEdit.EditLabel.Caption:=LANG_PackageCreatorOutputFile;
  OutputFileButton.Hint:=LanguageSetup.ChooseFile;
end;

procedure TPackageCreationForm.OKButtonClick(Sender: TObject);
Var St : TStringList;
begin
  If Trim(OutputFileEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    ModalResult:=mrNone; exit;
  end;

   OpenDialog.Filter:='All files useable for packages (*.zip;*.prof;*.ini;*.ico;*.exe)|*.zip;*.prof;*.ini;*.ico;*.exe'+'|Game packages (*.zip)|*.zip|Auto setup templates (*.prof)|*.prof|Language files (*.ini)|*.ini|Exe game packages (*.exe)|*.exe|Icon files (*.ico)|*.ico|All files (*.*)|*.*';
   OpenDialog.Title:='Create package info file for';
   If not OpenDialog.Execute then exit;
   
   St:=GetPackageDataForFile(OpenDialog.FileName);
   If St=nil then exit;
   try
     try
       St.SaveToFile(SaveDialog.FileName);
     except
       MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
       ModalResult:=mrNone; exit;
     end;
   finally
     St.Free;
   end;
end;

procedure TPackageCreationForm.OutputFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(ExtractFilePath(OutputFileEdit.Text));
  If S='' then S:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);

  SaveDialog.Title:=LANG_PackageCreatorOutputTitle;
  SaveDialog.Filter:=LANG_PackageCreatorOutputFilter;
  If not SaveDialog.Execute then exit;

  OutputFileEdit.Text:=SaveDialog.FileName;
end;

procedure TPackageCreationForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FileExportPackageListCreator); 
end;

procedure TPackageCreationForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowPackageCreationDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
Var AutoSetupDB : TGameDB;
begin
  PackageCreationForm:=TPackageCreationForm.Create(AOwner);
  try
    AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
    try
      PackageCreationForm.GameDB:=AGameDB;
      PackageCreationForm.AutoSetupDB:=AutoSetupDB;
      result:=(PackageCreationForm.ShowModal=mrOK);
    finally
      AutoSetupDB.Free;
    end;
  finally
    PackageCreationForm.Free;
  end;
end;

end.
