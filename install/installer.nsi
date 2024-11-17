# define const value
!define PRODUCT_NAME "My app"
!define PRODUCT_SHORT_NAME "MyApp"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_BUILD_VERSION "1.0.0.0"
!define PRODUCT_PUBLISHER "My company, Inc."
!define PRODUCT_COPYRIGHT "Copyright (c) 2023 My company Inc."
!define PRODUCT_WEB_SITE "http://www.mycompany.com"
!define PRODUCT_UNINSTALL_KEY "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"


# Variables
Var MyApp.Header.SubText ; Sub text in the header area
Var MyApp.Component.MainText 
Var MyApp.Component.InstallationType
Var MyApp.Component.InstallationTypeText
Var MyApp.Component.ComponentListTitleText
Var MyApp.Component.ComponentList
Var MyApp.Component.DescriptionTitleText
Var MyApp.Component.DescriptionText
Var MyApp.Component.DiskSizeText 
Var MyApp.InstalledPluginsCode


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

# base ui info
Caption "${PRODUCT_NAME} Installer"
BrandingText /TRIMLEFT "${PRODUCT_NAME} ${PRODUCT_VERSION}"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\myapp\nsis.ico"
; uninstaller
!define MUI_UNICON "..\myapp\uninstall.ico"
!define MUI_CUSTOMFUNCTION_GUIINIT GUIInit
!define MUI_HEADERIMAGE ; Defining this value is the basis for the follow two definitions
!define MUI_HEADERIMAGE_BITMAP "..\resource\header_150x57.bmp"
!define MUI_HEADERIMAGE_BITMAP_STRETCH NoStretchNoCropNoAlign
!define MUI_HEADERIMAGE_RIGHT ; Display to right

; Welcome page
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\resource\welcome_install.bmp"
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "..\myapp\license.txt"
; Components page
!define MUI_PAGE_HEADER_TEXT "Component Selection"
!define MUI_COMPONENTSPAGE_TEXT_COMPLIST "Select components to install:"
!define MUI_PAGE_HEADER_SUBTEXT "Select the components you want to install."
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ComponentsPageShow
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
ShowInstDetails hide
!insertmacro MUI_PAGE_INSTFILES
; Finish page
; Way 1
; !define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_SHORT_NAME}.exe"
; !define MUI_FINISHPAGE_RUN_TEXT "NB My App!"
; Way 2
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "NB My App!"
!define MUI_FINISHPAGE_RUN_FUNCTION FinishRun
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!define MUI_PAGE_CUSTOMFUNCTION_SHOW un.ComponentsPageShow 
!insertmacro MUI_UNPAGE_COMPONENTS
ShowUnInstDetails nevershow ; disable uninstall details to boost
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English" ; Languages selection after Install Pages and not before, trobule: https://nsis-dev.github.io/NSIS-Forums/html/t-278169.html


!macro RelayoutComponents
  FindWindow $0 "#32770" "" $HWNDPARENT

  GetDlgItem $MyApp.Header.SubText $HWNDPARENT 1038 ; header area subtext
  ShowWindow $MyApp.Header.SubText ${SW_HIDE} ; Hide header area subtext

  GetDlgItem $MyApp.Component.MainText $0 1006 ; The main text of the content area
  ShowWindow $MyApp.Component.MainText ${SW_HIDE} ; Hide the main text of the content area

  GetDlgItem $MyApp.Component.InstallationTypeText $0 1021 ; Title text for the installation type
  GetDlgItem $MyApp.Component.InstallationType $0 1017 ; installation type
  ShowWindow $MyApp.Component.InstallationTypeText ${SW_HIDE} ; Hide header text for installation types
  ShowWindow $MyApp.Component.InstallationType ${SW_HIDE} ; Hide installation type
  
  GetDlgItem $MyApp.Component.DescriptionTitleText $0 1042 ; description title text
  ShowWindow $MyApp.Component.DescriptionTitleText ${SW_HIDE} ; Hide the title text of the description

  GetDlgItem $MyApp.Component.ComponentListTitleText $0 1022 ; Component list title text
  GetDlgItem $MyApp.Component.ComponentList $0 1032 ; component list
  GetDlgItem $MyApp.Component.DiskSizeText $0 1023 ; required disk size text
  GetDlgItem $MyApp.Component.DescriptionText $0 1043 ; The content text of the description


  ; # MSDN https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwindowpos
  System::Call "User32::SetWindowPos(i $MyApp.Component.ComponentListTitleText, i 0, i 0, i 0, i 270, i 13, i 0)" ; Sets the position of the component list title text
  System::Call "User32::SetWindowPos(i $MyApp.Component.ComponentList, i 0, i 0, i 18, i 270, i 176, i 0)" ; Set the position of the component list
  System::Call "User32::SetWindowPos(i $MyApp.Component.DescriptionText, i 0, i 285, i 16, i 164, i 176, i 0)" ; Sets the position of the content text of the description
  System::Call "User32::SetWindowPos(i $MyApp.Component.DiskSizeText, i 0, i 0, i 210, i 0, i 0, i 1)" ; Sets the position of the disk size text
!macroend

; When components page show
Function ComponentsPageShow
  !insertmacro RelayoutComponents
FunctionEnd

Function FinishRun
  SetOutPath "$INSTDIR"
  ExecShell "" "$INSTDIR\${PRODUCT_SHORT_NAME}.exe"
FunctionEnd

Function .onInit
  ; Read the current installed plugins code
  ReadRegDWORD $MyApp.InstalledPluginsCode HKLM "${PRODUCT_UNINSTALL_KEY}" "InstalledPlugins"
  IfErrors 0 +2
    StrCpy $MyApp.InstalledPluginsCode 0 ; init to zero
FunctionEnd

Section -myapp
  ; set the section disk space requirement, unit is KB.
  AddSize 1024

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

Section -driver
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  File /r "..\myapp\driver"

  ; run install
  nsExec::Exec "$INSTDIR\driver\install.bat"
SectionEnd

!define PLUGIN1_CODE 1 ;0001
!define PLUGIN2_CODE 2 ;0010

; ! bold name
Section !plugin1 SEC_PLUGIN1_ID
  AddSize 512

  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  File "..\myapp\plugins\plugin1.dll"
  
  IntOp $MyApp.InstalledPluginsCode $MyApp.InstalledPluginsCode | ${PLUGIN1_CODE}
	WriteRegDWORD HKLM "${PRODUCT_UNINSTALL_KEY}" "InstalledPlugins" $MyApp.InstalledPluginsCode
SectionEnd

; /o default to be unselect
Section /o plugin2 SEC_PLUGIN2_ID
  AddSize 512

  SetOutPath "$INSTDIR\plugins"
  SetOverwrite ifnewer

  File /r "..\myapp\plugins\plugin2"
  
  IntOp $MyApp.InstalledPluginsCode $MyApp.InstalledPluginsCode | ${PLUGIN2_CODE}
	WriteRegDWORD HKLM "${PRODUCT_UNINSTALL_KEY}" "InstalledPlugins" $MyApp.InstalledPluginsCode
SectionEnd

!macro componentInstalled sectionID code name
  Push $0

  IntOp $0 $MyApp.InstalledPluginsCode & ${code}
  ; MessageBox MB_ICONINFORMATION|MB_OK "Code: $MyApp.InstalledPluginsCode"

  ${if} $0 == ${code}
    SectionSetFlags ${sectionID} 0 ; uncheck section
    SectionSetText ${sectionID} "${name} (Installed)" ; append text 'Installed'
  ${endif}

  Pop $0
!macroend

; On UI init
Function GUIInit
  !insertmacro componentInstalled ${SEC_PLUGIN1_ID} ${PLUGIN1_CODE} "plugin1"
  !insertmacro componentInstalled ${SEC_PLUGIN2_ID} ${PLUGIN2_CODE} "plugin2"
FunctionEnd

Section !un.plugin1 SEC_UN_PLUGIN1_ID
  Delete "$INSTDIR\plugin1.dll"
SectionEnd

Section /o un.plugin2 SEC_UN_PLUGIN2_ID
  RMDir /r "$INSTDIR\plugins\plugin2"
SectionEnd

Section -un.driver
  ; run uninstall
  nsExec::Exec "$INSTDIR\driver\uninstall.bat"

  RMDir /r "$INSTDIR\driver"
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

Function un.ComponentsPageShow
  !insertmacro RelayoutComponents
FunctionEnd

; Set components descriptions
!define DESCRIPTION_PLUGIN1 "Plugin1 is a highly efficient tool designed to optimize users' workflows. It offers a wide range of features, including data processing, quick analysis, and intelligent operation suggestions. Whether used in personal projects or team collaborations, Plugin1 significantly boosts productivity. With its simple and user-friendly interface, users can easily get started with minimal effort."
!define DESCRIPTION_PLUGIN2 "Plugin2 is dedicated to providing comprehensive multi-functional extension support, suitable for various scenarios. Its powerful modular design allows users to flexibly configure features according to their needs, enabling higher productivity and streamlined workflow management. Plugin2 combines stability with flexibility, making it the ideal choice for meeting professional demands."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_PLUGIN1_ID} "${DESCRIPTION_PLUGIN1}"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_PLUGIN2_ID} "${DESCRIPTION_PLUGIN2}"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN 
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_UN_PLUGIN1_ID} "${DESCRIPTION_PLUGIN1}"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_UN_PLUGIN2_ID} "${DESCRIPTION_PLUGIN2}"
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END
