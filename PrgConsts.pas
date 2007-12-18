unit PrgConsts;
interface

const DosBoxFileName='DOSBOX.EXE';
      DosBoxConfFileName='DOSBOX.CONF';
      MakeDOSFilesystemFileName='mkdosfs.exe';

      ConfOptFile='ConfOpt.dat';
      HistoryFileName='History.dat';
      DosBoxDOSProfile='DOSBox DOS';

      GameListSubDir='Confs';
      IconsSubDir='IconLibrary';
      CaptureSubDir='Capture';
      LanguageSubDir='Lang';
      CustomConfigsSubDir='CustomConfigs';
      TemplateSubDir='Templates';

var MainSetupFile : String;
    OperationModeConfig : String;

implementation

uses SysUtils, Forms;

initialization
  MainSetupFile:=ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  OperationModeConfig:=ChangeFileExt(ExtractFileName(Application.ExeName),'.dat');
end.
