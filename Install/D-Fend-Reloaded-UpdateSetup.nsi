; NSI SCRIPT FOR D-FEND RELOADED (UPDATE)
; ============================================================



; Include used librarys
; ============================================================

!include "MUI.nsh"
!include "WinMessages.nsh"



; Define program name and version
; ============================================================

!define VER_MAYOR 0
!define VER_MINOR1 4
!define VER_MINOR2 0

!define PrgName "D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
OutFile "D-Fend-Reloaded-${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}-UpdateSetup.exe"

VIAddVersionKey "ProductName" "D-Fend Reloaded"
VIAddVersionKey "ProductVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
VIAddVersionKey "Comments" "${PrgName} is a Frontend for DOSBox"
VIAddVersionKey "CompanyName" "Written by Alexander Herzog"
VIAddVersionKey "LegalCopyright" "Licensed under the GPL v3"
VIAddVersionKey "FileDescription" "Update installer for ${PrgName}"
VIAddVersionKey "FileVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
VIProductVersion "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}.0"




; Initial settings
; ============================================================

!packhdr "$%TEMP%\exehead.tmp" 'upx.exe "$%TEMP%\exehead.tmp"'

Name "${PrgName}"
BrandingText "${PrgName} UPDATE"

RequestExecutionLevel user
XPStyle on
InstallDir "$PROGRAMFILES\D-Fend Reloaded\"
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
Var InstallDataType



; Main settings for different languages
; ============================================================

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Spanish"

!include "D-Fend-Reloaded-Setup-Lang-English.nsi"
!include "D-Fend-Reloaded-Setup-Lang-French.nsi"
!include "D-Fend-Reloaded-Setup-Lang-German.nsi"
!include "D-Fend-Reloaded-Setup-Lang-Russian.nsi"
!include "D-Fend-Reloaded-Setup-Lang-Simplified_Chinese.nsi"
!include "D-Fend-Reloaded-Setup-Lang-Spanish.nsi"



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
  
  
  ; Read installation type
  
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
  IntOp $InstallDataType 0 + 0
  Goto ReadInstTypeEnd
  InstUserMode:
  IntOp $InstallDataType 0 + 1
  strcpy $DataInstDir "$PROFILE\D-Fend Reloaded"
  ReadInstTypeEnd:
  
  ; Update main files
  
  SetOutPath "$INSTDIR"
  File "..\DFend.exe"
  File "..\oggenc2.exe"
  File "..\LicenseComponents.txt"
  File "..\Links.txt"
  File "..\ChangeLog.txt"
  File "..\FAQs.txt"
  File "..\D-Fend Reloaded DataInstaller.nsi"
  File "..\UpdateCheck\UpdateCheck.exe"
  File "..\SetInstLang\SetInstallerLanguage.exe"
  
  SetOutPath "$DataInstDir"
  File "..\D-Fend Reloaded DataInstaller.nsi"
  File "..\Icons.ini"
  
  SetOutPath "$INSTDIR\Lang"
  File "..\Lang\*.ini"  
  
  ; Update config file
  
  WriteINIStr $DataInstDir\ConfOpt.dat resolution value original,320x200,640x432,640x480,720x480,800x600,1024x768,1152x864,1280x720,1280x768,1280x960,1280x1024,1600x1200,1920x1080,1920x1200
  WriteINIStr $DataInstDir\ConfOpt.dat joysticks value none,auto,2axis,4axis,fcs,ch
  
  ; Update templates
  
  IntCmp $InstallDataType 1 WriteNewUserDir
    
    SetOutPath "$DataInstDir\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$DataInstDir\Templates"
    File "..\NewUserData\Templates\*.prof"
	
    SetOutPath "$DataInstDir\AutoSetup"
    File "..\NewUserData\AutoSetup\*.prof"	

    SetOutPath "$DataInstDir\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
  
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
	
	; Copy FreeDOS files to NewUserData directory
	
	IfFileExists "$DataInstDir\VirtualHD\FREEDOS\*.*" 0 TemplateWritingFinish
	IfFileExists "$INSTDIR\NewUserData\FREEDOS\*.*" TemplateWritingFinish
	
	CreateDirectory "$INSTDIR\NewUserData\FREEDOS"
	CopyFiles /SILENT "$DataInstDir\VirtualHD\FREEDOS\*.*" "$INSTDIR\NewUserData\FREEDOS\"

  TemplateWritingFinish:
  
  ; Install DOSZip
  
  IntCmp $InstallDataType 1 DoszipToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\DOSZIP"
  Goto DoszipWritingStart
  DoszipToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\DOSZIP"
  DoszipWritingStart:
  
  File /r "..\NewUserData\DOSZIP\*.*" 
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
  !define MUI_LANGDLL_ALLLANGUAGES
  !insertmacro MUI_LANGDLL_DISPLAY
  
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