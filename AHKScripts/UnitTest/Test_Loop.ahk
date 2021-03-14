#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

T := New UnitTest

DEBUG := T.GetOption("Debug") ;DEBUG := True

/*
	Loop
	Loop, Count
	Loop, Files, FilePattern , Mode
	Loop, Reg, KeyName , Mode
	Loop, Parse, InputVar , Delimiters, OmitChars
	Loop, Read, InputFile , OutputFile
*/
;LoopEZ(Subcommand = "", LoopFunction = "MyFunction", Count = "", Param = "") {
Loop(CountOrCommand = "", LoopFunction = "MyFunction", Param = "") {
	if IsType(CountOrCommand, "integer") {
		Count := CountOrCommand
		Loop, %Count%
		{
			v := %LoopFunction%(Param, A_Index, A_LoopField)
		}
	}
	Return v
}

MyFunction(Param, AIndex, ALoopField) {
	v := Param * 3
	Return v
}

; F := "MyFunction"
; v := %F%()
; MsgBox 0,,%v%

v := Loop(3,"MyFunction", 2)
;MsgBox 0,,%v%

T.Assert(A_ScriptName, A_Linenumber, v , 6)

;DEBUG T.Assert(A_ScriptName, A_Linenumber, True , False)

T.Close()
T := ""
ExitApp

Escape::ExitApp