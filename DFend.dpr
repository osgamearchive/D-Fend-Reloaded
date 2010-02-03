program DFend;

uses
  FastMM4 in 'FastMM4.pas',
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
  IconManagerFormUnit in 'IconManagerFormUnit.pas' {IconManagerForm},
  ProfileMountEditorFormUnit in 'ProfileMountEditorFormUnit.pas' {ProfileMountEditorForm},
  DosBoxUnit in 'DosBoxUnit.pas',
  HistoryFormUnit in 'HistoryFormUnit.pas' {HistoryForm},
  TemplateFormUnit in 'TemplateFormUnit.pas' {TemplateForm},
  UninstallFormUnit in 'UninstallFormUnit.pas' {UninstallForm},
  UninstallSelectFormUnit in 'UninstallSelectFormUnit.pas' {UninstallSelectForm},
  ViewImageFormUnit in 'ViewImageFormUnit.pas' {ViewImageForm},
  CreateConfFormUnit in 'CreateConfFormUnit.pas' {CreateConfForm},
  TemplateSelectProfileFormUnit in 'TemplateSelectProfileFormUnit.pas' {TemplateSelectProfileForm},
  WizardFormUnit in 'WizardFormUnit.pas' {WizardForm},
  CreateShortcutFormUnit in 'CreateShortcutFormUnit.pas' {CreateShortcutForm},
  CreateImageUnit in 'CreateImageUnit.pas' {CreateImageForm},
  InfoFormUnit in 'InfoFormUnit.pas' {InfoForm},
  TransferFormUnit in 'TransferFormUnit.pas' {TransferForm},
  BuildInstallerFormUnit in 'BuildInstallerFormUnit.pas' {BuildInstallerForm},
  ResHookUnit in 'ResHookUnit.pas',
  SerialEditFormUnit in 'SerialEditFormUnit.pas' {SerialEditForm},
  BuildInstallerForSingleGameFormUnit in 'BuildInstallerForSingleGameFormUnit.pas' {BuildInstallerForSingleGameForm},
  UserInfoFormUnit in 'UserInfoFormUnit.pas' {UserInfoForm},
  ModernProfileEditorFormUnit in 'ModernProfileEditorFormUnit.pas' {ModernProfileEditorForm},
  ModernProfileEditorBaseFrameUnit in 'ModernProfileEditorBaseFrameUnit.pas' {ModernProfileEditorBaseFrame: TFrame},
  ModernProfileEditorGameInfoFrameUnit in 'ModernProfileEditorGameInfoFrameUnit.pas' {ModernProfileEditorGameInfoFrame: TFrame},
  ModernProfileEditorDirectoryFrameUnit in 'ModernProfileEditorDirectoryFrameUnit.pas' {ModernProfileEditorDirectoryFrame: TFrame},
  ModernProfileEditorDOSBoxFrameUnit in 'ModernProfileEditorDOSBoxFrameUnit.pas' {ModernProfileEditorDOSBoxFrame: TFrame},
  ModernProfileEditorHardwareFrameUnit in 'ModernProfileEditorHardwareFrameUnit.pas' {ModernProfileEditorHardwareFrame: TFrame},
  ModernProfileEditorCPUFrameUnit in 'ModernProfileEditorCPUFrameUnit.pas' {ModernProfileEditorCPUFrame: TFrame},
  ModernProfileEditorMemoryFrameUnit in 'ModernProfileEditorMemoryFrameUnit.pas' {ModernProfileEditorMemoryFrame: TFrame},
  ModernProfileEditorGraphicsFrameUnit in 'ModernProfileEditorGraphicsFrameUnit.pas' {ModernProfileEditorGraphicsFrame: TFrame},
  ListViewImageUnit in 'ListViewImageUnit.pas',
  ModernProfileEditorKeyboardFrameUnit in 'ModernProfileEditorKeyboardFrameUnit.pas' {ModernProfileEditorKeyboardFrame: TFrame},
  StatisticsFormUnit in 'StatisticsFormUnit.pas' {StatisticsForm},
  ModernProfileEditorSoundFrameUnit in 'ModernProfileEditorSoundFrameUnit.pas' {ModernProfileEditorSoundFrame: TFrame},
  ModernProfileEditorSoundBlasterFrameUnit in 'ModernProfileEditorSoundBlasterFrameUnit.pas' {ModernProfileEditorSoundBlasterFrame: TFrame},
  ModernProfileEditorGUSFrameUnit in 'ModernProfileEditorGUSFrameUnit.pas' {ModernProfileEditorGUSFrame: TFrame},
  ModernProfileEditorMIDIFrameUnit in 'ModernProfileEditorMIDIFrameUnit.pas' {ModernProfileEditorMIDIFrame: TFrame},
  ModernProfileEditorJoystickFrameUnit in 'ModernProfileEditorJoystickFrameUnit.pas' {ModernProfileEditorJoystickFrame: TFrame},
  ModernProfileEditorDrivesFrameUnit in 'ModernProfileEditorDrivesFrameUnit.pas' {ModernProfileEditorDrivesFrame: TFrame},
  ModernProfileEditorSerialPortsFrameUnit in 'ModernProfileEditorSerialPortsFrameUnit.pas' {ModernProfileEditorSerialPortsFrame: TFrame},
  ModernProfileEditorSerialPortFrameUnit in 'ModernProfileEditorSerialPortFrameUnit.pas' {ModernProfileEditorSerialPortFrame: TFrame},
  ModernProfileEditorNetworkFrameUnit in 'ModernProfileEditorNetworkFrameUnit.pas' {ModernProfileEditorNetworkFrame: TFrame},
  ModernProfileEditorDOSEnvironmentFrameUnit in 'ModernProfileEditorDOSEnvironmentFrameUnit.pas' {ModernProfileEditorDOSEnvironmentFrame: TFrame},
  ModernProfileEditorStartFrameUnit in 'ModernProfileEditorStartFrameUnit.pas' {ModernProfileEditorStartFrame: TFrame},
  CacheChooseFormUnit in 'CacheChooseFormUnit.pas' {CacheChooseForm},
  ModernProfileEditorMouseFrameUnit in 'ModernProfileEditorMouseFrameUnit.pas' {ModernProfileEditorMouseFrame: TFrame},
  ModernProfileEditorVolumeFrameUnit in 'ModernProfileEditorVolumeFrameUnit.pas' {ModernProfileEditorVolumeFrame: TFrame},
  IconLoaderUnit in 'IconLoaderUnit.pas',
  LanguageEditorStartFormUnit in 'LanguageEditorStartFormUnit.pas' {LanguageEditorStartForm},
  LanguageEditorFormUnit in 'LanguageEditorFormUnit.pas' {LanguageEditorForm},
  PlaySoundFormUnit in 'PlaySoundFormUnit.pas' {PlaySoundForm},
  WallpaperStyleFormUnit in 'WallpaperStyleFormUnit.pas' {WallpaperStyleForm},
  CreateISOImageFormUnit in 'CreateISOImageFormUnit.pas' {CreateISOImageForm},
  ReadDriveUnit in 'ReadDriveUnit.pas',
  DriveReadFormUnit in 'DriveReadFormUnit.pas' {DriveReadForm},
  HashCalc in 'HashCalc.pas',
  SelectProfilesFormUnit in 'SelectProfilesFormUnit.pas' {SelectProfilesForm},
  SimpleXMLUnit in 'SimpleXMLUnit.pas',
  CreateXMLFormUnit in 'CreateXMLFormUnit.pas' {CreateXMLForm},
  ExpandImageFormUnit in 'ExpandImageFormUnit.pas' {ExpandImageForm},
  FirstRunWizardFormUnit in 'FirstRunWizardFormUnit.pas' {FirstRunWizardForm},
  WizardPrgFileUnit in 'WizardPrgFileUnit.pas' {WizardPrgFileFrame: TFrame},
  WizardBaseUnit in 'WizardBaseUnit.pas' {WizardBaseFrame: TFrame},
  WizardTemplateUnit in 'WizardTemplateUnit.pas' {WizardTemplateFrame: TFrame},
  WizardFinishUnit in 'WizardFinishUnit.pas' {WizardFinishFrame: TFrame},
  WizardGameInfoUnit in 'WizardGameInfoUnit.pas' {WizardGameInfoFrame: TFrame},
  BuildImageFromFolderFormUnit in 'BuildImageFromFolderFormUnit.pas' {BuildImageFromFolderForm},
  ImageTools in 'ImageTools.pas',
  SmallWaitFormUnit in 'SmallWaitFormUnit.pas' {SmallWaitForm},
  MiniRunFormUnit in 'MiniRunFormUnit.pas' {MiniRunForm},
  ScummVMToolsUnit in 'ScummVMToolsUnit.pas',
  ModernProfileEditorScummVMGraphicsFrameUnit in 'ModernProfileEditorScummVMGraphicsFrameUnit.pas' {ModernProfileEditorScummVMGraphicsFrame: TFrame},
  ModernProfileEditorScummVMFrameUnit in 'ModernProfileEditorScummVMFrameUnit.pas' {ModernProfileEditorScummVMFrame: TFrame},
  ModernProfileEditorScummVMSoundFrameUnit in 'ModernProfileEditorScummVMSoundFrameUnit.pas' {ModernProfileEditorScummVMSoundFrame: TFrame},
  ScummVMUnit in 'ScummVMUnit.pas',
  ListScummVMGamesFormUnit in 'ListScummVMGamesFormUnit.pas' {ListScummVMGamesForm},
  WizardScummVMUnit in 'WizardScummVMUnit.pas' {WizardScummVMFrame: TFrame},
  WizardScummVMSettingsUnit in 'WizardScummVMSettingsUnit.pas' {WizardScummVMSettingsFrame: TFrame},
  DragNDropErrorFormUnit in 'DragNDropErrorFormUnit.pas' {DragNDropErrorForm},
  ChecksumFormUnit in 'ChecksumFormUnit.pas' {ChecksumForm},
  ModernProfileEditorPrinterFrameUnit in 'ModernProfileEditorPrinterFrameUnit.pas' {ModernProfileEditorPrinterFrame: TFrame},
  SetupFormUnit in 'SetupFormUnit.pas' {SetupForm},
  SetupFrameBaseUnit in 'SetupFrameBaseUnit.pas' {SetupFrameBase: TFrame},
  SetupFrameSurfaceUnit in 'SetupFrameSurfaceUnit.pas' {SetupFrameSurface: TFrame},
  SetupFrameToolbarUnit in 'SetupFrameToolbarUnit.pas' {SetupFrameToolbar: TFrame},
  SetupFrameDirectoriesUnit in 'SetupFrameDirectoriesUnit.pas' {SetupFrameDirectories: TFrame},
  SetupFrameLanguageUnit in 'SetupFrameLanguageUnit.pas' {SetupFrameLanguage: TFrame},
  SetupFrameGamesListColumnsUnit in 'SetupFrameGamesListColumnsUnit.pas' {SetupFrameGamesListColumns: TFrame},
  SetupFrameGamesListAppearanceUnit in 'SetupFrameGamesListAppearanceUnit.pas' {SetupFrameGamesListAppearance: TFrame},
  SetupFrameGamesListTreeAppearanceUnit in 'SetupFrameGamesListTreeAppearanceUnit.pas' {SetupFrameGamesListTreeAppearance: TFrame},
  SetupFrameGamesListScreenshotAppearanceUnit in 'SetupFrameGamesListScreenshotAppearanceUnit.pas' {SetupFrameGamesListScreenshotAppearance: TFrame},
  SetupFrameProfileEditorUnit in 'SetupFrameProfileEditorUnit.pas' {SetupFrameProfileEditor: TFrame},
  SetupFrameDefaultValuesUnit in 'SetupFrameDefaultValuesUnit.pas' {SetupFrameDefaultValues: TFrame},
  SetupFrameProgramsUnit in 'SetupFrameProgramsUnit.pas' {SetupFramePrograms: TFrame},
  SetupFrameDOSBoxUnit in 'SetupFrameDOSBoxUnit.pas' {SetupFrameDOSBox: TFrame},
  SetupFrameScummVMUnit in 'SetupFrameScummVMUnit.pas' {SetupFrameScummVM: TFrame},
  SetupFrameQBasicUnit in 'SetupFrameQBasicUnit.pas' {SetupFrameQBasic: TFrame},
  SetupFrameWaveEncoderUnit in 'SetupFrameWaveEncoderUnit.pas' {SetupFrameWaveEncoder: TFrame},
  SetupFrameSecurityUnit in 'SetupFrameSecurityUnit.pas' {SetupFrameSecurity: TFrame},
  SetupFrameServiceUnit in 'SetupFrameServiceUnit.pas' {SetupFrameService: TFrame},
  SetupFrameUpdateUnit in 'SetupFrameUpdateUnit.pas' {SetupFrameUpdate: TFrame},
  SetupFrameFreeDOSUnit in 'SetupFrameFreeDOSUnit.pas' {SetupFrameFreeDOS: TFrame},
  SetupFrameDOSBoxExtUnit in 'SetupFrameDOSBoxExtUnit.pas' {SetupFrameDOSBoxExt: TFrame},
  TextViewerFormUnit in 'TextViewerFormUnit.pas' {TextViewerForm},
  SetupFrameWineUnit in 'SetupFrameWineUnit.pas' {SetupFrameWine: TFrame},
  OperationModeInfoFormUnit in 'OperationModeInfoFormUnit.pas' {OperationModeInfoForm},
  ZipInfoFormUnit in 'ZipInfoFormUnit.pas' {ZipInfoForm},
  ProfileMountEditorDriveFrameUnit in 'ProfileMountEditorDriveFrameUnit.pas' {ProfileMountEditorDriveFrame: TFrame},
  ProfileMountEditorFloppyDriveFrameUnit in 'ProfileMountEditorFloppyDriveFrameUnit.pas' {ProfileMountEditorFloppyDriveFrame: TFrame},
  ProfileMountEditorCDDriveFrameUnit in 'ProfileMountEditorCDDriveFrameUnit.pas' {ProfileMountEditorCDDriveFrame: TFrame},
  ProfileMountEditorFloppyImage1FrameUnit in 'ProfileMountEditorFloppyImage1FrameUnit.pas' {ProfileMountEditorFloppyImage1Frame: TFrame},
  ProfileMountEditorFloppyImage2FrameUnit in 'ProfileMountEditorFloppyImage2FrameUnit.pas' {ProfileMountEditorFloppyImage2Frame: TFrame},
  ProfileMountEditorCDImageFrameUnit in 'ProfileMountEditorCDImageFrameUnit.pas' {ProfileMountEditorCDImageFrame: TFrame},
  ProfileMountEditorHDImageFrameUnit in 'ProfileMountEditorHDImageFrameUnit.pas' {ProfileMountEditorHDImageFrame: TFrame},
  ProfileMountEditorPhysFSFrameUnit in 'ProfileMountEditorPhysFSFrameUnit.pas' {ProfileMountEditorPhysFSFrame: TFrame},
  ProfileMountEditorZipFrameUnit in 'ProfileMountEditorZipFrameUnit.pas' {ProfileMountEditorZipFrame: TFrame},
  ZipManagerUnit in 'ZipManagerUnit.pas',
  ZipWaitInfoFormUnit in 'ZipWaitInfoFormUnit.pas' {ZipWaitInfoForm},
  SetupFrameCompressionUnit in 'SetupFrameCompressionUnit.pas' {SetupFrameCompression: TFrame},
  CopyProfileFormUnit in 'CopyProfileFormUnit.pas' {CopyProfileForm},
  ScreensaverControlUnit in 'ScreensaverControlUnit.pas',
  PlayVideoFormUnit in 'PlayVideoFormUnit.pas' {PlayVideoForm},
  ViewFilesFrameUnit in 'ViewFilesFrameUnit.pas' {ViewFilesFrame: TFrame},
  SetupFrameDOSBoxFormUnit in 'SetupFrameDOSBoxFormUnit.pas' {SetupFrameDOSBoxForm},
  LinkFileUnit in 'LinkFileUnit.pas',
  LinkFileEditFormUnit in 'LinkFileEditFormUnit.pas' {LinkFileEditForm},
  ExtraExeEditFormUnit in 'ExtraExeEditFormUnit.pas' {ExtraExeEditForm},
  SetupFrameGamesListScreenshotModeAppearanceUnit in 'SetupFrameGamesListScreenshotModeAppearanceUnit.pas' {SetupFrameGamesListScreenshotModeAppearance: TFrame},
  ImageCacheUnit in 'ImageCacheUnit.pas',
  ZipPackageUnit in 'ZipPackageUnit.pas',
  WindowsProfileUnit in 'WindowsProfileUnit.pas',
  HelpTools in 'HelpTools.pas',
  HelpConsts in 'HelpConsts.pas',
  BuildZipPackagesFormUnit in 'BuildZipPackagesFormUnit.pas' {BuildZipPackagesForm},
  FullscreenInfoFormUnit in 'FullscreenInfoFormUnit.pas' {FullscreenInfoForm},
  DOSBoxCountUnit in 'DOSBoxCountUnit.pas',
  QuickStartFormUnit in 'QuickStartFormUnit.pas' {QuickStartForm},
  ModernProfileEditorScummVMGameFrameUnit in 'ModernProfileEditorScummVMGameFrameUnit.pas' {ModernProfileEditorScummVMGameFrame: TFrame},
  SetupFrameEditorUnit in 'SetupFrameEditorUnit.pas' {SetupFrameEditor: TFrame},
  SetupFrameViewerUnit in 'SetupFrameViewerUnit.pas' {SetupFrameViewer: TFrame},
  ClassExtensions in 'ClassExtensions.pas',
  DOSBoxShortNameUnit in 'DOSBoxShortNameUnit.pas',
  FileNameConvertor in 'FileNameConvertor.pas',
  RunPrgManagerUnit in 'RunPrgManagerUnit.pas',
  ModernProfileEditorHelperProgramsFrameUnit in 'ModernProfileEditorHelperProgramsFrameUnit.pas' {ModernProfileEditorHelperProgramsFrame: TFrame},
  SetupFrameWindowsGamesUnit in 'SetupFrameWindowsGamesUnit.pas' {SetupFrameWindowsGames: TFrame},
  SetupFrameZipPrgsUnit in 'SetupFrameZipPrgsUnit.pas' {SetupFrameZipPrgs: TFrame},
  SetupFrameCustomLanguageStringsUnit in 'SetupFrameCustomLanguageStringsUnit.pas' {SetupFrameCustomLanguageStrings: TFrame},
  SelectCDDriveToMountFormUnit in 'SelectCDDriveToMountFormUnit.pas' {SelectCDDriveToMountForm},
  SelectCDDriveToMountByDataFormUnit in 'SelectCDDriveToMountByDataFormUnit.pas' {SelectCDDriveToMountByDataForm},
  ModernProfileEditorScummVMHardwareFrameUnit in 'ModernProfileEditorScummVMHardwareFrameUnit.pas' {ModernProfileEditorScummVMHardwareFrame: TFrame},
  pngimage in 'Components\pngimage\pngimage.pas',
  CreateShortcutsFormUnit in 'CreateShortcutsFormUnit.pas' {CreateShortcutsForm},
  SetupFrameGameListIconModeAppearanceUnit in 'SetupFrameGameListIconModeAppearanceUnit.pas' {SetupFrameGameListIconModeAppearance: TFrame},
  ImportSelectTemplateFormUnit in 'ImportSelectTemplateFormUnit.pas' {ImportSelectTemplateForm},
  Resample in 'Resample.pas',
  ImageStretch in 'ImageStretch.pas',
  ModernProfileEditorAddtionalChecksumFrameUnit in 'ModernProfileEditorAddtionalChecksumFrameUnit.pas' {ModernProfileEditorAddtionalChecksumFrame: TFrame},
  WaitFormUnit in 'WaitFormUnit.pas' {WaitForm},
  ScanGamesFolderFormUnit in 'ScanGamesFolderFormUnit.pas' {ScanGamesFolderForm},
  SelectTemplateForZipImportFormUnit in 'SelectTemplateForZipImportFormUnit.pas' {SelectTemplateForZipImportForm},
  ChecksumScanner in 'ChecksumScanner.pas',
  DownloadWaitFormUnit in 'DownloadWaitFormUnit.pas' {DownloadWaitForm},
  FastMM4HTTPFixes in 'FastMM4HTTPFixes.pas',
  PackageBuilderUnit in 'PackageBuilderUnit.pas',
  PackageDBCacheUnit in 'PackageDBCacheUnit.pas',
  PackageDBToolsUnit in 'PackageDBToolsUnit.pas',
  PackageDBUnit in 'PackageDBUnit.pas',
  PackageManagerFormUnit in 'PackageManagerFormUnit.pas' {PackageManagerForm},
  PackageManagerToolsUnit in 'PackageManagerToolsUnit.pas',
  PackageManagerRepositoriesEditFormUnit in 'PackageManagerRepositoriesEditFormUnit.pas' {PackageManagerRepositoriesEditForm},
  SetupFrameMenubarUnit in 'SetupFrameMenubarUnit.pas' {SetupFrameMenubar: TFrame},
  SetupFrameUserInterpreterFrameUnit in 'SetupFrameUserInterpreterFrameUnit.pas' {SetupFrameUserInterpreterFrame: TFrame},
  PackageCreationFormUnit in 'PackageCreationFormUnit.pas' {PackageCreationForm},
  TextEditPopupUnit in 'TextEditPopupUnit.pas',
  SetupFrameImageScalingUnit in 'SetupFrameImageScalingUnit.pas' {SetupFrameImageScaling: TFrame},
  SelectAutoSetupFormUnit in 'SelectAutoSetupFormUnit.pas' {SelectAutoSetupForm},
  MultipleProfilesEditorFormUnit in 'MultipleProfilesEditorFormUnit.pas' {MultipleProfilesEditorForm},
  SetupFrameMoreEmulatorsUnit in 'SetupFrameMoreEmulatorsUnit.pas' {SetupFrameMoreEmulators: TFrame},
  InstallationSupportFormUnit in 'InstallationSupportFormUnit.pas' {InstallationSupportForm},
  CreateImageToolsUnit in 'CreateImageToolsUnit.pas',
  RenameAllScreenshotsFormUnit in 'RenameAllScreenshotsFormUnit.pas' {RenameAllScreenshotsForm},
  DOSBoxTempUnit in 'DOSBoxTempUnit.pas',
  InternetDataWaitFormUnit in 'InternetDataWaitFormUnit.pas' {InternetDataWaitForm},
  DataReaderFormUnit in 'DataReaderFormUnit.pas' {DataReaderForm},
  ProviderFormUnit in 'ProviderFormUnit.pas' {ProviderForm},
  PackageManagerRepositoriesEditURLFormUnit in 'PackageManagerRepositoriesEditURLFormUnit.pas' {PackageManagerRepositoriesEditURLForm},
  DataReaderConfigUnit in 'DataReaderConfigUnit.pas',
  DataReaderToolsUnit in 'DataReaderToolsUnit.pas',
  DataReaderUnit in 'DataReaderUnit.pas',
  InstallationRunFormUnit in 'InstallationRunFormUnit.pas' {InstallationRunForm},
  MakeBootImageFromProfileFormUnit in 'MakeBootImageFromProfileFormUnit.pas' {MakeBootImageFromProfileForm},
  SetupFrameAutomaticConfigurationUnit in 'SetupFrameAutomaticConfigurationUnit.pas' {SetupFrameAutomaticConfiguration: TFrame},
  CheatDBUnit in 'CheatDBUnit.pas',
  CheatApplyFormUnit in 'CheatApplyFormUnit.pas' {CheatApplyForm},
  CheatDBEditFormUnit in 'CheatDBEditFormUnit.pas' {CheatDBEditForm},
  CheatDBInternalPrivateerPositionUnit in 'CheatDBInternalPrivateerPositionUnit.pas' {CheatDBInternalPrivateerPositionForm},
  CheatDBInternalUnit in 'CheatDBInternalUnit.pas',
  CheatDBToolsUnit in 'CheatDBToolsUnit.pas',
  CheatDBSearchUnit in 'CheatDBSearchUnit.pas',
  CheatSearchFormUnit in 'CheatSearchFormUnit.pas' {CheatSearchForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'D-Fend Reloaded';
  Application.CreateForm(TDFendReloadedMainForm, DFendReloadedMainForm);
  Application.Run;
end.
