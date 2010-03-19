unit FirstRunWizardFormUnit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFirstRunWizardForm2 = class(TForm)
    Image: TImage;
    OKButton: TBitBtn;
    HelpButton: TBitBtn;
    StartLabel: TLabel;
    ProgramLanguageLabel: TLabel;
    ProgramLanguageComboBox: TComboBox;
    DOSBoxLabel: TLabel;
    DOSBoxLanguageLabel: TLabel;
    DOSBoxLanguageComboBox: TComboBox;
    UpdatesCheckBox: TCheckBox;
    UpdatesLabel: TLabel;
    DOSBoxComboBox: TComboBox;
    DOSBoxButton: TSpeedButton;
    ProgramLanguageWarningButton: TSpeedButton;
    DOSBoxEdit: TEdit;
    DOSBoxWarningButton: TSpeedButton;
    PortableOKButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ProgramLanguageComboBoxChange(Sender: TObject);
    procedure ProgramLanguageButtonClick(Sender: TObject);
    procedure DOSBoxComboBoxChange(Sender: TObject);
    procedure DOSBoxEditChange(Sender: TObject);
    procedure DOSBoxButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    JustLoadingLanguage,DefaultDOSBoxAvailable : Boolean;
    DosBoxLang : TStringList;
    procedure LoadAndSetupLanguageList;
    Procedure LoadGUILanguage;
    procedure LoadAndSetupDOSBoxLanguages(const ResetLang : Boolean);
  public
    { Public-Deklarationen }
  end;

var
  FirstRunWizardForm2: TFirstRunWizardForm2;

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;

implementation

uses Registry, Math, CommonTools, LanguageSetupUnit, VistaToolsUnit, HelpConsts,
     PrgSetupUnit, IconLoaderUnit, PrgConsts, MainUnit, LoggingUnit;

{$R *.dfm}

procedure TFirstRunWizardForm2.FormCreate(Sender: TObject);
begin
  LogInfo('First run wizard: FormCreate');

  DosBoxLang:=TStringList.Create;
  JustLoadingLanguage:=False;
  DefaultDOSBoxAvailable:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)))=Trim(ExtUpperCase(PrgDir+'DOSBox\'));

  SetVistaFonts(self);

  UserIconLoader.LoadIcons;
  UserIconLoader.DialogImage(DI_Warning,ProgramLanguageWarningButton);
  UserIconLoader.DialogImage(DI_Warning,DOSBoxWarningButton);
  UserIconLoader.DialogImage(DI_Information,PortableOKButton);
  UserIconLoader.DialogImage(DI_SelectFolder,DOSBoxButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  LoadGUILanguage;
end;

procedure TFirstRunWizardForm2.FormShow(Sender: TObject);
begin
  LogInfo('First run wizard: FormShow');

  LoadAndSetupLanguageList;

  DOSBoxEdit.Text:=MakeRelPath(PrgSetup.DOSBoxSettings[0].DosBoxDir,PrgSetup.BaseDir);
  DOSBoxEditChange(Sender);

  LoadAndSetupDOSBoxLanguages(True);
end;

procedure TFirstRunWizardForm2.FormDestroy(Sender: TObject);
begin
  DosBoxLang.Free;
end;

procedure TFirstRunWizardForm2.LoadGUILanguage;
Var I : Integer;
begin
  JustLoadingLanguage:=True;
  try
    LogInfo('First run wizard: LoadGUILanguage');

    {General GUI elements}
    ProgramLanguageLabel.ParentFont:=True;
    DOSBoxLabel.ParentFont:=True;
    DOSBoxLanguageLabel.ParentFont:=True;
    UpdatesCheckBox.ParentFont:=True;
    Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
    ProgramLanguageLabel.Font.Style:=[fsBold];
    DOSBoxLabel.Font.Style:=[fsBold];
    DOSBoxLanguageLabel.Font.Style:=[fsBold];
    UpdatesCheckBox.Font.Style:=[fsBold];

    Caption:=LanguageSetup.FirstRunWizard;
    StartLabel.Caption:=LanguageSetup.FirstRunWizardInfoOverview;
    ProgramLanguageLabel.Caption:=LanguageSetup.FirstRunWizardProgramLanguage;
    ProgramLanguageWarningButton.Caption:=LanguageSetup.LanguageOutdatedShort;
    DOSBoxLabel.Caption:=LanguageSetup.FirstRunWizardDOSBoxDir;
    DOSBoxButton.Hint:=LanguageSetup.ChooseFolder;
    DOSBoxLanguageLabel.Caption:=LanguageSetup.FirstRunWizardDOSBoxLanguage;
    UpdatesCheckBox.Caption:=LanguageSetup.FirstRunWizardAutoUpdate;
    UpdatesLabel.Caption:=LanguageSetup.FirstRunWizardAutoUpdateInfo;
    OKButton.Caption:=LanguageSetup.OK;
    HelpButton.Caption:=LanguageSetup.Help;

    {DOSBox selection}
    I:=DOSBoxComboBox.ItemIndex;
    DOSBoxComboBox.Items.BeginUpdate;
    try
      DOSBoxComboBox.Items.Clear;
      DOSBoxComboBox.Items.Add(LanguageSetup.FirstRunWizardDOSBoxDirDefault);
      DOSBoxComboBox.Items.Add(LanguageSetup.FirstRunWizardDOSBoxDirCustom);
    finally
      DOSBoxComboBox.Items.EndUpdate;
    end;
    DOSBoxComboBox.ItemIndex:=Max(0,I);
    DOSBoxEdit.Enabled:=(DOSBoxComboBox.Items.Count=0) or (DOSBoxComboBox.ItemIndex=1);
    DOSBoxButton.Enabled:=(DOSBoxComboBox.Items.Count=0) or (DOSBoxComboBox.ItemIndex=1);
  finally
    JustLoadingLanguage:=False;
  end;
end;

procedure TFirstRunWizardForm2.LoadAndSetupLanguageList;
Var I,J : Integer;
    St : TStringList;
    Reg : TRegistry;
begin
  JustLoadingLanguage:=True;
  try
    LogInfo('First run wizard: LoadAndSetupLanguageList');

    {Load language list}
    St:=GetLanguageList;
    try
      ProgramLanguageComboBox.Items.AddStrings(St);
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
    ProgramLanguageComboBox.ItemIndex:=0;
    For I:=0 to ProgramLanguageComboBox.Items.Count-1 do If Integer(ProgramLanguageComboBox.Items.Objects[I])=J then begin
      ProgramLanguageComboBox.ItemIndex:=I; break;
    end;
  finally
    JustLoadingLanguage:=False;
  end;

  ProgramLanguageComboBoxChange(self);
end;

Function MainVersionStringToInt(S : String) : Integer;
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
end;

procedure TFirstRunWizardForm2.ProgramLanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  if JustLoadingLanguage then exit;

  LoadLanguage(ShortLanguageName(ProgramLanguageComboBox.Text)+'.ini');
  DFendReloadedMainForm.SelectHelpFile;
  LoadGUILanguage;

  ProgramLanguageWarningButton.Visible:=False;
  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    ProgramLanguageWarningButton.Visible:=True;
    ProgramLanguageWarningButton.Hint:=LanguageSetup.LanguageNoVersion;
  end else begin
    If MainVersionStringToInt(S)<MainVersionStringToInt(GetNormalFileVersionAsString) then begin
      ProgramLanguageWarningButton.Visible:=True;
      ProgramLanguageWarningButton.Hint:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end;
  end;

  LoadAndSetupDOSBoxLanguages(True);
end;

procedure TFirstRunWizardForm2.ProgramLanguageButtonClick(Sender: TObject);
begin
  If (Sender=ProgramLanguageWarningButton) or (Sender=DOSBoxWarningButton)
    then MessageDlg((Sender as TSpeedButton).Hint,mtWarning,[mbOK],0)
    else MessageDlg((Sender as TSpeedButton).Hint,mtInformation,[mbOK],0);
end;

procedure TFirstRunWizardForm2.DOSBoxButtonClick(Sender: TObject);
Var S : String;
begin
  S:=MakeAbsPath(DosBoxEdit.Text,PrgSetup.BaseDir);
  if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then DosBoxEdit.Text:=MakeRelPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir);
end;

procedure TFirstRunWizardForm2.DOSBoxComboBoxChange(Sender: TObject);
begin
  If JustLoadingLanguage then exit;
  If DOSBoxComboBox.Items.Count=0 then exit;
  DOSBoxEdit.Enabled:=(DOSBoxComboBox.ItemIndex=1);
  DOSBoxButton.Enabled:=(DOSBoxComboBox.ItemIndex=1);

  If DOSBoxComboBox.ItemIndex=0 then begin
    DOSBoxEdit.Text:=MakeRelPath(PrgSetup.DOSBoxSettings[0].DosBoxDir,PrgSetup.BaseDir);
    DOSBoxEditChange(Sender);
  end;
end;

procedure TFirstRunWizardForm2.DOSBoxEditChange(Sender: TObject);
Var S,T,DOSBoxVersion : String;
    I : Integer;
begin
  DOSBoxWarningButton.Visible:=False;
  PortableOKButton.Visible:=False;

  S:=IncludeTrailingPathDelimiter(MakeAbsPath(DOSBoxEdit.Text,PrgSetup.BaseDir));
  If not FileExists(S+DosBoxFileName) then begin
    DOSBoxWarningButton.Visible:=True;
    DOSBoxWarningButton.Caption:=LanguageSetup.FirstRunWizardDOSBoxDirNoDOSBoxShort;
    DOSBoxWarningButton.Hint:=LanguageSetup.FirstRunWizardDOSBoxDirNoDOSBox;
  end else begin
    DOSBoxVersion:=CheckDOSBoxVersion(-1,DosBoxEdit.Text);
    DOSBoxWarningButton.Visible:=OldDOSBoxVersion(DOSBoxVersion);
    If DOSBoxWarningButton.Visible then begin
      DOSBoxWarningButton.Caption:=LanguageSetup.MessageDOSBoxOutdatedShort;
      T:=FloatToStr(MinSupportedDOSBoxVersion);
      For I:=1 to length(T) do If T[I]=',' then T[I]:='.';
      DOSBoxWarningButton.Hint:=Format(LanguageSetup.MessageDOSBoxOutdated,[DOSBoxVersion,T]);
    end else begin
      S:=IncludeTrailingPathDelimiter(ExtUpperCase(MakeAbsPath(DOSBoxEdit.Text,PrgSetup.BaseDir)));
      T:=IncludeTrailingPathDelimiter(ExtUpperCase(PrgDir));
      If (OperationMode=omPortable) and (Copy(S,1,length(T))=T) then begin
        PortableOKButton.Visible:=True;
        PortableOKButton.Caption:=LanguageSetup.FirstRunWizardDOSBoxDirPortableOKShort;
        PortableOKButton.Hint:=LanguageSetup.FirstRunWizardDOSBoxDirPortableOK;
      end;
    end;
  end;

  LoadAndSetupDOSBoxLanguages(False);
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

procedure TFirstRunWizardForm2.LoadAndSetupDOSBoxLanguages(const ResetLang : Boolean);
Var I : Integer;
    S,Save : String;
begin
  Save:=DOSBoxLanguageComboBox.Text;

  DosBoxLang.Clear;
  DOSBoxLanguageComboBox.Items.Clear;

  DOSBoxLanguageComboBox.Items.Add('English');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(MakeAbsPath(DosBoxEdit.Text,PrgSetup.BaseDir)),DOSBoxLanguageComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DOSBoxLanguageComboBox.Items,DosBoxLang);

  If (Save<>'') and not ResetLang then begin
    I:=DOSBoxLanguageComboBox.Items.IndexOf(Save);
    If I>=0 then begin DOSBoxLanguageComboBox.ItemIndex:=I; exit; end;
  end;

  S:=ShortLanguageName(ProgramLanguageComboBox.Items[ProgramLanguageComboBox.ItemIndex]);
  I:=DOSBoxLanguageComboBox.Items.IndexOf(S);
  If (I<0) and (ExtUpperCase(S)='GERMAN') then I:=DOSBoxLanguageComboBox.Items.IndexOf('Deutsch');
  If I>=0 then begin DOSBoxLanguageComboBox.ItemIndex:=I; exit; end;

  DOSBoxLanguageComboBox.ItemIndex:=0;
end;

procedure TFirstRunWizardForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PrgSetup.Language:=ShortLanguageName(ProgramLanguageComboBox.Text)+'.ini';
  PrgSetup.DOSBoxSettings[0].DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxEdit.Text);
  PrgSetup.DOSBoxSettings[0].DosBoxLanguage:=DosBoxLang[DOSBoxLanguageComboBox.ItemIndex];
  PrgSetup.GameDir:=PrgDataDir+'VirtualHD\';

  PrgSetup.VersionSpecificUpdateCheck:=True;
  If UpdatesCheckBox.Checked then begin
    PrgSetup.CheckForUpdates:=1;
    PrgSetup.DataReaderCheckForUpdates:=2;
  end else begin
    PrgSetup.CheckForUpdates:=0;
    PrgSetup.DataReaderCheckForUpdates:=0;
  end;
  PrgSetup.PackageListsCheckForUpdates:=0;
  PrgSetup.CheatsDBCheckForUpdates:=0;

  PrgSetup.ValueForNotSet:=LanguageSetup.NotSetLanguageDefault;
end;

procedure TFirstRunWizardForm2.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_FirstRunWizard);
end;

procedure TFirstRunWizardForm2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowFirstRunWizardDialog(const AOwner : TComponent; var SearchForUpdatesNow : Boolean) : Boolean;
begin
  FirstRunWizardForm2:=TFirstRunWizardForm2.Create(AOwner);
  try
    result:=(FirstRunWizardForm2.ShowModal=mrOK);
    if not result then LoadLanguage(PrgSetup.Language);
    SearchForUpdatesNow:=result and FirstRunWizardForm2.UpdatesCheckBox.Checked;
  finally
    FirstRunWizardForm2.Free;
  end;
end;

end.
