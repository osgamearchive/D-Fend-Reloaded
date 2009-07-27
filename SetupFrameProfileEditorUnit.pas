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
    RenameProfFilesCheckBox: TCheckBox;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
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
  NoFlicker(RenameProfFilesCheckBox);

  ReopenLastActiveProfileSheetCheckBox.Checked:=PrgSetup.ReopenLastProfileEditorTab;
  ProfileEditorDFendRadioButton.Checked:=PrgSetup.DFendStyleProfileEditor;
  ProfileEditorModernRadioButton.Checked:=not PrgSetup.DFendStyleProfileEditor;
  If PrgSetup.AlwaysSetScreenshotFolderAutomatically then AutoSetScreenshotFolderRadioGroup.ItemIndex:=1 else AutoSetScreenshotFolderRadioGroup.ItemIndex:=0;
  RenameProfFilesCheckBox.Checked:=PrgSetup.RenameProfFileOnRenamingProfile;
end;

procedure TSetupFrameProfileEditor.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameProfileEditor.LoadLanguage;
begin
  ReopenLastActiveProfileSheetCheckBox.Caption:=LanguageSetup.SetupFormReopenLastActiveProfileSheet;
  ProfileEditorDFendRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorDFendStyle;
  ProfileEditorModernRadioButton.Caption:=LanguageSetup.SetupFormProfileEditorModern;
  AutoSetScreenshotFolderRadioGroup.Caption:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolder;
  AutoSetScreenshotFolderRadioGroup.Items[0]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderOnlyWizard;
  AutoSetScreenshotFolderRadioGroup.Items[1]:=LanguageSetup.SetupFormProfileEditorAutoSetScreenshotFolderAlways;
  RenameProfFilesCheckBox.Caption:=LanguageSetup.SetupFormProfileEditorRenameProfFilesOnRenamingProfile;

  HelpContext:=ID_FileOptionsProfileEditor;
end;

procedure TSetupFrameProfileEditor.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameProfileEditor.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameProfileEditor.HideFrame;
begin
end;

procedure TSetupFrameProfileEditor.RestoreDefaults;
begin
  ReopenLastActiveProfileSheetCheckBox.Checked:=False;
  ProfileEditorModernRadioButton.Checked:=True;
  AutoSetScreenshotFolderRadioGroup.ItemIndex:=1;
  RenameProfFilesCheckBox.Checked:=False;
end;

procedure TSetupFrameProfileEditor.SaveSetup;
begin
  PrgSetup.ReopenLastProfileEditorTab:=ReopenLastActiveProfileSheetCheckBox.Checked;
  PrgSetup.DFendStyleProfileEditor:=ProfileEditorDFendRadioButton.Checked;
  PrgSetup.AlwaysSetScreenshotFolderAutomatically:=(AutoSetScreenshotFolderRadioGroup.ItemIndex=1);
  PrgSetup.RenameProfFileOnRenamingProfile:=RenameProfFilesCheckBox.Checked;
end;

end.
