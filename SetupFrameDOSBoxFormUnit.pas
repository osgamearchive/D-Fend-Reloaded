unit SetupFrameDOSBoxFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, PrgSetupUnit, GameDBUnit;

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
    WarningButton: TSpeedButton;
    DOSBoxKeyboardLayoutLabel: TLabel;
    DOSBoxKeyboardLayoutComboBox: TComboBox;
    DOSBoxCodepageLabel: TLabel;
    DOSBoxCodepageComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure RestoreDefaultValuesButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WarningButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    GameDB : TGameDB;
  public
    { Public-Deklarationen }
    DOSBoxData : TDOSBoxData;
    IsDefault : Boolean;
  end;

var
  SetupFrameDOSBoxForm: TSetupFrameDOSBoxForm;

Function ShowSetupFrameDOSBoxDialog(const AOwner : TComponent; var DOSBoxData : TDOSBoxData; const IsDefault : Boolean; const GameDB : TGameDB) : Boolean;

implementation

uses ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, CommonTools,
     SetupDosBoxFormUnit, PrgConsts, IconLoaderUnit, DOSBoxLangTools;

{$R *.dfm}

procedure TSetupFrameDOSBoxForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  DosBoxLang:=TStringList.Create;

  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  WarningButton.Hint:=LanguageSetup.MsgDlgWarning;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  DOSBoxKeyboardLayoutLabel.Caption:=LanguageSetup.GameKeyboardLayout;
  DOSBoxCodepageLabel.Caption:=LanguageSetup.GameKeyboardCodepage;
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

  UserIconLoader.DialogImage(DI_SelectFolder,DosBoxButton);
  UserIconLoader.DialogImage(DI_FindFile,FindDosBoxButton);
  UserIconLoader.DialogImage(DI_SelectFile,DosBoxMapperButton);
  UserIconLoader.DialogImage(DI_ResetDefault,RestoreDefaultValuesButton);
end;

procedure TSetupFrameDOSBoxForm.FormShow(Sender: TObject);
Var St : TStringList;
    I : Integer;
    S,T : String;
begin
  St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try DOSBoxKeyboardLayoutComboBox.Items.AddStrings(St); finally St.Free; end;
  St:=ValueToList(GameDB.ConfOpt.Codepage,';,'); try DOSBoxCodepageComboBox.Items.AddStrings(St); finally St.Free; end;
  DOSBoxKeyboardLayoutComboBox.ItemIndex:=0;
  DOSBoxCodepageComboBox.ItemIndex:=0;

  If IsDefault then begin
    Caption:=Format(LanguageSetup.SetupFormDOSBoxInstallationMoreSettingsCaption,[LanguageSetup.Default]);
  end else begin
    Caption:=Format(LanguageSetup.SetupFormDOSBoxInstallationMoreSettingsCaption,[DOSBoxData.Name]);
  end;
  DosBoxDirEdit.Text:=DOSBoxData.DosBoxDir;
  DosBoxDirEditChange(Sender);
  DosBoxLangEditComboBox.ItemIndex:=Max(0,DosBoxLang.IndexOf(DOSBoxData.DosBoxLanguage));

  S:=Trim(ExtUpperCase(DOSBoxData.KeyboardLayout));
  For I:=0 to DOSBoxKeyboardLayoutComboBox.Items.Count-1 do begin
    T:=DOSBoxKeyboardLayoutComboBox.Items[I];
    If Trim(ExtUpperCase(T))=S then begin DOSBoxKeyboardLayoutComboBox.ItemIndex:=I; break; end;
    If Pos('(',T)<>0 then begin
      T:=Copy(T,Pos('(',T)+1,MaxInt);
      If Pos(')',T)<>0 then T:=Copy(T,1,Pos(')',T)-1);
      If Trim(ExtUpperCase(T))=S then begin DOSBoxKeyboardLayoutComboBox.ItemIndex:=I; break; end;
    end;
  end;

  S:=Trim(ExtUpperCase(DOSBoxData.Codepage));
  For I:=0 to DOSBoxCodepageComboBox.Items.Count-1 do begin
    T:=DOSBoxCodepageComboBox.Items[I];
    If Trim(ExtUpperCase(T))=S then begin DOSBoxCodepageComboBox.ItemIndex:=I; break; end;
    If Pos('(',T)<>0 then begin
      If Trim(Copy(T,1,Pos('(',T)-1))=S then begin DOSBoxCodepageComboBox.ItemIndex:=I; break; end;
    end;
  end;

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
  GetDOSBoxLangNamesAndFiles(DosBoxDirEdit.Text,DosBoxLangEditComboBox.Items,DosBoxLang,True);

  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;

  I:=DosBoxLang.IndexOf(PrgSetup.DOSBoxSettings[0].DosBoxLanguage);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;

  WarningButton.Visible:=OldDOSBoxVersion(CheckDOSBoxVersion(-1,DosBoxDirEdit.Text));
  DosBoxDirEdit.Width:=IfThen(WarningButton.Visible,WarningButton.Left-4,WarningButton.Left+WarningButton.Width)-DosBoxDirEdit.Left;
end;

procedure TSetupFrameDOSBoxForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=DosBoxDirEdit.Text;
          If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
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
            else DosBoxTxtOpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(DosBoxMapperEdit.Text,PrgSetup.BaseDir));
          if not DosBoxTxtOpenDialog.Execute then exit;
          DosBoxMapperEdit.Text:=MakeRelPath(DosBoxTxtOpenDialog.FileName,PrgSetup.BaseDir);
    end;
  end;
end;

procedure TSetupFrameDOSBoxForm.OKButtonClick(Sender: TObject);
begin
  DOSBoxData.DosBoxDir:=DosBoxDirEdit.Text;
  DOSBoxData.DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];
  DOSBoxData.KeyboardLayout:=DOSBoxKeyboardLayoutComboBox.Items[DOSBoxKeyboardLayoutComboBox.ItemIndex];
  DOSBoxData.Codepage:=DOSBoxCodepageComboBox.Items[DOSBoxCodepageComboBox.ItemIndex];
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
  DOSBoxKeyboardLayoutComboBox.ItemIndex:=0;
  DOSBoxCodepageComboBox.ItemIndex:=0;
  DosBoxMapperEdit.Text:='.\mapper.txt';
  CommandLineEdit.Text:='';
  HideDosBoxConsoleCheckBox.Checked:=True;
  CenterDOSBoxCheckBox.Checked:=False;
  DisableScreensaverCheckBox.Checked:=False;
  If IsWindowsVista then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
end;

procedure TSetupFrameDOSBoxForm.WarningButtonClick(Sender: TObject);
begin
  DOSBoxOutdatedWarning(DosBoxDirEdit.Text);
end;

{ global }

Function ShowSetupFrameDOSBoxDialog(const AOwner : TComponent; var DOSBoxData : TDOSBoxData; const IsDefault : Boolean; const GameDB : TGameDB) : Boolean;
begin
  SetupFrameDOSBoxForm:=TSetupFrameDOSBoxForm.Create(AOwner);
  try
    SetupFrameDOSBoxForm.DOSBoxData:=DOSBoxData;
    SetupFrameDOSBoxForm.IsDefault:=IsDefault;
    SetupFrameDOSBoxForm.GameDB:=GameDB;
    result:=(SetupFrameDOSBoxForm.ShowModal=mrOK);
    if result then DOSBoxData:=SetupFrameDOSBoxForm.DOSBoxData;
  finally
    SetupFrameDOSBoxForm.Free;
  end;
end;

end.
