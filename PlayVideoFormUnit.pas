unit PlayVideoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, MPlayer, ExtCtrls, Menus, StdCtrls,
  Buttons;

type
  TPlayVideoForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    PreviousButton: TToolButton;
    NextButton: TToolButton;
    ToolButton1: TToolButton;
    SaveButton: TToolButton;
    ToolButton2: TToolButton;
    PlayPauseButton: TToolButton;
    SaveDialog: TSaveDialog;
    ImageList: TImageList;
    MediaPanel: TPanel;
    Panel1: TPanel;
    TrackBar: TTrackBar;
    Timer: TTimer;
    PopupMenu: TPopupMenu;
    StatusBar: TStatusBar;
    ToolButton3: TToolButton;
    ZoomButton: TToolButton;
    ZoomPopupMenu: TPopupMenu;
    ZoomMenuItem1: TMenuItem;
    ZoomMenuItem2: TMenuItem;
    ZoomMenuItem3: TMenuItem;
    ZoomMenuItem4: TMenuItem;
    ZoomMenuItem5: TMenuItem;
    ZoomMenuItem6: TMenuItem;
    ZoomMenuItem7: TMenuItem;
    ZoomMenuItem8: TMenuItem;
    ZoomMenuItem9: TMenuItem;
    ZoomMenuItem10: TMenuItem;
    ZoomMenuItem11: TMenuItem;
    ZoomMenuItem12: TMenuItem;
    InfoLabel: TLabel;
    InstallButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure InstallButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
    procedure CenterWindow;
    Function VideoFileDamaged : Boolean;
  public
    { Public-Deklarationen }
    FileName : String;
    PrevVideos, NextVideos : TStringList;
  end;

var
  PlayVideoForm: TPlayVideoForm;

Procedure PlayVideoDialog(const AOwner : TComponent; const AFileName : String; const APrevVideos, ANextVideos : TStringList);

implementation

uses ShellAPI, MediaInterface, VistaToolsUnit, LanguageSetupUnit, CommonTools,
     PrgSetupUnit;

{$R *.dfm}

procedure TPlayVideoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InfoLabel.Font.Color:=clWhite;

  PreviousButton.Caption:=LanguageSetup.Previous;
  NextButton.Caption:=LanguageSetup.Next;
  SaveButton.Caption:=LanguageSetup.Save;
  PlayPauseButton.Caption:=LanguageSetup.SoundCapturePlayPause;
  ZoomButton.Caption:=LanguageSetup.ViewImageFormZoomButton;
  InfoLabel.Caption:=LanguageSetup.CaptureVideosInstallCodecInfo;
  InstallButton.Caption:=LanguageSetup.CaptureVideosInstallCodec;

  JustChanging:=False;
  PrevVideos:=TStringList.Create;
  NextVideos:=TStringList.Create;
end;

procedure TPlayVideoForm.FormShow(Sender: TObject);
Var OK : Boolean;
begin
  PreviousButton.Enabled:=(PrevVideos.Count>0);
  NextButton.Enabled:=(NextVideos.Count>0);
  Caption:=LanguageSetup.CaptureVideos+' ['+MakeRelPath(FileName,PrgSetup.BaseDir)+']';

  If VideoFileDamaged then begin
    InfoLabel.Caption:=LanguageSetup.CaptureVideosVideoDamaged;
    InfoLabel.Visible:=True;
    InstallButton.Visible:=False;
    PlayPauseButton.Enabled:=False;
    Panel1.Visible:=False;
    exit;
  end else begin
    InfoLabel.Caption:=LanguageSetup.CaptureVideosInstallCodecInfo;
  end;

  loadMediaFile(FileName, MediaPanel.Handle);
  OK:= MediaStreamAvailable and VideoAvailable;
  InfoLabel.Visible:=not OK;
  InstallButton.Visible:=not OK;
  PlayPauseButton.Enabled:=Ok;
  Panel1.Visible:=Ok;

  if Ok then begin
    Width:=getVideoWidth+(Width-MediaPanel.ClientWidth+10);
    Height:=getCoupledVideoHeight(getVideoWidth)+(Height-MediaPanel.ClientHeight+10);
    setVideoPos(5, 5, MediaPanel.ClientWidth-10, MediaPanel.ClientHeight-10);
    StatusBar.Panels[1].Text:=IntToStr(getVideoWidth)+'x'+IntToStr(getCoupledVideoHeight(getVideoWidth));
    playMediaStream;
    TimerTimer(Sender);
  end;
end;

function TPlayVideoForm.VideoFileDamaged: Boolean;
Var FSt : TFileStream;
    S : String;
    C : Array[0..3] of Char;
begin
  result:=False;

  S:=MakeAbsPath(FileName,PrgSetup.BaseDir);
  if not FileExists(S) then exit;

  try FSt:=TFileStream.Create(S,fmOpenRead); except exit; end;
  try
    try FSt.ReadBuffer(C,4); except result:=True; exit; end;
    If (C[0]<>'R') or (C[1]<>'I') or (C[2]<>'F') or (C[3]<>'F') then begin result:=True; exit; end;
  finally
    FSt.Free;
  end;
end;

procedure TPlayVideoForm.FormDestroy(Sender: TObject);
begin
  freeMediaStream;
  PrevVideos.Free;
  NextVideos.Free;
end;

procedure TPlayVideoForm.FormResize(Sender: TObject);
Var D : Double;
    I : Integer;
begin
  if not VideoAvailable then exit;

  D:=getCoupledVideoHeight(1000000)/1000000;
  If MediaPanel.ClientHeight-10>=Round((MediaPanel.ClientWidth-10)*D) then begin
    {use full width}
    I:=Round((MediaPanel.ClientWidth-10)*D);
    setVideoPos(5, MediaPanel.ClientHeight div 2 - I div 2, MediaPanel.ClientWidth-10, I);
    StatusBar.Panels[2].Text:=IntToStr(Round((MediaPanel.ClientWidth-10)*100/getVideoWidth))+'%';
  end else begin
    {use full height}
    I:=Round((MediaPanel.ClientHeight-10)/D);
    setVideoPos(MediaPanel.ClientWidth div 2 - I div 2, 5, I, MediaPanel.ClientHeight-10);
    StatusBar.Panels[2].Text:=IntToStr(Round((MediaPanel.ClientHeight-10)*100/getCoupledVideoHeight(getVideoWidth)))+'%';
  end;
end;

procedure TPlayVideoForm.TimerTimer(Sender: TObject);
begin
  JustChanging:=True;
  try
    If getMediaStreamDuration>0 then begin
      TrackBar.Position:=Round(100*getMediaStreamPos/getMediaStreamDuration);
      StatusBar.Panels[0].Text:=FloatToStrF(getMediaStreamPos/1000/10000,ffFixed,15,3)+'/'+FloatToStrF(getMediaStreamDuration/1000/10000,ffFixed,15,3);
      StatusBar.Panels[3].Text:=FileName;
      If (getMediaStreamPos=getMediaStreamDuration) and MediaStreamPlayed then pauseMediaStream;
    end;
  finally
    JustChanging:=False;
  end;
end;

procedure TPlayVideoForm.TrackBarChange(Sender: TObject);
begin
  If JustChanging then exit;
  setMediaStreamPos(Round(TrackBar.Position*getMediaStreamDuration/100));
end;

procedure TPlayVideoForm.CenterWindow;
Var P : TForm;
begin
  P:=(Owner as TForm);

  Left:=(P.Left+P.Width div 2)-Width div 2;
  Top:=(P.Top+P.Height div 2)-Height div 2;
end;

procedure TPlayVideoForm.ButtonWork(Sender: TObject);
Var S : String;
    F : Double;
begin
  Case (Sender as TComponent).Tag of
    0 : If PrevVideos.Count>0 then begin
          freeMediaStream;
          NextVideos.Insert(0,FileName);
          FileName:=PrevVideos[PrevVideos.Count-1];
          PrevVideos.Delete(PrevVideos.Count-1);
          FormShow(Sender);
        end;
    1 : if NextVideos.Count>0 then begin
          freeMediaStream;
          PrevVideos.Add(FileName);
          FileName:=NextVideos[0];
          NextVideos.Delete(0);
          FormShow(Sender);
        end;
    2 : begin
          S:=ExtractFileExt(FileName);
          If (S<>'') and (S[1]='.') then S:=Copy(S,2,MaxInt);
          SaveDialog.DefaultExt:=S;
          SaveDialog.Title:=LanguageSetup.VideoCaptureSaveTitle;
          SaveDialog.Filter:=LanguageSetup.VideoCaptureSaveFilter;
          If not SaveDialog.Execute then exit;
          S:=SaveDialog.FileName;
          If not CopyFile(PChar(FileName),PChar(S),True) then MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[FileName,S]),mtError,[mbOK],0);
        end;
    3 : if VideoAvailable then begin
          If MediaStreamPlayed and (getMediaStreamPos<>getMediaStreamDuration) then pauseMediaStream else begin
            If getMediaStreamPos=getMediaStreamDuration then setMediaStreamPos(0);
            playMediaStream;
          end;
        end;
    4 : begin
          If WindowState=wsMaximized then WindowState:=wsNormal;
          S:=RemoveUnderline((Sender as TMenuItem).Caption);
          F:=StrToInt(Copy(S,1,length(S)-1))/100;
          Width:=Round(getVideoWidth*F)+(Width-MediaPanel.ClientWidth+10);
          Height:=Round(getCoupledVideoHeight(getVideoWidth)*F)+(Height-MediaPanel.ClientHeight+10);
          CenterWindow;
        end;
  end;
end;

procedure TPlayVideoForm.InstallButtonClick(Sender: TObject);
begin
  If not FileExists(PrgDir+'InstallVideoCodec.exe') then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[PrgDir+'InstallVideoCodec.exe']),mtError,[mbOK],0);
    exit;
  end;

  ShellExecute(Handle,'open',PChar(PrgDir+'InstallVideoCodec.exe'),PChar(ExcludeTrailingPathDelimiter(PrgSetup.DOSBoxSettings[0].DosBoxDir)),PChar(PrgDir),SW_SHOW);

  Close;
end;

{ global }

Procedure PlayVideoDialog(const AOwner : TComponent; const AFileName : String; const APrevVideos, ANextVideos : TStringList);
begin
  PlayVideoForm:=TPlayVideoForm.Create(AOwner);
  try
    PlayVideoForm.FileName:=AFileName;
    If APrevVideos<>nil then PlayVideoForm.PrevVideos.Assign(APrevVideos);
    If ANextVideos<>nil then PlayVideoForm.NextVideos.Assign(ANextVideos);
    PlayVideoForm.ShowModal;
  finally
    PlayVideoForm.Free;
  end;
end;

end.
