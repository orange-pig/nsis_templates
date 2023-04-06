# define const value
!define PRODUCT_NAME "My app"
!define PRODUCT_SHORT_NAME "MyApp"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_BUILD_VERSION "1.0.0.0"
!define PRODUCT_PUBLISHER "My company, Inc."
!define PRODUCT_COPYRIGHT "Copyright (c) 2023 My company Inc."
!define PRODUCT_WEB_SITE "http://www.mycompany.com"

# info of installer
OutFile "MyApp_Setup.exe" ; set file name of compiler out
Icon "..\myapp\nsis.ico"
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}" ; set name of installer execute
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

; BrandingText /TRIMLEFT "${PRODUCT_NAME} ${PRODUCT_VERSION}" ; the text under install 
; ; install page
; ShowInstDetails hide
; ShowUnInstDetails nevershow ; disable uninstall details to boost

Section "Section1" SEC01
  SetOutPath "$INSTDIR"
  File "..\myapp\MyApp.exe"
SectionEnd

; Section -Post
;   WriteUninstaller "$INSTDIR\uninst.exe"
; SectionEnd

; Section Uninstall
;   Delete "$INSTDIR\${PRODUCT_NAME}.url"
;   Delete "$INSTDIR\uninst.exe"
;   Delete "$INSTDIR\Example.file"
;   Delete "$INSTDIR\AppMainExe.exe"

;   Delete "$SMPROGRAMS\My application\Uninstall.lnk"
;   Delete "$SMPROGRAMS\My application\Website.lnk"
;   Delete "$DESKTOP\My application.lnk"
;   Delete "$SMPROGRAMS\My application\My application.lnk"

;   RMDir "$SMPROGRAMS\My application"
;   RMDir "$INSTDIR"

;   DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
;   DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
;   SetAutoClose true
; SectionEnd