; NSI SCRIPT FOR D-FEND RELOADED (UPDATE)
; ============================================================

!include VersionSettings.nsi
!insertmacro VersionData
!define INST_FILENAME "UpdateSetup.exe"
!define Update
!include CommonTools.nsi



; Settings for the modern user interface (MUI)
; ============================================================

!insertmacro MUI_PAGE_WELCOME
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
  
  SetDetailsPrint none
  
  ; Read installation type
  ; ($InstallDataType=0 <=> Prg dir mode, $InstallDataType=1 <=> User dir mode; in user dir mode $DataInstDir will contain the data directory otherwise $INSTDIR)
  
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
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateDFendReloaded)"

  SetDetailsPrint listonly
  SetOutPath "$INSTDIR"
  SetDetailsPrint none  
  File "..\DFend.exe"
  File "..\Readme_OperationMode.txt"
  
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\Bin"  
  SetDetailsPrint none  
  File "..\Bin\oggenc2.exe"
  File "..\Bin\mkdosfs.exe"
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
  
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\Lang"
  SetDetailsPrint none  
  File "..\Lang\*.ini"
  File "..\Lang\*.chm"

  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\IconSets"
  SetDetailsPrint none  
  File /r "..\IconSets\*.*"
  
  ; Remove files in $INSTDIR for which the new position is $INSTDIR\Bin
  
  IfFileExists "$INSTDIR\License.txt" 0 +2
    CopyFiles /SILENT "$INSTDIR\License.txt" "$INSTDIR\Bin\License.txt"
   
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
  
  ; Update config file
  
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat resolution value original,320x200,320x240,640x432,640x480,720x480,800x600,1024x768,1152x864,1280x720,1280x768,1280x960,1280x1024,1600x1200,1920x1080,1920x1200,0x0
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat joysticks value none,auto,2axis,4axis,fcs,ch
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat GUSRate value 8000,11025,22050,32000,44100,48000,50000
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat OPLRate value 8000,11025,22050,32000,44100,48000,50000
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat PCRate value 8000,11025,22050,32000,44100,48000,50000
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat Rate value 8000,11025,22050,32000,44100,48000,50000
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat scale value "No Scaling (none),Nearest neighbor upscaling with factor 2 (normal2x),Nearest neighbor upscaling with factor 3 (normal3x),Advanced upscaling with factor 2 (advmame2x),Advanced upscaling with factor 3 (advmame3x),high quality with factor 2 (hq2x), high quality with factor 3 (hq3x),2xsai (2xsai), super2xsai (super2xsai), supereagle (supereagle),Advanced interpoling with factor 2 (advinterp2x),Advanced interpoling with factor 3 (advinterp3x),Advanced upscaling with sharpening with factor 2 (tv2x),Advanced upscaling with sharpening with factor 3 (tv3x),Simulates the phopsphors on a dot trio CRT with factor 2 (rgb2x),Simulates the phopsphors on a dot trio CRT with factor 3 (rgb3x),Nearest neighbor with black lines with factor 2 (scan2x),Nearest neighbor with black lines with factor 3 (scan3x)"
  WriteINIStr $DataInstDir\Settings\ConfOpt.dat video value "hercules,cga,tandy,pcjr,ega,vgaonly,svga_s3,svga_et3000,svga_et4000,svga_paradise,vesa_nolfb,vesa_oldvbe"
  
  ; Update templates

  IntCmp $InstallDataType 1 WriteNewUserDir
    ; Prg dir mode -> Update files directly

	SetDetailsPrint listonly
    SetOutPath "$DataInstDir\AutoSetup"
	SetDetailsPrint none
    File "..\NewUserData\AutoSetup\*.prof"	
	
    SetOutPath "$DataInstDir\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$DataInstDir\Templates"
    File "..\NewUserData\Templates\*.prof"

    SetOutPath "$DataInstDir\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$DataInstDir\Settings"
    File "..\NewUserData\Icons.ini"

  Goto TemplateWritingFinish
  WriteNewUserDir:  
    ; User dir mode -> Update files in NewUserData folder

	SetDetailsPrint listonly
    SetOutPath "$INSTDIR\NewUserData\AutoSetup"
	SetDetailsPrint none
    File "..\NewUserData\AutoSetup\*.prof"

    SetOutPath "$INSTDIR\NewUserData\Capture\DOSBox DOS"
    File "..\NewUserData\Capture\DOSBox DOS\*.*"

    SetOutPath "$INSTDIR\NewUserData\Templates"
    File "..\NewUserData\Templates\*.prof"

    SetOutPath "$INSTDIR\NewUserData\IconLibrary"
    File "..\NewUserData\IconLibrary\*.*"
	
    SetOutPath "$INSTDIR\NewUserData"
    File "..\NewUserData\Icons.ini"
	
	; Copy FreeDOS files to NewUserData directory
	
	IfFileExists "$DataInstDir\VirtualHD\FREEDOS\*.*" 0 TemplateWritingFinish
	IfFileExists "$INSTDIR\NewUserData\FREEDOS\*.*" TemplateWritingFinish
	
	CreateDirectory "$INSTDIR\NewUserData\FREEDOS"
	CopyFiles /SILENT "$DataInstDir\VirtualHD\FREEDOS\*.*" "$INSTDIR\NewUserData\FREEDOS\"

  TemplateWritingFinish:
  
  ; Install DOSZip
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_InstallDOSZip)"
  SetDetailsPrint listonly

  IntCmp $InstallDataType 1 DoszipToNewUserDir
    SetOutPath "$DataInstDir\VirtualHD\DOSZIP"
  Goto DoszipWritingStart
  DoszipToNewUserDir:
    SetOutPath "$INSTDIR\NewUserData\DOSZIP"
  DoszipWritingStart:
  
  SetDetailsPrint none
  File /r "..\NewUserData\DOSZIP\*.*"
  
  IntCmp $InstallDataType 2 NoUninstallerUpdate
  
  ; Update uninstaller
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateUninstaller)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR"
  SetDetailsPrint none
  
  WriteUninstaller "Uninstall.exe"
  SetShellVarContext all
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\D-Fend Reloaded" "DisplayVersion" "${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}"
  
  ; Add/Update to Vista games explorer
  IfFileExists "$LOCALAPPDATA\Microsoft\Windows\GameExplorer\*.*" 0 NoUninstallerUpdate
  ClearErrors
  ReadRegStr $GEGUID HKLM "Software\D-Fend Reloaded" "GameExplorerGUID"  
  IfErrors 0 NoNewGEGUIDNeeded
  ${GameExplorer_GenerateGUID}
  Pop $GEGUID
  WriteRegStr HKLM "Software\D-Fend Reloaded" "GameExplorerGUID" "$GEGUID"
  NoNewGEGUIDNeeded:
  ClearErrors
  ${GameExplorer_AddGame} all $INSTDIR\Bin\DFendGameExplorerData.dll $INSTDIR $INSTDIR\DFend.exe $GEGUID  
  
  NoUninstallerUpdate:
  
  ; Update DOSBox installation
  
  IfFileExists "$INSTDIR\DOSBox\*.*" 0 NoDOSBoxUpdate
  
  SetDetailsPrint both
  DetailPrint "$(LANGNAME_UpdateDOSBox)"
  SetDetailsPrint listonly
  SetOutPath "$INSTDIR\DOSBox"
  SetDetailsPrint none

  File "..\DOSBox\README.txt"
  ; not changed File "..\DOSBox\COPYING.txt"
  File "..\DOSBox\THANKS.txt"
  File "..\DOSBox\NEWS.txt"
  ; not changed File "..\DOSBox\AUTHORS.txt"
  File "..\DOSBox\INSTALL.txt"
  File "..\DOSBox\DOSBox.exe"
  File "..\DOSBox\dosbox.conf"
  File "..\DOSBox\SDL.dll"
  File "..\DOSBox\SDL_net.dll"
  
  SetOutPath "$INSTDIR\DOSBox\zmbv"
  ; not changed File "..\DOSBox\zmbv\zmbv.dll"
  File "..\DOSBox\zmbv\zmbv.inf"
  ; not changed File "..\DOSBox\zmbv\README.txt"

  SetOutPath "$INSTDIR\DOSBox"
  File "..\DosBoxLang\Readme-0.73-French.txt"
  File "..\DosBoxLang\French.dosbox.conf"
  File "..\DosBoxLang\French.lng"
  File "..\DosBoxLang\Portuguese.lng"
  File "..\DosBoxLang\Portuguese.dosbox.conf"
  File "..\DosBoxLang\Turkish.lng"
  File "..\DosBoxLang\Readme-0.72-Persian.rtf"
  
  NoDOSBoxUpdate:
SectionEnd



; Definition of NSIS functions
; ============================================================

!macro ExtractInstallOptionFiles
!macroend

!insertmacro CommonUACCode