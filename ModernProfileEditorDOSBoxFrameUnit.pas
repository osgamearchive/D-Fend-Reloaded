unit ModernProfileEditorDOSBoxFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, ExtCtrls, Buttons,
  ComCtrls;

type
  TModernProfileEditorDOSBoxFrame = class(TFrame, IModernProfileEditorFrame)
    DOSBoxForegroundPriorityRadioGroup: TRadioGroup;
    DOSBoxBackgroundPriorityRadioGroup: TRadioGroup;
    CloseDOSBoxOnExitCheckBox: TCheckBox;
    DefaultDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationEdit: TEdit;
    CustomDOSBoxInstallationButton: TSpeedButton;
    CustomSetsClearButton: TBitBtn;
    CustomSetsLoadButton: TBitBtn;
    CustomSetsSaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    CustomSetsMemo: TRichEdit;
    CustomSetsLabel: TLabel;
    DOSBoxInstallationComboBox: TComboBox;
    UserLanguageCheckBox: TCheckBox;
    UserLanguageComboBox: TComboBox;
    procedure CustomDOSBoxInstallationButtonClick(Sender: TObject);
    procedure CustomDOSBoxInstallationEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure DOSBoxInstallationComboBoxChange(Sender: TObject);
    procedure DOSBoxInstallationTypeClick(Sender: TObject);
    procedure UserLanguageCheckBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    ProfileName,ProfileExe,ProfileSetup,ProfileDOSBoxInstallation : PString;
    FOnProfileNameChange : TTextEvent;
    Procedure UpdateLanguageList;
    Procedure SelectInLanguageList(const LangName : String);
  public
    { Public-Deklarationen }
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     PrgConsts, HelpConsts, IconLoaderUnit, TextEditPopupUnit;

{$R *.dfm}

const FPriority : Array[0..3] of String = ('lower','normal','higher','highest');
const BPriority : Array[0..4] of String = ('pause','lower','normal','higher','highest');

{ TModernProfileEditorDOSBoxFrame }

constructor TModernProfileEditorDOSBoxFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DosBoxLang:=TStringList.Create;
end;

destructor TModernProfileEditorDOSBoxFrame.Destroy;
begin
  DosBoxLang.Free;
  inherited Destroy;
end;

procedure TModernProfileEditorDOSBoxFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var I : Integer;
    S : String;
begin
  NoFlicker(DOSBoxForegroundPriorityRadioGroup);
  NoFlicker(DOSBoxBackgroundPriorityRadioGroup);
  NoFlicker(CloseDOSBoxOnExitCheckBox);
  NoFlicker(DefaultDOSBoxInstallationRadioButton);
  NoFlicker(DOSBoxInstallationComboBox);
  NoFlicker(CustomDOSBoxInstallationRadioButton);
  NoFlicker(CustomDOSBoxInstallationEdit);
  NoFlicker(UserLanguageCheckBox);
  NoFlicker(UserLanguageComboBox);
  {NoFlicker(CustomSetsMemo); - will hide text in Memo}
  NoFlicker(CustomSetsClearButton);
  NoFlicker(CustomSetsLoadButton);
  NoFlicker(CustomSetsSaveButton);

  SetRichEditPopup(CustomSetsMemo);

  DOSBoxForegroundPriorityRadioGroup.Caption:=LanguageSetup.GamePriorityForeground;
  with DOSBoxForegroundPriorityRadioGroup.Items do begin
    Add(LanguageSetup.GamePriorityLower);
    Add(LanguageSetup.GamePriorityNormal);
    Add(LanguageSetup.GamePriorityHigher);
    Add(LanguageSetup.GamePriorityHighest);
  end;
  DOSBoxBackgroundPriorityRadioGroup.Caption:=LanguageSetup.GamePriorityBackground;
  with DOSBoxBackgroundPriorityRadioGroup.Items do begin
    Add(LanguageSetup.GamePriorityPause);
    Add(LanguageSetup.GamePriorityLower);
    Add(LanguageSetup.GamePriorityNormal);
    Add(LanguageSetup.GamePriorityHigher);
    Add(LanguageSetup.GamePriorityHighest);
  end;
  CloseDOSBoxOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  DefaultDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionDefault;
  CustomDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionCustom;
  CustomDOSBoxInstallationButton.Hint:=LanguageSetup.ChooseFolder;
  UserLanguageCheckBox.Caption:=LanguageSetup.GameDOSBoxLanguageCustom;
  CustomSetsLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsMemo.Font.Name:='Courier New';
  CustomSetsClearButton.Caption:=LanguageSetup.Del;
  CustomSetsLoadButton.Caption:=LanguageSetup.Load;
  CustomSetsSaveButton.Caption:=LanguageSetup.Save;
  UserIconLoader.DialogImage(DI_SelectFolder,CustomDOSBoxInstallationButton);
  UserIconLoader.DialogImage(DI_Clear,CustomSetsClearButton);
  UserIconLoader.DialogImage(DI_Load,CustomSetsLoadButton);
  UserIconLoader.DialogImage(DI_Save,CustomSetsSaveButton);

  For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do begin
    If I=0 then S:=LanguageSetup.Default else S:=PrgSetup.DOSBoxSettings[I].Name;
    DOSBoxInstallationComboBox.Items.Add(S+' ('+MakeRelPath(PrgSetup.DOSBoxSettings[I].DosBoxDir,PrgSetup.BaseDir,True)+')');
  end;
  DOSBoxInstallationComboBox.ItemIndex:=0;

  ProfileName:=InitData.CurrentProfileName;
  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileDOSBoxInstallation:=InitData.CurrentDOSBoxInstallation;
  FOnProfileNameChange:=InitData.OnProfileNameChange;

  HelpContext:=ID_ProfileEditDOSBox;
end;

procedure TModernProfileEditorDOSBoxFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    S,T : String;
    I : Integer;
    B : Boolean;
begin
  St:=ValueToList(Game.Priority,',');
  try
    If (St.Count>=1) and (St[0]<>'') then S:=St[0] else S:=FPriority[2];
    If (St.Count>=2) and (St[1]<>'') then T:=St[1] else T:=BPriority[2];
  finally
    St.Free;
  end;
  S:=Trim(ExtUpperCase(S));
  DOSBoxForegroundPriorityRadioGroup.ItemIndex:=1;
  For I:=0 to DOSBoxForegroundPriorityRadioGroup.Items.Count-1 do If ExtUpperCase(FPriority[I])=S then begin
    DOSBoxForegroundPriorityRadioGroup.ItemIndex:=I;
    break;
  end;
  T:=Trim(ExtUpperCase(T));
  DOSBoxBackgroundPriorityRadioGroup.ItemIndex:=2;
  For I:=0 to DOSBoxBackgroundPriorityRadioGroup.Items.Count-1 do If ExtUpperCase(BPriority[I])=T then begin
    DOSBoxBackgroundPriorityRadioGroup.ItemIndex:=I;
    break;
  end;

  CloseDOSBoxOnExitCheckBox.Checked:=Game.CloseDosBoxAfterGameExit;

  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir)); B:=False;
  If S='' then S:='DEFAULT';
  For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do begin
    If I=0 then T:='DEFAULT' else T:=PrgSetup.DOSBoxSettings[I].Name;
    If S=Trim(ExtUpperCase(T)) then begin
      B:=True;
      DefaultDOSBoxInstallationRadioButton.Checked:=True;
      DOSBoxInstallationComboBox.ItemIndex:=I;
      break;
    end;
  end;
  If not B then begin
    CustomDOSBoxInstallationRadioButton.Checked:=True;
    CustomDOSBoxInstallationEdit.Text:=Game.CustomDOSBoxDir;
  end;
  UserLanguageCheckBoxClick(self);

  UpdateLanguageList;
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxLanguage));
  If (S='') or (S='DEFAULT') then begin
    UserLanguageCheckBox.Checked:=False;
    SelectInLanguageList('');
  end else begin
    UserLanguageCheckBox.Checked:=True;
    SelectInLanguageList(ChangeFileExt(ExtractFileName(Game.CustomDOSBoxLanguage),''));
  end;

  St:=StringToStringList(Game.CustomSettings);
  try
    CustomSetsMemo.Lines.Assign(St);
  finally
    St.Free;
  end;
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

procedure TModernProfileEditorDOSBoxFrame.UpdateLanguageList;
Var Save,DosBoxDir : String;
begin
  If DefaultDOSBoxInstallationRadioButton.Checked then begin
    DosBoxDir:=IncludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].DosBoxDir);
    FOnProfileNameChange(self,ProfileName^,ProfileExe^,ProfileSetup^,'','',PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].Name);
  end else begin
    DosBoxDir:=IncludeTrailingPathDelimiter(CustomDOSBoxInstallationEdit.Text);
    FOnProfileNameChange(self,ProfileName^,ProfileExe^,ProfileSetup^,'','',CustomDOSBoxInstallationEdit.Text);
  end;

  If UserLanguageComboBox.ItemIndex>=0 then Save:=UserLanguageComboBox.Items[UserLanguageComboBox.ItemIndex] else Save:='';
  UserLanguageComboBox.Items.BeginUpdate;
  try
    UserLanguageComboBox.Items.Clear;
    DosBoxLang.Clear;

    UserLanguageComboBox.Items.Add('English');
    DosBoxLang.Add('English');

    FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDir),UserLanguageComboBox.Items,DosBoxLang);
    FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',UserLanguageComboBox.Items,DosBoxLang);
    UserLanguageComboBox.ItemIndex:=Max(0,UserLanguageComboBox.Items.IndexOf(Save));
  finally
    UserLanguageComboBox.Items.EndUpdate;
  end;

  SelectInLanguageList(Save);
end;

procedure TModernProfileEditorDOSBoxFrame.UserLanguageCheckBoxClick(Sender: TObject);
begin
  UserLanguageComboBox.Enabled:=UserLanguageCheckBox.Checked;
end;

Procedure TModernProfileEditorDOSBoxFrame.SelectInLanguageList(const LangName : String);
begin
  If Trim(LangName)=''
    then UserLanguageComboBox.ItemIndex:=0
    else UserLanguageComboBox.ItemIndex:=Max(0,UserLanguageComboBox.Items.IndexOf(LangName));
end;

procedure TModernProfileEditorDOSBoxFrame.GetGame(const Game: TGame);
begin
  Game.Priority:=FPriority[DOSBoxForegroundPriorityRadioGroup.ItemIndex]+','+BPriority[DOSBoxBackgroundPriorityRadioGroup.ItemIndex];
  Game.CloseDosBoxAfterGameExit:=CloseDOSBoxOnExitCheckBox.Checked;
  If DefaultDOSBoxInstallationRadioButton.Checked then begin
    Game.CustomDOSBoxDir:=PrgSetup.DOSBoxSettings[DOSBoxInstallationComboBox.ItemIndex].Name;
  end else begin
    Game.CustomDOSBoxDir:=CustomDOSBoxInstallationEdit.Text;
  end;

  If UserLanguageCheckBox.Checked then Game.CustomDOSBoxLanguage:=ExtractFileName(DosBoxLang[UserLanguageComboBox.ItemIndex]) else Game.CustomDOSBoxLanguage:='default';

  Game.CustomSettings:=StringListToString(CustomSetsMemo.Lines);
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(CustomDOSBoxInstallationEdit.Text);
  If S='' then S:=PrgSetup.DOSBoxSettings[0].DosBoxDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  S:=MakeRelPath(S,PrgSetup.BaseDir,True);
  If S='' then exit;
  CustomDOSBoxInstallationEdit.Text:=IncludeTrailingPathDelimiter(S);
end;

procedure TModernProfileEditorDOSBoxFrame.DOSBoxInstallationTypeClick(Sender: TObject);
begin
  UpdateLanguageList;
end;

procedure TModernProfileEditorDOSBoxFrame.DOSBoxInstallationComboBoxChange(Sender: TObject);
begin
  DefaultDOSBoxInstallationRadioButton.Checked:=True;
  UpdateLanguageList;
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationEditChange(Sender: TObject);
begin
  CustomDOSBoxInstallationRadioButton.Checked:=True;
  UpdateLanguageList;
end;

procedure TModernProfileEditorDOSBoxFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : CustomSetsMemo.Lines.Clear;
    1 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorCustomSetsLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not OpenDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorCustomSetsSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not SaveDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
  end;
end;

end.
