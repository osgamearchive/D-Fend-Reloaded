; NSI SCRIPT FOR D-FEND RELOADED (UPDATE)
; ============================================================



; Include used librarys
; ============================================================

!include "MUI.nsh"
!include "WinMessages.nsh"



; Define program name and version
; ============================================================

!define VER_MAYOR 0
!define VER_MINOR1 3
!define VER_MINOR2 0

!define PrgName "D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
OutFile "D-Fend-Reloaded-${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}-UpdateSetup.exe"



; Initial settings
; ============================================================

!packhdr "$%TEMP%\exehead.tmp" 'upx.exe "$%TEMP%\exehead.tmp"'

Name "${PrgName}"
BrandingText "${PrgName} UPDATE"

RequestExecutionLevel user
XPStyle on
InstallDir "$PROGRAMFILES\D-Fend Reloaded"
SetCompressor /solid lzma
!insertmacro MUI_RESERVEFILE_LANGDLL



; Settings for the modern user interface (MUI)
; ============================================================

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\win.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "13c.bmp"

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "$(LANGNAME_WelcomeTextUpdate)"
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION ExecAppFile
!define MUI_FINISHPAGE_RUN_TEXT "$(LANGNAME_RunDFend)"

Function ExecAppFile
  ; Execute DFend as normal user (unelevated), otherwise data package installers can't close DFend
  UAC::Exec '' '"$INSTDIR\DFend.exe"' '' ''
FunctionEnd

!define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
!define MUI_LANGDLL_REGISTRY_KEY "Software\D-Fend Reloaded" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH



; Global variables
; ============================================================

Var DataInstDir



; Main settings for different languages
; ============================================================

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

!include "D-Fend-Reloaded-Setup-Lang-English.nsi"
!include "D-Fend-Reloaded-Setup-Lang-German.nsi"



; Definition of install sections
; ============================================================

Section "-CloseDFend"
  SectionIn RO

  Push $0
  FindWindow $0 'TDFendReloadedMainform' ''
  IntCmp $0 0 DoneCloseDFend
  SendMessage $0 ${WM_CLOSE} 0 0 /TIMEOUT=${TO_MS}
  Sleep 2000
  DoneCloseDFend:
  Pop $0
SectionEnd

Section "$(LANGNAME_DFendReloaded)" ID_DFend
  SectionIn RO
  
  IfFileExists "$INSTDIR\DFend.dat" StartCheck
  MessageBox MB_OK "$(LANGNAME_NoInstallationFound)"
  Quit
  StartCheck:
  
  StrCpy $DataInstDir $INSTDIR
  
  ClearErrors
  FileOpen $0 $INSTDIR\DFend.dat r
  IfErrors ReadInstTypeEnd
  FileRead $0 $1
  FileClose $0
  StrCmp $1 "USERDIRMODE" InstUserMode
  Goto ReadInstTypeEnd
  InstUserMode:
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  ReadInstTypeEnd:
  
  SetOutPath "$INSTDIR"
  File "..\DFend.exe"
  File "..\oggenc2.exe"
  File "..\LicenseComponents.txt"
  File "..\Links.txt"
  File "..\ChangeLog.txt"
  File "..\FAQs.txt"
  File "..\D-Fend Reloaded DataInstaller.nsi"
  File "..\UpdateCheck\UpdateCheck.exe"
  
  SetOutPath "$DataInstDir"
  File "..\D-Fend Reloaded DataInstaller.nsi"
  File "..\Icons.ini"
    
  SetOutPath "$INSTDIR\Lang"
  File "..\Lang\*.ini"
  
  SetOutPath "$DataInstDir\Templates"
  File "..\Templates\*.prof"
  
  SetOutPath "$DataInstDir\IconLibrary"
  File "..\IconLibrary\*.*"
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
  MessageBox MB_YESNO "$(LANGNAME_NeedAdminRightsUpdate)" IDYES UAC_Elevate IDNO InitReturn

  InitReturn:
FunctionEnd  

Function .OnInstFailed
    UAC::Unload
FunctionEnd

Function .OnInstSuccess
    UAC::Unload
FunctionEnd