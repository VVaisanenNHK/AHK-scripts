﻿;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WinGravity.ahk
;; Window gravities for Windows/Autohotkey
;; Copyright (C) 2012  Florian Bruhin / The Compiler <me@the-compiler.org>
;;


; Skips the gentle method of activating a window and goes straight to the forceful method.
#WinActivateForce
; Don't display a tray icon
; #NoTrayIcon

; Things to do before moving a window
MoveInit:
  WinGet, maximized, MinMax, A
  if (maximized)
	WinRestore, A
  SysGet, Scr, MonitorWorkArea
return

; Restore or minimize a window
RestoreOrMinimize:
  WinGet, maximized, MinMax, A
  if (maximized)
    WinRestore, A
  else
    WinMinimize, A
return
; Arrow keys
#down::
  GoSub, RestoreOrMinimize
  return
#up::
  WinMaximize, A
return
#left::
  GoSub, MoveInit
  WinMove,A,,ScrLeft,ScrTop,ScrRight/2.0,ScrBottom
return
#right::
  GoSub, MoveInit
  WinMove,A,,ScrRight/2.0,ScrTop,ScrRight/2.0,ScrBottom
return


#^Numpad0::
  GoSub, RestoreOrMinimize
return
#^Numpad1::
  GoSub, MoveInit
  WinMove,A,,ScrLeft,ScrTop,ScrRight/5.0,ScrBottom
return
#^Numpad2::
  GoSub, MoveInit
  WinMove,A,,ScrRight/5.0,ScrTop,ScrRight/5.0*3,ScrBottom
return
#^Numpad3::
  GoSub, MoveInit
  WinMove,A,,ScrRight/5.0*4,ScrTop,ScrRight/5.0,ScrBottom
return
#^Numpad4::
  GoSub, MoveInit
  WinMove,A,,ScrLeft,ScrTop,ScrRight/4.0,ScrBottom
return
#^Numpad5::
  GoSub, MoveInit
  WinMove,A,,ScrRight/4.0,ScrTop,ScrRight/4.0*2,ScrBottom
return
#^Numpad6::
  GoSub, MoveInit
  WinMove,A,,ScrRight/4.0*3,ScrTop,ScrRight/4.0,ScrBottom
return
#^Numpad7::
  GoSub, MoveInit
  WinMove,A,,ScrLeft,ScrTop,ScrRight/3.0,ScrBottom
return
#^Numpad8::
  GoSub, MoveInit
  WinMove,A,,ScrRight/3.0,ScrTop,ScrRight/3.0,ScrBottom
return
#^Numpad9::
  GoSub, MoveInit
  WinMove,A,,ScrRight/3.0*2,ScrTop,ScrRight/3.0,ScrBottom
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WindowTopBarHider

;-Caption
LWIN & LButton::
WinSet, Style, -0xC00000, A
return
;

;+Caption
LWIN & RButton::
WinSet, Style, +0xC00000, A
return
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MouseAccelToggle


WhatIsIt?:
    SPI_GETMOUSE(accel, low, high)
    MsgBox Mouse acceleration settings-`n  accel:`t%accel%`n  low:`t%low%`n  high:`t%high%
return

#^¨::    ; Enable acceleration.
#^'::    ; Disable acceleration.
    SPI_SETMOUSE(A_ThisHotkey="#^¨") ; i.e. 1 if #^¨, 0 otherwise.
    gosub WhatIsIt?
return


; Get mouse acceleration level and low/high thresholds.
; Returns true on success and false on failure.
SPI_GETMOUSE(ByRef accel, ByRef low="", ByRef high="")
{
    VarSetCapacity(vValue, 12)
    if !DllCall("SystemParametersInfo", "uint", 3, "uint", 0, "uint", &vValue, "uint", 0)
        return false ; Fail.
    low := NumGet(vValue, 0)
    high := NumGet(vValue, 4)
    accel := NumGet(vValue, 8)
    return true
}

; Set mouse acceleration level and low/high thresholds.
; Supplies standard default values for low/high if omitted.
; fWinIni:  0 or one of the following values:
;           1 to update the user profile
;           2 to notify applications
;           3 to do both.
; Returns true on success and false on failure.
SPI_SETMOUSE(accel, low="", high="", fWinIni=0)
{
    VarSetCapacity(vValue, 12)
    , NumPut(accel
    , NumPut(high!="" ? high : accel ? 10 : 0
    , NumPut(low!="" ? low : accel ? 6 : 0, vValue)))
    return 0!=DllCall("SystemParametersInfo", "uint", 4, "uint", 0, "uint", &vValue, "uint", 0)
}
return
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BEGIN INSTANT APPLICATION SWITCHER SCRIPTS;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#^Q::switchToExcel()
;!#^E::closeAllExcels()

#^E::switchToExplorer()
!#^E::closeAllExplorers()

#^W::switchToWord()
;!#^E::closeAllExcels()

#^Z::switchToChrome()
;!#^E::closeAllExcels()

#^A::switchToOutlook()
;!#^E::closeAllExcels()

#^S::switchToOneNote()
;!#^E::closeAllExcels()

#^D::switchToJeeves()
;!#^E::closeAllExcels()



; This is a script that will always go to The last explorer window you had open.
; If explorer is already active, it will go to the NEXT last Explorer window you had open.

switchToExplorer(){
IfWinNotExist, ahk_class CabinetWClass
	Run, explorer.exe
GroupAdd, taranexplorers, ahk_class CabinetWClass
if WinActive("ahk_exe explorer.exe")
	GroupActivate, taranexplorers, r
else
	WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

closeAllExplorers()
{
WinClose,ahk_group taranexplorers
}




switchToWord()
{
Process, Exist, WINWORD.EXE	
;Next line is just for error handling
;msgbox errorLevel `n%errorLevel%

	If errorLevel = 0
	{
		objWord := ComObjCreate("Word.Application")
		objWord.Visible := True
		objWord.RecentFiles(1).open

	}
	else
	{
	GroupAdd, taranwords, ahk_class OpusApp
	if WinActive("ahk_class OpusApp")
		GroupActivate, taranwords, r
	else
		WinActivate ahk_class OpusApp
	}
}

switchToExcel()
{
Process, Exist, EXCEL.EXE
;Next line is just for error handling
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		{
		objExcel := ComObjCreate("Excel.Application")
		objExcel.Visible := True
		objExcel.RecentFiles(1).open
 		}
	else
	{
	GroupAdd, taranwords2, ahk_class XLMAIN
	if WinActive("ahk_class XLMAIN")
		GroupActivate, taranwords2, r
	else
		WinActivate ahk_class XLMAIN
	}
}


switchToChrome()
{
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
}


switchToOutlook()
{
IfWinNotExist, ahk_exe outlook.exe
	Run outlook.exe
if WinActive("ahk_exe outlook.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe outlook.exe
}


switchToOneNote()
{
IfWinNotExist, ahk_exe onenote.exe
	Run, onenote.exe
	
if WinActive("ahk_exe onenote.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe onenote.exe
}


switchToJeeves()
{
IfWinNotExist, ahk_exe jvs32client.exe
	Run, C:\jvslocalclientv5\bin64\Client\jvs32client.exe "C:\jvslocalclientv5\Bin64\Client\ThinClientnhkprodCB.ini"
	
if WinActive("ahk_exe jvs32client.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe jvs32client.exe
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VILJAMIs Outlook macrostuff

#IfWinActive, ahk_class rctrl_renwnd32
#^1::FlagToday()
#^2::FlagTomorrow()
#^3::Flag3Days()
#^4::FlagNextWeek()
#^§::UnFlag()
#^<::LookForAllMailsRelated()


FlagToday()
{
	Send ^+G
	Send {Tab}
	Send {Tab}
	Send {Return}
	Sendinput ^{tab}
	Send {Return}
	Send {Tab}
	Send {Return}
	Send {Return}
	Send {Return}
}


FlagTomorrow()
{
	Send ^+G
	Send {Tab}
	Send {Tab}
	Send {Return}
	Sendinput ^{tab}
	Send {Return}
	Send {Tab}
	Send {Return}
	Send {Right}
	Send {Return}
	Send {Return}
}

Flag3Days()
{
	Send ^+G
	Send {Tab}
	Send {Tab}
	Send {Return}
	Sendinput ^{tab}
	Send {Return}
	Send {Tab}
	Send {Return}
	loop, 3 
		Send {Right}
	Send {Return}
	Send {Return}
}


FlagNextWeek()
{
	Send ^+G
	Send {Tab}
	Send {Tab}
	Send {Return}
	Sendinput ^{tab}
	Send {Return}
	Send {Tab}
	Send {Return}
	loop, 7
		Send {Right}
	Send {Return}
	Send {Return}
}

UnFlag()
{
	Send ^+G
	loop, 7
		Send {Tab}
	Send {Return}
}
Return

LookForAllMailsRelated()
{
#IfWinActive ahk_class OutlookGrid1

	Send +{F10}
	loop, 10 
		Send {Tab}
	Send {Return}
	Send {Return}
	
#IfWinActive
}

#IfWinActive


#IfWinActive, ahk_class XLMAIN
#^9::DeleteRow()

DeleteRow()
{


}

#IfWinActive


#!^R::Reload
Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
Return