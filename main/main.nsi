
; !define PRODUCT_NAME "My app"
; !define PRODUCT_VERSION "1.0"
; !define PRODUCT_PUBLISHER "My company, Inc."
; !define PRODUCT_WEB_SITE "http://www.mycompany.com"

; Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "MyApp_Setup.exe"
; InstallDir "$PROGRAMFILES\My app"

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