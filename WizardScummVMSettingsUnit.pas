unit WizardScummVMSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, GameDBUnit, Buttons;

type
  TWizardScummVMSettingsFrame = class(TFrame)
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    InfoLabel: TLabel;
    Bevel: TBevel;
    LanguageInfoLabel: TLabel;
    SavePathGroupBox: TGroupBox;
    SavePathEditButton: TSpeedButton;
    SavePathDefaultRadioButton: TRadioButton;
    SavePathCustomRadioButton: TRadioButton;
    SavePathEdit: TEdit;
    procedure SavePathEditChange(Sender: TObject);
    procedure SavePathEditButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FGameDB : TGameDB;
    ScummVMPath : String;
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure SetScummVMGameName(const Name, Path : String);
    Function CreateGame(const GameName : String) : TGame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TWizardScummVMSettingsFrame }

procedure TWizardScummVMSettingsFrame.Init(const GameDB: TGameDB);
begin
  SetVistaFonts(self);
  FGameDB:=GameDB;

  InfoLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage6Info;
  LanguageLabel.Caption:=LanguageSetup.ProfileEditorScummVMLanguage;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  SavePathGroupBox.Caption:=LanguageSetup.ProfileEditorScummVMSavePath;
  SavePathDefaultRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathGameDir+' ('+LanguageSetup.Default+')';
  SavePathCustomRadioButton.Caption:=LanguageSetup.ProfileEditorScummVMSavePathCustom;
  LanguageInfoLabel.Caption:=LanguageSetup.WizardFormScummVMLanguageInfo;
end;

Type TLangRec=record
  Game, Lang : String;
end;

const LangData : Array[0..7] of TLangRec=(
  (Game: 'maniac'; Lang: 'en,de,fr,it,es'),
  (Game: 'zak'; Lang: 'en,de,fr,it,es'),
  (Game: 'dig'; Lang: 'jp, zh,kr'),
  (Game: 'comi'; Lang: 'en,de,fr,it,pt,es,jp,zh,kr'),
  (Game: 'sky'; Lang: 'gb,en,de,fr,it,pt,es,se'),
  (Game: 'sword1'; Lang: 'en,de,fr,it,es,pt,cz'),
  (Game: 'simon1'; Lang: 'en,de,fr,it,es,hb,pl,ru'),
  (Game: 'simon2'; Lang: 'en,de,fr,it,es,hb,pl,ru')
);

procedure TWizardScummVMSettingsFrame.SetScummVMGameName(const Name, Path : String);
Var S : String;
    I : Integer;
    St : TStringList;
begin
  If LanguageComboBox.ItemIndex>=0 then S:=LanguageComboBox.Text else S:='';
  LanguageComboBox.Items.BeginUpdate;
  try
    LanguageComboBox.Items.Clear;
    For I:=Low(LangData) to High(LangData) do If LangData[I].Game=Name then begin
      St:=ValueToList(LangData[I].Lang,','); try LanguageComboBox.Items.AddStrings(St); finally St.Free; end;
      break;
    end;
  finally
    LanguageComboBox.Items.EndUpdate;
  end;

  LanguageComboBox.Enabled:=(LanguageComboBox.Items.Count>0);
  LanguageLabel.Enabled:=(LanguageComboBox.Items.Count>0);
  LanguageInfoLabel.Visible:=(LanguageComboBox.Items.Count>0);

  If LanguageComboBox.Items.Count>0 then begin
    If S='' then LanguageComboBox.ItemIndex:=0 else begin
      I:=LanguageComboBox.Items.IndexOf(S);
      If I>=0 then LanguageComboBox.ItemIndex:=I;
    end;
  end;

  ScummVMPath:=Path;
end;

function TWizardScummVMSettingsFrame.CreateGame(const GameName: String): TGame;
begin
  result:=FGameDB[FGameDB.Add(GameName)];
  result.ProfileMode:='ScummVM';
  result.Name:=GameName;

  If LanguageComboBox.ItemIndex>=0 then result.ScummVMLanguage:=LanguageComboBox.Text else result.ScummVMLanguage:='';
  result.StartFullscreen:=StartFullscreenCheckBox.Checked;

  If SavePathDefaultRadioButton.Checked then result.ScummVMSavePath:='' else result.ScummVMSavePath:=Trim(SavePathEdit.Text);
end;

procedure TWizardScummVMSettingsFrame.SavePathEditChange(Sender: TObject);
begin
  SavePathDefaultRadioButton.Checked:=(Trim(SavePathEdit.Text)='');
  SavePathCustomRadioButton.Checked:=(Trim(SavePathEdit.Text)<>'');
end;

procedure TWizardScummVMSettingsFrame.SavePathEditButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(SavePathEdit.Text);
  If S='' then S:=Trim(ScummVMPath);
  If S='' then S:=PrgSetup.GameDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  SavePathEdit.Text:=S;
  SavePathEditChange(Sender);
end;

end.
