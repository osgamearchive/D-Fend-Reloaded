unit SetupFrameUpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit, PackageDBUnit, GameDBUnit;

type
  TSetupFrameUpdate = class(TFrame, ISetupFrame)
    Update0RadioButton: TRadioButton;
    Update1RadioButton: TRadioButton;
    Update2RadioButton: TRadioButton;
    Update3RadioButton: TRadioButton;
    UpdateCheckBox: TCheckBox;
    UpdateLabel: TLabel;
    DataReaderInfoLabel: TLabel;
    DataReaderComboBox: TComboBox;
    PackagesLabel: TLabel;
    PackagesComboBox: TComboBox;
    UpdateButton: TBitBtn;
    CheatsLabel: TLabel;
    CheatsComboBox: TComboBox;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses ShellAPI, Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, PrgConsts,
     HelpConsts, IconLoaderUnit, InternetDataWaitFormUnit, DataReaderUnit,
     CommonTools, MainUnit, DownloadWaitFormUnit, ProgramUpdateCheckUnit,
     CheatDBToolsUnit, UpdateCheckFormUnit;

{$R *.dfm}

{ TSetupFrameUpdate }

function TSetupFrameUpdate.GetName: String;
begin
  result:=LanguageSetup.MenuHelpUpdates;
  While (result<>'') and (result[length(result)]='.') do SetLength(result,length(result)-1);
end;

procedure TSetupFrameUpdate.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  case PrgSetup.CheckForUpdates of
    0 : Update0RadioButton.Checked:=True;
    1 : Update1RadioButton.Checked:=True;
    2 : Update2RadioButton.Checked:=True;
    3 : Update3RadioButton.Checked:=True;
  end;
  UpdateCheckBox.Checked:=PrgSetup.VersionSpecificUpdateCheck;

  UserIconLoader.DialogImage(DI_Update,UpdateButton);

  DataReaderComboBox.Items.Clear;
  While DataReaderComboBox.Items.Count<4 do DataReaderComboBox.Items.Add('');

  PackagesComboBox.Items.Clear;
  While PackagesComboBox.Items.Count<4 do PackagesComboBox.Items.Add('');

  CheatsComboBox.Items.Clear;
  While CheatsComboBox.Items.Count<3 do CheatsComboBox.Items.Add('');

  DataReaderComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.DataReaderCheckForUpdates));
  PackagesComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.PackageListsCheckForUpdates));
  CheatsComboBox.ItemIndex:=Max(0,Min(2,PrgSetup.CheatsDBCheckForUpdates));

  GameDB:=InitData.GameDB;
end;

procedure TSetupFrameUpdate.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameUpdate.LoadLanguage;
Var I : Integer;
begin
  Update0RadioButton.Caption:=LanguageSetup.SetupFormUpdate0;
  Update1RadioButton.Caption:=LanguageSetup.SetupFormUpdate1;
  Update2RadioButton.Caption:=LanguageSetup.SetupFormUpdate2;
  Update3RadioButton.Caption:=LanguageSetup.SetupFormUpdate3;
  UpdateCheckBox.Caption:=LanguageSetup.SetupFormUpdateVersionSpecific;
  UpdateLabel.Caption:=LanguageSetup.SetupFormUpdateInfo;
  UpdateButton.Caption:=LanguageSetup.SetupFormUpdateButton;

  DataReaderInfoLabel.Caption:=LanguageSetup.SetupFormUpdateDataReader;
  I:=DataReaderComboBox.ItemIndex;
  try
    DataReaderComboBox.Items[0]:=LanguageSetup.SetupFormUpdateDataReader0;
    DataReaderComboBox.Items[1]:=LanguageSetup.SetupFormUpdateDataReader1;
    DataReaderComboBox.Items[2]:=LanguageSetup.SetupFormUpdateDataReader2;
    DataReaderComboBox.Items[3]:=LanguageSetup.SetupFormUpdateDataReader3;
  finally
    DataReaderComboBox.ItemIndex:=I;
  end;

  PackagesLabel.Caption:=LanguageSetup.SetupFormUpdatePackages;
  I:=PackagesComboBox.ItemIndex;
  try
    PackagesComboBox.Items[0]:=LanguageSetup.SetupFormUpdatePackages0;
    PackagesComboBox.Items[1]:=LanguageSetup.SetupFormUpdatePackages1;
    PackagesComboBox.Items[2]:=LanguageSetup.SetupFormUpdatePackages2;
    PackagesComboBox.Items[3]:=LanguageSetup.SetupFormUpdatePackages3;
  finally
    PackagesComboBox.ItemIndex:=I;
  end;

  CheatsLabel.Caption:=LanguageSetup.SetupFormUpdateCheats;
  I:=CheatsComboBox.ItemIndex;
  try
    CheatsComboBox.Items[0]:=LanguageSetup.SetupFormUpdateCheats0;
    CheatsComboBox.Items[1]:=LanguageSetup.SetupFormUpdateCheats1;
    CheatsComboBox.Items[2]:=LanguageSetup.SetupFormUpdateCheats2;
  finally
    CheatsComboBox.ItemIndex:=I;
  end;

  HelpContext:=ID_FileOptionsSearchForUpdates;
end;

procedure TSetupFrameUpdate.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameUpdate.ShowFrame(const AdvencedMode: Boolean);
begin
  UpdateButton.Visible:=PrgSetup.ActivateIncompleteFeatures;
  DataReaderInfoLabel.Visible:=PrgSetup.ActivateIncompleteFeatures;
  DataReaderComboBox.Visible:=PrgSetup.ActivateIncompleteFeatures;
  PackagesLabel.Visible:=PrgSetup.ActivateIncompleteFeatures;
  PackagesComboBox.Visible:=PrgSetup.ActivateIncompleteFeatures;
  CheatsLabel.Visible:=PrgSetup.ActivateIncompleteFeatures;
  CheatsComboBox.Visible:=PrgSetup.ActivateIncompleteFeatures;
end;

procedure TSetupFrameUpdate.HideFrame;
begin
end;

procedure TSetupFrameUpdate.RestoreDefaults;
begin
  Update0RadioButton.Checked:=True;
  UpdateCheckBox.Checked:=True;

  DataReaderComboBox.ItemIndex:=2;
  PackagesComboBox.ItemIndex:=0;
  CheatsComboBox.ItemIndex:=0;
end;

procedure TSetupFrameUpdate.SaveSetup;
begin
  If Update0RadioButton.Checked then PrgSetup.CheckForUpdates:=0;
  If Update1RadioButton.Checked then PrgSetup.CheckForUpdates:=1;
  If Update2RadioButton.Checked then PrgSetup.CheckForUpdates:=2;
  If Update3RadioButton.Checked then PrgSetup.CheckForUpdates:=3;
  PrgSetup.VersionSpecificUpdateCheck:=UpdateCheckBox.Checked;

  PrgSetup.DataReaderCheckForUpdates:=DataReaderComboBox.ItemIndex;
  PrgSetup.PackageListsCheckForUpdates:=PackagesComboBox.ItemIndex;
  PrgSetup.CheatsDBCheckForUpdates:=CheatsComboBox.ItemIndex;
end;

procedure TSetupFrameUpdate.ButtonWork(Sender: TObject);
begin
  If PrgSetup.ActivateIncompleteFeatures then begin
    ShowUpdateCheckDialog(self,GameDB);
  end else begin
    RunUpdateCheck(self,False);
  end;
end;


end.
