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
	
	Gosub Test_Log

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_Log:

	LogFile					:= JoinPath(A_ScriptDir, "TestFile.log")
	DefaultLogFile 	:= JoinPath(A_ScriptDir, "Debug.log")

	Text := "Test 1 - Overwrite"

	;	Log(Text := "", Filename := "", TimeFormat := "", Overwrite := False )
	D.Log(Text, LogFile, "HH:mm:ss", True)
	FileBuffer := FileRead(LogFile)
  T.Assert(A_ScriptName, A_Linenumber, StrContains(FileBuffer, ": Test 1 - Overwrite"), True)

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause(FileBuffer)

	Text := "Test 2 - No Overwrite"
	D.Log(Text, LogFile, "HH:mm:ss", False)
	FileBuffer := FileRead(LogFile)
	v := StrContains(FileBuffer, ": Test 1") And StrContains(FileBuffer, ": Test 2")
  T.Assert(A_ScriptName, A_Linenumber, v, True)

	IF (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause(FileBuffer)

	Text := "Test 3 - Default LogFile is Debug.log"
	D.Log(Text,,,True)
	FileBuffer := FileRead(DefaultLogFile)
	v := StrContains(FileBuffer, "Test 3") And !StrContains(FileBuffer, ":")
  T.Assert(A_ScriptName, A_Linenumber, v, True)

	IF (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause(FileBuffer)

	Text := "Test 4 - Time Stamp, no text"
	D.Log(,,"HH-mm-ss")
	D.Log(Text,,"HH-mm-ss")
	FileBuffer := FileRead(DefaultLogFile)
	v := StrContains(FileBuffer, ": Test 4")
  T.Assert(A_ScriptName, A_Linenumber, v, True)

	IF (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause(FileBuffer)

	FileDelete(DefaultLogFile)
	Text := "Test 5 - No params, all default, logs a blank line"
	D.Log()
	FileBuffer := FileRead(DefaultLogFile)
  T.Assert(A_ScriptName, A_Linenumber, (FileBuffer = "`r`n"), True)

	IF (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)
	D.Pause(">" FileBuffer "<")
	
	FileDelete(LogFile)
	FileDelete(DefaultLogFile)
Return

Escape::
GuiClose:
  D.Close()
  T.Close()
  T := ""
ExitApp
