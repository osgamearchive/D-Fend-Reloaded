unit ModernProfileEditorBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorBaseFrame = class(TFrame, IModernProfileEditorFrame)
    IconPanel: TPanel;
    IconImage: TImage;
    IconSelectButton: TBitBtn;
    IconDeleteButton: TBitBtn;
    ProfileNameEdit: TLabeledEdit;
    ProfileFileNameEdit: TLabeledEdit;
    GameExeGroup: TGroupBox;
    GameExeEdit: TLabeledEdit;
    GameParameterEdit: TLabeledEdit;
    GameExeButton: TSpeedButton;
    SetupExeGroup: TGroupBox;
    SetupExeButton: TSpeedButton;
    SetupExeEdit: TLabeledEdit;
    SetupParameterEdit: TLabeledEdit;
    OpenDialog: TOpenDialog;
    InfoLabel: TLabel;
    procedure IconButtonClick(Sender: TObject);
    procedure ExeSelectButtonClick(Sender: TObject);
    procedure ProfileNameEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    FOnProfileNameChange : TTextEvent;
    IconName : String;
    OldFileName : String;
    ProfileExe,ProfileSetup : PString;
    procedure LoadIcon;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, IconManagerFormUnit, PrgSetupUnit,
     PrgConsts, CommonTools, GameDBToolsUnit;

{$R *.dfm}

{ TModernProfileEditorBaseFrame }

procedure TModernProfileEditorBaseFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
begin
  NoFlicker(ProfileNameEdit);
  NoFlicker(ProfileFileNameEdit);
  NoFlicker(GameExeGroup);
  NoFlicker(GameExeEdit);
  NoFlicker(GameParameterEdit);
  NoFlicker(SetupExeGroup);
  NoFlicker(SetupExeEdit);
  NoFlicker(SetupParameterEdit);

  FOnProfileNameChange:=OnProfileNameChange;

  IconPanel.ControlStyle:=IconPanel.ControlStyle-[csParentBackground];
  IconSelectButton.Caption:=LanguageSetup.ProfileEditorIconSelect;
  IconDeleteButton.Caption:=LanguageSetup.ProfileEditorIconDelete;
  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorProfileName;
  ProfileFileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorFilename;

  GameExeGroup.Caption:=LanguageSetup.ProfileEditorGame;
  GameExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  GameExeButton.Hint:=LanguageSetup.ChooseFile;
  GameParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameParameters;

  SetupExeGroup.Caption:=LanguageSetup.ProfileEditorSetup;
  SetupExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  SetupExeButton.Hint:=LanguageSetup.ChooseFile;
  SetupParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupParameters;

  InfoLabel.Caption:=LanguageSetup.ProfileEditorSetupInfo;

  ProfileExe:=CurrentProfileExe;
  ProfileSetup:=CurrentProfileSetup;
end;

procedure TModernProfileEditorBaseFrame.SetGame(const Game: TGame; const LoadFromTemplate : Boolean);
begin
  If Game=nil then begin
    ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
    exit;
  end;

  OldFileName:='';

  IconName:=Game.Icon;
  LoadIcon;
  If not LoadFromTemplate then begin
    ProfileNameEdit.Text:=Game.Name;
  end;
  If LoadFromTemplate then begin
    ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
    ProfileFileNameEdit.Color:=Color;
  end else begin
    If Game.SetupFile<>'' then begin
      OldFileName:=Game.SetupFile;
      ProfileFileNameEdit.Text:=ChangeFileExt(ExtractFileName(Game.SetupFile),'');
      ProfileFileNameEdit.ReadOnly:=False;
    end else begin
      {Main Template}
      ProfileNameEdit.Visible:=False;
      ProfileFileNameEdit.Text:=LanguageSetup.ProfileEditorNoFilename;
      ProfileFileNameEdit.Color:=Color;
      ProfileNameEdit.ReadOnly:=True;
    end;
  end;

  GameExeEdit.Text:=Game.GameExe;
  GameParameterEdit.Text:=Game.GameParameters;
  SetupExeEdit.Text:=Game.SetupExe;
  SetupParameterEdit.Text:=Game.SetupParameters;
end;

function TModernProfileEditorBaseFrame.CheckValue: Boolean;
begin
  result:=True;

  If (Trim(ProfileNameEdit.Text)='') and (not ProfileNameEdit.ReadOnly) then begin
    MessageDlg(LanguageSetup.MessageNoProfileName,mtError,[mbOK],0);
    result:=False;
    exit;
  end;
end;

procedure TModernProfileEditorBaseFrame.GetGame(const Game: TGame);
Var NewFileName : String;
begin
  Game.Icon:=IconName;
  If not ProfileNameEdit.ReadOnly then Game.Name:=ProfileNameEdit.Text;
  ProfileEditorCloseCheck(Game,GameExeEdit.Text,SetupExeEdit.Text);
  Game.GameExe:=GameExeEdit.Text;
  Game.GameParameters:=GameParameterEdit.Text;
  Game.SetupExe:=SetupExeEdit.Text;
  Game.SetupParameters:=SetupParameterEdit.Text;

  If (OldFileName<>'') and (ProfileFileNameEdit.Text<>ChangeFileExt(ExtractFileName(OldFileName),'')) then begin
    NewFileName:=IncludeTrailingPathDelimiter(ExtractFilePath(OldFileName))+ChangeFileExt(ProfileFileNameEdit.Text,'.prof');
    Game.RenameINI(NewFileName);
  end;
end;

procedure TModernProfileEditorBaseFrame.ProfileNameEditChange(Sender: TObject);
begin
  FOnProfileNameChange(Sender,ProfileNameEdit.Text,ProfileExe^,ProfileSetup^);
end;

procedure TModernProfileEditorBaseFrame.IconButtonClick(Sender: TObject);
begin
  Case (Sender as TBitBtn).Tag of
    0 : if ShowIconManager(self,IconName) then LoadIcon;
    1 : begin IconName:=''; LoadIcon; end;
  end;
end;

procedure TModernProfileEditorBaseFrame.LoadIcon;
begin
  If IconName='' then begin
    IconImage.Picture:=nil;
    exit;
  end;
  try
    IconImage.Picture.LoadFromFile(IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir)+IconName);
  except end;
end;

procedure TModernProfileEditorBaseFrame.ExeSelectButtonClick(Sender: TObject);
Var S : String;
begin
  Case (Sender as TSpeedButton).Tag of
    0 : begin
          S:=MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(GameExeEdit.Text)='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          GameExeEdit.Text:=S;
        end;
    1 : begin
          S:=MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          If (S='') or (Trim(SetupExeEdit.Text)='') then begin
            If PrgSetup.GameDir=''
              then OpenDialog.InitialDir:=PrgSetup.BaseDir
              else OpenDialog.InitialDir:=PrgSetup.GameDir;
          end else OpenDialog.InitialDir:=ExtractFilePath(S);
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          SetupExeEdit.Text:=S;
        end;
  end;
end;

end.
