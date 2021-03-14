/*
  https://www.autohotkey.com/docs/commands/IfIn.htm

  if Var in MatchList
  if Var not in MatchList

  if Var contains MatchList
  if Var not contains MatchList

*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
ListLines, Off
#Include <AHKEZ>
; ==================

#Include <AHKEZ_UnitTest>

DEBUG := T.GetOption("Debug") ;DEBUG := True

T := New UnitTest()

SN := SplitPath(A_ScriptName).NameNoExt

;note AHK syntax requires percent signs %

  MatchList := "Chevy,Dodge,Ford"

  ;exact match - IS true SB true
  var := "Dodge"
  IS := False
  if var in %MatchList%
    IS := True
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

  ;not exact match - IS false SB false
  var := "Toyota"
  IS := False
  if var in %MatchList%
    IS := True
  T.Assert(A_ScriptName, A_Linenumber, IS, False)

  ;Not Supported: Ternary Operation
  ;v := (var in %MatchList%) ? True : False
  ;T.Assert(A_ScriptName, A_Linenumber, v, True)

;note AHKEZ syntax doesn't require percent signs %

  MatchList := "Apple,Banana,Cherry,Date,Fruit,Fruit2,Grape,Grapefruit,Pineapple"

Test_IfIn:

  ;is in - IS true SB true
  var := "Fruit2"
  IS := IfIn(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

  ;is not in - IS false SB false
  var := "Frui"
  IS := IfIn(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, False)

;note IfIn MatchList spaces or tabs are significant

  MatchList := "Apple, Fruit,Grape"

  ;is in - IS false SB false
  ;no match because there is a space in MatchList ", Fruit"
  var := "Fruit"
  IS := IfIn(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, False)

Test_IfContains:

  ;contains number - IS true SB true
  var := 2
  IS := False
  if var contains 1,2,3
    IS := True
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

  ;contains string - IS true SB true
  var := "2"
  IS := False
  if var contains 1,2,3  ; Note that it compares the values as strings, not numbers.
    IS := True
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

;note AHKEZ IfContains

  MatchList := "1,2,3"

  ;contains number - IS true SB true
  var := 2
  IS := IfContains(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

  ;contains string - IS true SB true
  var := "2"
  IS := IfContains(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, True)

  ;contains string - IS true SB true
  ;note the 3 in 30 matches the 3 in the MatchList
  var := 30
  IS := IfContains(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, True)
 
;note IfContains MatchList spaces or tabs are significant

  MatchList := "1, 2, 3"

  ;contains number - IS false SB false
  var := 2
  IS := IfContains(var, MatchList) ? True : False
  T.Assert(A_ScriptName, A_Linenumber, IS, False)

T.Close()
T := ""

ExitApp

Escape::
ExitApp