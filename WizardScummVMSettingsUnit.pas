unit WizardScummVMSettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, GameDBUnit;

type
  TWizardScummVMSettingsFrame = class(TFrame)
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    InfoLabel: TLabel;
    Bevel: TBevel;
    LanguageInfoLabel: TLabel;
  private
    { Private-Deklarationen }
    FGameDB : TGameDB;
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure SetScummVMGameName(const Name : String);
    Function CreateGame(const GameName : String) : TGame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

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

procedure TWizardScummVMSettingsFrame.SetScummVMGameName(const Name: String);
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
end;

function TWizardScummVMSettingsFrame.CreateGame(const GameName: String): TGame;
begin
  result:=FGameDB[FGameDB.Add(GameName)];
  result.ProfileMode:='ScummVM';
  result.Name:=GameName;

  If LanguageComboBox.ItemIndex>=0 then result.ScummVMLanguage:=LanguageComboBox.Text else result.ScummVMLanguage:='';
  result.StartFullscreen:=StartFullscreenCheckBox.Checked;
end;

end.
