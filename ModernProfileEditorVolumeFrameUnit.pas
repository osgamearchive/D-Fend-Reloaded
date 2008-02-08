unit ModernProfileEditorVolumeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, Spin;

type
  TModernProfileEditorVolumeFrame = class(TFrame, IModernProfileEditorFrame)
    SoundVolumeLeftLabel: TLabel;
    SoundVolumeRightLabel: TLabel;
    SoundVolumeMasterLabel: TLabel;
    SoundVolumeDisneyLabel: TLabel;
    SoundVolumeSpeakerLabel: TLabel;
    SoundVolumeGUSLabel: TLabel;
    SoundVolumeSBLabel: TLabel;
    SoundVolumeFMLabel: TLabel;
    SoundVolumeMasterLeftEdit: TSpinEdit;
    SoundVolumeMasterRightEdit: TSpinEdit;
    SoundVolumeDisneyLeftEdit: TSpinEdit;
    SoundVolumeDisneyRightEdit: TSpinEdit;
    SoundVolumeSpeakerLeftEdit: TSpinEdit;
    SoundVolumeSpeakerRightEdit: TSpinEdit;
    SoundVolumeGUSLeftEdit: TSpinEdit;
    SoundVolumeGUSRightEdit: TSpinEdit;
    SoundVolumeSBLeftEdit: TSpinEdit;
    SoundVolumeSBRightEdit: TSpinEdit;
    SoundVolumeFMLeftEdit: TSpinEdit;
    SoundVolumeFMRightEdit: TSpinEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit;

{$R *.dfm}

{ TModernProfileEditorVolumeFrame }

procedure TModernProfileEditorVolumeFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName: PString);
begin
  NoFlicker(SoundVolumeMasterLeftEdit);
  NoFlicker(SoundVolumeMasterRightEdit);
  NoFlicker(SoundVolumeDisneyLeftEdit);
  NoFlicker(SoundVolumeDisneyRightEdit);
  NoFlicker(SoundVolumeSpeakerLeftEdit);
  NoFlicker(SoundVolumeSpeakerRightEdit);
  NoFlicker(SoundVolumeGUSLeftEdit);
  NoFlicker(SoundVolumeGUSRightEdit);
  NoFlicker(SoundVolumeSBLeftEdit);
  NoFlicker(SoundVolumeSBRightEdit);
  NoFlicker(SoundVolumeFMLeftEdit);
  NoFlicker(SoundVolumeFMRightEdit);

  SoundVolumeLeftLabel.Caption:=LanguageSetup.Left;
  SoundVolumeRightLabel.Caption:=LanguageSetup.Right;
  SoundVolumeMasterLabel.Caption:=LanguageSetup.ProfileEditorSoundMasterVolume;
  SoundVolumeDisneyLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscDisneySoundsSource;
  SoundVolumeSpeakerLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscPCSpeaker;
  SoundVolumeGUSLabel.Caption:=LanguageSetup.ProfileEditorSoundGUS;
  SoundVolumeSBLabel.Caption:=LanguageSetup.ProfileEditorSoundSoundBlaster;
  SoundVolumeFMLabel.Caption:=LanguageSetup.ProfileEditorSoundFM;
end;

procedure TModernProfileEditorVolumeFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SoundVolumeMasterLeftEdit.Value:=Game.MixerVolumeMasterLeft;
  SoundVolumeMasterRightEdit.Value:=Game.MixerVolumeMasterRight;
  SoundVolumeDisneyLeftEdit.Value:=Game.MixerVolumeDisneyLeft;
  SoundVolumeDisneyRightEdit.Value:=Game.MixerVolumeDisneyRight;
  SoundVolumeSpeakerLeftEdit.Value:=Game.MixerVolumeSpeakerLeft;
  SoundVolumeSpeakerRightEdit.Value:=Game.MixerVolumeSpeakerRight;
  SoundVolumeGUSLeftEdit.Value:=Game.MixerVolumeGUSLeft;
  SoundVolumeGUSRightEdit.Value:=Game.MixerVolumeGUSRight;
  SoundVolumeSBLeftEdit.Value:=Game.MixerVolumeSBLeft;
  SoundVolumeSBRightEdit.Value:=Game.MixerVolumeSBRight;
  SoundVolumeFMLeftEdit.Value:=Game.MixerVolumeFMLeft;
  SoundVolumeFMRightEdit.Value:=Game.MixerVolumeFMRight;
end;

function TModernProfileEditorVolumeFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorVolumeFrame.GetGame(const Game: TGame);
begin
  Game.MixerVolumeMasterLeft:=SoundVolumeMasterLeftEdit.Value;
  Game.MixerVolumeMasterRight:=SoundVolumeMasterRightEdit.Value;
  Game.MixerVolumeDisneyLeft:=SoundVolumeDisneyLeftEdit.Value;
  Game.MixerVolumeDisneyRight:=SoundVolumeDisneyRightEdit.Value;
  Game.MixerVolumeSpeakerLeft:=SoundVolumeSpeakerLeftEdit.Value;
  Game.MixerVolumeSpeakerRight:=SoundVolumeSpeakerRightEdit.Value;
  Game.MixerVolumeGUSLeft:=SoundVolumeGUSLeftEdit.Value;
  Game.MixerVolumeGUSRight:=SoundVolumeGUSRightEdit.Value;
  Game.MixerVolumeSBLeft:=SoundVolumeSBLeftEdit.Value;
  Game.MixerVolumeSBRight:=SoundVolumeSBRightEdit.Value;
  Game.MixerVolumeFMLeft:=SoundVolumeFMLeftEdit.Value;
  Game.MixerVolumeFMRight:=SoundVolumeFMRightEdit.Value;
end;

end.
