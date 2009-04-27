; NSI SCRIPT FOR D-FEND RELOADED
; ============================================================

!include VersionSettings.nsi
!insertmacro VersionData
!define INST_FILENAME "Setup.exe"

!include CommonTools.nsi



; Register custom page definitions for different languages
; ============================================================

!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
ReserveFile "Languages\ioFileDanish.ini"
ReserveFile "Languages\ioFileDutch.ini"
ReserveFile "Languages\ioFileEnglish.ini"
ReserveFile "Languages\ioFileFrench.ini"
ReserveFile "Languages\ioFileGerman.ini"
ReserveFile "Languages\ioFileItalian.ini"
ReserveFile "Languages\ioFilePolish.ini"
ReserveFile "Languages\ioFileRussian.ini"
ReserveFile "Languages\ioFileSimplified_Chinese.ini"
ReserveFile "Languages\ioFileSpanish.ini"
ReserveFile "Languages\ioFileTraditional_Chinese.ini"

ReserveFile "Languages\ioFile2Danish.ini"
ReserveFile "Languages\ioFile2Dutch.ini"
ReserveFile "Languages\ioFile2English.ini"
ReserveFile "Languages\ioFile2French.ini"
ReserveFile "Languages\ioFile2German.ini"
ReserveFile "Languages\ioFile2Italian.ini"
ReserveFile "Languages\ioFile2Polish.ini"
ReserveFile "Languages\ioFile2Russian.ini"
ReserveFile "Languages\ioFile2Simplified_Chinese.ini"
ReserveFile "Languages\ioFile2Spanish.ini"
ReserveFile "Languages\ioFile2Traditional_Chinese.ini"



; Settings for the modern user interface (MUI)
; ============================================================

Var FastInstallationMode

Function AbortIfFastMode
  IntCmp $FastInstallationMode 1 AbortPage ShowPage
  AbortPage:
  Abort
  ShowPage:
FunctionEnd

!insertmacro MUI_PAGE_WELCOME
; !insertmacro MUI_PAGE_LICENSE $(LANGNAME_License)
Page custom InstallMode
Page custom InstallType 
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortIfFastMode
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortIfFastMode
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro UninstallerPages
!insertmacro LanguageSetup



; Definition of install sections
; ============================================================

!insertmacro CommonSections

Section "$(LANGNAME_DFendReloaded)" ID_DFend
  SectionIn RO
  SetDetailsPrint both
  
  ; Installation type
  ; ($InstallDataType=0 <=> Prg dir mode, $InstallDataType=1 <=> User dir mode; in user dir mode $DataInstDir will contain the data directory otherwise $INSTDIR)
  
  IntCmp $InstallDataType 1 UserDataDir
  strcpy $DataInstDir $INSTDIR
  Goto StartInstall
  UserDataDir:
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  StartInstall:
  
  ; Store installation folder in registry if not portable installation
  
  IntCmp $InstallDataType 2 NoRegistryWhenUSBStickInstall
  WriteRegStr HKLM "Software\D-Fend Reloaded" "ProgramFolder" "$INSTDIR"
  WriteRegStr HKLM "Software\D-Fend Reloaded" "DataFolder" "$DataInstDir"
  NoRegistryWhenUSBStickInstall:
  
  ; Install main files

  SetOutPath "$INSTDIR"
  File "..\DFend.exe"
  File "..\Readme_OperationMode.txt"
  
  SetOutPath "$INSTDIR\Bin"
  File "..\Bin\mkdosfs.exe"  
  File "..\Bin\oggenc2.exe"
  File "..\Bin\License.txt"
  File "..\Bin\LicenseComponents.txt"
  File "..\Bin\Links.txt"
  File "..\Bin\SearchLinks.txt"
  File "..\Bin\ChangeLog.txt"
  File "..\Bin\D-Fend Reloaded DataInstaller.nsi"
  File "..\Bin\UpdateCheck.exe"
  File "..\Bin\SetInstallerLanguage.exe"  
  File "..\Bin\7za.dll"
  File "..\Bin\DelZip179.dll"
  File "..\Bin\mediaplr.dll"
  File "..\Bin\InstallVideoCodec.exe"
  IntCmp $InstallDataType 2 +2
  File "..\Bin\DFendGameExplorerData.dll"

  CreateDirectory "$DataInstDir\Confs"
  
  CreateDirectory "$DataInstDir\GameData"

  SetOutPath "$INSTDIR\Lang"
  File "..\Lang\*.ini"
  File "..\Lang\*.chm"

  SetOutPath "$INSTDIR\IconSets"
  File /r "..\IconSets\*.*"

  ; Remove files in $INSTDIR for which the new position is $INSTDIR\Bin
  
  Delete "$INSTDIR\oggenc2.exe"
  Delete "$INSTDIR\LicenseComponents.txt"
  Delete "$INSTDIR\License.txt"
  IntCmp $InstallDataType 0 KeepSettingsFilesIfPrgDirIsUserDir  
  Delete "$INSTDIR\Links.txt"
  Delete "$INSTDIR\SearchLinks.txt"
  KeepSettingsFilesIfPrgDirIsUserDir:
  Delete "$INSTDIR\ChangeLog.txt"
  Delete "$INSTDIR\D-Fend Reloaded DataInstaller.nsi"
  Delete "$INSTDIR\SetInstallerLanguage.exe"
  Delete "$INSTDIR\UpdateCheck.exe"
  Delete "$INSTDIR\7za.dll"
  Delete "$INSTDIR\DelZip179.dll"
  Delete "$INSTDIR\InstallVideoCodec.exe"
  Delete "$INSTDIR\mkdosfs.exe"
  Delete "$INSTDIR\mediaplr.dll"
  
  SetDetailsPrint none
  
  ; Install templates  
  
  IntCmp $InstallDataType 1 WriteNewUserDir
  
    SetOutPath "$DataInstDir\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$DataInstDir\Templates"
    File "..\NewUserData\Templates\*.prof"
	
    SetOutPath "$DataInstDir\AutoSetup"
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$DataInstDir\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$DataInstDir\Settings"
    File "..\NewUserData\Icons.ini"
  
  Goto TemplateWritingFinish
  WriteNewUserDir:  

    SetOutPath "$INSTDIR\NewUserData\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$INSTDIR\NewUserData\Templates"
    File "..\NewUserData\Templates\*.prof"
	
    SetOutPath "$INSTDIR\NewUserData\AutoSetup"
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$INSTDIR\NewUserData\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$INSTDIR\NewUserData"
    File "..\NewUserData\Icons.ini"

  TemplateWritingFinish:
  
  SetDetailsPrint both
  
  ; Create "VirtualHD" folder in data dir
  
  CreateDirectory "$DataInstDir\VirtualHD"

  ; Write installation mode to DFend.dat
  
  ClearErrors
  FileOpen $0 $INSTDIR\DFend.dat w
  IfErrors InstTypeEnd
  IntCmp $InstallDataType 0 InstType0
  IntCmp $InstallDataType 1 InstType1
  FileWrite $0 "PORTABLEMODE"
  Goto InstTypeClose
  InstType0:
  FileWrite $0 "PRGDIRMODE"
  Goto InstTypeClose
  InstType1:
  FileWrite $0 "USERDIRMODE"
  InstTypeClose:
  FileClose $0
  InstTypeEnd:
  
  ; Create uninstaller and start menu entries
  
  IntCmp $InstallDataType 2 NoDFendStartMenuLinks
  SetOutPath "$INSTDIR"
  WriteUninstaller "Uninstall.exe"
  
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_DFendReloaded).lnk" "$INSTDIR\DFend.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_Uninstall).lnk" "$INSTDIR\Uninstall.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GamesFolder).lnk" "$DataInstDir\VirtualHD"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GameDataFolder).lnk" "$DataInstDir\GameData"
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayName" "${PrgName} ($(LANGNAME_Deinstall))"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "UninstallString" '"$INSTDIR\Uninstall.exe"'  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayIcon" "$INSTDIR\DFend.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "Publisher" "Alexander Herzog"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoModify" 1
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoRepair" 1
  
  ; Add/Update to Vista games explorer
  IfFileExists "$LOCALAPPDATA\Microsoft\Windows\GameExplorer\*.*" 0 NoDFendStartMenuLinks
  ClearErrors
  ReadRegStr $GEGUID HKLM "Software\D-Fend Reloaded" "GameExplorerGUID"  
  IfErrors 0 NoNewGEGUIDNeeded
  ${GameExplorer_GenerateGUID}
  Pop $GEGUID
  WriteRegStr HKLM "Software\D-Fend Reloaded" "GameExplorerGUID" "$GEGUID"
  NoNewGEGUIDNeeded:
  ClearErrors
  ${GameExplorer_AddGame} all $INSTDIR\Bin\DFendGameExplorerData.dll $INSTDIR $INSTDIR\DFend.exe $GEGUID

  NoDFendStartMenuLinks:
SectionEnd



SectionGroup "$(LANGNAME_DOSBox)" ID_DosBox
  
Section "$(LANGNAME_ProgramFiles)" ID_DosBoxProgramFiles
  SetDetailsPrint both
  SetOutPath "$INSTDIR\DOSBox"
  SetDetailsPrint none
  File "..\DOSBox\README.txt"
  File "..\DOSBox\COPYING.txt"
  File "..\DOSBox\THANKS.txt"
  File "..\DOSBox\NEWS.txt"
  File "..\DOSBox\AUTHORS.txt"
  File "..\DOSBox\INSTALL.txt"
  File "..\DOSBox\DOSBox.exe"
  File "..\DOSBox\dosbox.conf"
  File "..\DOSBox\SDL.dll"
  File "..\DOSBox\SDL_net.dll"
  
  SetOutPath "$INSTDIR\DOSBox\zmbv"
  File "..\DOSBox\zmbv\zmbv.dll"
  File "..\DOSBox\zmbv\zmbv.inf"
  File "..\DOSBox\zmbv\README.txt"

  CreateDirectory "$INSTDIR\DOSBox\capture"
  
  IntCmp $InstallDataType 2 NoDosBoxStartMenuLinks
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox"
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox.lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox (noconsole).lnk" "$INSTDIR\DOSBox\DOSBox.exe" "-noconsole -conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\README.lnk" "$INSTDIR\DOSBox\README.txt"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox.conf.lnk" "notepad.exe" "$INSTDIR\DOSBox\dosbox.conf"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Capture folder.lnk" "$INSTDIR\DOSBox\capture"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video\Video instructions.lnk" "$INSTDIR\DOSBox\zmbv\README.txt"
  
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x we_nt
  we_nt:  
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll32" "setupapi,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\zmbv\zmbv.inf"
  goto end
  we_9x:
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll" "setupx.dll,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\zmbv\zmbv.inf"
  end:
  NoDosBoxStartMenuLinks:
SectionEnd

Section "$(LANGNAME_LanguageFiles)" ID_DosBoxLanguageFiles
  SetDetailsPrint both
  SetOutPath "$INSTDIR\DOSBox"
  SetDetailsPrint none
  File "..\DosBoxLang\*.*"
SectionEnd

Section "$(LANGNAME_VideoCodec)" ID_DosBoxVideoCodec
  SetDetailsPrint both
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x2 we_nt2
  we_nt2:
  Exec '"rundll32" setupapi,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\zmbv\zmbv.inf'
  goto end2
  we_9x2:
  Exec '"rundll32" setupx.dll,InstallHinfSection DefaultInstall 128 $INSTDIR\DOSBox\zmbv\zmbv.inf'
  end2:
SectionEnd
 
SectionGroupEnd



SectionGroup "$(LANGNAME_Tools)" ID_Tools

Section "$(LANGNAME_FreeDosTools)" ID_FreeDosTools
  SetDetailsPrint both
  
  IntCmp $InstallDataType 1 FreeDOSToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\FREEDOS"
  Goto FreeDOSWritingStart
  FreeDOSToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\FREEDOS"
  FreeDOSWritingStart:
  
  SetDetailsPrint none
  File /r "..\NewUserData\FREEDOS\*.*"
SectionEnd

Section "$(LANGNAME_Doszip)" ID_Doszip
  SetDetailsPrint both
  
  IntCmp $InstallDataType 1 DoszipToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\DOSZIP"
  Goto DoszipWritingStart
  DoszipToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\DOSZIP"
  DoszipWritingStart:
  
  SetDetailsPrint none
  File /r "..\NewUserData\DOSZIP\*.*"
SectionEnd

SectionGroupEnd



Section "$(LANGNAME_DesktopShortcut)" ID_DesktopShortcut
  SetDetailsPrint both
  SetShellVarContext all
  CreateShortCut "$DESKTOP\$(LANGNAME_DFendReloaded).lnk" "$INSTDIR\DFend.exe" 
SectionEnd



; Definition of NSIS functions
; ============================================================

!macro ExtractInstallOptionFiles
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileDanish.ini" "ioFileDanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileDutch.ini" "ioFileDutch.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileEnglish.ini" "ioFileEnglish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileFrench.ini" "ioFileFrench.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileGerman.ini" "ioFileGerman.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileItalian.ini" "ioFileItalian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFilePolish.ini" "ioFilePolish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileRussian.ini" "ioFileRussian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileSimplified_Chinese.ini" "ioFileSimplified_Chinese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileSpanish.ini" "ioFileSpanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFileTraditional_Chinese.ini" "ioFileTraditional_Chinese.ini"
  
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Danish.ini" "ioFile2Danish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Dutch.ini" "ioFile2Dutch.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2English.ini" "ioFile2English.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2French.ini" "ioFile2French.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2German.ini" "ioFile2German.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Italian.ini" "ioFile2Italian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Polish.ini" "ioFile2Polish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Russian.ini" "ioFile2Russian.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Simplified_Chinese.ini" "ioFile2Simplified_Chinese.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Spanish.ini" "ioFile2Spanish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Languages\ioFile2Traditional_Chinese.ini" "ioFile2Traditional_Chinese.ini"
!macroend

!insertmacro CommonUACCode

Var FONT

!macro ActivateSection SectionID
  SectionGetFlags ${SectionID} $R0
  IntOp $R0 $R0 | 0x00000001
  SectionSetFlags ${SectionID} $R0
!macroend

Function InstallMode
  IntOp $FastInstallationMode 0 + 0
  IntCmp $AdminOK 0 InstallModePageFinish
  
  !insertmacro MUI_HEADER_TEXT $(PAGE2_TITLE) $(PAGE2_SUBTITLE)
  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG  "$(LANGNAME_ioFile2)"  
  
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 1" "HWND"
  CreateFont $FONT "$(^Font)" "$(^FontSize)" "600"
  SendMessage $9 ${WM_SETFONT} $FONT 0

  !insertmacro MUI_INSTALLOPTIONS_SHOW

  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile2)" "Field 1" "State"
  IntCmp $9 1 FastMode
  Goto InstallModePageFinish
  FastMode:  
  !insertmacro ActivateSection ${ID_DosBox}
  !insertmacro ActivateSection ${ID_DosBoxProgramFiles}
  !insertmacro ActivateSection ${ID_DosBoxLanguageFiles}
  !insertmacro ActivateSection ${ID_DosBoxVideoCodec}
  !insertmacro ActivateSection ${ID_Tools}
  !insertmacro ActivateSection ${ID_FreeDosTools}
  !insertmacro ActivateSection ${ID_Doszip}
  !insertmacro ActivateSection ${ID_DesktopShortcut}
  StrCpy $INSTDIR "$PROGRAMFILES\D-Fend Reloaded\"
  IntOp $InstallDataType 1 + 0
  IntOp $FastInstallationMode 1 + 0
  InstallModePageFinish:
FunctionEnd

Function InstallType
  IntCmp $FastInstallationMode 1 EndSel

  !insertmacro MUI_HEADER_TEXT $(PAGE_TITLE) $(PAGE_SUBTITLE)
  
  IntCmp $AdminOK 1 NoInstallrestrictions 
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 1" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 3" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 3" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "$(LANGNAME_ioFile)" "Field 5" "State" "1"
  NoInstallrestrictions:
  
  !insertmacro MUI_INSTALLOPTIONS_INITDIALOG  "$(LANGNAME_ioFile)"  
  
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 3" "HWND"
  CreateFont $FONT "$(^Font)" "$(^FontSize)" "600"
  SendMessage $9 ${WM_SETFONT} $FONT 0  
  
  !insertmacro MUI_INSTALLOPTIONS_SHOW

  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 1" "State"
  IntCmp $9 0 Next1
  IntOp $InstallDataType 0 + 0
  Goto EndSel
  
  Next1:
  !insertmacro MUI_INSTALLOPTIONS_READ $9 "$(LANGNAME_ioFile)" "Field 3" "State"
  IntCmp $9 0 Next2
  IntOp $InstallDataType 1 + 0
  Goto EndSel  
  
  Next2:
  IntOp $InstallDataType 2 + 0
  SectionGetFlags ${ID_DesktopShortcut} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DesktopShortcut} $R0    
  
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0

  StrCpy $INSTDIR "$DESKTOP\D-Fend Reloaded\"
  
  EndSel:
FunctionEnd

Function .onSelChange
  IntCmp $InstallDataType 2 NoDesktopShortcut
  Goto NextSelChangeCheck
  
  NoDesktopShortcut:  
  
  SectionGetFlags ${ID_DesktopShortcut} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DesktopShortcut} $R0
  
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0  
  
  NextSelChangeCheck:

  SectionGetFlags ${ID_DosBoxProgramFiles} $R0
  IntOp $R0 $R0 & 1
  IntCmp $R0 1 End
  
  SectionGetFlags ${ID_DosBoxLanguageFiles} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxLanguageFiles} $R0
    
  SectionGetFlags ${ID_DosBoxVideoCodec} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxVideoCodec} $R0
	
  End:
FunctionEnd



; Link between install sections and descriptions
; ============================================================

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DFend} $(DESC_DFend)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBox} $(DESC_DosBox)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxProgramFiles} $(DESC_DosBoxProgramFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxLanguageFiles} $(DESC_DosBoxLanguageFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxVideoCodec} $(DESC_VideoCodec)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_Tools} $(DESC_Tools)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_FreeDosTools} $(DESC_FreeDosTools)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_Doszip} $(DESC_Doszip)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DesktopShortcut} $(DESC_DesktopShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

