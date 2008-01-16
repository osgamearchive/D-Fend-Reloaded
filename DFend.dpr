program DFend;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {DFendReloadedMainForm},
  CommonComponents in 'CommonComponents.pas',
  CommonTools in 'CommonTools.pas',
  PrgSetupUnit in 'PrgSetupUnit.pas',
  SetupDosBoxFormUnit in 'SetupDosBoxFormUnit.pas' {SetupDosBoxForm},
  LanguageSetupUnit in 'LanguageSetupUnit.pas',
  PrgConsts in 'PrgConsts.pas',
  VistaToolsUnit in 'VistaToolsUnit.pas',
  GameDBUnit in 'GameDBUnit.pas',
  GameDBToolsUnit in 'GameDBToolsUnit.pas',
  ProfileEditorFormUnit in 'ProfileEditorFormUnit.pas' {ProfileEditorForm},
  SetupFormUnit in 'SetupFormUnit.pas' {SetupForm},
  IconManagerFormUnit in 'IconManagerFormUnit.pas' {IconManagerForm},
  ProfileMountEditorFormUnit in 'ProfileMountEditorFormUnit.pas' {ProfileMountEditorForm},
  DosBoxUnit in 'DosBoxUnit.pas',
  HistoryFormUnit in 'HistoryFormUnit.pas' {HistoryForm},
  TemplateFormUnit in 'TemplateFormUnit.pas' {TemplateForm},
  UninstallFormUnit in 'UninstallFormUnit.pas' {UninstallForm},
  UninstallSelectFormUnit in 'UninstallSelectFormUnit.pas' {UninstallSelectForm},
  pngimage in 'pngimage\pngimage.pas',
  ViewImageFormUnit in 'ViewImageFormUnit.pas' {ViewImageForm},
  CreateConfFormUnit in 'CreateConfFormUnit.pas' {CreateConfForm},
  TemplateSelectProfileFormUnit in 'TemplateSelectProfileFormUnit.pas' {TemplateSelectProfileForm},
  WizardFormUnit in 'WizardFormUnit.pas' {WizardForm},
  CreateShortcutFormUnit in 'CreateShortcutFormUnit.pas' {CreateShortcutForm},
  DiskImageToolsUnit in 'DiskImageToolsUnit.pas',
  CreateImageUnit in 'CreateImageUnit.pas' {CreateImageForm},
  InfoFormUnit in 'InfoFormUnit.pas' {InfoForm},
  TransferFormUnit in 'TransferFormUnit.pas' {TransferForm},
  BuildInstallerFormUnit in 'BuildInstallerFormUnit.pas' {BuildInstallerForm},
  ProgressFormUnit in 'ProgressFormUnit.pas' {ProgressForm},
  ResHookUnit in 'ResHookUnit.pas',
  SerialEditFormUnit in 'SerialEditFormUnit.pas' {SerialEditForm},
  ChangeProfilesFormUnit in 'ChangeProfilesFormUnit.pas' {ChangeProfilesForm},
  BuildInstallerForSingleGameFormUnit in 'BuildInstallerForSingleGameFormUnit.pas' {BuildInstallerForSingleGameForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'D-Fend Reloaded';
  Application.CreateForm(TDFendReloadedMainForm, DFendReloadedMainForm);
  Application.Run;
end.
