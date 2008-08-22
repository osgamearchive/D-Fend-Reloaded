unit ModernProfileEditorVolumeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, Spin, ComCtrls;

type
  TModernProfileEditorVolumeFrame = class(TFrame, IModernProfileEditorFrame)
    SoundVolumeLeftLabel1: TLabel;
    SoundVolumeRightLabel1: TLabel;
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
    SoundVolumeMasterLeftTrackBar: TTrackBar;
    SoundVolumeMasterRightTrackBar: TTrackBar;
    SoundVolumeLeftLabel2: TLabel;
    SoundVolumeRightLabel2: TLabel;
    SoundVolumeDisneyLeftTrackBar: TTrackBar;
    SoundVolumeDisneyRightTrackBar: TTrackBar;
    SoundVolumeLeftLabel3: TLabel;
    SoundVolumeRightLabel3: TLabel;
    SoundVolumeSpeakerLeftTrackBar: TTrackBar;
    SoundVolumeSpeakerRightTrackBar: TTrackBar;
    SoundVolumeGUSLeftTrackBar: TTrackBar;
    SoundVolumeGUSRightTrackBar: TTrackBar;
    SoundVolumeLeftLabel4: TLabel;
    SoundVolumeRightLabel4: TLabel;
    SoundVolumeSBLeftTrackBar: TTrackBar;
    SoundVolumeSBRightTrackBar: TTrackBar;
    SoundVolumeLeftLabel5: TLabel;
    SoundVolumeRightLabel5: TLabel;
    SoundVolumeFMLeftTrackBar: TTrackBar;
    SoundVolumeFMRightTrackBar: TTrackBar;
    SoundVolumeLeftLabel6: TLabel;
    SoundVolumeRightLabel6: TLabel;
    procedure SpinEditChange(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorVolumeFrame }

procedure TModernProfileEditorVolumeFrame.InitGUI(const InitData : TModernProfileEditorInitData);
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

  SoundVolumeLeftLabel1.Caption:=LanguageSetup.Left;
  SoundVolumeLeftLabel2.Caption:=LanguageSetup.Left;
  SoundVolumeLeftLabel3.Caption:=LanguageSetup.Left;
  SoundVolumeLeftLabel4.Caption:=LanguageSetup.Left;
  SoundVolumeLeftLabel5.Caption:=LanguageSetup.Left;
  SoundVolumeLeftLabel6.Caption:=LanguageSetup.Left;
  SoundVolumeRightLabel1.Caption:=LanguageSetup.Right;
  SoundVolumeRightLabel2.Caption:=LanguageSetup.Right;
  SoundVolumeRightLabel3.Caption:=LanguageSetup.Right;
  SoundVolumeRightLabel4.Caption:=LanguageSetup.Right;
  SoundVolumeRightLabel5.Caption:=LanguageSetup.Right;
  SoundVolumeRightLabel6.Caption:=LanguageSetup.Right;
  SoundVolumeMasterLabel.Caption:=LanguageSetup.ProfileEditorSoundMasterVolume;
  SoundVolumeDisneyLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscDisneySoundsSource;
  SoundVolumeSpeakerLabel.Caption:=LanguageSetup.ProfileEditorSoundMiscPCSpeaker;
  SoundVolumeGUSLabel.Caption:=LanguageSetup.ProfileEditorSoundGUS;
  SoundVolumeSBLabel.Caption:=LanguageSetup.ProfileEditorSoundSoundBlaster;
  SoundVolumeFMLabel.Caption:=LanguageSetup.ProfileEditorSoundFM;

  JustChanging:=False;

  HelpContext:=ID_ProfileEditSoundVolume;
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

  SpinEditChange(self);
end;

procedure TModernProfileEditorVolumeFrame.ShowFrame;
begin
end;

procedure TModernProfileEditorVolumeFrame.SpinEditChange(Sender: TObject);
begin
  If JustChanging then exit;
  JustChanging:=True;
  try
    SoundVolumeMasterLeftTrackBar.Position:=100-SoundVolumeMasterLeftEdit.Value;
    SoundVolumeMasterRightTrackBar.Position:=100-SoundVolumeMasterRightEdit.Value;
    SoundVolumeDisneyLeftTrackBar.Position:=100-SoundVolumeDisneyLeftEdit.Value;
    SoundVolumeDisneyRightTrackBar.Position:=100-SoundVolumeDisneyRightEdit.Value;
    SoundVolumeSpeakerLeftTrackBar.Position:=100-SoundVolumeSpeakerLeftEdit.Value;
    SoundVolumeSpeakerRightTrackBar.Position:=100-SoundVolumeSpeakerRightEdit.Value;
    SoundVolumeGUSLeftTrackBar.Position:=100-SoundVolumeGUSLeftEdit.Value;
    SoundVolumeGUSRightTrackBar.Position:=100-SoundVolumeGUSRightEdit.Value;
    SoundVolumeSBLeftTrackBar.Position:=100-SoundVolumeSBLeftEdit.Value;
    SoundVolumeSBRightTrackBar.Position:=100-SoundVolumeSBRightEdit.Value;
    SoundVolumeFMLeftTrackBar.Position:=100-SoundVolumeFMLeftEdit.Value;
    SoundVolumeFMRightTrackBar.Position:=100-SoundVolumeFMRightEdit.Value;
  finally
    JustChanging:=False;
  end;
end;

procedure TModernProfileEditorVolumeFrame.TrackBarChange(Sender: TObject);
begin
  If JustChanging then exit;
  JustChanging:=True;
  try
    SoundVolumeMasterLeftEdit.Value:=100-SoundVolumeMasterLeftTrackBar.Position;
    SoundVolumeMasterRightEdit.Value:=100-SoundVolumeMasterRightTrackBar.Position;
    SoundVolumeDisneyLeftEdit.Value:=100-SoundVolumeDisneyLeftTrackBar.Position;
    SoundVolumeDisneyRightEdit.Value:=100-SoundVolumeDisneyRightTrackBar.Position;
    SoundVolumeSpeakerLeftEdit.Value:=100-SoundVolumeSpeakerLeftTrackBar.Position;
    SoundVolumeSpeakerRightEdit.Value:=100-SoundVolumeSpeakerRightTrackBar.Position;
    SoundVolumeGUSLeftEdit.Value:=100-SoundVolumeGUSLeftTrackBar.Position;
    SoundVolumeGUSRightEdit.Value:=100-SoundVolumeGUSRightTrackBar.Position;
    SoundVolumeSBLeftEdit.Value:=100-SoundVolumeSBLeftTrackBar.Position;
    SoundVolumeSBRightEdit.Value:=100-SoundVolumeSBRightTrackBar.Position;
    SoundVolumeFMLeftEdit.Value:=100-SoundVolumeFMLeftTrackBar.Position;
    SoundVolumeFMRightEdit.Value:=100-SoundVolumeFMRightTrackBar.Position;
  finally
    JustChanging:=False;
  end;
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
