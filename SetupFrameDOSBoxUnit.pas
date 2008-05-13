unit SetupFrameDOSBoxUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameDOSBox = class(TFrame, ISetupFrame)
    DosBoxButton: TSpeedButton;
    FindDosBoxButton: TSpeedButton;
    DosBoxMapperButton: TSpeedButton;
    SDLVideodriverLabel: TLabel;
    SDLVideodriverInfoLabel: TLabel;
    DosBoxDirEdit: TLabeledEdit;
    HideDosBoxConsoleCheckBox: TCheckBox;
    MinimizeDFendCheckBox: TCheckBox;
    DosBoxMapperEdit: TLabeledEdit;
    SDLVideoDriverComboBox: TComboBox;
    CenterDOSBoxCheckBox: TCheckBox;
    DosBoxTxtOpenDialog: TOpenDialog;
    DOSBoxDownloadURLInfo: TLabel;
    DOSBoxDownloadURL: TLabel;
    UseShortPathNamesCheckBox: TCheckBox;
    RestoreWindowCheckBox: TCheckBox;
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DOSBoxDownloadURLClick(Sender: TObject);
  private
    { Private-Deklarationen }
    PDosBoxDir : PString;
    DosBoxDirChange : TSimpleEvent;
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
     SetupDosBoxFormUnit;

{$R *.dfm}

{ TSetupFrameDOSBox }

function TSetupFrameDOSBox.GetName: String;
begin
  result:=LanguageSetup.SetupFormDosBoxSheet;
end;

procedure TSetupFrameDOSBox.InitGUIAndLoadSetup(InitData: TInitData);
begin
  PDosBoxDir:=InitData.PDosBoxDir;
  DosBoxDirChange:=InitData.DosBoxDirChangeNotify;

  NoFlicker(DosBoxDirEdit);
  NoFlicker(DosBoxMapperEdit);
  NoFlicker(HideDosBoxConsoleCheckBox);
  NoFlicker(MinimizeDFendCheckBox);
  NoFlicker(CenterDOSBoxCheckBox);
  NoFlicker(SDLVideoDriverComboBox);
  NoFlicker(UseShortPathNamesCheckBox);
  NoFlicker(RestoreWindowCheckBox);

  DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
  DosBoxDirEditChange(self);
  DosBoxMapperEdit.Text:=PrgSetup.DosBoxMapperFile;
  HideDosBoxConsoleCheckBox.Checked:=PrgSetup.HideDosBoxConsole;
  MinimizeDFendCheckBox.Checked:=PrgSetup.MinimizeOnDosBoxStart;
  RestoreWindowCheckBox.Checked:=PrgSetup.RestoreWhenDOSBoxCloses;
  CenterDOSBoxCheckBox.Checked:=PrgSetup.CenterDOSBoxWindow;
  UseShortPathNamesCheckBox.Checked:=PrgSetup.UseShortFolderNames;
  If Trim(ExtUpperCase(PrgSetup.SDLVideodriver))='WINDIB' then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
end;

procedure TSetupFrameDOSBox.LoadLanguage;
begin
  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;
  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  DosBoxMapperEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxMapperFile;
  DosBoxMapperButton.Hint:=LanguageSetup.ChooseFile;
  DOSBoxDownloadURLInfo.Caption:=LanguageSetup.SetupFormDOSBoxDownloadURL;
  DOSBoxDownloadURL.Caption:='http:/'+'/www.dosbox.com/download.php?main=1';
  with DOSBoxDownloadURL.Font do begin Color:=clBlue; Style:=[fsUnderline]; end;
  DOSBoxDownloadURL.Cursor:=crHandPoint;

  HideDosBoxConsoleCheckBox.Caption:=LanguageSetup.SetupFormHideDosBoxConsole;
  MinimizeDFendCheckBox.Caption:=LanguageSetup.SetupFormMinimizeDFend;
  CenterDOSBoxCheckBox.Caption:=LanguageSetup.SetupFormCenterDOSBoxWindow;
  SDLVideodriverLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriver;
  SDLVideodriverInfoLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriverInfo;
end;

procedure TSetupFrameDOSBox.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDOSBox.ShowFrame(const AdvencedMode: Boolean);
begin
  DosBoxMapperEdit.Visible:=AdvencedMode;
  DosBoxMapperButton.Visible:=AdvencedMode;
  HideDosBoxConsoleCheckBox.Visible:=AdvencedMode;
  MinimizeDFendCheckBox.Visible:=AdvencedMode;
  {RestoreWindowCheckBox.Visible:=AdvencedMode;}
  CenterDOSBoxCheckBox.Visible:=AdvencedMode;
  SDLVideodriverLabel.Visible:=AdvencedMode;
  SDLVideoDriverComboBox.Visible:=AdvencedMode;
  SDLVideodriverInfoLabel.Visible:=AdvencedMode;
  {UseShortPathNamesCheckBox.Visible:=AdvencedMode;}

  If AdvencedMode then DOSBoxDownloadURLInfo.Top:=SDLVideodriverInfoLabel.Top+SDLVideodriverInfoLabel.Height+10 else DOSBoxDownloadURLInfo.Top:=DosBoxMapperEdit.Top-10;
  DOSBoxDownloadURL.Top:=DOSBoxDownloadURLInfo.Top+19;
end;

procedure TSetupFrameDOSBox.RestoreDefaults;
begin
  DosBoxMapperEdit.Text:='.\mapper.txt';
  HideDosBoxConsoleCheckBox.Checked:=True;
  MinimizeDFendCheckBox.Checked:=False;
  RestoreWindowCheckBox.Checked:=False;
  CenterDOSBoxCheckBox.Checked:=False;
  UseShortPathNamesCheckBox.Checked:=True;
  If IsWindowsVista then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;
end;

procedure TSetupFrameDOSBox.SaveSetup;
begin
  PrgSetup.DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
  PrgSetup.DosBoxMapperFile:=DosBoxMapperEdit.Text;
  PrgSetup.HideDosBoxConsole:=HideDosBoxConsoleCheckBox.Checked;
  PrgSetup.MinimizeOnDosBoxStart:=MinimizeDFendCheckBox.Checked;
  PrgSetup.RestoreWhenDOSBoxCloses:=RestoreWindowCheckBox.Checked;
  PrgSetup.CenterDOSBoxWindow:=CenterDOSBoxCheckBox.Checked;
  PrgSetup.UseShortFolderNames:=UseShortPathNamesCheckBox.Checked;
  If SDLVideoDriverComboBox.ItemIndex=1 then PrgSetup.SDLVideodriver:='WinDIB' else PrgSetup.SDLVideodriver:='DirectX';
end;

procedure TSetupFrameDOSBox.DosBoxDirEditChange(Sender: TObject);
begin
  If PDosBoxDir^=DosBoxDirEdit.Text then exit;
  PDosBoxDir^:=DosBoxDirEdit.Text;
  DosBoxDirChange;
end;

procedure TSetupFrameDOSBox.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    3 : begin
          S:=DosBoxDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDosBoxDir,S) then begin
            DosBoxDirEdit.Text:=S;
            DosBoxDirEditChange(Sender);
          end;
        end;
    4 : if SearchDosBox(self) then begin
          DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
          DosBoxDirEditChange(Sender);
        end;
    5 : begin
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

procedure TSetupFrameDOSBox.DOSBoxDownloadURLClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar((Sender as TLabel).Caption),nil,nil,SW_SHOW);
end;

end.
