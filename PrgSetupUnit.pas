unit PrgSetupUnit;
interface

uses Classes, CommonComponents;

Type TOperationMode=(omPrgDir, omUserDir, omPortable);

var OperationMode : TOperationMode;

{
omPrgDir=Data is stored in Programfolder; XP with User is Admin
omUserDir=Data is stored in User-Data-Folder; Vista with normal User
omPortable=like omPrgDir, but DosBoxDir, BaseDir, GameDir and DataDir are stored relative to PrgDir
}

Type TDOSBoxData=record
  Name, DosBoxDir, DosBoxMapperFile, DosBoxLanguage, SDLVideodriver, CommandLineParameters : String;
  KeyboardLayout, Codepage : String;
  HideDosBoxConsole, CenterDOSBoxWindow, DisableScreensaver, WaitOnError : Boolean;
end;

Type TDOSBoxSetting=class
  private
    FPrgSetup : TBasePrgSetup;
    FNr : Integer;
    FName, FDosBoxDir, FDosBoxMapperFile, FDosBoxLanguage, FSDLVideodriver, FCommandLineParameters : String;
    FKeyboardLayout, FCodepage : String;
    FHideDosBoxConsole, FCenterDOSBoxWindow, FDisableScreensaver, FWaitOnError : Boolean;
    Procedure ReadSettings;
    Procedure WriteSettings;
    Procedure InitDirs;
    Procedure DoneDirs;
  public
    Constructor Create(const APrgSetup : TBasePrgSetup; const ANr : Integer);
    Destructor Destroy; override;
    property Nr : Integer read FNr write FNr;

    property Name : String read FName write FName;
    property DosBoxDir : String read FDosBoxDir write FDosBoxDir;
    property DosBoxMapperFile : String read FDosBoxMapperFile write FDosBoxMapperFile;
    property DosBoxLanguage : String read FDosBoxLanguage write FDosBoxLanguage;
    property SDLVideodriver : String read FSDLVideodriver write FSDLVideodriver;
    property CommandLineParameters : String read FCommandLineParameters write FCommandLineParameters;

    property KeyboardLayout : String read FKeyboardLayout write FKeyboardLayout;
    property Codepage : String read FCodepage write FCodepage;

    property HideDosBoxConsole : Boolean read FHideDosBoxConsole write FHideDosBoxConsole;
    property CenterDOSBoxWindow : Boolean read FCenterDOSBoxWindow write FCenterDOSBoxWindow;
    property DisableScreensaver : Boolean read FDisableScreensaver write FDisableScreensaver;
    property WaitOnError : Boolean read FWaitOnError write FWaitOnError;
end;

Type TPackerSetting=class
  private
    FPrgSetup : TBasePrgSetup;
    FNr : Integer;
    FName, FZipFileName, FFileExtensions : String;
    FExtractFile, FCreateFile, FUpdateFile : String;
    Procedure ReadSettings;
    Procedure WriteSettings;
  public
    Constructor Create(const APrgSetup : TBasePrgSetup; const ANr : Integer);
    Destructor Destroy; override;
    property Nr : Integer read FNr write FNr;

    property Name : String read FName write FName;
    property ZipFileName : String read FZipFileName write FZipFileName;
    property FileExtensions : String read FFileExtensions write FFileExtensions;
    property ExtractFile : String read FExtractFile write FExtractFile;
    property CreateFile : String read FCreateFile write FCreateFile;
    property UpdateFile : String read FUpdateFile write FUpdateFile;
 end;

Type TPrgSetup=class(TBasePrgSetup)
  private
    FDOSBox, FPacker : TList;
    Procedure ReadSettings;
    Procedure InitDirs;
    Procedure DoneDirs;
    Function GetDriveLetter(DriveLetter: Char): String;
    Procedure SetDriveLetter(DriveLetter: Char; const Value: String);
    Procedure LoadDOSBoxSettings;
    Procedure DeleteOldDOSBoxSettings;
    Procedure LoadPackerSettings;
    Procedure DeleteOldPackerSettings;
    Function GetListCount(Index : Integer) : Integer;
    Function GetDOSBoxSettings(I : Integer) : TDOSBoxSetting;
    Function GetPackerSettings(I : Integer) : TPackerSetting;
  public
    Constructor Create(const SetupFile : String = '');
    Destructor Destroy; override;

    Function AddDOSBoxSettings(const Name : String) : Integer;
    Function DeleteDOSBoxSettings(const ANr : Integer) : Boolean;
    Function SwapDOSBoxSettings(const ANr1, ANr2 : Integer) : Boolean;

    Function AddPackerSettings(const Name : String) : Integer;
    Function DeletePackerSettings(const ANr : Integer) : Boolean;
    Function SwapPackerSettings(const ANr1, ANr2 : Integer) : Boolean;

    property GameDir : String index 0 read GetString write SetString;
    property BaseDir : String index 1 read GetString write SetString;
    property DataDir : String index 2 read GetString write SetString;
    property Language : String index 3 read GetString write SetString;
    property ColOrder : String index 4 read GetString write SetString;
    property ColVisible : String index 5 read GetString write SetString;
    property ListViewStyle : String index 6 read GetString write SetString;
    property PathToFREEDOS : String index 7 read GetString write SetString;
    property UpdateCheckURL : String index 8 read GetString write SetString;
    property GamesListViewBackground : String index 9 read GetString write SetString;
    property GamesListViewFontColor : String index 10 read GetString write SetString;
    property ScreenshotsListViewBackground : String index 11 read GetString write SetString;
    property ScreenshotsListViewFontColor : String index 12 read GetString write SetString;
    property GamesTreeViewBackground : String index 13 read GetString write SetString;
    property GamesTreeViewFontColor : String index 14 read GetString write SetString;
    property ToolbarBackground : String index 15 read GetString write SetString;
    property UserGroups : String index 16 read GetString write SetString;
    property WaveEncMp3 : String index 17 read GetString write SetString;
    property WaveEncOgg : String index 18 read GetString write SetString;
    property WaveEncMp3Parameters : String index 19 read GetString write SetString;
    property WaveEncOggParameters : String index 20 read GetString write SetString;
    property ValueForNotSet : String index 21 read GetString write SetString;
    property ScummVMPath : String index 22 read GetString write SetString;
    property DFendVersion : String index 23 read GetString write SetString;
    property LinuxShellScriptPreamble : String index 24 read GetString write SetString;
    property QBasic : String index 25 read GetString write SetString;
    property QBasicParam : String index 26 read GetString write SetString;
    property LastAddedDriveType : String index 27 read GetString write SetString;
    property QuickStarterDOSBoxTemplate : String index 28 read GetString write SetString;
    property TextEditor : String index 29 read GetString write SetString;
    property ImageViewer : String index 30 read GetString write SetString;
    property SoundPlayer : String index 31 read GetString write SetString;
    property VideoPlayer : String index 32 read GetString write SetString;
    property DeleteToRecycleBin : String index 33 read GetString write SetString;
    property FilterMain : String index 34 read GetString write SetString;
    property FilterSub : String index 35 read GetString write SetString;
    property ColumnWidths : String index 36 read GetString write SetString;
    property ColumnWidthsNoExtraInfoMode : String index 37 read GetString write SetString;
    property CaptureDir : String index 38 read GetString write SetString;
    property IconSet : String index 39 read GetString write SetString;

    property LinuxRemap[DriveLetter : Char]  : String read GetDriveLetter write SetDriveLetter;

    property AskBeforeDelete : Boolean index 0 read GetBoolean write SetBoolean;
    property ReopenLastProfileEditorTab : Boolean index 1 read GetBoolean write SetBoolean;
    property MinimizeOnDosBoxStart : Boolean index 2 read GetBoolean write SetBoolean;
    property MainMaximized : Boolean index 3 read GetBoolean write SetBoolean;
    property MinimizeToTray : Boolean index 4 read GetBoolean write SetBoolean;
    property DeleteOnlyInBaseDir : Boolean index 5 read GetBoolean write SetBoolean;
    property ShowScreenshots : Boolean index 6 read GetBoolean write SetBoolean;
    property ShowTree : Boolean index 7 read GetBoolean write SetBoolean;
    property ShowSearchBox : Boolean index 8 read GetBoolean write SetBoolean;
    property ShowExtraInfo : Boolean index 9 read GetBoolean write SetBoolean;
    property StartWithWindows : Boolean index 10 read GetBoolean write SetBoolean;
    property ShowTooltips : Boolean index 11 read GetBoolean write SetBoolean;
    property DFendStyleProfileEditor : Boolean index 12 read GetBoolean write SetBoolean;
    property EasySetupMode : Boolean index 13 read GetBoolean write SetBoolean;
    property AllowMultiFloppyImagesMount : Boolean index 14 read GetBoolean write SetBoolean;
    property AllowPhysFSUsage : Boolean index 15 read GetBoolean write SetBoolean;
    property AllowTextModeLineChange : Boolean index 16 read GetBoolean write SetBoolean;
    property VersionSpecificUpdateCheck : Boolean index 17 read GetBoolean write SetBoolean;
    property UseShortFolderNames : Boolean index 18 read GetBoolean write SetBoolean;
    property AlwaysSetScreenshotFolderAutomatically : Boolean index 19 read GetBoolean write SetBoolean;
    property ShowXMLExportMenuItem : Boolean index 20 read GetBoolean write SetBoolean;
    property ShowXMLImportMenuItem : Boolean index 21 read GetBoolean write SetBoolean;
    property MinimizeOnScummVMStart : Boolean index 22 read GetBoolean write SetBoolean;
    property EnableWineMode : Boolean index 23 read GetBoolean write SetBoolean;
    property LinuxLinkMode : Boolean index 24 read GetBoolean write SetBoolean;
    property RemapMounts : Boolean index 25 read GetBoolean write SetBoolean;
    property RemapScreenShotFolder : Boolean index 26 read GetBoolean write SetBoolean;
    property RemapMapperFile : Boolean index 27 read GetBoolean write SetBoolean;
    property RemapDOSBoxFolder : Boolean index 28 read GetBoolean write SetBoolean;
    property UseCheckSumsForProfiles : Boolean index 29 read GetBoolean write SetBoolean;
    property AllowVGAChipsetSettings : Boolean index 30 read GetBoolean write SetBoolean;
    property AllowGlideSettings : Boolean index 31 read GetBoolean write SetBoolean;
    property AllowPrinterSettings : Boolean index 32 read GetBoolean write SetBoolean;
    property ShowToolbar : Boolean index 33 read GetBoolean write SetBoolean;
    property ShowToolbarTexts : Boolean index 34 read GetBoolean write SetBoolean;
    property ShowToolbarButtonClose : Boolean index 35 read GetBoolean write SetBoolean;
    property ShowToolbarButtonRun : Boolean index 36 read GetBoolean write SetBoolean;
    property ShowToolbarButtonRunSetup : Boolean index 37 read GetBoolean write SetBoolean;
    property ShowToolbarButtonAdd : Boolean index 38 read GetBoolean write SetBoolean;
    property ShowToolbarButtonEdit : Boolean index 39 read GetBoolean write SetBoolean;
    property ShowToolbarButtonDelete : Boolean index 40 read GetBoolean write SetBoolean;
    property RestoreWhenDOSBoxCloses : Boolean index 41 read GetBoolean write SetBoolean;
    property FavoritesBold : Boolean index 42 read GetBoolean write SetBoolean;
    property FavoritesItalic : Boolean index 43 read GetBoolean write SetBoolean;
    property FavoritesUnderline : Boolean index 44 read GetBoolean write SetBoolean;
    property ScreenshotListUseFirstScreenshot : Boolean index 45 read GetBoolean write SetBoolean;
    property FullscreenInfo : Boolean index 46 read GetBoolean write SetBoolean;
    property GridLinesInGamesList : Boolean index 47 read GetBoolean write SetBoolean;
    property QuickStarterMaximized : Boolean index 48 read GetBoolean write SetBoolean;
    property QuickStarterDOSBoxFullscreen : Boolean index 49 read GetBoolean write SetBoolean;
    property QuickStarterDOSBoxAutoClose : Boolean index 50 read GetBoolean write SetBoolean;
    property FileTypeFallbackForEditor : Boolean index 51 read GetBoolean write SetBoolean;
    property AutoFixLineWrap : Boolean index 52 read GetBoolean write SetBoolean;
    property CenterScummVMWindow : Boolean index 53 read GetBoolean write SetBoolean;
    property HideScummVMConsole : Boolean index 54 read GetBoolean write SetBoolean;
    property ShowShortNameWarnings : Boolean index 55 read GetBoolean write SetBoolean;
    property RestoreWhenScummVMCloses : Boolean index 56 read GetBoolean write SetBoolean;
    property UseWindowsExeIcons : Boolean index 57 read GetBoolean write SetBoolean;
    property MinimizeOnWindowsGameStart : Boolean index 58 read GetBoolean write SetBoolean;
    property RestoreWhenWindowsGameCloses : Boolean index 59 read GetBoolean write SetBoolean;
    property RestoreFilter : Boolean index 60 read GetBoolean write SetBoolean;
    property AllowSecureMode : Boolean index 61 read GetBoolean write SetBoolean;
    property AllowMoreIOCTLSettings : Boolean index 62 read GetBoolean write SetBoolean;
    property AllowCPUType : Boolean index 63 read GetBoolean write SetBoolean;
    property AllowPixelShader : Boolean index 64 read GetBoolean write SetBoolean;
    property StoreColumnWidths : Boolean index 65 read GetBoolean write SetBoolean;
    property ActivateIncompleteFeatures : Boolean index 66 read GetBoolean write SetBoolean;
    property RenameProfFileOnRenamingProfile : Boolean index 67 read GetBoolean write SetBoolean;
    property ScanFolderAllGames : Boolean index 68 read GetBoolean write SetBoolean;

    property MainLeft : Integer index 0 read GetInteger write SetInteger;
    property MainTop : Integer index 1 read GetInteger write SetInteger;
    property MainWidth : Integer index 2 read GetInteger write SetInteger;
    property MainHeight : Integer index 3 read GetInteger write SetInteger;
    property TreeWidth : Integer index 4 read GetInteger write SetInteger;
    property ScreenshotHeight : Integer index 5 read GetInteger write SetInteger;
    property ScreenshotPreviewSize : Integer index 6 read GetInteger write SetInteger;
    property AddButtonFunction : Integer index 7 read GetInteger write SetInteger;
    property CheckForUpdates : Integer index 8 read GetInteger write SetInteger;
    property LastUpdateCheck : Integer index 9 read GetInteger write SetInteger;
    property StartWindowSize : Integer index 10 read GetInteger write SetInteger;
    property GamesListViewFontSize : Integer index 11 read GetInteger write SetInteger;
    property ScreenshotsListViewFontSize : Integer index 12 read GetInteger write SetInteger;
    property GamesTreeViewFontSize : Integer index 13 read GetInteger write SetInteger;
    property ToolbarFontSize : Integer index 14 read GetInteger write SetInteger;
    property CompressionLevel : Integer index 15 read GetInteger write SetInteger;
    property ScreenshotListViewWidth : Integer index 16 read GetInteger write SetInteger;
    property ScreenshotListViewHeight : Integer index 17 read GetInteger write SetInteger;
    property QuickStarterLeft : Integer index 18 read GetInteger write SetInteger;
    property QuickStarterTop : Integer index 19 read GetInteger write SetInteger;
    property QuickStarterWidth : Integer index 20 read GetInteger write SetInteger;
    property QuickStarterHeight : Integer index 21 read GetInteger write SetInteger;
    property ScreenshotListUseFirstScreenshotNr : Integer index 22 read GetInteger write SetInteger;
    property DOSBoxShortFileNameAlgorithm : Integer index 23 read GetInteger write SetInteger;
    property LastWizardMode : Integer index 24 read GetInteger write SetInteger;
    property IconSize : Integer index 25 read GetInteger write SetInteger;
    property ImageFilter : Integer index 26 read GetInteger write SetInteger;

    property DOSBoxSettingsCount : Integer index 0 read GetListCount;
    property DOSBoxSettings[I : Integer] : TDOSBoxSetting read GetDOSBoxSettings;

    property PackerSettingsCount : Integer index 1 read GetListCount;
    property PackerSettings[I : Integer] : TPackerSetting read GetPackerSettings;
end;

var PrgSetup : TPrgSetup;

Function PrgDataDir : String;

Function WineSupportEnabled : Boolean;

Procedure DOSBoxSettingToDOSBoxData(const DOSBoxSetting : TDOSBoxSetting; var DOSBoxData : TDOSBoxData);
Procedure DOSBoxDataToDOSBoxSetting(const DOSBoxData : TDOSBoxData; const DOSBoxSetting : TDOSBoxSetting);
Procedure InitDOSBoxData(var DOSBoxData : TDOSBoxData);

implementation

uses ShlObj, SysUtils, Forms, CommonTools, PrgConsts, GameDBToolsUnit;

{ TDOSBoxSetting }

constructor TDOSBoxSetting.Create(const APrgSetup: TBasePrgSetup; const ANr: Integer);
begin
  inherited Create;
  FPrgSetup:=APrgSetup;
  FNr:=ANr;
  ReadSettings;
  InitDirs;
end;

destructor TDOSBoxSetting.Destroy;
begin
  DoneDirs;
  WriteSettings;
  inherited Destroy;
end;

procedure TDOSBoxSetting.ReadSettings;
Var Section : String;
begin
  If FNr=0 then Section:='ProgramSets' else Section:='DOSBox-'+IntToStr(FNr+1);

  If FNr=0 then FName:='Default' else FName:=FPrgSetup.MemIni.ReadString(Section,'Name','');

  FDosBoxDir:=FPrgSetup.MemIni.ReadString(Section,'Location','');
  FDosBoxMapperFile:=FPrgSetup.MemIni.ReadString(Section,'LocationMap','.\mapper.txt');
  FDosBoxLanguage:=FPrgSetup.MemIni.ReadString(Section,'DosBoxLanguageFile','');
  FSDLVideodriver:=FPrgSetup.MemIni.ReadString(Section,'SDLVideodriver','DirectX');
  FCommandLineParameters:=FPrgSetup.MemIni.ReadString(Section,'CommandLineParameters','');

  FKeyboardLayout:=FPrgSetup.MemIni.ReadString(Section,'KeyboardLayout','');
  FCodepage:=FPrgSetup.MemIni.ReadString(Section,'Codepage','');

  FHideDosBoxConsole:=FPrgSetup.MemIni.ReadBool(Section,'Hideconsole',True);
  FCenterDOSBoxWindow:=FPrgSetup.MemIni.ReadBool(Section,'CenterDOSBoxWindow',False);
  FDisableScreensaver:=FPrgSetup.MemIni.ReadBool(Section,'DisableScreensaver',False);
  FWaitOnError:=FPrgSetup.MemIni.ReadBool(Section,'WaitOnError',True);
end;

procedure TDOSBoxSetting.WriteSettings;
Var Section : String;
begin
  If FNr=0 then Section:='ProgramSets' else Section:='DOSBox-'+IntToStr(FNr+1);

  If FNr<>0 then PrgSetup.MemIni.WriteString(Section,'Name',FName);

  FPrgSetup.MemIni.WriteString(Section,'Location',FDosBoxDir);
  FPrgSetup.MemIni.WriteString(Section,'LocationMap',FDosBoxMapperFile);
  FPrgSetup.MemIni.WriteString(Section,'DosBoxLanguageFile',FDosBoxLanguage);
  FPrgSetup.MemIni.WriteString(Section,'SDLVideodriver',FSDLVideodriver);
  FPrgSetup.MemIni.WriteString(Section,'CommandLineParameters',FCommandLineParameters);

  FPrgSetup.MemIni.WriteString(Section,'KeyboardLayout',FKeyboardLayout);
  FPrgSetup.MemIni.WriteString(Section,'Codepage',Codepage);

  FPrgSetup.MemIni.WriteBool(Section,'Hideconsole',FHideDosBoxConsole);
  FPrgSetup.MemIni.WriteBool(Section,'CenterDOSBoxWindow',FCenterDOSBoxWindow);
  FPrgSetup.MemIni.WriteBool(Section,'DisableScreensaver',FDisableScreensaver);
  FPrgSetup.MemIni.WriteBool(Section,'WaitOnError',FWaitOnError);

  FPrgSetup.UpdateFile;
end;

procedure TDOSBoxSetting.InitDirs;
begin
  If OperationMode=omPortable then begin
    FDosBoxDir:=MakeExtAbsPath(FDosBoxDir,PrgDir);
    FDosBoxLanguage:=MakeExtAbsPath(FDosBoxLanguage,PrgDir);
    If (not FileExists(FDosBoxLanguage)) and FileExists(IncludeTrailingPathDelimiter(FDosBoxDir)+ExtractFileName(FDosBoxLanguage)) then
      FDosBoxLanguage:=IncludeTrailingPathDelimiter(FDosBoxDir)+ExtractFileName(FDosBoxLanguage);
  end;
end;

procedure TDOSBoxSetting.DoneDirs;
begin
  If OperationMode=omPortable then begin
    DosBoxDir:=MakeExtRelPath(DosBoxDir,PrgDir);
    DosBoxLanguage:=MakeExtRelPath(DosBoxLanguage,PrgDir);
  end;
end;

{ TPackerSetting }

constructor TPackerSetting.Create(const APrgSetup: TBasePrgSetup; const ANr: Integer);
begin
  inherited Create;
  FPrgSetup:=APrgSetup;
  FNr:=ANr;
  ReadSettings;
end;

destructor TPackerSetting.Destroy;
begin
  WriteSettings;
  inherited Destroy;
end;

procedure TPackerSetting.ReadSettings;
Var Section : String;
begin
  Section:='Packer-'+IntToStr(FNr+1);

  FName:=FPrgSetup.MemIni.ReadString(Section,'Name','');
  FZipFileName:=FPrgSetup.MemIni.ReadString(Section,'Filename','');
  FFileExtensions:=FPrgSetup.MemIni.ReadString(Section,'FileExtensions','');
  FExtractFile:=FPrgSetup.MemIni.ReadString(Section,'ExtractFile','');
  FCreateFile:=FPrgSetup.MemIni.ReadString(Section,'CreateFile','');
  FUpdateFile:=FPrgSetup.MemIni.ReadString(Section,'UpdateFile','');
end;

procedure TPackerSetting.WriteSettings;
Var Section : String;
begin
  Section:='Packer-'+IntToStr(FNr+1);

  PrgSetup.MemIni.WriteString(Section,'Name',FName);
  PrgSetup.MemIni.WriteString(Section,'Filename',FZipFileName);
  PrgSetup.MemIni.WriteString(Section,'FileExtensions',FFileExtensions);
  PrgSetup.MemIni.WriteString(Section,'ExtractFile',FExtractFile);
  PrgSetup.MemIni.WriteString(Section,'CreateFile',FCreateFile);
  PrgSetup.MemIni.WriteString(Section,'UpdateFile',FUpdateFile);

  FPrgSetup.UpdateFile;
end;

{ TPrgSetup }

constructor TPrgSetup.Create(const SetupFile : String);
begin
  If SetupFile=''
    then inherited Create(PrgDataDir+SettingsFolder+'\'+MainSetupFile)
    else inherited Create(SetupFile);

  ReadSettings;
  InitDirs;
  If ExtUpperCase(Language)='Deutsch.ini' then Language:='German.ini';

  FDOSBox:=TList.Create;
  FPacker:=TList.Create;
  LoadDOSBoxSettings;
  LoadPackerSettings;
end;

destructor TPrgSetup.Destroy;
Var I : Integer;
begin
  DeleteOldDOSBoxSettings;
  For I:=0 to FDOSBox.Count-1 do TDOSBoxSetting(FDOSBox[I]).Free;
  FDOSBox.Free;

  DeleteOldPackerSettings;
  For I:=0 to FPacker.Count-1 do TPackerSetting(FPacker[I]).Free;
  FPacker.Free;

  DoneDirs;
  inherited Destroy;
end;

Procedure TPrgSetup.LoadDOSBoxSettings;
Var I : Integer;
begin
  FDOSBox.Add(TDOSBoxSetting.Create(self,0));
  For I:=2 to MaxInt-1 do begin
    If not MemIni.SectionExists('DOSBox-'+IntToStr(I)) then break;
    FDOSBox.Add(TDOSBoxSetting.Create(self,I-1));
  end;
end;

Procedure TPrgSetup.DeleteOldDOSBoxSettings;
Var I : Integer;
begin
  I:=FDOSBox.Count+1;
  While MemIni.SectionExists('DOSBox-'+IntToStr(I)) do begin
    MemIni.EraseSection('DOSBox-'+IntToStr(I));
    Inc(I);
  end;
end;

Procedure TPrgSetup.LoadPackerSettings;
Var I : Integer;
begin
  For I:=1 to MaxInt-1 do begin
    If not MemIni.SectionExists('Packer-'+IntToStr(I)) then break;
    FPacker.Add(TPackerSetting.Create(self,I-1));
  end;
end;

Procedure TPrgSetup.DeleteOldPackerSettings;
Var I : Integer;
begin
  I:=FPacker.Count+1;
  While MemIni.SectionExists('Packer-'+IntToStr(I)) do begin
    MemIni.EraseSection('Packer-'+IntToStr(I));
    Inc(I);
  end;
end;

procedure TPrgSetup.ReadSettings;
Var I : Integer;
begin
  AddStringRec(0,'ProgramSets','DefGameLoc',PrgDataDir+'VirtualHD\');
  AddStringRec(1,'ProgramSets','DefLoc',PrgDataDir);
  AddStringRec(2,'ProgramSets','DefDataLoc',PrgDataDir+'GameData\');
  AddStringRec(3,'ProgramSets','LanguageFile','English.ini');
  AddStringRec(4,'ProgramSets','ColOrder','1234567');
  AddStringRec(5,'ProgramSets','ColVisible','1111110');
  AddStringRec(6,'ProgramSets','ILVS','List');
  AddStringRec(7,'ProgramSets','PathToFREEDOS','.\VirtualHD\FREEDOS\');
  AddStringRec(8,'ProgramSets','UpdateCheckURL','http:/'+'/dfendreloaded.sourceforge.net/UpdateInfo.txt');
  AddStringRec(9,'ProgramSets','GamesListViewBackground','');
  AddStringRec(10,'ProgramSets','GamesListViewFontColor','clWindowText');
  AddStringRec(11,'ProgramSets','ScreenshotsListViewBackground','');
  AddStringRec(12,'ProgramSets','ScreenshotsListViewFontColor','clWindowText');
  AddStringRec(13,'ProgramSets','GamesTreeViewBackground','');
  AddStringRec(14,'ProgramSets','GamesTreeViewFontColor','clWindowText');
  AddStringRec(15,'ProgramSets','ToolbarBackground','');
  AddStringRec(16,'ProgramSets','UserGroups','');
  AddStringRec(17,'ProgramSets','WaveEncMp3','');
  AddStringRec(18,'ProgramSets','WaveEncOgg','');
  AddStringRec(19,'ProgramSets','WaveEncMp3Parameters','-h -V 0 "%1" "%2"');
  AddStringRec(20,'ProgramSets','WaveEncOggParameters','"%1" --output="%2" --quality=10');
  AddStringRec(21,'ProgramSets','ValueForNotSet','');
  AddStringRec(22,'ProgramSets','ScummVMPath','');
  AddStringRec(23,'ProgramSets','ProgramVersion','');
  AddStringRec(24,'WineSupport','ShellScriptPreamble','#!/bin/bash');
  AddStringRec(25,'ProgramSets','QBasic','');
  AddStringRec(26,'ProgramSets','QBasicParams','/run %s');
  AddStringRec(27,'ProgramSets','LastAddedDriveType','Drive');
  AddStringRec(28,'ProgramSets','QuickStarterDOSBoxTemplate','');
  AddStringRec(29,'ProgramSets','TextEditor','');
  AddStringRec(30,'ProgramSets','ImageViewer','');
  AddStringRec(31,'ProgramSets','SoundPlayer','');
  AddStringRec(32,'ProgramSets','VideoPlayer','');
  AddStringRec(33,'ProgramSets','DeleteToRecycleBin','1011110');
  AddStringRec(34,'ProgramSets','FilterMain','');
  AddStringRec(35,'ProgramSets','FilterSub','');
  AddStringRec(36,'ProgramSets','ColWidths','');
  AddStringRec(37,'ProgramSets','ColumnWidthsNoExtraInfoMode','');
  AddStringRec(38,'ProgramSets','CaptureDefaultPath','.\'+CaptureSubDir+'\');
  AddStringRec(39,'ProgramSets','IconSet','Modern');

  For I:=0 to 25 do AddStringRec(1000+I,'WineSupport',chr(ord('A')+I),'');

  AddBooleanRec(0,'ProgramSets','AskBeforeDelete',True);
  AddBooleanRec(1,'ProgramSets','ShowLastTab',False);
  AddBooleanRec(2,'ProgramSets','Minimize',False);
  AddBooleanRec(3,'ProgramSets','MainMaximized',False);
  AddBooleanRec(4,'ProgramSets','MinimizeToTray',False);
  AddBooleanRec(5,'ProgramSets','DeleteOnlyInBaseDir',True);
  AddBooleanRec(6,'ProgramSets','ShowThumbNails',True);
  AddBooleanRec(7,'ProgramSets','ShowFilterTree',True);
  AddBooleanRec(8,'ProgramSets','ShowSearchBox',True);
  AddBooleanRec(9,'ProgramSets','ShowExtrainfo',True);
  AddBooleanRec(10,'ProgramSets','StartWithWindows',False);
  AddBooleanRec(11,'ProgramSets','TooltipsInGamesList',True);
  AddBooleanRec(12,'ProgramSets','DFendStyleProfileEditor',False);
  AddBooleanRec(13,'ProgramSets','EasySetup',True);
  AddBooleanRec(14,'ProgramSets','AllowMultiFloppyImagesMount',False);
  AddBooleanRec(15,'ProgramSets','AllowPhysFSUsage',False);
  AddBooleanRec(16,'ProgramSets','AllowTextModeLineChange',False);
  AddBooleanRec(17,'ProgramSets','VersionSpecificUpdateCheck',True);
  AddBooleanRec(18,'ProgramSets','UseShortFolderNames',True);
  AddBooleanRec(19,'ProgramSets','AlwaysSetScreenshotFolderAutomatically',True);
  AddBooleanRec(20,'ProgramSets','ShowXMLExportMenuItem',False);
  AddBooleanRec(21,'ProgramSets','ShowXMLImportMenuItem',False);
  AddBooleanRec(22,'ProgramSets','MinimizeOnScummVMStart',False);
  AddBooleanRec(23,'WineSupport','Enable',False);
  AddBooleanRec(24,'WineSupport','LinuxLinkMode',False);
  AddBooleanRec(25,'WineSupport','RemapMounts',False);
  AddBooleanRec(26,'WineSupport','RemapScreenshotFolder',False);
  AddBooleanRec(27,'WineSupport','RemapMapperFile',False);
  AddBooleanRec(28,'WineSupport','RemapDOSBoxFolder',False);
  AddBooleanRec(29,'ProgramSets','UseCheckSumsForProfiles',True);
  AddBooleanRec(30,'ProgramSets','AllowVGAChipsetSettings',False);
  AddBooleanRec(31,'ProgramSets','AllowGlideSettings',False);
  AddBooleanRec(32,'ProgramSets','AllowPrinterSettings',False);
  AddBooleanRec(33,'ProgramSets','ShowToolbar',True);
  AddBooleanRec(34,'ProgramSets','ShowToolbarCaptions',True);
  AddBooleanRec(35,'ProgramSets','ShowToolbarButtonClose',False);
  AddBooleanRec(36,'ProgramSets','ShowToolbarButtonRun',True);
  AddBooleanRec(37,'ProgramSets','ShowToolbarButtonRunSetup',False);
  AddBooleanRec(38,'ProgramSets','ShowToolbarButtonAdd',True);
  AddBooleanRec(39,'ProgramSets','ShowToolbarButtonEdit',True);
  AddBooleanRec(40,'ProgramSets','ShowToolbarButtonDelete',True);
  AddBooleanRec(41,'ProgramSets','RestoreWindowWhenDOSBoxCloses',False);
  AddBooleanRec(42,'ProgramSets','Favorites.Bold',True);
  AddBooleanRec(43,'ProgramSets','Favorites.Italic',False);
  AddBooleanRec(44,'ProgramSets','Favorites.Underline',False);
  AddBooleanRec(45,'ProgramSets','ScreenshotsGamesList.UseFirstScreenshot',True);
  AddBooleanRec(46,'ProgramSets','ShowFullscreenInfo',True);
  AddBooleanRec(47,'ProgramSets','GridLinesInGamesList',False);
  AddBooleanRec(48,'ProgramSets','QuickStarterMaximized',False);
  AddBooleanRec(49,'ProgramSets','QuickStarterDOSBoxFullscreen',False);
  AddBooleanRec(50,'ProgramSets','QuickStarterDOSBoxAutoClose',True);
  AddBooleanRec(51,'ProgramSets','FileTypeFallbackForEditor',True);
  AddBooleanRec(52,'ProgramSets','AutoFixLineWrap',False);
  AddBooleanRec(53,'ProgramSets','CenterScummVMWindow',False);
  AddBooleanRec(54,'ProgramSets','HideScummVMConsole',False);
  AddBooleanRec(55,'ProgramSets','ShowShortNameWarnings',True);
  AddBooleanRec(56,'ProgramSets','RestoreWhenScummVMCloses',False);
  AddBooleanRec(57,'ProgramSets','UseWindowsExeIcons',True);
  AddBooleanRec(58,'ProgramSets','MinimizeOnWindowsGameStart',False);
  AddBooleanRec(59,'ProgramSets','RestoreWhenWindowsGameCloses',False);
  AddBooleanRec(60,'ProgramSets','RestoreFilter',True);
  AddBooleanRec(61,'ProgramSets','AllowSecureMode',False);
  AddBooleanRec(62,'ProgramSets','AllowMoreIOCTLSettings',False);
  AddBooleanRec(63,'ProgramSets','AllowCPUType',False);
  AddBooleanRec(64,'ProgramSets','AllowPixelShader',False);
  AddBooleanRec(65,'ProgramSets','StoreColWidths',False);
  AddBooleanRec(66,'ProgramSets','ActivateIncompleteFeatures',False);
  AddBooleanRec(67,'ProgramSets','RenameProfFileOnRenamingProfile',False);
  AddBooleanRec(68,'ProgramSets','ScanFolderAllGames',False);

  AddIntegerRec(0,'ProgramSets','MainLeft',-1);
  AddIntegerRec(1,'ProgramSets','MainTop',-1);
  AddIntegerRec(2,'ProgramSets','MainWidth',-1);
  AddIntegerRec(3,'ProgramSets','MainHeight',-1);
  AddIntegerRec(4,'ProgramSets','TreeWidth',-1);
  AddIntegerRec(5,'ProgramSets','ScreenshotHeight',-1);
  AddIntegerRec(6,'ProgramSets','ScreenshotPreviewHeight',100);
  AddIntegerRec(7,'ProgramSets','AddButtonFunction',2);
  AddIntegerRec(8,'ProgramSets','CheckForUpdates',0);
  AddIntegerRec(9,'ProgramSets','LastUpdateCheck',0);
  AddIntegerRec(10,'ProgramSets','StartWindowSize',0);
  AddIntegerRec(11,'ProgramSets','GamesListViewFontSize',9);
  AddIntegerRec(12,'ProgramSets','ScreenshotsListViewFontSize',9);
  AddIntegerRec(13,'ProgramSets','GamesTreeViewFontSize',9);
  AddIntegerRec(14,'ProgramSets','ToolbarFontSize',9);
  AddIntegerRec(15,'ProgramSets','CompressionLevel',3);
  AddIntegerRec(16,'ProgramSets','ScreenshotsGamesList.Width',150);
  AddIntegerRec(17,'ProgramSets','ScreenshotsGamesList.Height',100);
  AddIntegerRec(18,'ProgramSets','QuickStarterLeft',-1);
  AddIntegerRec(19,'ProgramSets','QuickStarterTop',-1);
  AddIntegerRec(20,'ProgramSets','QuickStarterWidth',-1);
  AddIntegerRec(21,'ProgramSets','QuickStarterHeight',-1);
  AddIntegerRec(22,'ProgramSets','ScreenshotsGamesList.UseScreenshotNr',1);
  AddIntegerRec(23,'ProgramSets','DOSBoxShortFileNameAlgorithm',3);
  AddIntegerRec(24,'ProgramSets','LastWizardMode',1);
  AddIntegerRec(25,'ProgramSets','IconSize',32);
  AddIntegerRec(26,'ProgramSets','ImageFilter',0);
end;

Procedure TPrgSetup.InitDirs;
begin
  If BaseDir='' then BaseDir:=PrgDataDir;
  If GameDir='' then GameDir:=BaseDir+'VirtualHD\';
  If DataDir='' then DataDir:=BaseDir+'GameData\';
  If CaptureDir='' then CaptureDir:=BaseDir+CaptureSubDir+'\';

  If OperationMode=omPortable then begin
    BaseDir:=MakeExtAbsPath(BaseDir,PrgDir);
    GameDir:=MakeExtAbsPath(GameDir,PrgDir);
    DataDir:=MakeExtAbsPath(DataDir,PrgDir);
    CaptureDir:=MakeExtAbsPath(CaptureDir,PrgDir);
    ScummVMPath:=MakeExtAbsPath(ScummVMPath,PrgDir);
    QBasic:=MakeExtAbsPath(QBasic,PrgDir);
    WaveEncOgg:=MakeExtAbsPath(WaveEncOgg,PrgDir);
    WaveEncMp3:=MakeExtAbsPath(WaveEncMp3,PrgDir);
  end;

  If not FileExists(WaveEncOgg) then begin
    If FileExists(PrgDir+OggEncPrgFile) then WaveEncOgg:=PrgDir+OggEncPrgFile else begin
      If FileExists(PrgDir+BinFolder+'\'+OggEncPrgFile) then WaveEncOgg:=PrgDir+BinFolder+'\'+OggEncPrgFile;
    end;
  end;
end;

procedure TPrgSetup.DoneDirs;
begin
  If OperationMode=omPortable then begin
    BaseDir:=MakeExtRelPath(BaseDir,PrgDir);
    GameDir:=MakeExtRelPath(GameDir,PrgDir);
    DataDir:=MakeExtRelPath(DataDir,PrgDir);
    CaptureDir:=MakeExtRelPath(CaptureDir,PrgDir);
    ScummVMPath:=MakeExtRelPath(ScummVMPath,PrgDir);
    QBasic:=MakeExtRelPath(QBasic,PrgDir);
    WaveEncOgg:=MakeExtRelPath(WaveEncOgg,PrgDir);
    WaveEncMp3:=MakeExtRelPath(WaveEncMp3,PrgDir);
  end;
end;

Function TPrgSetup.GetDriveLetter(DriveLetter: Char): String;
begin
  result:=GetString(1000+(ord(UpCase(DriveLetter)))-ord('A'));
end;

Procedure TPrgSetup.SetDriveLetter(DriveLetter: Char; const Value: String);
begin
  SetString(1000+(ord(UpCase(DriveLetter)))-ord('A'),Value);
end;

Function TPrgSetup.GetListCount(Index : Integer) : Integer;
begin
  Case Index of
    0 : result:=FDOSBox.Count;
    1 : result:=FPacker.Count;
    else result:=0;
  end;
end;

Function TPrgSetup.GetDOSBoxSettings(I : Integer) : TDOSBoxSetting;
begin
  If (I<0) or (I>=FDOSBox.Count) then result:=nil else result:=TDOSBoxSetting(FDOSBox[I]);
end;

Function TPrgSetup.GetPackerSettings(I : Integer) : TPackerSetting;
begin
  If (I<0) or (I>=FPacker.Count) then result:=nil else result:=TPackerSetting(FPacker[I]);
end;

Function TPrgSetup.AddDOSBoxSettings(const Name : String) : Integer;
begin
  result:=FDOSBox.Add(TDOSBoxSetting.Create(self,FDOSBox.Count));
  TDOSBoxSetting(FDOSBox[result]).Name:=Name;
end;

Function TPrgSetup.DeleteDOSBoxSettings(const ANr : Integer) : Boolean;
Var I : Integer;
begin
  result:=(ANr>0) and (ANr<FDOSBox.Count); {do not delete ANr=0}
  If not result then exit;

  TDOSBoxSetting(FDOSBox[ANr]).Free;
  FDOSBox.Delete(ANr);
  For I:=ANr to FDOSBox.Count-1 do TDOSBoxSetting(FDOSBox[I]).Nr:=I;
end;

Function TPrgSetup.SwapDOSBoxSettings(const ANr1, ANr2 : Integer) : Boolean;
begin
  result:=(ANr1>0) and (ANr1<FDOSBox.Count) and (ANr2>0) and (ANr2<FDOSBox.Count);
  If not result then exit;

  FDOSBox.Exchange(ANr1,ANr2);
  TDOSBoxSetting(FDOSBox[ANr1]).Nr:=ANr1;
  TDOSBoxSetting(FDOSBox[ANr2]).Nr:=ANr2;
end;

Function TPrgSetup.AddPackerSettings(const Name : String) : Integer;
begin
  result:=FPacker.Add(TPackerSetting.Create(self,FPacker.Count));
  TPackerSetting(FPacker[result]).Name:=Name;
end;

Function TPrgSetup.DeletePackerSettings(const ANr : Integer) : Boolean;
Var I : Integer;
begin
  result:=(ANr>=0) and (ANr<FPacker.Count);
  If not result then exit;

  TPackerSetting(FPacker[ANr]).Free;
  FPacker.Delete(ANr);
  For I:=ANr to FPacker.Count-1 do TPackerSetting(FPacker[I]).Nr:=I;
end;

Function TPrgSetup.SwapPackerSettings(const ANr1, ANr2 : Integer) : Boolean;
begin
  result:=(ANr1>=0) and (ANr1<FPacker.Count) and (ANr2>=0) and (ANr2<FPacker.Count);
  If not result then exit;

  FPacker.Exchange(ANr1,ANr2);
  TPackerSetting(FPacker[ANr1]).Nr:=ANr1;
  TPackerSetting(FPacker[ANr2]).Nr:=ANr2;
end;

{ global }

Procedure ReadOperationMode;
Var St : TStringList;
    I : Integer;
    S : String;
begin
  OperationMode:=omPrgDir;
  if not FileExists(PrgDir+OperationModeConfig) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(PrgDir+OperationModeConfig); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OperationMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OperationMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OperationMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

Function PrgDataDir : String;
begin
  If OperationMode=omUserDir then begin
    result:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    result:=PrgDir;
  end;
end;

Function WineSupportEnabled : Boolean;
Var S : String;
begin
  If ParamCount=1 then begin
    S:=Trim(ExtUpperCase(ParamStr(1)));
    If (Pos('WINEMODE',S)>0) or (Pos('WINESUPPORTENABLED',S)>0) then begin result:=True; exit; end;
    If (Pos('WINDOWSMODE',S)>0) or (Pos('NOWINESUPPORT',S)>0) or (Pos('WINESUPPORTDISABLED',S)>0) then begin result:=False; exit; end;
  end;
  result:=PrgSetup.EnableWineMode;
end;

Procedure DOSBoxSettingToDOSBoxData(const DOSBoxSetting : TDOSBoxSetting; var DOSBoxData : TDOSBoxData);
begin
  DOSBoxData.Name:=DOSBoxSetting.Name;
  DOSBoxData.DosBoxDir:=DOSBoxSetting.DosBoxDir;
  DOSBoxData.DosBoxMapperFile:=DOSBoxSetting.DosBoxMapperFile;
  DOSBoxData.DosBoxLanguage:=DOSBoxSetting.DosBoxLanguage;
  DOSBoxData.SDLVideodriver:=DOSBoxSetting.SDLVideodriver;
  DOSBoxData.CommandLineParameters:=DOSBoxSetting.CommandLineParameters;
  DOSBoxData.KeyboardLayout:=DOSBoxSetting.KeyboardLayout;
  DOSBoxData.Codepage:=DOSBoxSetting.Codepage;
  DOSBoxData.HideDosBoxConsole:=DOSBoxSetting.HideDosBoxConsole;
  DOSBoxData.CenterDOSBoxWindow:=DOSBoxSetting.CenterDOSBoxWindow;
  DOSBoxData.DisableScreensaver:=DOSBoxSetting.DisableScreensaver;
  DOSBoxData.WaitOnError:=DOSBoxSetting.WaitOnError;
end;

Procedure DOSBoxDataToDOSBoxSetting(const DOSBoxData : TDOSBoxData; const DOSBoxSetting : TDOSBoxSetting);
begin
  DOSBoxSetting.Name:=DOSBoxData.Name;
  DOSBoxSetting.DosBoxDir:=DOSBoxData.DosBoxDir;
  DOSBoxSetting.DosBoxMapperFile:=DOSBoxData.DosBoxMapperFile;
  DOSBoxSetting.DosBoxLanguage:=DOSBoxData.DosBoxLanguage;
  DOSBoxSetting.SDLVideodriver:=DOSBoxData.SDLVideodriver;
  DOSBoxSetting.CommandLineParameters:=DOSBoxData.CommandLineParameters;
  DOSBoxSetting.KeyboardLayout:=DOSBoxData.KeyboardLayout;
  DOSBoxSetting.Codepage:=DOSBoxData.Codepage;
  DOSBoxSetting.HideDosBoxConsole:=DOSBoxData.HideDosBoxConsole;
  DOSBoxSetting.CenterDOSBoxWindow:=DOSBoxData.CenterDOSBoxWindow;
  DOSBoxSetting.DisableScreensaver:=DOSBoxData.DisableScreensaver;
  DOSBoxSetting.WaitOnError:=DOSBoxData.WaitOnError;
end;

Procedure InitDOSBoxData(var DOSBoxData : TDOSBoxData);
begin
  with DOSBoxData do begin
    Name:='';
    DosBoxDir:='';
    DosBoxMapperFile:='.\mapper.txt';
    DosBoxLanguage:='';
    SDLVideodriver:='DirectX';
    CommandLineParameters:='';
    KeyboardLayout:='';
    Codepage:='';
    HideDosBoxConsole:=True;
    CenterDOSBoxWindow:=False;
    DisableScreensaver:=False;
    WaitOnError:=True;
  end;
end;

initialization
  ReadOperationMode;
  UpdateSettingsFilesLocation;
  PrgSetup:=TPrgSetup.Create;
finalization
  PrgSetup.Free;
  PrgSetup:=nil;
end.
