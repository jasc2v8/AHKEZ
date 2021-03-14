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

  ;https://www.autohotkey.com/boards/viewtopic.php?f=6&t=87709
  Test_iPhilip_Object:

  object := {key: "value"}
  T.Assert(A_ScriptName, A_Linenumber, IsType(object, "object"), True)

  MyString := "String"
  T.Assert(A_ScriptName, A_Linenumber, IsType(MyString, "string"), True)

  MyStringNumber := "51"
  T.Assert(A_ScriptName, A_Linenumber, IsType(MyStringNumber, "string"), True)

Test_Array:

  ;no valid test for "array" in AHK_L_v1 so no Function wrapper in AHKEZ
  ;Workarounds in your code:

	;after creation before adding items:
	;MaxIndex:=MyArray.MaxIndex() ;blank if empty
	;Length:=MyArray.Length()	;0 if empty

  MyArray := []
  T.Assert(A_ScriptName, A_Linenumber, MyArray.Length(), 0)
  T.Assert(A_ScriptName, A_Linenumber, MyArray.MaxIndex(), "")

  MyArray := ["Hello, World!", 4, 3, 2, 1]
  MyArrayCount := MyArray.MaxIndex()
  Sum := 0
  Loop % MyArrayCount
  {
     Sum += MyArray[A_Index]
  }
  T.Assert(A_ScriptName, A_Linenumber, Sum, 10)
  T.Assert(A_ScriptName, A_Linenumber, MyArray.Length(), 5)
  T.Assert(A_ScriptName, A_Linenumber, MyArray.MaxIndex(), 5)

  MyArray := {}
  T.Assert(A_ScriptName, A_Linenumber, MyArray.Length(), 0)
  T.Assert(A_ScriptName, A_Linenumber, MyArray.MaxIndex(), "")

  MyArray := {1: "Hello, World!", 2: 4, 3: 3, 4: 2, 5: 1}
  ;For key, value in MyArray
    ;MsgBox % key ": " value
  T.Assert(A_ScriptName, A_Linenumber, MyArray.Length(), 5)
  T.Assert(A_ScriptName, A_Linenumber, MyArray.MaxIndex(), 5)

Gosub Finished
Escape::
Finished:
  T.Close()
  T := ""
ExitApp
