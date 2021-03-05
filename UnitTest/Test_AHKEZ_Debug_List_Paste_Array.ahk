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

	Gosub Test_List_Paste_Array

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_List_Paste_Array:

	array := []
	Array[1] := "one"
	Array[2] := "two"
	Array[3] := "3"

	D.Clear()
	D.PasteArray("My PasteArray Title", Array)

 	hDebugGuiEdit1 := ControlGetID("Edit1", "Debug GUI")
  TextBuffer := EditGetText(hDebugGuiEdit1)

  TextResult := "My PasteArray Title: 1: one2: two3: 3"
	T.Assert(A_ScriptName, A_Linenumber, TextBuffer, TextResult)

	;ListVars(1,,hDebugGuiEdit1, ">" TextBuffer "<", ">" TextResult "<")

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause()

	D.Hide()

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.ListArray("My ListArray Title", Array)

	D.Show()
	
Return

Escape::
GuiClose:
  D.Close()
  T.Close()
  T := ""
ExitApp
