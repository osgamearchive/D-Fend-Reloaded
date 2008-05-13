unit ModernProfileEditorScummVMFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorScummVMFrame = class(TFrame, IModernProfileEditorFrame)
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    SubtitlesCheckBox: TCheckBox;
    AutosaveLabel: TLabel;
    AutosaveEdit: TSpinEdit;
    TalkSpeedEdit: TSpinEdit;
    TalkSpeedLabel: TLabel;
  private
    { Private-Deklarationen }
    LastGameName : String;
    CurrentGameName : PString;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TModernProfileEditorScummVMFrame }

procedure TModernProfileEditorScummVMFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName : PString);
begin
  LastGameName:='';

  NoFlicker(LanguageComboBox);
  NoFlicker(AutosaveEdit);
  NoFlicker(TalkSpeedEdit);
  NoFlicker(SubtitlesCheckBox);

  LanguageLabel.Caption:=LanguageSetup.ProfileEditorScummVMLanguage;
  AutosaveLabel.Caption:=LanguageSetup.ProfileEditorScummVMAutosave;
  TalkSpeedLabel.Caption:=LanguageSetup.ProfileEditorScummVMTextSpeed;
  SubtitlesCheckBox.Caption:=LanguageSetup.ProfileEditorScummVMSubtitles;

  CurrentGameName:=CurrentScummVMGameName;
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

procedure TModernProfileEditorScummVMFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  AutosaveEdit.Value:=Min(86400,Max(1,Game.ScummVMAutosave));
  TalkSpeedEdit.Value:=Min(1000,Max(1,Game.ScummVMTalkSpeed));
  SubtitlesCheckBox.Checked:=Game.ScummVMSubtitles;
end;

procedure TModernProfileEditorScummVMFrame.ShowFrame;
Var S : String;
    I : Integer;
    St : TStringList;
begin
  If LastGameName=CurrentGameName^ then exit;
  LastGameName:=CurrentGameName^;

  If LanguageComboBox.ItemIndex>=0 then S:=LanguageComboBox.Text else S:='';
  LanguageComboBox.Items.BeginUpdate;
  try
    LanguageComboBox.Items.Clear;
    For I:=Low(LangData) to High(LangData) do If LangData[I].Game=LastGameName then begin
      St:=ValueToList(LangData[I].Lang,','); try LanguageComboBox.Items.AddStrings(St); finally St.Free; end;
      break;
    end;
  finally
    LanguageComboBox.Items.EndUpdate;
  end;

  LanguageComboBox.Enabled:=(LanguageComboBox.Items.Count>0);
  LanguageLabel.Enabled:=(LanguageComboBox.Items.Count>0);

  If LanguageComboBox.Items.Count>0 then begin
    If S='' then LanguageComboBox.ItemIndex:=0 else begin
      I:=LanguageComboBox.Items.IndexOf(S);
      If I>=0 then LanguageComboBox.ItemIndex:=I;
    end;
  end;
end;

function TModernProfileEditorScummVMFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorScummVMFrame.GetGame(const Game: TGame);
begin
  If LanguageComboBox.ItemIndex>=0 then Game.ScummVMLanguage:=LanguageComboBox.Text else Game.ScummVMLanguage:='';
  Game.ScummVMAutosave:=AutosaveEdit.Value;
  Game.ScummVMTalkSpeed:=TalkSpeedEdit.Value;
  Game.ScummVMSubtitles:=SubtitlesCheckBox.Checked;
end;

end.
