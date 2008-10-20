unit WizardPrgFileUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, ExtCtrls, GameDBUnit;

type
  TWizardPrgFileFrame = class(TFrame)
    InfoLabel: TLabel;
    GamesFolderEdit: TLabeledEdit;
    ProgramEdit: TLabeledEdit;
    SetupEdit: TLabeledEdit;
    SetupButton: TSpeedButton;
    ProgramButton: TSpeedButton;
    GamesFolderButton: TSpeedButton;
    DataFolderEdit: TLabeledEdit;
    BaseDataFolderEdit: TLabeledEdit;
    BaseInfoLabel3: TLabel;
    BaseDataFolderButton: TSpeedButton;
    DataFolderButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    Bevel: TBevel;
    FolderInfoButton: TSpeedButton;
    DataFolderShowButton: TBitBtn;
    FolderInfoButton2: TSpeedButton;
    procedure ButtonWork(Sender: TObject);
    procedure FolderInfoButtonClick(Sender: TObject);
    procedure DataFolderShowButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses ShellAPI, ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TWizardPrgFileFrame }

procedure TWizardPrgFileFrame.Init(const GameDB: TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  BaseInfoLabel3.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage2Info;
  ProgramEdit.EditLabel.Caption:=LanguageSetup.WizardFormProgram;
  ProgramButton.Hint:=LanguageSetup.ChooseFile;
  SetupEdit.EditLabel.Caption:=LanguageSetup.WizardFormSetup;
  SetupButton.Hint:=LanguageSetup.ChooseFile;
  GamesFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormGamesFolder;
  GamesFolderButton.Caption:=LanguageSetup.WizardFormExplorer;
  DataFolderShowButton.Caption:=LanguageSetup.WizardFormDataFolderButton;
  BaseInfoLabel3.Caption:=LanguageSetup.WizardFormInfoLabel3;
  DataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormDataFolder;
  DataFolderButton.Hint:=LanguageSetup.ChooseFolder;
  BaseDataFolderEdit.EditLabel.Caption:=LanguageSetup.WizardFormBaseDataFolder;
  BaseDataFolderButton.Caption:=LanguageSetup.WizardFormExplorer;

  GamesFolderEdit.Text:=PrgSetup.GameDir;
  BaseDataFolderEdit.Text:=PrgSetup.DataDir;

  GamesFolderEdit.Color:=Color;
  BaseDataFolderEdit.Color:=Color;
end;

procedure TWizardPrgFileFrame.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : ShellExecute(Handle,'explore',PChar(GamesFolderEdit.Text),nil,PChar(GamesFolderEdit.Text),SW_SHOW);
    1 : begin
          S:=MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic))
            then OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilterWithBasic
            else OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If Trim(ProgramEdit.Text)='' then begin
            If Trim(SetupEdit.Text)='' then begin
              If GamesFolderEdit.Visible=False {=Windows Mode} then begin
                OpenDialog.InitialDir:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
              end else begin
                If PrgSetup.GameDir=''
                  then OpenDialog.InitialDir:=PrgSetup.BaseDir
                  else OpenDialog.InitialDir:=PrgSetup.GameDir;
              end;
            end else begin
              OpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(SetupEdit.Text,PrgSetup.BaseDir));
            end;
          end else begin
            OpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir));
          end;

          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          ProgramEdit.Text:=S;
        end;
    2 : begin
          S:=MakeAbsPath(SetupEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic))
            then OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilterWithBasic
            else OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If Trim(SetupEdit.Text)='' then begin
            If Trim(ProgramEdit.Text)='' then begin
              If GamesFolderEdit.Visible=False {=Windows Mode} then begin
                OpenDialog.InitialDir:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
              end else begin
                If PrgSetup.GameDir=''
                  then OpenDialog.InitialDir:=PrgSetup.BaseDir
                  else OpenDialog.InitialDir:=PrgSetup.GameDir;
              end;
            end else begin
              OpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(ProgramEdit.Text,PrgSetup.BaseDir));
            end;
          end else begin
            OpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(SetupEdit.Text,PrgSetup.BaseDir));
          end;

          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          SetupEdit.Text:=S;
        end;
    3 : ShellExecute(Handle,'explore',PChar(BaseDataFolderEdit.Text),nil,PChar(BaseDataFolderEdit.Text),SW_SHOW);
    4 : begin
          If Trim(DataFolderEdit.Text)=''
            then S:=PrgSetup.DataDir
            else S:=MakeAbsPath(DataFolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          DataFolderEdit.Text:=S;
        end;
  end;
end;

procedure TWizardPrgFileFrame.WriteDataToGame(const Game: TGame);
begin
  Game.GameExe:=ProgramEdit.Text;
  Game.SetupExe:=SetupEdit.Text;
  Game.DataDir:=DataFolderEdit.Text;
end;

procedure TWizardPrgFileFrame.FolderInfoButtonClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : MessageDlg(Format(LanguageSetup.WizardFormGamesFolderInfo,[PrgSetup.BaseDir]),mtInformation,[mbOK],0);
    1 : MessageDlg(Format(LanguageSetup.WizardFormBaseDataFolderInfo,[PrgSetup.BaseDir]),mtInformation,[mbOK],0);
  end;
end;

procedure TWizardPrgFileFrame.DataFolderShowButtonClick(Sender: TObject);
begin
  DataFolderShowButton.Visible:=False;

  BaseInfoLabel3.Visible:=True;
  BaseDataFolderEdit.Visible:=True;
  BaseDataFolderButton.Visible:=True;
  DataFolderEdit.Visible:=True;
  DataFolderButton.Visible:=True;
  FolderInfoButton2.Visible:=True;
end;


end.
