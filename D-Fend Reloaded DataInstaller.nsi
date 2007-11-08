; NSI SCRIPT FOR D-FEND RELOADED DATA PACKAGES
; ============================================================

; This is a include file. Example of a installer script file:
; OutFile "...-Setup.exe"
; !include "D-Fend Reloaded DataInstaller.nsi"
;
;Section "PrgName"
;  SetOutPath "$DataInstDir\Confs"
;  File ".\Confs\Prg.prof"
;  SetOutPath "$DataInstDir\VirtualHD\PrgDir"
;  File /r ".\VirtualHD\PrgDir\*.*"
;SectionEnd

!include "MUI.nsh"
!include WinMessages.nsh

Name "D-Fend Reloaded data package"
BrandingText "D-Fend Reloaded data package"

SetCompressor /solid lzma
RequestExecutionLevel user
XPStyle on
InstallDir "$PROGRAMFILES\D-Fend Reloaded"
InstallDirRegKey HKLM "Software\D-Fend Reloaded" "ProgramFolder"
!insertmacro MUI_RESERVEFILE_LANGDLL

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT "$(LANGNAME_WelcomeText)"
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_RUN "$INSTDIR\DFend.exe"
!define MUI_FINISHPAGE_RUN_TEXT "$(LANGNAME_RunDFend)"

!define MUI_LANGDLL_REGISTRY_ROOT "HKLM" 
!define MUI_LANGDLL_REGISTRY_KEY "Software\D-Fend Reloaded" 
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

Var DataInstDir

LangString LANGNAME_WelcomeText ${LANG_ENGLISH} "This wizard will guide you through the installation.\r\n\r\nPlease close D-Fend Reloaded before continuing.\r\n\r\nClick Next to continue."
LangString LANGNAME_InstallError ${LANG_ENGLISH} "$INSTDIR\DFend.dat not found."
LangString LANGNAME_RunDFend ${LANG_ENGLISH} "Run D-Fend Reloaded now"
LangString LANGNAME_WelcomeText ${LANG_GERMAN} "Dieser Assistent wird Sie durch die Installation begleiten.\r\n\r\nBitte beenden Sie D-Fend Reloaded, bevor Sie fortfahren.\r\n\r\nKlicken Sie auf Weiter, um fortzufahren."
LangString LANGNAME_InstallError ${LANG_GERMAN} "Die Datei $INSTDIR\DFend.dat existiert nicht."
LangString LANGNAME_RunDFend ${LANG_GERMAN} "Fend Reloaded jetzt ausführen"

Function .onInit  
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd  

Section "-SearchingDFendDataDir"
  SectionIn RO
  
  ; Searching DFend.dat
  IfFileExists "$INSTDIR\DFend.dat" DFendDatExists
  MessageBox MB_OK "$(LANGNAME_InstallError)"
  Abort
  DFendDatExists:
  
  ; Reading DFend.dat
  ClearErrors
  FileOpen $0 "$INSTDIR\DFend.dat" r
  IfErrors ErrorReadingDFendDat
  FileRead $0 $1
  FileClose $0
  ErrorReadingDFendDat:

  ; Interpreting DFend.dat content
  StrCmp $1 "USERDIRMODE" Mode1
  StrCpy $DataInstDir  $INSTDIR  
  Goto ModeFinish
  Mode1:
  StrCpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  ModeFinish:
SectionEnd

!define TO_MS 2000
!define SYNC_TERM 0x00100001

Section "-CloseDFend"
  SectionIn RO

  Push $0
  FindWindow $0 'TDFendReloadedMainform' ''
  IntCmp $0 0 DoneCloseDFend
  SendMessage $0 ${WM_CLOSE} 0 0 /TIMEOUT=${TO_MS}
  DoneCloseDFend:
  Pop $0
SectionEnd