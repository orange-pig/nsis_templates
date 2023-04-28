# define const value
!define PRODUCT_NAME "My app"
!define PRODUCT_SHORT_NAME "MyApp"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_BUILD_VERSION "1.0.0.0"
!define PRODUCT_PUBLISHER "My company, Inc."
!define PRODUCT_COPYRIGHT "Copyright (c) 2023 My company Inc."
!define PRODUCT_WEB_SITE "http://www.mycompany.com"
!define PRODUCT_UNINSTALL_KEY "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

# info of installer
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}" ; set name of installer execute
OutFile "MyApp_Setup.exe" ; set file name of compiler out
Icon "..\${PRODUCT_SHORT_NAME}\nsis.ico"
InstallDir "C:\${PRODUCT_SHORT_NAME}" ; set the default install dir

# info of installer execute file
VIAddVersionKey ProductName "${PRODUCT_NAME} Installer" ; product name
VIAddVersionKey ProductVersion "${PRODUCT_VERSION}" ; product version
VIAddVersionKey Comments "${PRODUCT_NAME}" ; description
VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}" ; compnay name
VIAddVersionKey LegalCopyright "${PRODUCT_COPYRIGHT}" ; copyright
VIAddVersionKey FileVersion "${PRODUCT_BUILD_VERSION}" ; file version
VIAddVersionKey FileDescription "${PRODUCT_NAME} Installer" ; file description
VIProductVersion "${PRODUCT_BUILD_VERSION}" ; product verion(actual replace FileVersion)

# use MUI
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\myapp\nsis.ico"
# uninstaller
!define MUI_UNICON "..\myapp\uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "..\myapp\license.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English" ; Languages selection after Install Pages and not before, trobule: https://nsis-dev.github.io/NSIS-Forums/html/t-278169.html


; BrandingText /TRIMLEFT "${PRODUCT_NAME} ${PRODUCT_VERSION}" ; the text under install 
; ; install page
; ShowInstDetails hide
; ShowUnInstDetails nevershow ; disable uninstall details to boost

Section -myapp
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  WriteUninstaller "$INSTDIR\uninstall.exe"

  File "..\myapp\MyApp.exe" ;app execute
  File "/oname=$INSTDIR\repair.file" "..\myapp\s_win_repair.file" ;rename to repair.file

  ; install all files in myapp\bin\ to $INSTDIR\bin
  SetOutPath "$INSTDIR\bin"
  File /r "..\myapp\bin\*.*"

  ; install MUI_icon to $INSTDIR\resources
  SetOutPath "$INSTDIR\resources"
  File "/oname=uninstallerIcon.ico" "${MUI_ICON}" 

  ; Desktop icon
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_SHORT_NAME}.exe"

  ; Start Menu icon
  IfFileExists "$SMPROGRAMS\${PRODUCT_NAME}" +2 0
    CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_SHORT_NAME}.exe"

  ; Register the installed software
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\resources\uninstallerIcon.ico"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKLM "${PRODUCT_UNINSTALL_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section un.onUserAbort
;   # your code here
; SectionEnd

Section -Uninstall
  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\repair.file"
  Delete "$INSTDIR\MyApp.exe"

  RMDir /r "$INSTDIR\bin"

  Delete "$INSTDIR\resources\uninstallerIcon.ico"
  RMDir "$INSTDIR\resources"

  ; delete Desktop icon
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  ; delete start menu folder 
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

  RMDir "$INSTDIR"
  
  ; delete reg item
  DeleteRegKey HKLM "${PRODUCT_UNINSTALL_KEY}"
  
  ; close after finish
  SetAutoClose true
SectionEnd