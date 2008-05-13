unit ScummVMUnit;
interface

uses Classes, GameDBUnit;

Procedure RunScummVMGame(const Game : TGame);

Function BuildScummVMIniFile(const Game : TGame) : TStringList;

implementation

uses Windows, Forms, Dialogs, SysUtils, PrgSetupUnit, CommonTools, PrgConsts,
     GameDBToolsUnit, LanguageSetupUnit;

Function BuildScummVMIniFile(const Game : TGame) : TStringList;
begin
  result:=TStringList.Create;
  result.Add('[scummvm]');
  result.Add('gfx_mode='+Game.ScummVMFilter);
  If Game.StartFullscreen then result.Add('fullscreen=true') else result.Add('fullscreen=false');
  result.Add('');
  result.Add('['+Game.ScummVMGame+']');
  result.Add('path='+IncludeTrailingPathDelimiter(MakeAbsPath(Game.ScummVMPath,PrgSetup.BaseDir)));
  result.Add('autosave_period='+IntToStr(Game.ScummVMAutosave));
  result.Add('language='+Game.ScummVMLanguage);
  result.Add('music_volume='+IntToStr(Game.ScummVMMusicVolume));
  result.Add('speech_volume='+IntToStr(Game.ScummVMSpeechVolume));
  result.Add('sfx_volume='+IntToStr(Game.ScummVMSFXVolume));
  result.Add('midi_gain='+IntToStr(Game.ScummVMMIDIGain));
  result.Add('output_rate='+IntToStr(Game.ScummVMSampleRate));
  If Game.AspectCorrection then result.Add('aspect_ratio=true') else result.Add('aspect_ratio=false');
  result.Add('music_driver='+Game.ScummVMMusicDriver);
  If Game.ScummVMNativeMT32 then result.Add('native_mt32=true') else result.Add('native_mt32=false');
  If Game.ScummVMEnableGS then result.Add('enable_gs=true') else result.Add('enable_gs=false');
  If Game.ScummVMMultiMIDI then result.Add('multi_midi=true') else result.Add('multi_midi=false');
  result.Add('talkspeed='+IntToStr(Game.ScummVMTalkSpeed));
  If Game.ScummVMSpeechMute then result.Add('speech_mute=true') else result.Add('speech_mute=false');
  If Game.ScummVMSubtitles then result.Add('subtitles=true') else result.Add('subtitles=false');
end;

Procedure RunScummVM(const INIFile, GameName : String; const FullScreen : Boolean);
Var PrgFile, Params : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  PrgFile:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile;
  if not FileExists(PrgFile) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindDosBox,[PrgFile]),mtError,[mbOK],0);
    exit;
  end;

  Params:='--config="'+INIFile+'" '+GameName;

  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    lpReserved:=nil;
    lpDesktop:=nil;
    lpTitle:=nil;
    dwFlags:=0;
    cbReserved2:=0;
    lpReserved2:=nil;
  end;

  CreateProcess(
    PChar(PrgFile),
    PChar('"'+PrgFile+'" '+Params),
    nil,
    nil,
    False,
    0,
    nil,
    PChar(ExtractFilePath(PrgFile)),
    StartupInfo,
    ProcessInformation
  );

  CloseHandle(ProcessInformation.hProcess);
  CloseHandle(ProcessInformation.hThread);
end;

Procedure RunScummVMGame(const Game : TGame);
Var St : TStringList;
begin
  If PrgSetup.MinimizeOnScummVMStart then Application.Minimize;

  St:=BuildScummVMIniFile(Game);
  try
    try
      St.SaveToFile(TempDir+ScummVMConfFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[TempDir+ScummVMConfFileName]),mtError,[mbOK],0);
      exit;
    end;
    AddToHistory(Game.Name);

    RunScummVM(TempDir+ScummVMConfFileName,Game.ScummVMGame,Game.StartFullscreen);
  finally
    St.Free;
  end;
end;

end.
