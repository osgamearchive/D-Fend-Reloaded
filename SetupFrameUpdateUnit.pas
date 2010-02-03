unit SetupFrameUpdateUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit, PackageDBUnit;

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
    DataReaderButton: TBitBtn;
    PackagesButton: TBitBtn;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure PackageDBDownload(Sender : TObject; const Progress, Size : Integer; const Status : TDownloadStatus; var ContinueDownload : Boolean);
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
     CommonTools, MainUnit, DownloadWaitFormUnit;

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
  UserIconLoader.DialogImage(DI_Update,DataReaderButton);
  UserIconLoader.DialogImage(DI_Update,PackagesButton);

  DataReaderComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.DataReaderCheckForUpdates));
  PackagesComboBox.ItemIndex:=Max(0,Min(3,PrgSetup.PackageListsCheckForUpdates));
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
  DataReaderButton.Caption:=LanguageSetup.SetupFormUpdatePackagesButton;

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
  PackagesButton.Caption:=LanguageSetup.SetupFormUpdatePackagesButton;

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
  DataReaderButton.Visible:=PrgSetup.ActivateIncompleteFeatures;
  PackagesLabel.Visible:=PrgSetup.ActivateIncompleteFeatures;
  PackagesComboBox.Visible:=PrgSetup.ActivateIncompleteFeatures;
  PackagesButton.Visible:=PrgSetup.ActivateIncompleteFeatures;
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
end;

procedure TSetupFrameUpdate.ButtonWork(Sender: TObject);
Var I : Integer;
    DataReader : TDataReader;
    PackageDB : TPackageDB;
begin
  Case (Sender as TComponent).Tag of
    0 : If FileExists(PrgDir+'UpdateCheck.exe') or FileExists(PrgDir+BinFolder+'\'+'UpdateCheck.exe')
          then DFendReloadedMainForm.RunUpdateCheck(False)
          else ShellExecute(Handle,'open',PChar(LanguageSetup.MenuHelpUpdatesURL),nil,nil,SW_SHOW);
    1 : begin
          I:=PrgSetup.DataReaderCheckForUpdates;
          try
            PrgSetup.DataReaderCheckForUpdates:=3;
            DataReader:=TDataReader.Create;
            try
              ShowDataReaderInternetConfigWaitDialog(Owner,DataReader,LanguageSetup.DataReaderDownloadCaption,LanguageSetup.DataReaderDownloadInfo,LanguageSetup.DataReaderDownloadError);
            finally
              DataReader.Free;
            end;
          finally
            PrgSetup.DataReaderCheckForUpdates:=I;
          end;
        end;
    2 : begin
          PackageDB:=TPackageDB.Create;
          try
            PackageDB.LoadDB(False,False);
            PackageDB.OnDownload:=PackageDBDownload;
            PackageDB.LoadDB(True,((Word(GetKeyState(VK_LSHIFT)) div 256)<>0) or ((Word(GetKeyState(VK_RSHIFT)) div 256)<>0));
          finally
            PackageDB.Free;
          end;
        end;  
  end;
end;

Procedure TSetupFrameUpdate.PackageDBDownload(Sender : TObject; const Progress, Size : Integer; const Status : TDownloadStatus; var ContinueDownload : Boolean);
begin
  Case Status of
    dsStart : begin Enabled:=False; InitDownloadWaitForm(self,Size); end;
    dsProgress : begin
                   If DownloadWaitForm.ProgressBar.Max=1 then DownloadWaitForm.ProgressBar.Max:=Size;
                   ContinueDownload:=StepDownloadWaitForm(Progress);
                 end;
    dsDone : begin Enabled:=True; DoneDownloadWaitForm; end;
  End;
end;

end.
