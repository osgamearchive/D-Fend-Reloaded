unit PlaySoundFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer, StdCtrls, ExtCtrls, ImgList, ComCtrls, ToolWin, Menus;

type
  TPlaySoundForm = class(TForm)
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    MenuSave: TMenuItem;
    MenuSaveMp3: TMenuItem;
    MenuSaveOgg: TMenuItem;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    TrackBar: TTrackBar;
    Timer: TTimer;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    SaveButton: TToolButton;
    ToolButton2: TToolButton;
    PreviousButton: TToolButton;
    NextButton: TToolButton;
    MediaPlayer: TMediaPlayer;
    PlayPauseButton: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
  public
    { Public-Deklarationen }
    FileDamaged : Boolean;
    FileName : String;
    PrevSounds, NextSounds : TStringList;
  end;

var
  PlaySoundForm: TPlaySoundForm;

Procedure PlaySoundDialog(const AOwner : TComponent; const AFileName : String; const APrevSounds, ANextSounds : TStringList);

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

procedure TPlaySoundForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  PreviousButton.Caption:=LanguageSetup.Previous;
  NextButton.Caption:=LanguageSetup.Next;
  SaveButton.Caption:=LanguageSetup.Save;
  PlayPauseButton.Caption:=LanguageSetup.SoundCapturePlayPause;
  MenuSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  MenuSaveMp3.Caption:=LanguageSetup.SoundsPopupSaveMp3;
  MenuSaveOgg.Caption:=LanguageSetup.SoundsPopupSaveOgg;

  MediaPlayer.TimeFormat:=tfMilliseconds;
  JustChanging:=False;

  PrevSounds:=TStringList.Create;
  NextSounds:=TStringList.Create;
end;

procedure TPlaySoundForm.FormShow(Sender: TObject);
Var S : String;
begin
  PreviousButton.Enabled:=(PrevSounds.Count>0);
  NextButton.Enabled:=(NextSounds.Count>0);

  Caption:=LanguageSetup.CaptureSounds+' ['+MakeRelPath(FileName,PrgSetup.BaseDir)+']';
  FileDamaged:=False;

  MediaPlayer.FileName:=FileName;
  try
    MediaPlayer.Open;
    StatusBar.Panels[0].Text:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
    MediaPlayer.Play;
    StatusBar.Panels[1].Text:=FileName;
  except
    MessageDlg(MediaPlayer.ErrorMessage,mtError,[mbOK],0);
    FileDamaged:=True;
  end;

  SaveButton.Enabled:=not FileDamaged;
  PlayPauseButton.Enabled:=not FileDamaged;

  S:=ExtUpperCase(ExtractFileExt(FileName));
  MenuSaveMp3.Enabled:=(S='.WAV') and FileExists(PrgSetup.WaveEncMp3);
  MenuSaveOgg.Enabled:=(S='.WAV') and FileExists(PrgSetup.WaveEncOgg);
end;

procedure TPlaySoundForm.FormDestroy(Sender: TObject);
begin
  PrevSounds.Free;
  NextSounds.Free;
end;

procedure TPlaySoundForm.TimerTimer(Sender: TObject);
begin
  If FileDamaged then exit;
  JustChanging:=True;
  try
    try
      TrackBar.Position:=Round(100*MediaPlayer.Position/MediaPlayer.Length);
      StatusBar.Panels[0].Text:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
    except end;
  finally
    JustChanging:=False;
  end;
end;

procedure TPlaySoundForm.TrackBarChange(Sender: TObject);
begin
  If JustChanging or FileDamaged then exit;
  MediaPlayer.Position:=Round(TrackBar.Position*MediaPlayer.Length/100);
  StatusBar.Panels[0].Text:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
end;

procedure TPlaySoundForm.ButtonWork(Sender: TObject);
Var P : TPoint;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : If PrevSounds.Count>0 then begin
          NextSounds.Insert(0,FileName);
          FileName:=PrevSounds[PrevSounds.Count-1];
          PrevSounds.Delete(PrevSounds.Count-1);
          FormShow(Sender);
        end;
    1 : if NextSounds.Count>0 then begin
          PrevSounds.Add(FileName);
          FileName:=NextSounds[0];
          NextSounds.Delete(0);
          FormShow(Sender);
        end;
    2 : begin
          P:=ToolBar.ClientToScreen(Point(SaveButton.Left+5,SaveButton.Top+5));
          PopupMenu.Popup(P.X,P.Y);
        end;
    3 : begin
          S:=ExtractFileExt(FileName);
          If (S<>'') and (S[1]='.') then S:=Copy(S,2,MaxInt);
          SaveDialog.DefaultExt:=S;
          SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
          S:=Trim(ExtUpperCase(S));
          SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveWAVFilter;
          If S='MP3' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
          If S='OGG' then SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          If not CopyFile(PChar(FileName),PChar(S),True) then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
        end;
    4 : begin
          SaveDialog.DefaultExt:='mp3';
          SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
          SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(Format(PrgSetup.WaveEncMp3Parameters,[FileName,S])),nil,SW_SHOW);
        end;
    5 : begin
          SaveDialog.DefaultExt:='ogg';
          SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
          SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(Format(PrgSetup.WaveEncOggParameters,[FileName,S])),nil,SW_SHOW);
        end;
    6 : If MediaPlayer.Mode=mpPlaying then MediaPlayer.Pause else MediaPlayer.Play;
  end;
end;

{ global }

Procedure PlaySoundDialog(const AOwner : TComponent; const AFileName : String; const APrevSounds, ANextSounds : TStringList);
Var S : String;
begin
  S:=ExtUpperCase(ExtractFileExt(AFileName));
  If (S<>'.WAV') and (S<>'.MP3') {and (S<>'.OGG')} then exit;
  PlaySoundForm:=TPlaySoundForm.Create(AOwner);
  try
    PlaySoundForm.FileName:=AFileName;
    If APrevSounds<>nil then PlaySoundForm.PrevSounds.Assign(APrevSounds);
    If ANextSounds<>nil then PlaySoundForm.NextSounds.Assign(ANextSounds);
    PlaySoundForm.ShowModal;
  finally
    PlaySoundForm.Free;
  end; 
end;

end.
