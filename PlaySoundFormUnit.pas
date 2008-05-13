unit PlaySoundFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer, StdCtrls, ExtCtrls, ImgList, ComCtrls, ToolWin, Menus;

type
  TPlaySoundForm = class(TForm)
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    CloseButton: TToolButton;
    SaveButton: TToolButton;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    MenuSave: TMenuItem;
    MenuSaveMp3: TMenuItem;
    MenuSaveOgg: TMenuItem;
    ToolButton2: TToolButton;
    MediaPlayer: TMediaPlayer;
    SaveDialog: TSaveDialog;
    StatusBar: TStatusBar;
    TrackBar: TTrackBar;
    Timer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
  public
    { Public-Deklarationen }
    FileName : String;
  end;

var
  PlaySoundForm: TPlaySoundForm;

Procedure PlaySoundDialog(const AOwner : TComponent; const AFileName : String);

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

procedure TPlaySoundForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CaptureSounds;
  CloseButton.Caption:=LanguageSetup.Close;
  SaveButton.Caption:=LanguageSetup.Save;
  MenuSave.Caption:=LanguageSetup.ScreenshotPopupSave;
  MenuSaveMp3.Caption:=LanguageSetup.SoundsPopupSaveMp3;
  MenuSaveOgg.Caption:=LanguageSetup.SoundsPopupSaveOgg;

  MediaPlayer.TimeFormat:=tfMilliseconds;
  JustChanging:=False;
end;

procedure TPlaySoundForm.FormShow(Sender: TObject);
Var S : String;
begin
  Caption:=Caption+' ['+MakeRelPath(FileName,PrgSetup.BaseDir)+']';

  MediaPlayer.FileName:=FileName;
  MediaPlayer.Open;
  StatusBar.SimpleText:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
  MediaPlayer.Play;

  S:=ExtUpperCase(ExtractFileExt(FileName));
  MenuSaveMp3.Enabled:=(S='.WAV') and FileExists(PrgSetup.WaveEncMp3);
  MenuSaveOgg.Enabled:=(S='.WAV') and FileExists(PrgSetup.WaveEncOgg);
end;

procedure TPlaySoundForm.TimerTimer(Sender: TObject);
begin
  JustChanging:=True;
  try
    TrackBar.Position:=Round(100*MediaPlayer.Position/MediaPlayer.Length);
    StatusBar.SimpleText:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
  finally
    JustChanging:=False;
  end;
end;

procedure TPlaySoundForm.TrackBarChange(Sender: TObject);
begin
  If JustChanging then exit;
  MediaPlayer.Position:=Round(TrackBar.Position*MediaPlayer.Length/100);
  StatusBar.SimpleText:=FloatToStrF(MediaPlayer.Position/1000,ffFixed,15,3)+'/'+FloatToStrF(MediaPlayer.Length/1000,ffFixed,15,3);
end;

procedure TPlaySoundForm.ButtonWork(Sender: TObject);
Var P : TPoint;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : begin
          P:=ToolBar.ClientToScreen(Point(SaveButton.Left+5,SaveButton.Top+5));
          PopupMenu.Popup(P.X,P.Y);
        end;
    2 : begin
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
    3 : begin
          SaveDialog.DefaultExt:='mp3';
          SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
          SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveMP3Filter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncMp3),PChar(Format(PrgSetup.WaveEncMp3Parameters,[FileName,S])),nil,SW_SHOW);
        end;
    4 : begin
          SaveDialog.DefaultExt:='ogg';
          SaveDialog.Title:=LanguageSetup.SoundCaptureSaveTitle;
          SaveDialog.Filter:=LanguageSetup.SoundCaptureSaveOGGFilter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          ShellExecute(Handle,'open',PChar(PrgSetup.WaveEncOgg),PChar(Format(PrgSetup.WaveEncOggParameters,[FileName,S])),nil,SW_SHOW);
        end;
  end;
end;

{ global }

Procedure PlaySoundDialog(const AOwner : TComponent; const AFileName : String);
Var S : String;
begin
  S:=ExtUpperCase(ExtractFileExt(AFileName));
  If (S<>'.WAV') and (S<>'.MP3') then exit;
  PlaySoundForm:=TPlaySoundForm.Create(AOwner);
  try
    PlaySoundForm.FileName:=AFileName;
    PlaySoundForm.ShowModal;
  finally
    PlaySoundForm.Free;
  end; 
end;

end.
