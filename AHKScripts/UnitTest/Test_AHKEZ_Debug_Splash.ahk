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
	
	Gosub Test_Splash

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_Splash:

	D.Out("Test_Splash START")

	if (!DEBUG) {
 		T.StartSendKeyTimer(TIMER_DURATION)
		D.P("Press RESUME to repeat using UpperLeft, UpperRight, LowerLeft, LowerRight, Center for 1 second")
  }

	D.Splash("my splash title", "Center"        , 1000, "cEnTeR")
	D.Splash("my splash title", "Upper Left"    , 1000, "UpperLeft")
	D.Splash("my splash title", "Upper Right"   , 1000, "UpperRight")
	D.Splash("my splash title", "Lower Left"    , 1000, "LOwErLEfT")
	D.Splash("my splash title", "Lower Right"   , 1000, "LOwERrIgHt")
	D.Splash("my splash title", "Center"        , 1000)

	if (!DEBUG) {
 		T.StartSendKeyTimer(TIMER_DURATION)
		D.P("Press RESUME to view Splash window with a long line of text in the center for 10 seconds")
  }

	D.Splash("my splash title"
		, "my splash text`nconsisting of`nseveral lines that wrap
		, or you can add line breaks`n`nThis one is a very, very, very long line."
		, 2000)

	if (!DEBUG) {
 		T.StartSendKeyTimer(TIMER_DURATION)
		D.P("Test_Splash END")
  }
Return

Escape::
GuiClose:
  D.Close()
  T.Close()
  T := ""
ExitApp
