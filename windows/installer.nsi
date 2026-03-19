!include "MUI2.nsh"

Name "A'lochi Maktab"
OutFile "AlochiMaktab-Setup.exe"
InstallDir "$PROGRAMFILES64\AlochiMaktab"
RequestExecutionLevel admin

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install"
  SetOutPath "$INSTDIR"
  File /r "..\..\build\windows\x64\runner\Release\*.*"
  CreateShortcut "$DESKTOP\A'lochi Maktab.lnk" "$INSTDIR\alochi_maktab.exe"
  CreateDirectory "$SMPROGRAMS\A'lochi Maktab"
  CreateShortcut "$SMPROGRAMS\A'lochi Maktab\A'lochi Maktab.lnk" "$INSTDIR\alochi_maktab.exe"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AlochiMaktab" "DisplayName" "A'lochi Maktab"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AlochiMaktab" "UninstallString" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
  RMDir /r "$INSTDIR"
  Delete "$DESKTOP\A'lochi Maktab.lnk"
  RMDir /r "$SMPROGRAMS\A'lochi Maktab"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AlochiMaktab"
SectionEnd
