unit SetupFrameWaveEncoderUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameWaveEncoder = class(TFrame, ISetupFrame)
    WaveEncMp3Button1: TSpeedButton;
    WaveEncMp3Button2: TSpeedButton;
    WaveEncOggButton1: TSpeedButton;
    WaveEncOggButton2: TSpeedButton;
    WaveEncMp3Edit: TLabeledEdit;
    WaveEncOggEdit: TLabeledEdit;
    PrgOpenDialog: TOpenDialog;
    WaveEncMp3ParameterEdit: TLabeledEdit;
    WaveEncOggParameterEdit: TLabeledEdit;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     SetupDosBoxFormUnit;

{$R *.dfm}

{ TSetupFrameWaveEncoder }

function TSetupFrameWaveEncoder.GetName: String;
begin
  result:=LanguageSetup.SetupFormWaveEnc;
end;

procedure TSetupFrameWaveEncoder.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(WaveEncMp3Edit);
  NoFlicker(WaveEncOggEdit);

  WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
  WaveEncMp3ParameterEdit.Text:=PrgSetup.WaveEncMp3Parameters;
  WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;
  WaveEncOggParameterEdit.Text:=PrgSetup.WaveEncOggParameters;
end;

procedure TSetupFrameWaveEncoder.LoadLanguage;
begin
  WaveEncMp3Edit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncMp3;
  WaveEncMp3Button1.Hint:=LanguageSetup.ChooseFile;
  WaveEncMp3Button2.Hint:=LanguageSetup.SetupFormSearchLame;
  WaveEncMp3ParameterEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncMp3Parameters;
  WaveEncOggEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncOgg;
  WaveEncOggButton1.Hint:=LanguageSetup.ChooseFile;
  WaveEncOggButton2.Hint:=LanguageSetup.SetupFormSearchOggEnc;
  WaveEncOggParameterEdit.EditLabel.Caption:=LanguageSetup.SetupFormWaveEncOggParameters;
end;

procedure TSetupFrameWaveEncoder.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameWaveEncoder.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameWaveEncoder.RestoreDefaults;
begin
  WaveEncMp3ParameterEdit.Text:='-h -V 0 "%s" "%s"';
  WaveEncOggParameterEdit.Text:='"%s" --output="%s" --quality=10';
end;

procedure TSetupFrameWaveEncoder.SaveSetup;
begin
  PrgSetup.WaveEncMp3:=WaveEncMp3Edit.Text;
  PrgSetup.WaveEncMp3Parameters:=WaveEncMp3ParameterEdit.Text;
  PrgSetup.WaveEncOgg:=WaveEncOggEdit.Text;
  PrgSetup.WaveEncOggParameters:=WaveEncOggParameterEdit.Text;
end;

procedure TSetupFrameWaveEncoder.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
   10 : begin
          S:=Trim(WaveEncMp3Edit.Text); If S<>'' then S:=ExtractFilePath(S);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncMp3;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncMp3Edit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   11 : if SearchLame(self) then WaveEncMp3Edit.Text:=PrgSetup.WaveEncMp3;
   12 : begin
          S:=Trim(WaveEncOggEdit.Text); If S<>'' then S:=ExtractFilePath(S);
          PrgOpenDialog.Title:=LanguageSetup.SetupFormWaveEncOgg;
          PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
          If S<>'' then PrgOpenDialog.InitialDir:=S;
          If PrgOpenDialog.Execute then begin
            WaveEncOggEdit.Text:=PrgOpenDialog.FileName;
          end;
        end;
   13 : if SearchOggEnc(self) then WaveEncOggEdit.Text:=PrgSetup.WaveEncOgg;
  end;
end;

end.
