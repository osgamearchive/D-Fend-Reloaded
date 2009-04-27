unit PrgConsts;
interface

const DosBoxFileName='DOSBOX.EXE';
      DosBoxConfFileName='DOSBOX.CONF';
      MakeDOSFilesystemFileName='mkdosfs.exe';

      ConfOptFile='ConfOpt.dat';
      ScummVMConfOptFile='ScummVM.dat';
      HistoryFileName='History.dat';
      IconsConfFile='Icons.ini';
      DosBoxDOSProfile='DOSBox DOS';

      GameListSubDir='Confs';
      IconsSubDir='IconLibrary';
      CaptureSubDir='Capture';
      LanguageSubDir='Lang';
      CustomConfigsSubDir='CustomConfigs';
      TemplateSubDir='Templates';
      AutoSetupSubDir='AutoSetup';
      NewUserDataSubDir='NewUserData';
      PhysFSDefaultWriteDir='PhysWrite';
      ZipTempDir='ZipTemp'; {Subdir of BaseDataDir; ment as base directory for extracting zip file for mounting}
      TempSubFolder='D-Fend Reloaded zip package'; {Subdir fo TempDir; ment for internal use when building/extracting zip packages}
      BinFolder='Bin';
      SettingsFolder='Settings';
      IconSetsFolder='IconSets';

      NSIInstallerHelpFile='D-Fend Reloaded DataInstaller.nsi';

      OggEncPrgFile='oggenc2.exe';
      LamePrgFile='lame.exe';
      ScummPrgFile='scummvm.exe';
      ScummVMConfFileName='scummvm.ini';
      QBasicPrgFile='QBasic.exe';
      QB45PrgFile='QB.exe';
      QB71PrgFile='QBX.exe';

      MinSupportedDOSBoxVersion=0.72;

var MainSetupFile : String;
    OperationModeConfig : String;

implementation

uses SysUtils, Forms;

initialization
  MainSetupFile:=ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  OperationModeConfig:=ChangeFileExt(ExtractFileName(Application.ExeName),'.dat');
end.
