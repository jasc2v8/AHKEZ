#NoEnv
; #Warn
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
; ==================

#Include <AHKEZ>
#Include <AHKEZ_UnitTest>
#Include <AHKEZ_DEBUG>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

TIMER_DURATION := 1000

Test_Start:

	D := new DebugGUI()
	
	Gosub Test_ShowHideMinMax

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_ShowHideMinMax:
/*
	Various methods use to control DebugGUI window state:
		WinGet hDebugGUI, ID, A
		WinHide A
		WinShow % "ahk_id" hDebugGUI
		WinMinimize A
		WinRestore ahk_id %hDebugGUI%
		WinMaximize Debug GUI
		WinRestore Debug GUI
*/
	WinGet hDebugGUI, ID, A
		
	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.P("Press resume to HIDE window for 2 seconds...")
	WinHide A
	D.Out("Window is hidden...")
	Sleep 2000
	WinShow % "ahk_id" hDebugGUI
	
	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.P("Press resume to MINIMIZE window for 2 seconds...")
	WinMinimize A
	D.Out("Window Minimized...")
	Sleep 2000
	WinRestore ahk_id %hDebugGUI%
	
	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.P("Press resume to MAXIMIZE window for 2 seconds...")
	WinMaximize Debug GUI
	D.Out("Window Maximized...")
	Sleep 2000

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.P("Press resume to RESTORE window...")
	WinRestore Debug GUI
	
	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.P("Test Finished!")
Return

Escape::
GuiClose:
  D.Close()
  T.Close()
  T := ""
ExitApp
