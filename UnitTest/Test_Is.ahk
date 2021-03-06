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

T := New UnitTest

DEBUG := T.GetOption("Debug") ;DEBUG := True

;** START TEST

;iPhilip https://www.autohotkey.com/boards/viewtopic.php?f=6&t=87709
IsType_TEST(ByRef var, type) {
   if (type = "object")
      Return IsObject(var)
   if (type = "array") 
      Return (var.Length() >= 0)
   if (type = "string")
      Return ObjGetCapacity([var], 1) != ""  ; https://www.autohotkey.com/docs/objects/Object.htm#GetCapacity
   if var is %type%
      Return True
   Return False
}

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

Test_IsType:

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

;https://www.autohotkey.com/boards/viewtopic.php?f=6&t=87709
Test_iPhilip:

  object := {key: "value"}
  T.Assert(A_ScriptName, A_Linenumber, IsType(object, "object"), True)

  MyArray := ["Hello, World!", 4, 3, 2, 1]
  T.Assert(A_ScriptName, A_Linenumber, IsType(MyArray, "array"), True)
 
  MyArray := []
  T.Assert(A_ScriptName, A_Linenumber, IsType(MyArray, "array"), True)
  T.Assert(A_ScriptName, A_Linenumber, IsType([], "array"), True)

  T.Assert(A_ScriptName, A_Linenumber, IsType([], "array"), True)
  T.Assert(A_ScriptName, A_Linenumber, IsType([], "string"), False)

Gosub Finished
Escape::
Finished:
  T.Close()
  T := ""
ExitApp
