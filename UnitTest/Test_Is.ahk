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

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

;** START TEST

IsBlankEZ(var) {
	Return RegExMatch(var, "^[\s]+$")
}
IsEmptyEZ(var) {
	Return (var = "")
}
IsTypeEZ(ByRef var, type) {
  if (type = "array") {
    if (var.MaxIndex())
      Return true
  }
  if (type = "string") {
    if (var.MaxIndex())
      Return false
    if (var = 0)
      Return False
    if (Not var++)
      Return, true
  }
  If var is %type%
    Return, true
  Return False
}

T.Assert(A_ScriptName, A_Linenumber, IsBlank(""), False)
T.Assert(A_ScriptName, A_Linenumber, IsBlank(Chr(0)), False)
T.Assert(A_ScriptName, A_Linenumber, IsBlank(" "), True)
T.Assert(A_ScriptName, A_Linenumber, IsBlank("`t"), True)
T.Assert(A_ScriptName, A_Linenumber, IsBlank("`r"), True)
T.Assert(A_ScriptName, A_Linenumber, IsBlank("`n"), True)
T.Assert(A_ScriptName, A_Linenumber, IsBlank("`r`n"), True)
T.Assert(A_ScriptName, A_Linenumber, IsBlank("    "), True)

T.Assert(A_ScriptName, A_Linenumber, IsEmpty(""), True)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty(Chr(0)), True)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty(" "), False)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty("`t"), False)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty("`r"), False)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty("`n"), False)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty("`r`n"), False)
T.Assert(A_ScriptName, A_Linenumber, IsEmpty("    "), False)

MyArray := ["Hello, World!", 4, 3, 2, 1]
MyArrayCount := MyArray.MaxIndex()
Sum := 0
Loop % MyArrayCount
{
    ;MsgBox % A_Index ": " MyArray[A_Index]
    Sum += MyArray[A_Index]
}
;MsgBox % "Sum: " Sum
T.Assert(A_ScriptName, A_Linenumber, Sum, 10)
T.Assert(A_ScriptName, A_Linenumber, IsType(MyArray, "array"), True)
T.Assert(A_ScriptName, A_Linenumber, IsType(Sum, "array"), False)

MyArray := {1: "Hello, World!", 2: 4, 3: 3, 4: 2, 5: 1}
;For key, value in MyArray
  ;MsgBox % key ": " value
T.Assert(A_ScriptName, A_Linenumber, IsType(MyArray, "array"), True)

Gosub Finished
Escape::
Finished:
  T.Close()
  T := ""
ExitApp
