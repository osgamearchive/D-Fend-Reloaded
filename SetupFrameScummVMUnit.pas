unit SetupFrameScummVMUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameScummVM = class(TFrame, ISetupFrame)
    ScummVMButton: TSpeedButton;
    FindScummVMButton: TSpeedButton;
    ScummVMDownloadURLInfo: TLabel;
    ScummVMDownloadURL: TLabel;
    ScummVMDirEdit: TLabeledEdit;
    ScummVMReadList: TBitBtn;
    MinimizeDFendScummVMCheckBox: TCheckBox;
    ScummVMShowListButton: TBitBtn;
    CenterScummVMCheckBox: TCheckBox;
    HideConsoleCheckBox: TCheckBox;
    RestoreWindowCheckBox: TCheckBox;
    procedure ButtonWork(Sender: TObject);
    procedure ScummVMDownloadURLClick(Sender: TObject);
    procedure MinimizeDFendScummVMCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses ShellAPI, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     ScummVMToolsUnit, SetupDosBoxFormUnit, ListScummVMGamesFormUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameScummVM }

function TSetupFrameScummVM.GetName: String;
begin
  result:=LanguageSetup.SetupFormScummVMSheet;
end;

procedure TSetupFrameScummVM.InitGUIAndLoadSetup(InitData: TInitData);
begin
  If PrgSetup.ActivateIncompleteFeatures then RestoreWindowCheckBox.Visible:=True;

  NoFlicker(ScummVMDirEdit);
  NoFlicker(ScummVMReadList);
  NoFlicker(MinimizeDFendScummVMCheckBox);
  Noflicker(RestoreWindowCheckBox);
  NoFlicker(CenterScummVMCheckBox);
  NoFlicker(HideConsoleCheckBox);

  ScummVMDirEdit.Text:=PrgSetup.ScummVMPath;
  MinimizeDFendScummVMCheckBox.Checked:=PrgSetup.MinimizeOnScummVMStart;
  RestoreWindowCheckBox.Checked:=PrgSetup.RestoreWhenScummVMCloses;
  CenterScummVMCheckBox.Checked:=PrgSetup.CenterScummVMWindow;
  HideConsoleCheckBox.Checked:=PrgSetup.HideScummVMConsole;

  MinimizeDFendScummVMCheckBoxClick(self);
end;

procedure TSetupFrameScummVM.LoadLanguage;
begin
  ScummVMDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormScummVMDir;
  ScummVMButton.Hint:=LanguageSetup.ChooseFolder;
  FindScummVMButton.Hint:=LanguageSetup.SetupFormSearchScummVM;
  ScummVMReadList.Caption:=LanguageSetup.SetupFormReadScummVMGamesList;
  ScummVMShowListButton.Caption:=LanguageSetup.WizardFormEmulationTypeListScummVMGames;
  MinimizeDFendScummVMCheckBox.Caption:=LanguageSetup.SetupFormMinimizeDFendScummVM;
  RestoreWindowCheckBox.Caption:=LanguageSetup.SetupFormRestoreWhenScummVMCloses;
  CenterScummVMCheckBox.Caption:=LanguageSetup.SetupFormCenterScummVMWindow;
  HideConsoleCheckBox.Caption:=LanguageSetup.SetupFormHideScummVMConsole;
  ScummVMDownloadURLInfo.Caption:=LanguageSetup.SetupFormScummVMDownloadURL;
  ScummVMDownloadURL.Caption:='http:/'+'/www.scummvm.org/downloads.php';
  with ScummVMDownloadURL.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  ScummVMDownloadURL.Cursor:=crHandPoint;

  HelpContext:=ID_FileOptionsScummVM;
end;

procedure TSetupFrameScummVM.MinimizeDFendScummVMCheckBoxClick(Sender: TObject);
begin
  RestoreWindowCheckBox.Enabled:=MinimizeDFendScummVMCheckBox.Checked;
end;

procedure TSetupFrameScummVM.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameScummVM.ShowFrame(const AdvencedMode: Boolean);
begin                                                
  MinimizeDFendScummVMCheckBox.Visible:=AdvencedMode;
  CenterScummVMCheckBox.Visible:=AdvencedMode;
  HideConsoleCheckBox.Visible:=AdvencedMode;
end;

procedure TSetupFrameScummVM.RestoreDefaults;
begin
  MinimizeDFendScummVMCheckBox.Checked:=False;
  RestoreWindowCheckBox.Checked:=False;
  CenterScummVMCheckBox.Checked:=False;
  HideConsoleCheckBox.Checked:=False;
  MinimizeDFendScummVMCheckBoxClick(self);
end;

procedure TSetupFrameScummVM.SaveSetup;
begin
  If Trim(ScummVMDirEdit.Text)<>''
    then PrgSetup.ScummVMPath:=IncludeTrailingPathDelimiter(ScummVMDirEdit.Text)
    else PrgSetup.ScummVMPath:='';
  PrgSetup.MinimizeOnScummVMStart:=MinimizeDFendScummVMCheckBox.Checked;
  PrgSetup.RestoreWhenScummVMCloses:=RestoreWindowCheckBox.Checked;
  PrgSetup.CenterScummVMWindow:=CenterScummVMCheckBox.Checked;
  PrgSetup.HideScummVMConsole:=HideConsoleCheckBox.Checked;
end;

procedure TSetupFrameScummVM.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
   16 : begin
          S:=ScummVMDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormScummVMDir,S) then ScummVMDirEdit.Text:=S;
        end;
   17 : if SearchScummVM(self) then ScummVMDirEdit.Text:=PrgSetup.ScummVMPath;
   18 : ScummVMGamesList.LoadListFromScummVM(True,ScummVMDirEdit.Text);
   19 : ShowListScummVMGamesDialog(self);
  end;
end;

procedure TSetupFrameScummVM.ScummVMDownloadURLClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

end.
