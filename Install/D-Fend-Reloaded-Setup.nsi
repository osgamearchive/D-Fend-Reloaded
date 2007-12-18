; NSI SCRIPT FOR D-FEND RELOADED
; ============================================================



; Include used librarys
; ============================================================

!include "MUI.nsh"
!include "Sections.nsh"



; Define program name and version
; ============================================================

!define VER_MAYOR 0
!define VER_MINOR1 1
!define VER_MINOR2 1

!define PrgName "D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
OutFile "D-Fend-Reloaded-${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}-Setup.exe"



; Initial settings
; ============================================================

Name "${PrgName}"
BrandingText "${PrgName}"

RequestExecutionLevel user
XPStyle on
InstallDir "$PROGRAMFILES\D-Fend Reloaded"
InstallDirRegKey HKLM "Software\D-Fend Reloaded" "ProgramFolder"
SetCompressor /solid lzma
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
!insertmacro MUI_RESERVEFILE_LANGDLL



; Register custom page definitions and license for different languages here
; ============================================================

ReserveFile "ioFileGerman.ini"
ReserveFile "ioFileEnglish.ini"



; Settings for the modern user interface (MUI)
; ============================================================

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\win.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "1035.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "13b.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "27.bmp"

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "$(LANGNAME_WelcomeText)"
!define MUI_LICENSEPAGE_HEADER_TEXT "$(LANGNAME_LICENSE_TITLE)"
!define MUI_LICENSEPAGE_HEADER_SUBTEXT "$(LANGNAME_LICENSE_SUBTITLE)"
!define MUI_LICENSEPAGE_TEXT_TOP "$(LANGNAME_LICENSE_TOP)"
!define MUI_LICENSEPAGE_TEXT_BOTTOM "$(LANGNAME_LICENSE_BOTTOM)"
!define MUI_LICENSEPAGE_BUTTON "$(LANGNAME_Next) >"
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION ExecAppFile
!define MUI_FINISHPAGE_RUN_TEXT "$(LANGNAME_RunDFend)"
!define MUI_UNABORTWARNING
!define MUI_UNWELCOMEPAGE_TITLE_3LINES
!define MUI_UNFINISHPAGE_TITLE_3LINES

Function ExecAppFile
  ; Execute DFend as normal user (unelevated), otherwise data package installers can't close DFend
  UAC::Exec '' '"$INSTDIR\DFend.exe"' '' ''
FunctionEnd

!define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
!define MUI_LANGDLL_REGISTRY_KEY "Software\D-Fend Reloaded" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE $(LANGNAME_License)
Page custom InstallType
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH



; Global variables
; ============================================================

Var InstallDataType
Var DataInstDir



; Main settings for different languages
; ============================================================

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

!include "D-Fend-Reloaded-Setup-Lang-English.nsi"
!include "D-Fend-Reloaded-Setup-Lang-German.nsi"



; Definition of install sections
; ============================================================

Section "$(LANGNAME_DFendReloaded)" ID_DFend
  SectionIn RO
  
  IntCmp $InstallDataType 1 UserDataDir
  strcpy $DataInstDir $INSTDIR
  Goto StartInstall
  UserDataDir:
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  StartInstall:
  
  IntCmp $InstallDataType 2 NoRegistryWhenUSBStickInstall
  WriteRegStr HKLM "Software\D-Fend Reloaded" "ProgramFolder" "$INSTDIR"
  WriteRegStr HKLM "Software\D-Fend Reloaded" "DataFolder" "$DataInstDir"
  NoRegistryWhenUSBStickInstall:

  SetOutPath "$INSTDIR"
  File "..\DFend.exe"
  File "..\mkdosfs.exe"  
  File "..\License.txt"
  File "..\LicenseComponents.txt"
  File "..\Links.txt"
  File "..\ChangeLog.txt"
  File "..\Readme_OperationMode.txt"
  
  SetOutPath "$DataInstDir"
  File "..\D-Fend Reloaded DataInstaller.nsi"
  
  CreateDirectory "$DataInstDir\Confs"
  
  SetOutPath "$DataInstDir\Capture\DOSBox DOS"
  File "..\Capture\DOSBox DOS\*.*"
  
  SetOutPath "$INSTDIR\Lang"
  File "..\Lang\*.ini"  
  
  SetOutPath "$DataInstDir\Templates"
  File "..\Templates\*.prof"
  
  CreateDirectory "$DataInstDir\GameData"
  CreateDirectory "$DataInstDir\IconLibrary"
  CreateDirectory "$DataInstDir\VirtualHD"

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
  
  IntCmp $InstallDataType 2 NoDFendStartMenuLinks
  SetOutPath "$INSTDIR"
  WriteUninstaller "Uninstall.exe"
  
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_DFendReloaded).lnk" "$INSTDIR\DFend.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_Uninstall).lnk" "$INSTDIR\Uninstall.exe"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GamesFolder).lnk" "$DataInstDir\VirtualHD"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\$(LANGNAME_GameDataFolder).lnk" "$DataInstDir\GameData"
  
  IntCmp $InstallDataType 2 NoDFendStartMenuLinks
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayName" "${PrgName} ($(LANGNAME_Deinstall))"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "UninstallString" '"$INSTDIR\Uninstall.exe"'  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayIcon" "$INSTDIR\DFend.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "Publisher" "Alexander Herzog"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoModify" 1
  WriteRegDWord HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "NoRepair" 1
  NoDFendStartMenuLinks:
SectionEnd



SectionGroup "$(LANGNAME_DOSBox)" ID_DosBox
  
Section "$(LANGNAME_ProgramFiles)" ID_DosBoxProgramFiles
  SetOutPath "$INSTDIR\DosBox"
  File "..\DosBox\README.txt"
  File "..\DosBox\COPYING.txt"
  File "..\DosBox\THANKS.txt"
  File "..\DosBox\NEWS.txt"
  File "..\DosBox\AUTHORS.txt"
  File "..\DosBox\INSTALL.txt"
  File "..\DosBox\DOSBox.exe"
  File "..\DosBox\dosbox.conf"
  File "..\DosBox\SDL.dll"
  File "..\DosBox\SDL_net.dll"
  
  SetOutPath "$INSTDIR\DosBox\zmbv"
  File "..\DosBox\zmbv\zmbv.dll"
  File "..\DosBox\zmbv\zmbv.inf"
  File "..\DosBox\zmbv\README.txt"

  CreateDirectory "$INSTDIR\DosBox\capture"
  
  IntCmp $InstallDataType 2 NoDosBoxStartMenuLinks
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox"
  CreateDirectory "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox.lnk" "$INSTDIR\DosBox\DOSBox.exe" "-conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox (noconsole).lnk" "$INSTDIR\DosBox\DOSBox.exe" "-noconsole -conf $\"$INSTDIR\DosBox\dosbox.conf$\"" "$INSTDIR\DosBox\DOSBox.exe" 0
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\README.lnk" "$INSTDIR\DosBox\README.txt"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\DOSBox.conf.lnk" "notepad.exe" "$INSTDIR\DosBox\dosbox.conf"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Capture folder.lnk" "$INSTDIR\DosBox\capture"
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DOSBox\Video\Video instructions.lnk" "$INSTDIR\DosBox\zmbv\README.txt"
  
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  IfErrors we_9x we_nt
  we_nt:  
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll32" "setupapi,InstallHinfSection DefaultInstall 128 $INSTDIR\DosBox\zmbv\zmbv.inf"
  goto end
  we_9x:
  CreateShortCut "$SMPROGRAMS\D-Fend Reloaded\DosBox\Video\Install movie codec.lnk" "rundll" "setupx.dll,InstallHinfSection DefaultInstall 128 $INSTDIR\DosBox\zmbv\zmbv.inf"
  end:
  NoDosBoxStartMenuLinks:
SectionEnd

Section "$(LANGNAME_LanguageFiles)" ID_DosBoxLanguageFiles
  SetOutPath "$INSTDIR\DosBox"
  File "..\DosBoxLang\*.*"
SectionEnd
 
SectionGroupEnd



Section "$(LANGNAME_FreeDosTools)" ID_FreeDosTools
  SetOutPath "$DataInstDir\VirtualHD\FREEDOS"
  File /r "..\VirtualHD\FREEDOS\*.*"
SectionEnd



Section "$(LANGNAME_DesktopShortcut)" ID_DesktopShortcut
  CreateShortCut "$DESKTOP\D-Fend Reloaded.lnk" "$INSTDIR\DFend.exe" 
SectionEnd



Section "Uninstall"
  ClearErrors
  FileOpen $0 $INSTDIR\DFend.dat r
  IfErrors UninstallUserDataEnd
  FileRead $0 $1
  FileClose $0
  StrCmp $1 "USERDIRMODE" AskForUserDataDel
  Goto UninstallUserDataEnd
  AskForUserDataDel:
  ReadRegStr $DataInstDir HKLM "Software\D-Fend Reloaded" "DataFolder"
  StrCmp $DataInstDir "" UninstallUserDataEnd
  MessageBox MB_YESNO "$(LANGNAME_ConfirmDelUserData)" IDYES DelUserData IDNO UninstallUserDataEnd
  DelUserData:  
  RmDir /r $DataInstDir  
  UninstallUserDataEnd:

  RmDir /r $INSTDIR
  RmDir /r "$SMPROGRAMS\D-Fend Reloaded"
  Delete "$DESKTOP\D-Fend Reloaded.lnk"
  DeleteRegKey HKLM "${MUI_LANGDLL_REGISTRY_KEY}"
SectionEnd



; Definition of NSIS functions
; ============================================================

Var AdminOK

Function .onInit  
  UAC_Elevate:
  UAC::RunElevated 
  StrCmp 1223 $0 UAC_ElevationAborted
  StrCmp 0 $0 0 UAC_Err
  StrCmp 1 $1 0 UAC_Success
  Quit
  UAC_Err:
  Abort
  UAC_Success:
  StrCmp 1 $3 UAC_OK
  StrCmp 3 $1 0 UAC_ElevationAborted
  UAC_ElevationAborted:
  IntOp $AdminOK 0 + 0
  Goto SelLang
  UAC_OK:
  IntOp $AdminOK 1 + 0
  Goto SelLang
  
  SelLang:
  !insertmacro MUI_LANGDLL_DISPLAY
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioFileEnglish.ini"
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "ioFileGerman.ini"
  
  IntCmp $AdminOK 1 InitReturn
  MessageBox MB_YESNO "$(LANGNAME_NeedAdminRights)" IDYES UAC_Elevate IDNO InitReturn

  InitReturn:
FunctionEnd  

Function un.onInit  
  UAC::RunElevated 
  StrCmp 1223 $0 UAC_UnErr
  StrCmp 0 $0 0 UAC_UnErr
  StrCmp 1 $1 0 UAC_UnSuccess
  Quit
  UAC_UnErr:
  Abort
  UAC_UnSuccess:
  StrCmp 1 $3 UAC_UnOK
  StrCmp 3 $1 0 UAC_UnErr
  UAC_UnOK:

  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Function .OnInstFailed
    UAC::Unload
FunctionEnd

Function .OnInstSuccess
    UAC::Unload
FunctionEnd

Function un.OnUnInstFailed
    UAC::Unload
FunctionEnd

Function un.OnUnInstSuccess
    UAC::Unload
FunctionEnd

Function InstallType
  !insertmacro MUI_HEADER_TEXT $(PAGE_TITLE) $(PAGE_SUBTITLE)
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "$(LANGNAME_ioFile)"
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
  
  EndSel:
FunctionEnd

Function .onSelChange
  IntCmp $InstallDataType 2 NoDesktopShortcut
  Goto NextSelChangeCheck
  NoDesktopShortcut:  
  SectionGetFlags ${ID_DesktopShortcut} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DesktopShortcut} $R0  
  NextSelChangeCheck:

  SectionGetFlags ${ID_DosBoxProgramFiles} $R0
  IntOp $R0 $R0 & 1
  IntCmp $R0 1 End
  
  SectionGetFlags ${ID_DosBoxLanguageFiles} $R0
  IntOp $R0 $R0 & 0xFFFFFFFE
  SectionSetFlags ${ID_DosBoxLanguageFiles} $R0
    
  End:
FunctionEnd



; Link between install sections and descriptions
; ============================================================

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DFend} $(DESC_DFend)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBox} $(DESC_DosBox)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxProgramFiles} $(DESC_DosBoxProgramFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DosBoxLanguageFiles} $(DESC_DosBoxLanguageFiles)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_FreeDosTools} $(DESC_FreeDosTools)
  !insertmacro MUI_DESCRIPTION_TEXT ${ID_DesktopShortcut} $(DESC_DesktopShortcut)
!insertmacro MUI_FUNCTION_DESCRIPTION_END
