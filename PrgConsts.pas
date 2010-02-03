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

      PackageDBSubFolder='Settings\Packages';
      PackageDBCacheSubFolder='Settings\Packages\Cache';
      PackageDBMainFileURL='http:/'+'/dfendreloaded.sourceforge.net/Packages/DFR.xml?version=%s';
      PackageDBTempFile='DFRTemp.xml';
      PackageDBMainFile='DFR.xml';
      PackageDBUserFile='User.xml';
      PackageDBCacheFile='Cache.xml';

      CacheVersionString='DFRCacheFile-FileVersion=001';
      CacheInfoString=#13+#13+'This is just a cache file for the profiles in the current directory. You can'+#13+
                      'ignore or delete this file. D-Fend Reloaded will only load data from this file'+#13+
                      'if the .prof file on disk has not changed. If you delete or change one of the'+#13+
                      '.prof files manually the cache will not be used for this profile. So just'+#13+
                      'ignore this file, you can still do what ever you want in this folder. This'+#13+
                      'cache will never mess up your database.'+#13+#13+
                      'You can turn off the creation of this cache files by setting "BinaryCache=0" in'+#13+
                      'the [ProgramSets] section of the DFend.ini.'+#13+#13+#13+
                      '===Start of binary cache==='+#13;
      CacheFile='Cache.dfr';

      DataReaderUpdateURL='http:/'+'/dfendreloaded.sourceforge.net/DataReader/DataReader.xml';
      DataReaderConfigFile='DataReader.xml';

      CheatDBFile='Cheats.xml';
      CheatDBSearchSubFolder='Settings\AddressSearch'; 

      MinSupportedDOSBoxVersion=0.73;

      DefaultFreeHDSize=250;

var MainSetupFile : String;
    OperationModeConfig : String;

implementation

uses SysUtils, Forms;

initialization
  MainSetupFile:=ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  OperationModeConfig:=ChangeFileExt(ExtractFileName(Application.ExeName),'.dat');
end.
