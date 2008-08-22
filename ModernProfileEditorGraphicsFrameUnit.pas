unit ModernProfileEditorGraphicsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorGraphicsFrame = class(TFrame, IModernProfileEditorFrame)
    WindowResolutionLabel: TLabel;
    WindowResolutionComboBox: TComboBox;
    FullscreenResolutionLabel: TLabel;
    FullscreenResolutionComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    DoublebufferingCheckBox: TCheckBox;
    KeepAspectRatioCheckBox: TCheckBox;
    RenderLabel: TLabel;
    RenderComboBox: TComboBox;
    VideoCardLabel: TLabel;
    VideoCardComboBox: TComboBox;
    ScaleLabel: TLabel;
    ScaleComboBox: TComboBox;
    FrameSkipLabel: TLabel;
    FrameSkipEdit: TSpinEdit;
    TextModeLinesRadioGroup: TRadioGroup;
    GlideEmulationCheckBox: TCheckBox;
    VGASettingsGroupBox: TGroupBox;
    VGAChipsetLabel: TLabel;
    VGAChipsetComboBox: TComboBox;
    VideoRamLabel: TLabel;
    VideoRamComboBox: TComboBox;
    VGASettingsLabel: TLabel;
    FullscreenInfoLabel: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorGraphicsFrame }

procedure TModernProfileEditorGraphicsFrame.InitGUI(const InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(WindowResolutionComboBox);
  NoFlicker(FullscreenResolutionComboBox);
  NoFlicker(StartFullscreenCheckBox);
  NoFlicker(DoublebufferingCheckBox);
  NoFlicker(KeepAspectRatioCheckBox);
  NoFlicker(GlideEmulationCheckBox);
  NoFlicker(RenderComboBox);
  NoFlicker(VideoCardComboBox);
  NoFlicker(VGASettingsGroupBox);
  NoFlicker(VGAChipsetComboBox);
  NoFlicker(VideoRamComboBox);
  NoFlicker(ScaleComboBox);
  NoFlicker(FrameSkipEdit);
  NoFlicker(TextModeLinesRadioGroup);

  WindowResolutionLabel.Caption:=LanguageSetup.GameWindowResolution;
  St:=ValueToList(InitData.GameDB.ConfOpt.Resolution,';,'); try WindowResolutionComboBox.Items.AddStrings(St); finally St.Free; end;
  FullscreenResolutionLabel.Caption:=LanguageSetup.GameFullscreenResolution;
  St:=ValueToList(InitData.GameDB.ConfOpt.Resolution,';,'); try FullscreenResolutionComboBox.Items.AddStrings(St); finally St.Free; end;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  FullscreenInfoLabel.Caption:='('+LanguageSetup.GameStartFullscreenInfo+')';
  DoublebufferingCheckBox.Caption:=LanguageSetup.GameUseDoublebuffering;
  KeepAspectRatioCheckBox.Caption:=LanguageSetup.GameAspectCorrection;
  GlideEmulationCheckBox.Caption:=LanguageSetup.GameGlideEmulation;
  RenderLabel.Caption:=LanguageSetup.GameRender;
  St:=ValueToList(InitData.GameDB.ConfOpt.Render,';,'); try RenderComboBox.Items.AddStrings(St); finally St.Free; end;
  VideoCardLabel.Caption:=LanguageSetup.GameVideoCard;
  St:=ValueToList(InitData.GameDB.ConfOpt.Video,';,'); try VideoCardComboBox.Items.AddStrings(St); finally St.Free; end;
  VGASettingsGroupBox.Caption:=LanguageSetup.GameVGASettings;
  VGAChipsetLabel.Caption:=LanguageSetup.GameVGAChipset;
  St:=ValueToList(InitData.GameDB.ConfOpt.VGAChipsets,';,'); try VGAChipsetComboBox.Items.AddStrings(St); finally St.Free; end;
  VideoRamLabel.Caption:=LanguageSetup.GameVideoRam;
  St:=ValueToList(InitData.GameDB.ConfOpt.VGAVideoRAM,';,'); try VideoRamComboBox.Items.AddStrings(St); finally St.Free; end;
  VGASettingsLabel.Caption:=LanguageSetup.GameVGASettingsInfo;
  ScaleLabel.Caption:=LanguageSetup.GameScale;
  St:=ValueToList(InitData.GameDB.ConfOpt.Scale,';,'); try ScaleComboBox.Items.AddStrings(St); finally St.Free; end;
  FrameSkipLabel.Caption:=LanguageSetup.GameFrameskip;

  TextModeLinesRadioGroup.Caption:=LanguageSetup.GameTextModeLines;

  HelpContext:=ID_ProfileEditGraphics;
end;

procedure TModernProfileEditorGraphicsFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
    S,T : String;
begin
  S:=Trim(ExtUpperCase(Game.WindowResolution));
  WindowResolutionComboBox.ItemIndex:=0;
  For I:=0 to WindowResolutionComboBox.Items.Count-1 do If Trim(ExtUpperCase(WindowResolutionComboBox.Items[I]))=S then begin
    WindowResolutionComboBox.ItemIndex:=I; break;
  end;

  S:=Trim(ExtUpperCase(Game.FullscreenResolution));
  FullscreenResolutionComboBox.ItemIndex:=0;
  For I:=0 to FullscreenResolutionComboBox.Items.Count-1 do If Trim(ExtUpperCase(FullscreenResolutionComboBox.Items[I]))=S then begin
    FullscreenResolutionComboBox.ItemIndex:=I; break;
  end;

  StartFullscreenCheckBox.Checked:=Game.StartFullscreen;
  DoublebufferingCheckBox.Checked:=Game.UseDoublebuffering;
  KeepAspectRatioCheckBox.Checked:=Game.AspectCorrection;
  GlideEmulationCheckBox.Visible:=PrgSetup.AllowGlideSettings;
  If PrgSetup.AllowGlideSettings then GlideEmulationCheckBox.Checked:=Game.GlideEmulation;

  S:=Trim(ExtUpperCase(Game.Render));
  RenderComboBox.ItemIndex:=0;
  For I:=0 to RenderComboBox.Items.Count-1 do If Trim(ExtUpperCase(RenderComboBox.Items[I]))=S then begin
    RenderComboBox.ItemIndex:=I; break;
  end;

  S:=Trim(ExtUpperCase(Game.VideoCard));
  VideoCardComboBox.ItemIndex:=VideoCardComboBox.Items.Count-1;
  For I:=0 to VideoCardComboBox.Items.Count-1 do If Trim(ExtUpperCase(VideoCardComboBox.Items[I]))=S then begin
    VideoCardComboBox.ItemIndex:=I; break;
  end;

  VGASettingsGroupBox.Visible:=PrgSetup.AllowVGAChipsetSettings;
  If PrgSetup.AllowVGAChipsetSettings then begin
    If VGAChipsetComboBox.Items.Count>0 then VGAChipsetComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(Game.VGAChipset));
    For I:=0 to VGAChipsetComboBox.Items.Count-1 do If Trim(ExtUpperCase(VGAChipsetComboBox.Items[I]))=S then begin
      VGAChipsetComboBox.ItemIndex:=I;
      break;
    end;
    If VideoRamComboBox.Items.Count>0 then VideoRamComboBox.ItemIndex:=0;
    S:=Trim(ExtUpperCase(IntToStr(Game.VideoRam)));
    For I:=0 to VideoRamComboBox.Items.Count-1 do begin
      T:=Trim(ExtUpperCase(VideoRamComboBox.Items[I]));
      If T=S then begin VideoRamComboBox.ItemIndex:=I; break; end;
      If T='2048' then VideoRamComboBox.ItemIndex:=I;
    end;
  end;  

  S:=Trim(ExtUpperCase(Game.Scale));
  ScaleComboBox.ItemIndex:=0;
  For I:=0 to ScaleComboBox.Items.Count-1 do begin
    T:=Trim(ExtUpperCase(ScaleComboBox.Items[I]));
    If Pos('(',T)=0 then continue;
    T:=Copy(T,Pos('(',T)+1,MaxInt);
    If Pos(')',T)=0 then continue;
    T:=Copy(T,1,Pos(')',T)-1);
    If Trim(T)=S then begin ScaleComboBox.ItemIndex:=I; break; end;
  end;

  FrameSkipEdit.Value:=Game.FrameSkip;

  TextModeLinesRadioGroup.Visible:=PrgSetup.AllowTextModeLineChange;
  If PrgSetup.AllowTextModeLineChange then Case Game.TextModeLines of
    28 : TextModeLinesRadioGroup.ItemIndex:=1;
    50 : TextModeLinesRadioGroup.ItemIndex:=2;
    else TextModeLinesRadioGroup.ItemIndex:=0;
  end;
end;

procedure TModernProfileEditorGraphicsFrame.ShowFrame;
begin
end;

function TModernProfileEditorGraphicsFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorGraphicsFrame.GetGame(const Game: TGame);
Var S : String;
begin
  Game.WindowResolution:=WindowResolutionComboBox.Text;
  Game.FullscreenResolution:=FullscreenResolutionComboBox.Text;

  Game.StartFullscreen:=StartFullscreenCheckBox.Checked;
  Game.UseDoublebuffering:=DoublebufferingCheckBox.Checked;
  Game.AspectCorrection:=KeepAspectRatioCheckBox.Checked;
  If PrgSetup.AllowGlideSettings then Game.GlideEmulation:=GlideEmulationCheckBox.Checked;

  Game.Render:=RenderComboBox.Text;
  Game.VideoCard:=VideoCardComboBox.Text;

  If PrgSetup.AllowVGAChipsetSettings then begin
    Game.VGAChipset:=VGAChipsetComboBox.Text;
    try Game.VideoRam:=StrToInt(VideoRamComboBox.Text); except Game.VideoRam:=2048; end;
  end;  

  S:=ScaleComboBox.Text;
  If Pos('(',S)=0 then Game.Scale:='' else begin
    S:=Copy(S,Pos('(',S)+1,MaxInt);
    If Pos(')',S)=0 then Game.Scale:=''  else Game.Scale:=Copy(S,1,Pos(')',S)-1);
  end;
  Game.FrameSkip:=FrameSkipEdit.Value;

  If PrgSetup.AllowTextModeLineChange then Case TextModeLinesRadioGroup.ItemIndex of
    0 : Game.TextModeLines:=25;
    1 : Game.TextModeLines:=28;
    2 : Game.TextModeLines:=50;
  end;
end;

end.
