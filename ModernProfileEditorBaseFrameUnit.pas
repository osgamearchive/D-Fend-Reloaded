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
    GameRelPathCheckBox: TCheckBox;
    SetupRelPathCheckBox: TCheckBox;
    GameGroup: TGroupBox;
    GameComboBox: TComboBox;
    GameEdit: TLabeledEdit;
    GameButton: TSpeedButton;
    InfoLabel: TLabel;
    ExtraExeFilesButton: TBitBtn;
    procedure IconButtonClick(Sender: TObject);
    procedure ExeSelectButtonClick(Sender: TObject);
    procedure ProfileNameEditChange(Sender: TObject);
    procedure RelPathCheckBoxClick(Sender: TObject);
    procedure GameComboBoxChange(Sender: TObject);
    procedure ExtraExeFilesButtonClick(Sender: TObject);
    procedure SetupExeEditChange(Sender: TObject);
    procedure GameExeEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    FOnProfileNameChange : TTextEvent;
    FLoadFromTemplate : Boolean;
    IconName : String;
    OldFileName : String;
    ProfileName,ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath : PString;
    ScummVM, WindowsMode : Boolean;
    ExtraExeFiles : TStringList;
    procedure LoadIcon;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, IconManagerFormUnit,
     PrgSetupUnit, PrgConsts, CommonTools, GameDBToolsUnit, ScummVMToolsUnit,
     ExtraExeEditFormUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorBaseFrame }

constructor TModernProfileEditorBaseFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ExtraExeFiles:=TStringList.Create;
end;

destructor TModernProfileEditorBaseFrame.Destroy;
begin
  ExtraExeFiles.Free;
  inherited Destroy;
end;

procedure TModernProfileEditorBaseFrame.InitGUI(const InitData : TModernProfileEditorInitData);
begin
  ScummVM:=False;
  WindowsMode:=False;

  NoFlicker(ProfileNameEdit);
  NoFlicker(ProfileFileNameEdit);
  NoFlicker(GameExeGroup);
  NoFlicker(GameExeEdit);
  NoFlicker(GameParameterEdit);
  NoFlicker(SetupExeGroup);
  NoFlicker(SetupExeEdit);
  NoFlicker(SetupParameterEdit);
  NoFlicker(GameGroup);
  NoFlicker(GameComboBox);
  NoFlicker(GameEdit);

  FOnProfileNameChange:=InitData.OnProfileNameChange;

  IconPanel.ControlStyle:=IconPanel.ControlStyle-[csParentBackground];
  IconSelectButton.Caption:=LanguageSetup.ProfileEditorIconSelect;
  IconDeleteButton.Caption:=LanguageSetup.ProfileEditorIconDelete;
  ProfileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorProfileName;
  ProfileFileNameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorFilename;

  GameExeGroup.Caption:=LanguageSetup.ProfileEditorGame;
  GameExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameEXE;
  GameExeButton.Hint:=LanguageSetup.ChooseFile;
  GameRelPathCheckBox.Caption:=LanguageSetup.ProfileEditorRelPath;
  GameParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorGameParameters;

  SetupExeGroup.Caption:=LanguageSetup.ProfileEditorSetup;
  SetupExeEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupEXE;
  SetupExeButton.Hint:=LanguageSetup.ChooseFile;
  SetupRelPathCheckBox.Caption:=LanguageSetup.ProfileEditorRelPath;
  SetupParameterEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSetupParameters;
  InfoLabel.Caption:=LanguageSetup.ProfileEditorSetupInfo;
  ExtraExeFilesButton.Caption:=LanguageSetup.ProfileEditorExtraExeFiles;

  GameGroup.Caption:=LanguageSetup.ProfileEditorScummVMGame;
  GameEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorScummVMGameFolder;
  GameButton.Hint:=LanguageSetup.ChooseFolder;

  ProfileName:=InitData.CurrentProfileName;
  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileScummVMGameName:=InitData.CurrentScummVMGameName;
  ProfileScummVMPath:=InitData.CurrentScummVMPath;

  HelpContext:=ID_ProfileEditProfile;
end;

procedure TModernProfileEditorBaseFrame.SetGame(const Game: TGame; const LoadFromTemplate : Boolean);
Var S : String;
    I : Integer;
begin
  FLoadFromTemplate:=LoadFromTemplate and (Game<>nil);

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

  If ScummVMMode(Game) then begin
    { ScummVM mode }
    ScummVM:=True;

    If ScummVMGamesList.Count=0 then ScummVMGamesList.LoadListFromScummVM(True);
    GameComboBox.Items.Clear;
    GameComboBox.Sorted:=False;
    GameComboBox.Items.AddStrings(ScummVMGamesList.DescriptionList);
    GameComboBox.Sorted:=True;
    If GameComboBox.Items.Count>0 then GameComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(Game.ScummVMGame));
    For I:=0 to ScummVMGamesList.NamesList.Count-1 do If Trim(ExtUpperCase(ScummVMGamesList.NamesList[I]))=S then begin
      GameComboBox.ItemIndex:=GameComboBox.Items.IndexOf(ScummVMGamesList.DescriptionList[I]);
      break;
    end;
    GameEdit.Text:=Game.ScummVMPath;
  end else begin
    If WindowsExeMode(Game) then begin
      { Windows mode }
      WindowsMode:=True;

      GameExeEdit.Text:=Game.GameExe;
      GameParameterEdit.Text:=Game.GameParameters;
      SetupExeEdit.Text:=Game.SetupExe;
      SetupParameterEdit.Text:=Game.SetupParameters;
    end else begin
      { DOSBox mode }
      S:=Trim(ExtUpperCase(Game.GameExe));
      If Copy(S,1,7)='DOSBOX:' then begin
        GameRelPathCheckBox.Checked:=True;
        GameExeEdit.Text:=Copy(Trim(Game.GameExe),8,MaxInt);
      end else begin
        GameExeEdit.Text:=Game.GameExe;
      end;
      GameParameterEdit.Text:=Game.GameParameters;

      S:=Trim(ExtUpperCase(Game.SetupExe));
      If Copy(S,1,7)='DOSBOX:' then begin
        SetupRelPathCheckBox.Checked:=True;
        SetupExeEdit.Text:=Copy(Trim(Game.SetupExe),8,MaxInt);
      end else begin
        SetupExeEdit.Text:=Game.SetupExe;
      end;
      SetupParameterEdit.Text:=Game.SetupParameters;
    end;
    { Windows and DOSBox mode }
    For I:=0 to 9 do If Trim(Game.ExtraPrgFile[I])<>'' then ExtraExeFiles.Add(Game.ExtraPrgFile[I]);
  end;
end;

procedure TModernProfileEditorBaseFrame.ShowFrame;
begin
  If ScummVM then begin
    { ScummVM mode }
    GameExeGroup.Visible:=False;
    SetupExeGroup.Visible:=False;
    ExtraExeFilesButton.Visible:=False;
    GameGroup.Visible:=True;
  end else begin
    GameGroup.Visible:=False;
    If WindowsMode then begin
      GameRelPathCheckBox.Visible:=False;
      SetupRelPathCheckBox.Visible:=False;
    end else begin
      { DOSBox mode }
    end;
  end;
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

procedure TModernProfileEditorBaseFrame.GameComboBoxChange(Sender: TObject);
begin
  If GameComboBox.ItemIndex>=0 then
    FOnProfileNameChange(Sender,ProfileNameEdit.Text,ProfileExe^,ProfileSetup^,ScummVMGamesList.NameFromDescription(GameComboBox.Text),ProfileScummVMPath^);
end;

procedure TModernProfileEditorBaseFrame.GetGame(const Game: TGame);
Var NewFileName : String;
    S : String;
    I : Integer;
begin
  Game.Icon:=IconName;
  If not ProfileNameEdit.ReadOnly then Game.Name:=ProfileNameEdit.Text;

  If ScummVM then begin
    { ScummVM mode }
    Game.ProfileMode:='ScummVM';
    If GameComboBox.ItemIndex>=0
      then Game.ScummVMGame:=ScummVMGamesList.NameFromDescription(GameComboBox.Text)
      else Game.ScummVMGame:='';
    Game.ScummVMPath:=GameEdit.Text;
  end else begin
    If WindowsMode then begin
      { Windows mode }
      Game.ProfileMode:='Windows';
      ProfileEditorCloseCheck(Game,GameExeEdit.Text,SetupExeEdit.Text);
      Game.GameExe:=GameExeEdit.Text;
      Game.GameParameters:=GameParameterEdit.Text;
      Game.SetupExe:=SetupExeEdit.Text;
      Game.SetupParameters:=SetupParameterEdit.Text;
    end else begin
      { DOSBox mode }
      Game.ProfileMode:='DOSBox';
      ProfileEditorCloseCheck(Game,GameExeEdit.Text,SetupExeEdit.Text);
      If GameRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
      Game.GameExe:=S+GameExeEdit.Text;
      Game.GameParameters:=GameParameterEdit.Text;
      If SetupRelPathCheckBox.Checked then S:='DOSBox:' else S:='';
      Game.SetupExe:=S+SetupExeEdit.Text;
      Game.SetupParameters:=SetupParameterEdit.Text;
    end;

    For I:=0 to 9 do Game.ExtraPrgFile[I]:='';
    For I:=0 to Min(9,ExtraExeFiles.Count-1) do Game.ExtraPrgFile[I]:=Trim(ExtraExeFiles[I]);
  end;

  If (OldFileName<>'') and (ProfileFileNameEdit.Text<>ChangeFileExt(ExtractFileName(OldFileName),'')) then begin
    S:=ProfileFileNameEdit.Text;
    If ExtUpperCase(Copy(S,length(S)-4,5))<>'.PROF' then S:=S+'.prof';
    NewFileName:=IncludeTrailingPathDelimiter(ExtractFilePath(OldFileName))+S;
    Game.RenameINI(NewFileName);
  end;
end;

procedure TModernProfileEditorBaseFrame.ProfileNameEditChange(Sender: TObject);
begin
  FOnProfileNameChange(Sender,ProfileNameEdit.Text,ProfileExe^,ProfileSetup^,ProfileScummVMGameName^,ProfileScummVMPath^);
end;

procedure TModernProfileEditorBaseFrame.GameExeEditChange(Sender: TObject);
begin
  FOnProfileNameChange(Sender,ProfileName^,GameExeEdit.Text,ProfileSetup^,ProfileScummVMGameName^,ProfileScummVMPath^);
end;

procedure TModernProfileEditorBaseFrame.SetupExeEditChange(Sender: TObject);
begin
  FOnProfileNameChange(Sender,ProfileName^,ProfileExe^,SetupExeEdit.Text,ProfileScummVMGameName^,ProfileScummVMPath^);
end;

procedure TModernProfileEditorBaseFrame.RelPathCheckBoxClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : GameExeButton.Visible:=not GameRelPathCheckBox.Checked;
    1 : SetupExeButton.Visible:=not SetupRelPathCheckBox.Checked;
  end;
end;

procedure TModernProfileEditorBaseFrame.IconButtonClick(Sender: TObject);
Var S : String;
begin
  Case (Sender as TBitBtn).Tag of
    0 : begin
          S:='';
          If not GameRelPathCheckBox.Checked then S:=MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir);
          If (S='') and (not SetupRelPathCheckBox.Checked) then S:=MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir);
          if ShowIconManager(self,IconName,ExtractFilePath(S)) then LoadIcon;
        end;
    1 : begin IconName:=''; LoadIcon; end;
  end;
end;

procedure TModernProfileEditorBaseFrame.LoadIcon;
Var S : String;
begin
  If IconName='' then begin
    IconImage.Picture:=nil;
    exit;
  end;
  try
    S:=MakeAbsIconName(IconName);
    If FileExists(S) then IconImage.Picture.LoadFromFile(S);
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
          If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic)) and (not WindowsMode)
            then OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilterWithBasic
            else OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          S:='';
          If (S='') and (Trim(GameExeEdit.Text)<>'') then S:=ExtractFilePath(MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir));
          If (S='') and (Trim(SetupExeEdit.Text)<>'') then S:=ExtractFilePath(MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir));
          If (S='') and WindowsMode then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          If S='' then S:=PrgSetup.GameDir;
          If S='' then S:=PrgSetup.BaseDir;
          OpenDialog.InitialDir:=S;
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          GameExeEdit.Text:=S;
        end;
    1 : begin
          S:=MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='exe';
          OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
          If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic)) and (not WindowsMode)
            then OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilterWithBasic
            else OpenDialog.Filter:=LanguageSetup.ProfileEditorEXEFilter;
          S:='';
          If (S='') and (Trim(SetupExeEdit.Text)<>'') then S:=ExtractFilePath(MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir));
          If (S='') and (Trim(GameExeEdit.Text)<>'') then S:=ExtractFilePath(MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir));
          If (S='') and WindowsMode then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
          If S='' then S:=PrgSetup.GameDir;
          If S='' then S:=PrgSetup.BaseDir;
          OpenDialog.InitialDir:=S;
          if not OpenDialog.Execute then exit;
          S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          If S='' then exit;
          SetupExeEdit.Text:=S;
        end;
    2 : begin
          If Trim(GameEdit.Text)='' then begin
            If PrgSetup.GameDir=''
              then S:=PrgSetup.BaseDir
              else S:=PrgSetup.GameDir;
          end else begin
            S:=MakeAbsPath(GameEdit.Text,PrgSetup.BaseDir);
          end;
          If SelectDirectory(Handle,LanguageSetup.ProfileEditorScummVMGameFolderCaption,S) then GameEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
  end;
end;

procedure TModernProfileEditorBaseFrame.ExtraExeFilesButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(SetupExeEdit.Text)='' then begin
    If Trim(GameExeEdit.Text)='' then begin
      If PrgSetup.GameDir=''
        then S:=PrgSetup.BaseDir
        else S:=PrgSetup.GameDir;
    end else begin
      S:=ExtractFilePath(MakeAbsPath(GameExeEdit.Text,PrgSetup.BaseDir));
    end;
  end else begin
    S:=ExtractFilePath(MakeAbsPath(SetupExeEdit.Text,PrgSetup.BaseDir));
  end;

  ShowExtraExeEditDialog(self,ExtraExeFiles,S);
end;

end.
