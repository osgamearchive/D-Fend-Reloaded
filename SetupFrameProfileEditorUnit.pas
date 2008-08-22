unit SetupFrameProfileEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, SetupFormUnit;

type
  TSetupFrameProfileEditor = class(TFrame, ISetupFrame)
    ReopenLastActiveProfileSheetCheckBox: TCheckBox;
    ProfileEditorDFendRadioButton: TRadioButton;
    ProfileEditorModernRadioButton: TRadioButton;
    AutoSetScreenshotFolderRadioGroup: TRadioGroup;
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

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameProfileEditor }

function TSetupFrameProfileEditor.GetName: String;
begin
  result:=LanguageSetup.ProfileEditor;
end;

procedure TSetupFrameProfileEditor.InitGUIAndLoadSetup(InitData: TInitData);
begin
  NoFlicker(ReopenLastActiveProfileSheetCheckBox);
  NoFlicker(ProfileEditorDFendRadioButton);
  NoFlicker(ProfileEditorModernRadioButton);
  NoFlicker(AutoSetScreenshotFolderRadioGroup);

  ReopenLastActiveProfileSheetCheckBox.Checked:=PrgSetup.ReopenLastProfileEditorTab;
  ProfileEditorDFendRadioButton.Checked:=PrgSetup.DFendStyleProfileEditor;
  ProfileEditorModernRadioButton.Checked:=not PrgSetup.DFendStyleProfileEditor;
  If PrgSetup.AlwaysSetScreenshotFolderAutomatically then AutoSetScreenshotFolderRadioGroup.ItemIndex:=1 else AutoSetScreenshotFolderRadioGroup.ItemIndex:=0;
end;

procedure TSetupFrameProfileEditor.LoadLanguage;
begin
  ReopenLastActiveProfileSheetCheckBox.Caption:=LanguageSetup.SetupFormReopenLastActiveProfileSheet;
  ProfileEditorDFendRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorDFendStyle;
  ProfileEditorModernRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorModern;
  AutoSetScreenshotFolderRadioGroup.Caption:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolder;
  AutoSetScreenshotFolderRadioGroup.Items[0]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderOnlyWizard;
  AutoSetScreenshotFolderRadioGroup.Items[1]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderAlways;

  HelpContext:=ID_FileOptionsProfileEditor;
end;

procedure TSetupFrameProfileEditor.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameProfileEditor.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameProfileEditor.RestoreDefaults;
begin
  ReopenLastActiveProfileSheetCheckBox.Checked:=False;
  ProfileEditorModernRadioButton.Checked:=True;
  AutoSetScreenshotFolderRadioGroup.ItemIndex:=1;
end;

procedure TSetupFrameProfileEditor.SaveSetup;
begin
  PrgSetup.ReopenLastProfileEditorTab:=ReopenLastActiveProfileSheetCheckBox.Checked;
  PrgSetup.DFendStyleProfileEditor:=ProfileEditorDFendRadioButton.Checked;
  PrgSetup.AlwaysSetScreenshotFolderAutomatically:=(AutoSetScreenshotFolderRadioGroup.ItemIndex=1);
end;

end.
