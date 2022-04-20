; rc2.0.2 (2022.4.17)

; Autoexec --------------------------------------------------------------------

#NoEnv
#Warn
if(!A_IsAdmin)
	ElevatePrompt()
TrayTip()


; Hotkeys ---------------------------------------------------------------------

#IfWinActive ahk_exe PlanetSide2_x64.exe
^insert::
	KeyWait Control
	KeyWait Insert
	SetKeyDelay, 30
	BlockInput, On    ; blockinput is nonfunctional without elevated privelages
	SendEvent {enter}
	Sleep, 100
	SendEvent /squad{space}leave{enter}
	BlockInput, Off
	SetKeyDelay, 10
	return
#IfWinActive

;@Ahk2Exe-IgnoreBegin
~^s:: reload
;@Ahk2Exe-IgnoreEnd

; Functions --------------------------------------------------------------------

TrayTip() {
	msg := "Leave Squad Macro is running"
	msg .= (A_IsAdmin) ? : " in basic mode"
	TrayTip, , % msg, 1, 0x10
	Sleep, 3000
	; https://www.autohotkey.com/docs/commands/TrayTip.htm#Remarks
	TrayTip	; Attempt to hide it the normal way.
	if(SubStr(A_OSVersion,1,3) = "10." || "11.") {
		Menu Tray, NoIcon
		Sleep 500	; It may be necessary to adjust this sleep.
		Menu Tray, Icon
	}
}

ElevatePrompt() {
	MsgBox, 0x23, Run as Admin?, 
	( LTrim
	If run with elevated privelages, Leave Squad Macro
	can block physical keystrokes while it is typing
	to prevent mishaps.
	
	Would you like to restart with elevated privelages?
	(May trigger UAC prompt)
	)
	IfMsgBox, Yes
	{
		; https://www.autohotkey.com/boards/viewtopic.php?p=404797#p404797
		if(!RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)")) {
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%",, UseErrorLevel
			ExitApp
		}
	}
	IfMsgBox, No
		return
	IfMsgBox, Cancel
		ExitApp
}