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

DEBUG := T.GetOption("Debug") ;
DEBUG := True

T.Assert(A_ScriptName, A_Linenumber, False, True)

;** START TEST

Test_JoinPath:

  path := JoinPath(A_WinDir, "system32\shell32.dll")

  if FileExist(path)
    exist := True

  ;MB(0,"test", "PATH: " path "`n`n EXIST: " exist)

  T.Assert(A_ScriptName, A_Linenumber, exist, True)

Test_Join:

  v := Join(",", 1,2,3)
  ;MB(0,"test",v)
  T.Assert(A_ScriptName, A_Linenumber, v, "1,2,3,")

  v := Join(3, A_Space)
  ;MB(0,"test",v)
  T.Assert(A_ScriptName, A_Linenumber, v, A_Space . A_Space . A_Space)

  v := Join(A_Space, "The", "cold", "rain.")
  ;MsgBox(v) ; "The cold rain."
  T.Assert(A_ScriptName, A_Linenumber, v, "The cold rain.")

  v := Join(":", "The result is ", 3.14)
  ;MsgBox(var) ; "The result is: 3.14"
  T.Assert(A_ScriptName, A_Linenumber, v, "The result is: 3.14")

  v := Join(":", "The result is ", MyValue := -3.14)
  ;MsgBox(var) ; "The result is: -3.14"
  T.Assert(A_ScriptName, A_Linenumber, v, "The result is: -3.14")

Gosub Finished
Escape::
Finished:
  T.Close()
  T := ""
ExitApp

