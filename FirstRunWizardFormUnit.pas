unit FirstRunWizardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFirstRunWizardForm = class(TForm)
    Notebook: TNotebook;
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    LanguageInfoLabel: TLabel;
    BackButton: TBitBtn;
    NextButton: TBitBtn;
    OKButton: TBitBtn;
    DosBoxButton: TSpeedButton;
    DosBoxDirEdit: TLabeledEdit;
    LanguageTopInfoLabel: TLabel;
    DOSBoxTopInfoLabel: TLabel;
    DosBoxLangLabel: TLabel;
    DosBoxLangEditComboBox: TComboBox;
    DOSBoxLanguageTopInfoLabel: TLabel;
    Update0RadioButton: TRadioButton;
    Update1RadioButton: TRadioButton;
    Update2RadioButton: TRadioButton;
    Update3RadioButton: TRadioButton;
    UpdateCheckBox: TCheckBox;
    UpdateLabel: TLabel;
    UpdateTopInfoLabel: TLabel;
    DOSBoxLanguageInfoLabel2: TLabel;
    DOSBoxInfoLabel: TLabel;
    GameDirTopInfoLabel: TLabel;
    GameDirEdit: TLabeledEdit;
    GameDirButton: TSpeedButton;
    GameDirInfoLabel: TLabel;
    AcceptAllSettingsButton: TBitBtn;
    HelpButton: TBitBtn;
    UpdateNowCheckBox: TCheckBox;
    WarningButton: TSpeedButton;
    StartLabel: TLabel;
    StartLabelLanguage: TLabel;
    StartLabelLanguageValue: TLabel;
    StartLabelDOSBox: TLabel;
    StartLabelDOSBoxValue: TLabel;
    StartLabelDOSBoxLanguage: TLabel;
    StartLabelDOSBoxLanguageValue: TLabel;
    StartLabelGamesFolder: TLabel;
    StartLabelGamesFolderValue: TLabel;
    StartLabelUpdates: TLabel;
    StartLabelUpdatesValue: TLabel;
    EditSettingsButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure DosBoxButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GameDirButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure WarningButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    Procedure InitGUI;
    Procedure LoadAndSetupLanguageList;
    Procedure LoadAndSetupDOSBoxLanguages;
    Procedure UpdateStartPage;
    Procedure SetupButttons;
  public
    { Public-Deklarationen }
  end;

var
  FirstRunWizardForm: TFirstRunWizardForm;

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;

implementation

uses Math, IniFiles, Registry, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit,
     CommonTools, PrgConsts, HelpConsts, IconLoaderUnit, MainUnit;

{$R *.dfm}

procedure TFirstRunWizardForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  StartLabel.Font.Style:=[fsBold];
  LanguageTopInfoLabel.Font.Style:=[fsBold];
  DOSBoxTopInfoLabel.Font.Style:=[fsBold];
  DOSBoxLanguageTopInfoLabel.Font.Style:=[fsBold];
  GameDirTopInfoLabel.Font.Style:=[fsBold];
  UpdateTopInfoLabel.Font.Style:=[fsBold];

  StartLabelLanguage.Font.Style:=[fsUnderline];
  StartLabelDOSBox.Font.Style:=[fsUnderline];
  StartLabelDOSBoxLanguage.Font.Style:=[fsUnderline];
  StartLabelGamesFolder.Font.Style:=[fsUnderline];
  StartLabelUpdates.Font.Style:=[fsUnderline];

  UserIconLoader.LoadIcons;
  UserIconLoader.DialogImage(DI_Previous,BackButton);
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Edit,EditSettingsButton);
  UserIconLoader.DialogImage(DI_All,AcceptAllSettingsButton);

  DosBoxLang:=TStringList.Create;
  InitGUI;
  Notebook.PageIndex:=0;
end;

procedure TFirstRunWizardForm.InitGUI;
begin
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  StartLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  LanguageTopInfoLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  DOSBoxTopInfoLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  DOSBoxLanguageTopInfoLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  GameDirTopInfoLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  UpdateTopInfoLabel.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  StartLabelLanguage.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  StartLabelDOSBox.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  StartLabelDOSBoxLanguage.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  StartLabelGamesFolder.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  StartLabelUpdates.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.FirstRunWizard;

  BackButton.Caption:=LanguageSetup.WizardFormButtonPrevious;
  NextButton.Caption:=LanguageSetup.WizardFormButtonNext;
  OKButton.Caption:=LanguageSetup.OK;
  HelpButton.Caption:=LanguageSetup.Help;
  EditSettingsButton.Caption:=LanguageSetup.FirstRunWizardEditSettings;
  AcceptAllSettingsButton.Caption:=LanguageSetup.FirstRunWizardAcceptAllSettings;

  LanguageTopInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoLanguage;
  LanguageLabel.Caption:=LanguageSetup.SetupFormLanguage;

  StartLabel.Caption:=LanguageSetup.FirstRunWizardInfoOverview;
  StartLabelLanguage.Caption:=LanguageSetup.SetupFormLanguage;
  StartLabelDOSBox.Caption:=LanguageSetup.SetupFormDosBoxDir;
  StartLabelDOSBoxLanguage.Caption:=LanguageSetup.SetupFormDosBoxLang;
  StartLabelGamesFolder.Caption:=LanguageSetup.SetupFormGameDir;
  StartLabelUpdates.Caption:=LanguageSetup.FirstRunWizardInfoUpdateShort;

  DOSBoxTopInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoDOSBox;
  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  WarningButton.Hint:=LanguageSetup.MsgDlgWarning;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  DOSBoxInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoDOSBox2;
  If OperationMode=omPortable then begin
    DOSBoxInfoLabel.Caption:=DOSBoxInfoLabel.Caption+#13+#13+LanguageSetup.FirstRunWizardInfoDOSBox3;
  end;

  DOSBoxLanguageTopInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoDOSBoxLanguage;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  DOSBoxLanguageInfoLabel2.Caption:=LanguageSetup.FirstRunWizardInfoDOSBoxLanguage2;

  GameDirTopInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoGameDir;
  GameDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormGameDir;
  GameDirButton.Hint:=LanguageSetup.ChooseFolder;
  GameDirInfoLabel.Caption:=Format(LanguageSetup.FirstRunWizardInfoGameDir2,[PrgSetup.BaseDir]);

  UpdateTopInfoLabel.Caption:=LanguageSetup.FirstRunWizardInfoUpdate;
  Update0RadioButton.Caption:=LanguageSetup.SetupFormUpdate0;
  Update1RadioButton.Caption:=LanguageSetup.SetupFormUpdate1;
  Update2RadioButton.Caption:=LanguageSetup.SetupFormUpdate2;
  Update3RadioButton.Caption:=LanguageSetup.SetupFormUpdate3;
  UpdateCheckBox.Caption:=LanguageSetup.SetupFormUpdateVersionSpecific;
  UpdateLabel.Caption:=LanguageSetup.SetupFormUpdateInfo;
  UpdateNowCheckBox.Caption:=LanguageSetup.FirstRunWizardUpdateNow;
end;

procedure TFirstRunWizardForm.FormShow(Sender: TObject);
begin
  LoadAndSetupLanguageList;
  DosBoxDirEdit.Text:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  DosBoxDirEditChange(Sender);
  case PrgSetup.CheckForUpdates of
    0 : Update0RadioButton.Checked:=True;
    1 : Update1RadioButton.Checked:=True;
    2 : Update2RadioButton.Checked:=True;
    3 : Update3RadioButton.Checked:=True;
  end;
  GameDirEdit.Text:=PrgSetup.GameDir;
  UpdateCheckBox.Checked:=PrgSetup.VersionSpecificUpdateCheck;
  UpdateStartPage;
  SetupButttons;
end;

procedure TFirstRunWizardForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Notebook.PageIndex<2 then LoadAndSetupDOSBoxLanguages;

  PrgSetup.Language:=ShortLanguageName(LanguageComboBox.Text)+'.ini';
  PrgSetup.DOSBoxSettings[0].DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
  PrgSetup.DOSBoxSettings[0].DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];
  PrgSetup.GameDir:=GameDirEdit.Text;
  If Update0RadioButton.Checked then PrgSetup.CheckForUpdates:=0;
  If Update1RadioButton.Checked then PrgSetup.CheckForUpdates:=1;
  If Update2RadioButton.Checked then PrgSetup.CheckForUpdates:=2;
  If Update3RadioButton.Checked then PrgSetup.CheckForUpdates:=3;
  PrgSetup.VersionSpecificUpdateCheck:=UpdateCheckBox.Checked;

  PrgSetup.ValueForNotSet:=LanguageSetup.NotSetLanguageDefault;
end;

Function VersionStringToInt(S : String) : Integer;
Var I : Integer;
    T : String;
begin
  result:=0;
  S:=Trim(S);

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256*256; except end;

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256; except end;

  try result:=result+StrToInt(S); except end;
end;

procedure TFirstRunWizardForm.FormDestroy(Sender: TObject);
begin
  DosBoxLang.Free;
end;

procedure TFirstRunWizardForm.LanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  LoadLanguage(ShortLanguageName(LanguageComboBox.Text)+'.ini');
  DFendReloadedMainForm.SelectHelpFile;
  InitGUI;

  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    LanguageInfoLabel.Visible:=True;
    LanguageInfoLabel.Caption:=LanguageSetup.LanguageNoVersion;
  end else begin
    If VersionStringToInt(S)<VersionStringToInt(GetNormalFileVersionAsString) then begin
      LanguageInfoLabel.Visible:=True;
      LanguageInfoLabel.Caption:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end else begin
      LanguageInfoLabel.Visible:=False;
    end;
  end;
end;

procedure TFirstRunWizardForm.LoadAndSetupLanguageList;
Var I,J : Integer;
    St : TStringList;
    Reg : TRegistry;
begin
  {Load language list}
  LanguageComboBox.OnChange:=nil;
  St:=GetLanguageList;
  try
    LanguageComboBox.Items.AddStrings(St);
  finally
    St.Free;
  end;

  {Read installer language}
  J:=1033;
  Reg:=TRegistry.Create;
  try
    Reg.Access:=KEY_READ;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    If Reg.OpenKey('\Software\D-Fend Reloaded',False) and Reg.ValueExists('Installer Language') then begin
      try J:=StrToInt(Reg.ReadString('Installer Language')); except end;
    end;
  finally
    Reg.Free;
  end;

  {Set program language to installer language}
  LanguageComboBox.ItemIndex:=0;
  For I:=0 to LanguageComboBox.Items.Count-1 do If Integer(LanguageComboBox.Items.Objects[I])=J then begin
    LanguageComboBox.ItemIndex:=I; break;
  end;

  LanguageComboBox.OnChange:=LanguageComboBoxChange;
  LanguageComboBoxChange(self);
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

procedure TFirstRunWizardForm.LoadAndSetupDOSBoxLanguages;
Var I : Integer;
    S,Save : String;
begin
  Save:=DosBoxLangEditComboBox.Text;

  DosBoxLang.Clear;
  DosBoxLangEditComboBox.Items.Clear;

  DosBoxLangEditComboBox.Items.Add('English');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDirEdit.Text),DosBoxLangEditComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DosBoxLangEditComboBox.Items,DosBoxLang);

  If Save<>'' then begin
    I:=DosBoxLangEditComboBox.Items.IndexOf(Save);
    If I>=0 then begin DosBoxLangEditComboBox.ItemIndex:=I; exit; end;
  end;

  S:=ShortLanguageName(LanguageComboBox.Items[LanguageComboBox.ItemIndex]);
  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If (I<0) and (ExtUpperCase(S)='GERMAN') then I:=DosBoxLangEditComboBox.Items.IndexOf('Deutsch');
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

Procedure TFirstRunWizardForm.UpdateStartPage;
begin
  LoadAndSetupDOSBoxLanguages;

  StartLabelLanguageValue.Caption:=LanguageComboBox.Text;

  If IncludeTrailingPathDelimiter(Trim(ExtUpperCase(DosBoxDirEdit.Text)))=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(PrgDir+'DOSBox'))) then begin
    StartLabelDOSBoxValue.Caption:=LanguageSetup.Default+' ('+DosBoxDirEdit.Text+')';
  end else begin
    StartLabelDOSBoxValue.Caption:=DosBoxDirEdit.Text;
  end;

  StartLabelDOSBoxLanguageValue.Caption:=DosBoxLangEditComboBox.Text;

  If IncludeTrailingPathDelimiter(Trim(ExtUpperCase(GameDirEdit.Text)))=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(PrgDataDir+'VirtualHD'))) then begin
    StartLabelGamesFolderValue.Caption:=LanguageSetup.Default+' ('+GameDirEdit.Text+')';
  end else begin
    StartLabelGamesFolderValue.Caption:=GameDirEdit.Text;
  end;

  If Update0RadioButton.Checked then StartLabelUpdatesValue.Caption:=Update0RadioButton.Caption;
  If Update1RadioButton.Checked then StartLabelUpdatesValue.Caption:=Update1RadioButton.Caption;
  If Update2RadioButton.Checked then StartLabelUpdatesValue.Caption:=Update2RadioButton.Caption;
  If Update3RadioButton.Checked then StartLabelUpdatesValue.Caption:=Update3RadioButton.Caption;
end;

procedure TFirstRunWizardForm.BackButtonClick(Sender: TObject);
begin
  Notebook.PageIndex:=Notebook.PageIndex-1;
  SetupButttons;
end;

procedure TFirstRunWizardForm.NextButtonClick(Sender: TObject);
begin
  Notebook.PageIndex:=Notebook.PageIndex+1;
  SetupButttons;
end;

Procedure TFirstRunWizardForm.SetupButttons;
Var I : Integer;
Procedure SetLeft(const B : TBitBtn); begin If not B.Visible then exit; B.Left:=I; inc(I,B.Width+8); end;
begin
  BackButton.Visible:=(Notebook.PageIndex>0);
  NextButton.Visible:=(Notebook.PageIndex<5) and (Notebook.PageIndex>0);
  OKButton.Visible:=(Notebook.PageIndex=5);
  AcceptAllSettingsButton.Visible:=(Notebook.PageIndex<5);
  EditSettingsButton.Visible:=(Notebook.PageIndex=0);

  I:=8;
  SetLeft(BackButton);
  SetLeft(NextButton);
  SetLeft(OKButton);
  SetLeft(AcceptAllSettingsButton);
  SetLeft(EditSettingsButton);
  SetLeft(HelpButton);
end;

procedure TFirstRunWizardForm.DosBoxButtonClick(Sender: TObject);
Var S : String;
begin
  S:=DosBoxDirEdit.Text;
  if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then DosBoxDirEdit.Text:=IncludeTrailingPathDelimiter(S);
end;

procedure TFirstRunWizardForm.DosBoxDirEditChange(Sender: TObject);
begin
  WarningButton.Visible:=OldDOSBoxVersion(CheckDOSBoxVersion(-1,DosBoxDirEdit.Text));
  DosBoxDirEdit.Width:=IfThen(WarningButton.Visible,WarningButton.Left-4,WarningButton.Left+WarningButton.Width)-DosBoxDirEdit.Left;
end;

procedure TFirstRunWizardForm.WarningButtonClick(Sender: TObject);
begin
  DOSBoxOutdatedWarning(DosBoxDirEdit.Text);
end;

procedure TFirstRunWizardForm.GameDirButtonClick(Sender: TObject);
Var S : String;
begin
  S:=GameDirEdit.Text; If S='' then S:=PrgSetup.BaseDir;
  if SelectDirectory(Handle,LanguageSetup.SetupFormGameDir,S) then GameDirEdit.Text:=IncludeTrailingPathDelimiter(S);
end;

procedure TFirstRunWizardForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FirstRunWizard);
end;

procedure TFirstRunWizardForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;
begin
  FirstRunWizardForm:=TFirstRunWizardForm.Create(AOwner);
  try
    result:=(FirstRunWizardForm.ShowModal=mrOK);
    if not result then LoadLanguage(PrgSetup.Language);
    SearchForUpdatesNow:=result and FirstRunWizardForm.UpdateNowCheckBox.Checked;
  finally
    FirstRunWizardForm.Free;
  end;
end;

end.
