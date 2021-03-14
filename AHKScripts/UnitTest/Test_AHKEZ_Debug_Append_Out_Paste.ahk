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

T := New UnitTest

DEBUG := T.GetOption("Debug") ;DEBUG := True

TIMER_DURATION := 1000

Test_Start:

	D := new DebugGUI()

	Gosub Test_Append_Out_Paste

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_Append_Out_Paste:

;SetTitleMatchMode, 1
;SetTitleMatchMode, Slow

  ;ok hDebugGui := WinExist()
  hDebugGui := WinExist("Debug GUI")

  WinWait("Debug GUI",,2)
  if (ErrorLevel)
    MB(0,,"WinWait TIMEOUT")

  hDebugGuiEdit1 := ControlGetID("Edit1", "Debug GUI")

  ;OK ListVars(1,,hDebugGui, hDebugGuiEdit1)

  Test_Append:

    Text := "Test_Append"

    D.Clear()
    D.Append(Text)
    D.Append(Text)

    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    D.Pause()

    TextBuffer := EditGetText(hDebugGuiEdit1)
    TextResult := "Test_Append" . NL . "Test_Append" . NL . "Press Resume to continue..." . NL

    T.Assert(A_ScriptName, A_Linenumber, TextBuffer, TextResult)

 Test_Out:

    Text := "Test_Out"

    D.Clear()
    D.Out(Text)
    D.Out(Text)
    
    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    D.Pause()

    TextBuffer := EditGetText(hDebugGuiEdit1)
    TextResult := "Test_Out" . NL . "Test_Out" . NL . "Press Resume to continue..." . NL

    T.Assert(A_ScriptName, A_Linenumber, TextBuffer, TextResult)

 Test_Paste:

    Text := "Test_Paste"

    D.Clear()
    D.Paste(Text)
    D.Paste(Text)
    
    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    D.Pause()

    TextBuffer := EditGetText(hDebugGuiEdit1)
    TextResult := "Test_Paste" . "Test_Paste" . "Press Resume to continue..." . NL

    T.Assert(A_ScriptName, A_Linenumber, TextBuffer, TextResult)

Return

Escape::
GuiClose:
  Gui, Destroy
  D.Close()
  T.Close()
  T := ""
ExitApp
