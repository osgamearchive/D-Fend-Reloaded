unit SetupFrameGamesListScreenshotAppearanceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Spin, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameGamesListScreenshotAppearance = class(TFrame, ISetupFrame)
    ScreenshotsListBackgroundRadioButton1: TRadioButton;
    ScreenshotsListBackgroundRadioButton2: TRadioButton;
    ScreenshotsListBackgroundColorBox: TColorBox;
    ScreenshotsListBackgroundRadioButton3: TRadioButton;
    ScreenshotsListBackgroundEdit: TEdit;
    ScreenshotsListBackgroundButton: TSpeedButton;
    ScreenshotsListFontSizeLabel: TLabel;
    ScreenshotsListFontSizeEdit: TSpinEdit;
    ScreenshotsListFontColorBox: TColorBox;
    ScreenshotsListFontColorLabel: TLabel;
    ScreenshotPreviewLabel: TLabel;
    ScreenshotPreviewEdit: TSpinEdit;
    ImageOpenDialog: TOpenDialog;
    procedure ScreenshotsListBackgroundColorBoxChange(Sender: TObject);
    procedure ScreenshotsListBackgroundEditChange(Sender: TObject);
    procedure ScreenshotsListBackgroundButtonClick(Sender: TObject);
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

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools;

{$R *.dfm}

{ TSetupFrameGamesListScreenshotAppearance }

function TSetupFrameGamesListScreenshotAppearance.GetName: String;
begin
  result:=LanguageSetup.SetupFormListViewSheet4;
end;

procedure TSetupFrameGamesListScreenshotAppearance.InitGUIAndLoadSetup(InitData: TInitData);
Var S : String;
    C : TColor;
begin
  PBaseDir:=InitData.PBaseDir;

  NoFlicker(ScreenshotsListBackgroundRadioButton1);
  NoFlicker(ScreenshotsListBackgroundRadioButton2);
  NoFlicker(ScreenshotsListBackgroundColorBox);
  NoFlicker(ScreenshotsListBackgroundRadioButton3);
  NoFlicker(ScreenshotsListBackgroundEdit);
  NoFlicker(ScreenshotsListFontSizeEdit);
  NoFlicker(ScreenshotsListFontColorBox);
  NoFlicker(ScreenshotPreviewEdit);

  S:=Trim(PrgSetup.ScreenshotsListViewBackground);
  If S='' then ScreenshotsListBackgroundRadioButton1.Checked:=True else begin
    try
      C:=StringToColor(S); ScreenshotsListBackgroundRadioButton2.Checked:=True; ScreenshotsListBackgroundColorBox.Selected:=C;
    except
      ScreenshotsListBackgroundRadioButton3.Checked:=True; ScreenshotsListBackgroundEdit.Text:=S;
    end;
  end;
  S:=Trim(PrgSetup.ScreenshotsListViewFontColor);
  If S='' then ScreenshotsListFontColorBox.Selected:=clWindowText else begin
    try ScreenshotsListFontColorBox.Selected:=StringToColor(S); except ScreenshotsListFontColorBox.Selected:=clWindowText; end;
  end;
  ScreenshotsListFontSizeEdit.Value:=PrgSetup.ScreenshotsListViewFontSize;
  ScreenshotPreviewEdit.Value:=Max(ScreenshotPreviewEdit.MinValue,Min(ScreenshotPreviewEdit.MaxValue,PrgSetup.ScreenshotPreviewSize));
end;

procedure TSetupFrameGamesListScreenshotAppearance.LoadLanguage;
Var GermanColorNames : Boolean;
begin
  GermanColorNames:=(ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI') or (ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='GERMAN.INI');

  ScreenshotsListBackgroundRadioButton1.Caption:=LanguageSetup.SetupFormBackgroundColorDefault;
  ScreenshotsListBackgroundRadioButton2.Caption:=LanguageSetup.SetupFormBackgroundColorColor;
  If GermanColorNames
    then ScreenshotsListBackgroundColorBox.Style:=ScreenshotsListBackgroundColorBox.Style+[cbPrettyNames]
    else ScreenshotsListBackgroundColorBox.Style:=ScreenshotsListBackgroundColorBox.Style-[cbPrettyNames];
  ScreenshotsListBackgroundRadioButton3.Caption:=LanguageSetup.SetupFormBackgroundColorFile;
  ScreenshotsListBackgroundButton.Hint:=LanguageSetup.ChooseFile;
  ScreenshotsListFontSizeLabel.Caption:=LanguageSetup.SetupFormFontSize;
  ScreenshotsListFontColorLabel.Caption:=LanguageSetup.SetupFormFontColor;
  If GermanColorNames
    then ScreenshotsListFontColorBox.Style:=ScreenshotsListFontColorBox.Style+[cbPrettyNames]
    else ScreenshotsListFontColorBox.Style:=ScreenshotsListFontColorBox.Style-[cbPrettyNames];
  ScreenshotPreviewLabel.Caption:=LanguageSetup.SetupFormScreenshotPreviewSize;
end;

procedure TSetupFrameGamesListScreenshotAppearance.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGamesListScreenshotAppearance.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameGamesListScreenshotAppearance.RestoreDefaults;
begin
  ScreenshotsListBackgroundRadioButton1.Checked:=True;
  ScreenshotsListBackgroundColorBox.Selected:=clBlack;
  ScreenshotsListBackgroundEdit.Text:='';
  ScreenshotsListFontSizeEdit.Value:=9;
  ScreenshotsListFontColorBox.Selected:=clBlack;
  ScreenshotPreviewEdit.Value:=100;
end;

procedure TSetupFrameGamesListScreenshotAppearance.SaveSetup;
begin
  If ScreenshotsListBackgroundRadioButton1.Checked then PrgSetup.ScreenshotsListViewBackground:='';
  If ScreenshotsListBackgroundRadioButton2.Checked then PrgSetup.ScreenshotsListViewBackground:=ColorToString(ScreenshotsListBackgroundColorBox.Selected);
  If ScreenshotsListBackgroundRadioButton3.Checked then PrgSetup.ScreenshotsListViewBackground:=ScreenshotsListBackgroundEdit.Text;
  PrgSetup.ScreenshotsListViewFontSize:=ScreenshotsListFontSizeEdit.Value;
  PrgSetup.ScreenshotsListViewFontColor:=ColorToString(ScreenshotsListFontColorBox.Selected);
  PrgSetup.ScreenshotPreviewSize:=ScreenshotPreviewEdit.Value;
end;

procedure TSetupFrameGamesListScreenshotAppearance.ScreenshotsListBackgroundColorBoxChange(Sender: TObject);
begin
  ScreenshotsListBackgroundRadioButton2.Checked:=True;
end;

procedure TSetupFrameGamesListScreenshotAppearance.ScreenshotsListBackgroundEditChange(Sender: TObject);
begin
  ScreenshotsListBackgroundRadioButton3.Checked:=True;
end;

procedure TSetupFrameGamesListScreenshotAppearance.ScreenshotsListBackgroundButtonClick(Sender: TObject);
Var S : String;
begin
  ImageOpenDialog.Title:=LanguageSetup.ScreenshotPopupImportTitle;
  ImageOpenDialog.Filter:=LanguageSetup.ScreenshotPopupImportFilter;
  S:=ScreenshotsListBackgroundEdit.Text;
  If Trim(S)='' then S:=IncludeTrailingPathDelimiter(PBaseDir^);
  S:=MakeAbsPath(S,IncludeTrailingPathDelimiter(PBaseDir^));
  ImageOpenDialog.InitialDir:=ExtractFilePath(S);
  If ImageOpenDialog.Execute then begin
    ScreenshotsListBackgroundEdit.Text:=MakeRelPath(ImageOpenDialog.FileName,IncludeTrailingPathDelimiter(PBaseDir^));
  end;
end;

end.
