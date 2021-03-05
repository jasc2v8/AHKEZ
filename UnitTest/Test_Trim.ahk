
#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

/*
	Result :=  Trim(String, OmitChars := " `t")
	Result := LTrim(String, OmitChars := " `t")
	Result := RTrim(String, OmitChars := " `t")
*/

Line 				:= "The rain in Spain falls mainly on the plain"
LineSuffix 	:= Line . "`r`n"
LinePrefix 	:= " `r`n`t" . Line
LineTrimmed := Line

;MsgBox >>%Line%<<

	;Trim removes spaces and tabs but not `r`n
	v := Trim(Line)
	;MsgBox >>%v%<<
	T.Assert(A_ScriptName, A_Linenumber, v, LineTrimmed)

;RTrim

	;RTrim removes OmitChars = "space`r`ntab"
	v := RTrim(LineSuffix, " `r`n`t")
	;MsgBox >>%v%<<
	T.Assert(A_ScriptName, A_Linenumber, v, LineTrimmed)

	;if you know how many chars to strip
	v := SubStr(LineSuffix,1,-2)
	;MsgBox >>%v%<<
	T.Assert(A_ScriptName, A_Linenumber, v, LineTrimmed)

;LTrim

	v := LTrim(LinePrefix, " `r`n`t")
	;MsgBox >>%v%<<
	T.Assert(A_ScriptName, A_Linenumber, v, LineTrimmed)

	;if you know how many chars to strip
	v := SubStr(LinePrefix,5)
	;MsgBox >>%v%<<
	T.Assert(A_ScriptName, A_Linenumber, v, LineTrimmed)

T.Close()
T := ""
ExitApp

Escape::
ExitApp
