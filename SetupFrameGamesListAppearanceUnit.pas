unit SetupFrameGamesListAppearanceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameGamesListAppearance = class(TFrame, ISetupFrame)
    GamesListBackgroundRadioButton1: TRadioButton;
    GamesListBackgroundRadioButton2: TRadioButton;
    GamesListBackgroundRadioButton3: TRadioButton;
    GamesListBackgroundColorBox: TColorBox;
    GamesListBackgroundEdit: TEdit;
    GamesListBackgroundButton: TSpeedButton;
    GamesListFontSizeLabel: TLabel;
    GamesListFontSizeEdit: TSpinEdit;
    GamesListFontColorBox: TColorBox;
    GamesListFontColorLabel: TLabel;
    NotSetGroupBox: TGroupBox;
    NotSetRadioButton1: TRadioButton;
    NotSetRadioButton2: TRadioButton;
    NotSetRadioButton3: TRadioButton;
    NotSetEdit: TEdit;
    ImageOpenDialog: TOpenDialog;
    procedure GamesListBackgroundColorBoxChange(Sender: TObject);
    procedure GamesListBackgroundEditChange(Sender: TObject);
    procedure GamesListBackgroundButtonClick(Sender: TObject);
    procedure NotSetEditChange(Sender: TObject);
  private
    { Private-Deklarationen }
    PBaseDir : PString;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools;

{$R *.dfm}

{ TSetupFrameGamesListAppearance }

function TSetupFrameGamesListAppearance.GetName: String;
begin
  result:=LanguageSetup.SetupFormListViewSheet2;
end;

procedure TSetupFrameGamesListAppearance.InitGUIAndLoadSetup(InitData: TInitData);
Var S : String;
    C : TColor;
begin
  PBaseDir:=InitData.PBaseDir;

  NoFlicker(GamesListBackgroundRadioButton1);
  NoFlicker(GamesListBackgroundRadioButton2);
  NoFlicker(GamesListBackgroundColorBox);
  NoFlicker(GamesListBackgroundRadioButton3);
  NoFlicker(GamesListBackgroundEdit);
  NoFlicker(GamesListFontSizeEdit);
  NoFlicker(GamesListFontColorBox);
  NoFlicker(NotSetGroupBox);
  NoFlicker(NotSetRadioButton1);
  NoFlicker(NotSetRadioButton2);
  NoFlicker(NotSetRadioButton3);
  NoFlicker(NotSetEdit);

  S:=Trim(PrgSetup.GamesListViewBackground);
  If S='' then GamesListBackgroundRadioButton1.Checked:=True else begin
    try
      C:=StringToColor(S); GamesListBackgroundRadioButton2.Checked:=True; GamesListBackgroundColorBox.Selected:=C;
    except
      GamesListBackgroundRadioButton3.Checked:=True; GamesListBackgroundEdit.Text:=S;
    end;
  end;
  S:=Trim(PrgSetup.GamesListViewFontColor);
  If S='' then GamesListFontColorBox.Selected:=clWindowText else begin
    try GamesListFontColorBox.Selected:=StringToColor(S); except GamesListFontColorBox.Selected:=clWindowText; end;
  end;
  GamesListFontSizeEdit.Value:=PrgSetup.GamesListViewFontSize;
  S:=Trim(PrgSetup.ValueForNotSet);
  NotSetRadioButton1.Checked:=(S='');
  NotSetRadioButton2.Checked:=(S='-');
  NotSetRadioButton3.Checked:=(S<>'') and (S<>'-');
  If NotSetRadioButton3.Checked then NotSetEdit.Text:=S;
end;

procedure TSetupFrameGamesListAppearance.LoadLanguage;
Var GermanColorNames : Boolean;
begin
  GermanColorNames:=(ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI') or (ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='GERMAN.INI');

  GamesListBackgroundRadioButton1.Caption:=LanguageSetup.SetupFormBackgroundColorDefault;
  GamesListBackgroundRadioButton2.Caption:=LanguageSetup.SetupFormBackgroundColorColor;
  If GermanColorNames
    then GamesListBackgroundColorBox.Style:=GamesListBackgroundColorBox.Style+[cbPrettyNames]
    else GamesListBackgroundColorBox.Style:=GamesListBackgroundColorBox.Style-[cbPrettyNames];
  GamesListBackgroundRadioButton3.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  GamesListBackgroundButton.Hint:=LanguageSetup.ChooseFile;
  GamesListFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;
  GamesListFontColorLabel.Caption:=LanguageSetup.SetupFormFontColor;
  If GermanColorNames
    then GamesListFontColorBox.Style:=GamesListFontColorBox.Style+[cbPrettyNames]
    else GamesListFontColorBox.Style:=GamesListFontColorBox.Style-[cbPrettyNames];
  NotSetGroupBox.Caption:=LanguageSetup.ValueForNotSet+' "'+LanguageSetup.NotSet+'"';
  NotSetRadioButton1.Caption:='"'+LanguageSetup.NotSet+'"';
end;

procedure TSetupFrameGamesListAppearance.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGamesListAppearance.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameGamesListAppearance.RestoreDefaults;
begin
  GamesListBackgroundColorBox.Selected:=clBlack;
  GamesListBackgroundEdit.Text:='';
  GamesListBackgroundRadioButton1.Checked:=True;

  GamesListFontSizeEdit.Value:=9;
  GamesListFontColorBox.Selected:=clBlack;

  NotSetEdit.Text:='';
  NotSetRadioButton1.Checked:=True;
end;

procedure TSetupFrameGamesListAppearance.SaveSetup;
begin
  If GamesListBackgroundRadioButton1.Checked then PrgSetup.GamesListViewBackground:='';
  If GamesListBackgroundRadioButton2.Checked then PrgSetup.GamesListViewBackground:=ColorToString(GamesListBackgroundColorBox.Selected);
  If GamesListBackgroundRadioButton3.Checked then PrgSetup.GamesListViewBackground:=GamesListBackgroundEdit.Text;
  PrgSetup.GamesListViewFontSize:=GamesListFontSizeEdit.Value;
  PrgSetup.GamesListViewFontColor:=ColorToString(GamesListFontColorBox.Selected);
  If NotSetRadioButton1.Checked then PrgSetup.ValueForNotSet:='';
  If NotSetRadioButton2.Checked then PrgSetup.ValueForNotSet:='-';
  If NotSetRadioButton3.Checked then PrgSetup.ValueForNotSet:=NotSetEdit.Text;
end;

procedure TSetupFrameGamesListAppearance.GamesListBackgroundColorBoxChange(Sender: TObject);
begin
  GamesListBackgroundRadioButton2.Checked:=True;
end;

procedure TSetupFrameGamesListAppearance.GamesListBackgroundEditChange(Sender: TObject);
begin
  GamesListBackgroundRadioButton3.Checked:=True;
end;

procedure TSetupFrameGamesListAppearance.GamesListBackgroundButtonClick(Sender: TObject);
Var S : String;
begin
  ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
  ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
  S:=GamesListBackgroundEdit.Text;
  If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
  S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
  ImageOpenDialog.InitialDir:=ExtractFilePath(S);
  If ImageOpenDialog.Execute then begin
    GamesListBackgroundEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(PBaseDir^));
  end;
end;

procedure TSetupFrameGamesListAppearance.NotSetEditChange(Sender: TObject);
begin
  NotSetRadioButton3.Checked:=True;
end;

end.