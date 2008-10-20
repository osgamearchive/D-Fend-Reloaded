unit ScummVMUnit;
interface

uses Classes, GameDBUnit;

Procedure RunScummVMGame(const Game : TGame);

Function BuildScummVMIniFile(const Game : TGame) : TStringList;

Function FindScummVMIni : String;

Var MinimizedAtScummVMStart : Boolean = False;

implementation

uses Windows, Forms, Dialogs, SysUtils, IniFiles, ShlObj, PrgSetupUnit,
     CommonTools, PrgConsts, GameDBToolsUnit, LanguageSetupUnit,
     ScummVMToolsUnit, ZipManagerUnit, DOSBoxCountUnit, RunPrgManagerUnit;

Function FindScummVMIni : String;
Var S : String;
begin
  result:='';

  S:=ScummVMGamesList.ScummVMIniFile;
  If FileExists(S) then begin result:=S; exit; end;

  S:=IncludeTrailingPathDelimiter(GetSpecialFolder(Application.Handle,CSIDL_APPDATA))+'ScummVM\';
  If FileExists(S+ScummVMConfFileName) then begin result:=S+ScummVMConfFileName; exit; end;

  SetLength(S,520); GetWindowsDirectory(PChar(S),512); SetLength(S,StrLen(PChar(S))); S:=IncludeTrailingPathDelimiter(S);
  If FileExists(S+ScummVMConfFileName) then begin result:=S+ScummVMConfFileName; exit; end;

  S:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath);
  If FileExists(S+ScummVMConfFileName) then begin result:=S+ScummVMConfFileName; exit; end;
end;

Procedure AddKeysFromDefaultScummVMIni(const St1,St2 : TStringList; const Ini : TIniFile; const GameName : String);
Var KnownKeys,Section : TStringList;
    I,J : Integer;
    S : String;
begin
  KnownKeys:=TStringList.Create;
  Section:=TStringList.Create;
  try
    For I:=0 to St1.Count-1 do begin S:=Trim(ExtUpperCase(St1[I])); J:=Pos('=',S); If (S<>'') and (S[1]<>'[') and (J>0) then KnownKeys.Add(Trim(Copy(S,1,J-1))); end;
    For I:=0 to St2.Count-1 do begin S:=Trim(ExtUpperCase(St2[I])); J:=Pos('=',S); If (S<>'') and (S[1]<>'[') and (J>0) then KnownKeys.Add(Trim(Copy(S,1,J-1))); end;

    {not copy [game] section
    Section.Clear;
    Ini.ReadSection(GameName,Section);
    For I:=0 to Section.Count-1 do begin
      If KnownKeys.IndexOf(ExtUpperCase(Section[I]))>=0 then continue;
      St2.Add(Section[I]+'='+Ini.ReadString(GameName,Section[I],''));
      KnownKeys.Add(ExtUpperCase(Section[I]));
    end;}

    Section.Clear;
    Ini.ReadSection('scummvm',Section);
    For I:=0 to Section.Count-1 do begin
      If KnownKeys.IndexOf(ExtUpperCase(Section[I]))>=0 then continue;
      St1.Add(Section[I]+'='+Ini.ReadString('scummvm',Section[I],''));
      KnownKeys.Add(ExtUpperCase(Section[I]));
    end;

  finally
    KnownKeys.Free;
    Section.Free;
  end;
end;


Function BuildScummVMIniFile(const Game : TGame) : TStringList;
Var S : String;
    Ini : TIniFile;
    St1, St2 : TStringList;
begin
  result:=TStringList.Create;

  St1:=TStringList.Create;
  St2:=TStringList.Create;
  try
    St1.Add('[scummvm]');
    St1.Add('gfx_mode='+Game.ScummVMFilter);
    If Game.StartFullscreen then St1.Add('fullscreen=true') else St1.Add('fullscreen=false');
    If Game.ScummVMConfirmExit then St1.Add('confirm_exit=true') else St1.Add('confirm_exit=false');

    St2.Add('['+Game.ScummVMGame+']');
    If Trim(Game.ScummVMPath)='' then S:='' else S:=IncludeTrailingPathDelimiter(MakeAbsPath(Game.ScummVMPath,PrgSetup.BaseDir));
    St2.Add('path='+S);

    If Trim(Game.ScummVMSavePath)<>'' then S:=IncludeTrailingPathDelimiter(MakeAbsPath(Game.ScummVMPath,PrgSetup.BaseDir)) else begin
      If Trim(Game.ScummVMPath)='' then S:='' else S:=IncludeTrailingPathDelimiter(MakeAbsPath(Game.ScummVMPath,PrgSetup.BaseDir));
    end;
    St2.Add('savepath='+S);

    St2.Add('autosave_period='+IntToStr(Game.ScummVMAutosave));
    St2.Add('language='+Game.ScummVMLanguage);
    St2.Add('music_volume='+IntToStr(Game.ScummVMMusicVolume));
    St2.Add('speech_volume='+IntToStr(Game.ScummVMSpeechVolume));
    St2.Add('sfx_volume='+IntToStr(Game.ScummVMSFXVolume));
    St2.Add('midi_gain='+IntToStr(Game.ScummVMMIDIGain));
    St2.Add('output_rate='+IntToStr(Game.ScummVMSampleRate));
    If Game.AspectCorrection then St2.Add('aspect_ratio=true') else St2.Add('aspect_ratio=false');
    S:=Game.ScummVMMusicDriver; If (S<>'') and (S[length(S)]=')') then begin SetLength(S,length(S)-1); Game.ScummVMMusicDriver:=S; end;
    St2.Add('music_driver='+Game.ScummVMMusicDriver);
    If Game.ScummVMNativeMT32 then St2.Add('native_mt32=true') else St2.Add('native_mt32=false');
    If Game.ScummVMEnableGS then St2.Add('enable_gs=true') else St2.Add('enable_gs=false');
    If Game.ScummVMMultiMIDI then St2.Add('multi_midi=true') else St2.Add('multi_midi=false');
    St2.Add('talkspeed='+IntToStr(Game.ScummVMTalkSpeed));
    If Game.ScummVMSpeechMute then St2.Add('speech_mute=true') else St2.Add('speech_mute=false');
    If Game.ScummVMSubtitles then St2.Add('subtitles=true') else St2.Add('subtitles=false');
    St2.Add('cdrom='+IntToStr(Game.ScummVMCDROM));
    St2.Add('joystick_num='+IntToStr(Game.ScummVMJoystickNum));

    S:=Trim(LowerCase(Game.ScummVMGame));

    If (S='sky') or (S='queen') then begin
      If Game.ScummVMAltIntro then St2.Add('alt_intro=true') else St2.Add('alt_intro=false');
    end;

    If S='sword2' then begin
      St2.Add('gfx_details='+IntToStr(Game.ScummVMGFXDetails));
      If Game.ScummVMMusicMute then St2.Add('music_mute=true') else St2.Add('music_mute=false');
      If Game.ScummVMObjectLabels then St2.Add('object_labels=true') else St2.Add('object_labels=false');
      If Game.ScummVMReverseStereo then St2.Add('reverse_stereo=true') else St2.Add('reverse_stereo=false');
      If Game.ScummVMSFXMute then St2.Add('sfx_mute=true') else St2.Add('sfx_mute=false');
    end;

    If (S='queen') or (S='simon1') or (S='simon2') then begin
      If Game.ScummVMMusicMute then St2.Add('music_mute=true') else St2.Add('music_mute=false');
      If Game.ScummVMSFXMute then St2.Add('sfx_mute=true') else St2.Add('sfx_mute=false');
    end;

    If S='kyra1' then begin
      St2.Add('walkspeed='+IntToStr(Game.ScummVMWalkspeed));
    end;

    S:=FindScummVMIni;
    If S<>'' then begin
      Ini:=TIniFile.Create(S);
      try
        S:=Ini.ReadString('scummvm','themepath','');
        If S='' then S:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath);
        St1.Add('themepath='+S);

        St1.Add('gui_theme='+Ini.ReadString('scummvm','gui_theme',''));

        S:=Ini.ReadString('scummvm','extra_path','');
        If S='' then S:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath);
        St1.Add('extra_path='+S);

        AddKeysFromDefaultScummVMIni(St1,St2,Ini,Game.ScummVMGame);
      finally
        Ini.Free;
      end;
    end else begin
      St2.Add('themepath='+IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath));
    end;

    result.AddStrings(St1);
    result.Add('');
    result.AddStrings(St2);
  finally
    St1.Free;
    St2.Free;
  end;
end;

Function RunScummVM(const INIFile, GameName : String; const FullScreen : Boolean; const ScreenshotDir : String) : THandle;
Var PrgFile, Params : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    Waited : Boolean;
begin
  result:=INVALID_HANDLE_VALUE;

  PrgFile:=IncludeTrailingPathDelimiter(PrgSetup.ScummVMPath)+ScummPrgFile;
  if not FileExists(PrgFile) then begin
    Application.Restore;
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindScummVM,[PrgFile]),mtError,[mbOK],0); 
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

  If ScreenshotDir<>'' then begin
    CreateProcess(
      PChar(PrgFile),
      PChar('"'+PrgFile+'" '+Params),
      nil,
      nil,
      False,
      0,
      nil,
      PChar(ScreenshotDir),
      StartupInfo,
      ProcessInformation
    );
  end else begin
    If not CreateProcess(
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
    ) then begin
      Application.Restore;
      MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[PrgFile]),mtError,[mbOK],0);
      result:=INVALID_HANDLE_VALUE;
      exit;
    end;
  end;

  result:=ProcessInformation.hProcess;
  CloseHandle(ProcessInformation.hThread);

  If PrgSetup.CenterScummVMWindow and (not FullScreen) then begin
    Sleep(1000); Waited:=True;
    CenterWindowFromProcessID(ProcessInformation.dwProcessId);
  end else begin
    Waited:=False;
  end;

  If PrgSetup.MinimizeOnScummVMStart then begin
    If not Waited then begin Sleep(1000); Waited:=True; end;
    {MinimizedAtScummVMStart:=True; -> RunScummVMGame}
  end;

  If PrgSetup.HideScummVMConsole and (not FullScreen) then begin
    If not Waited then Sleep(1000);
    HideWindowFromProcessIDAndTitle(ProcessInformation.dwProcessId,'\scummvm.exe');
  end;

  ScummVMCounter.Add(result);
end;

Procedure RunScummVMGame(const Game : TGame);
Var St : TStringList;
    S, SavePath : String;
    ZipRecNr : Integer;
    Error : Boolean;
    ScummVMHandle : THandle;
    AlreadyMinimized : Boolean;
begin
  ZipRecNr:=ZipManager.AddGame(Game,Error);
  If Error then exit;

  If PrgSetup.MinimizeOnScummVMStart then begin
    AlreadyMinimized:=(Application.MainForm.WindowState=wsMinimized);
    Application.Minimize;
  end else begin
    AlreadyMinimized:=False;
  end;

  try
    St:=BuildScummVMIniFile(Game);
    try
      try
        St.SaveToFile(TempDir+ScummVMConfFileName);
      except
        Application.Restore;
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[TempDir+ScummVMConfFileName]),mtError,[mbOK],0);
        exit;
      end;
      AddToHistory(Game.Name);

      S:='';
      If Trim(Game.CaptureFolder)<>'' then begin
        S:=MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir);
        If not ForceDirectories(S) then S:='';
      end;

      RunPrgManager.RunBeforeExecutionCommand(Game);
      ScummVMHandle:=RunScummVM(TempDir+ScummVMConfFileName,Game.ScummVMGame,Game.StartFullscreen,S);
      try
        If ZipRecNr>=0 then ZipManager.ActivateRepackCheck(ZipRecNr,ScummVMHandle);
        RunPrgManager.AddCommand(Game,ScummVMHandle);
      finally
        CloseHandle(ScummVMHandle);
      end;
    finally
      St.Free;
    end;
  finally
    If PrgSetup.MinimizeOnScummVMStart and (not AlreadyMinimized) then MinimizedAtScummVMStart:=True;
  end;
end;

end.
