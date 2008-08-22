unit SetupFrameDOSBoxFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, PrgSetupUnit;

type
  TSetupFrameDOSBoxForm = class(TForm)
    DosBoxMapperEdit: TLabeledEdit;
    DosBoxMapperButton: TSpeedButton;
    HideDosBoxConsoleCheckBox: TCheckBox;
    CenterDOSBoxCheckBox: TCheckBox;
    SDLVideoDriverComboBox: TComboBox;
    SDLVideodriverLabel: TLabel;
    SDLVideodriverInfoLabel: TLabel;
    DisableScreensaverCheckBox: TCheckBox;
    CommandLineEdit: TLabeledEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    RestoreDefaultValuesButton: TBitBtn;
    DosBoxTxtOpenDialog: TOpenDialog;
    DosBoxDirEdit: TLabeledEdit;
    DosBoxButton: TSpeedButton;
    FindDosBoxButton: TSpeedButton;
    DosBoxLangLabel: TLabel;
    DosBoxLangEditComboBox: TComboBox;
    WaitOnErrorCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure RestoreDefaultValuesButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
  public
    { Public-Deklarationen }
    DOSBoxData : TDOSBoxData;
    IsDefault : Boolean;
  end;

var
  SetupFrameDOSBoxForm: TSetupFrameDOSBoxForm;

Function ShowSetupFrameDOSBoxDialog(const AOwner : TComponent; var DOSBoxData : TDOSBoxData; const IsDefault : Boolean) : Boolean;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, SetupDosBoxFormUnit,
     PrgConsts;

{$R *.dfm}

procedure TSetupFrameDOSBoxForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  DosBoxLang:=TStringList.Create;

  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  DosBoxMapperEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxMapperFile;
  DosBoxMapperButton.Hint:=LanguageSetup.ChooseFile;
  CommandLineEdit.EditLabel.Caption:=LanguageSetup.SetupFormDOSBoxCommandLineParameters;
  HideDosBoxConsoleCheckBox.Caption:=LanguageSetup.SetupFormHideDosBoxConsole;
  CenterDOSBoxCheckBox.Caption:=LanguageSetup.SetupFormCenterDOSBoxWindow;
  DisableScreensaverCheckBox.Caption:=LanguageSetup.SetupFormDosBoxDisableScreensaver;
  WaitOnErrorCheckBox.Caption:=LanguageSetup.SetupFormDosBoxWaitOnError;
  SDLVideodriverLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriver;
  SDLVideodriverInfoLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriverInfo;
  SDLVideoDriverComboBox.Items[0]:=SDLVideoDriverComboBox.Items[0]+' ('+LanguageSetup.Default+')';

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  RestoreDefaultValuesButton.Caption:=LanguageSetup.SetupFormDefaultValueReset;
end;

procedure TSetupFrameDOSBoxForm.FormShow(Sender: TObject);
begin
  If IsDefault then begin
    Caption:=Format(LanguageSetup.SetupFormDOSBoxInstallationMoreSettingsCaption,[LanguageSetup.Default]);
  end else begin
    Caption:=Format(LanguageSetup.SetupFormDOSBoxInstallationMoreSettingsCaption,[DOSBoxData.Name]);
  end;
  DosBoxDirEdit.Text:=DOSBoxData.DosBoxDir;
  DosBoxDirEditChange(Sender);
  DosBoxLangEditComboBox.ItemIndex:=Max(0,DosBoxLang.IndexOf(DOSBoxData.DosBoxLanguage));
  DosBoxMapperEdit.Text:=DOSBoxData.DosBoxMapperFile;
  CommandLineEdit.Text:=DOSBoxData.CommandLineParameters;
  HideDosBoxConsoleCheckBox.Checked:=DOSBoxData.HideDosBoxConsole;
  CenterDOSBoxCheckBox.Checked:=DOSBoxData.CenterDOSBoxWindow;
  DisableScreensaverCheckBox.Checked:=DOSBoxData.DisableScreensaver;
  WaitOnErrorCheckBox.Checked:=DOSBoxData.WaitOnError;
  If Trim(ExtUpperCase(DOSBoxData.SDLVideodriver))='WINDIB' then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
end;

procedure TSetupFrameDOSBoxForm.FormDestroy(Sender: TObject);
begin
  DosBoxLang.Free;
end;

Procedure FindAndAddLngFiles(const Dir : String; const St, St2 : TStrings);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(Dir+'*.lng',faAnyFile,Rec);
  try
    while I=0 do begin
      St.Add(ChangeFileExt(Rec.Name,''));
      St2.Add(Dir+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TSetupFrameDOSBoxForm.DosBoxDirEditChange(Sender: TObject);
Var S : String;
    I : Integer;
begin
  S:=DosBoxLangEditComboBox.Text;
  DosBoxLangEditComboBox.Items.Clear;
  DosBoxLang.Clear;

  DosBoxLangEditComboBox.Items.Add('English');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDirEdit.Text),DosBoxLangEditComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DosBoxLangEditComboBox.Items,DosBoxLang);
  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;

  I:=DosBoxLang.IndexOf(PrgSetup.DOSBoxSettings[0].DosBoxLanguage);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

procedure TSetupFrameDOSBoxForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=DosBoxDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then begin
            DosBoxDirEdit.Text:=S;
          end;
        end;
    1 : if SearchDosBox(self,S) then begin
          DosBoxDirEdit.Text:=S;
        end;
    2 : begin
          DosBoxTxtOpenDialog.Title:=LanguageSetup.SetupFormDosBoxMapperFileTitle;
          DosBoxTxtOpenDialog.Filter:=LanguageSetup.SetupFormDosBoxMapperFileFilter;
          If Trim(DosBoxMapperEdit.Text)=''
            then DosBoxTxtOpenDialog.InitialDir:=PrgDataDir
            else DosBoxTxtOpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(DosBoxMapperEdit.Text,PrgDataDir));
          if not DosBoxTxtOpenDialog.Execute then exit;
          DosBoxMapperEdit.Text:=MakeRelPath(DosBoxTxtOpenDialog.FileName,PrgDataDir);
    end;
  end;
end;

procedure TSetupFrameDOSBoxForm.OKButtonClick(Sender: TObject);
begin
  DOSBoxData.DosBoxDir:=DosBoxDirEdit.Text;
  DOSBoxData.DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];
  DOSBoxData.DosBoxMapperFile:=DosBoxMapperEdit.Text;
  DOSBoxData.CommandLineParameters:=CommandLineEdit.Text;
  DOSBoxData.HideDosBoxConsole:=HideDosBoxConsoleCheckBox.Checked;
  DOSBoxData.CenterDOSBoxWindow:=CenterDOSBoxCheckBox.Checked;
  DOSBoxData.DisableScreensaver:=DisableScreensaverCheckBox.Checked;
  DOSBoxData.WaitOnError:=WaitOnErrorCheckBox.Checked;
  If SDLVideoDriverComboBox.ItemIndex=1 then DOSBoxData.SDLVideodriver:='WinDIB' else DOSBoxData.SDLVideodriver:='DirectX';
end;

procedure TSetupFrameDOSBoxForm.RestoreDefaultValuesButtonClick(Sender: TObject);
begin
  DosBoxMapperEdit.Text:='.\mapper.txt';
  CommandLineEdit.Text:='';
  HideDosBoxConsoleCheckBox.Checked:=True;
  CenterDOSBoxCheckBox.Checked:=False;
  DisableScreensaverCheckBox.Checked:=False;
  If IsWindowsVista then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
end;

{ global }

Function ShowSetupFrameDOSBoxDialog(const AOwner : TComponent; var DOSBoxData : TDOSBoxData; const IsDefault : Boolean) : Boolean;
begin
  SetupFrameDOSBoxForm:=TSetupFrameDOSBoxForm.Create(AOwner);
  try
    SetupFrameDOSBoxForm.DOSBoxData:=DOSBoxData;
    SetupFrameDOSBoxForm.IsDefault:=IsDefault;
    result:=(SetupFrameDOSBoxForm.ShowModal=mrOK);
    if result then DOSBoxData:=SetupFrameDOSBoxForm.DOSBoxData;
  finally
    SetupFrameDOSBoxForm.Free;
  end;
end;

end.
