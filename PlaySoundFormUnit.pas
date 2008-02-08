unit PlaySoundFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPlayer;

type
  TPlaySoundForm = class(TForm)
    MediaPlayer: TMediaPlayer;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    FileName : String;
  end;

var
  PlaySoundForm: TPlaySoundForm;

Procedure PlaySoundDialog(const AOwner : TComponent; const AFileName : String);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

procedure TPlaySoundForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.CaptureSounds;

  MediaPlayer.FileName:=FileName;
  MediaPlayer.Open;
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
