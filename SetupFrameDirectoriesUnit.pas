unit SetupFrameDirectoriesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameDirectories = class(TFrame, ISetupFrame)
    BaseDirEdit: TLabeledEdit;
    GameDirEdit: TLabeledEdit;
    DataDirEdit: TLabeledEdit;
    DataDirButton: TSpeedButton;
    GameDirButton: TSpeedButton;
    BaseDirButton: TSpeedButton;
    InfoLabel: TLabel;
    procedure ButtonWork(Sender: TObject);
    procedure BaseDirEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    PBaseDir : PString;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools;

{$R *.dfm}

{ TSetupFrameDirectories }

function TSetupFrameDirectories.GetName: String;
begin
  result:=LanguageSetup.SetupFormDirectoriesSheet;
end;

procedure TSetupFrameDirectories.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(BaseDirEdit);
  NoFlicker(GameDirEdit);
  NoFlicker(DataDirEdit);

  PBaseDir:=InitData.PBaseDir;

  BaseDirEdit.Text:=PrgSetup.BaseDir;
  GameDirEdit.Text:=PrgSetup.GameDir;
  DataDirEdit.Text:=PrgSetup.DataDir;
end;

procedure TSetupFrameDirectories.LoadLanguage;
begin
  BaseDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormBaseDir;
  BaseDirButton.Hint:=LanguageSetup.ChooseFolder;
  GameDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormGameDir;
  GameDirButton.Hint:=LanguageSetup.ChooseFolder;
  DataDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDataDir;
  DataDirButton.Hint:=LanguageSetup.ChooseFolder;
  InfoLabel.Caption:=LanguageSetup.SetupFormDirectoriesInfo;
end;

procedure TSetupFrameDirectories.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDirectories.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameDirectories.RestoreDefaults;
begin
  BaseDirEdit.Text:=PrgDataDir;
  GameDirEdit.Text:=PrgDataDir+'VirtualHD\';
  DataDirEdit.Text:=PrgDataDir+'GameData\';
end;

procedure TSetupFrameDirectories.SaveSetup;
begin
  PrgSetup.BaseDir:=BaseDirEdit.Text;
  PrgSetup.GameDir:=GameDirEdit.Text;
  PrgSetup.DataDir:=DataDirEdit.Text;
end;

procedure TSetupFrameDirectories.BaseDirEditChange(Sender: TObject);
begin
  PBaseDir^:=BaseDirEdit.Text;
end;

procedure TSetupFrameDirectories.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=BaseDirEdit.Text; If S='' then S:=PrgDataDir;
          if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then BaseDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    1 : begin
          S:=GameDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormGameDir,S) then GameDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    2 : begin
          S:=DataDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDataDir,S) then DataDirEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
  end;
end;

end.
