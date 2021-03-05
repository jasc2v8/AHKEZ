
#Include <AHKEZ_UnitTest>

T := New UnitTest

DEBUG := T.GetOption("Debug") ;DEBUG := True

;** START TEST

;KeyWait, Space , dt3
KeyWait("Space", "Dt1")
;MsgBox(,"Test_Functions", ErrorLevel)
T.Assert(A_ScriptName, A_Linenumber, ErrorLevel, 1)

;ok ListHotkeys()
;ok ListLines()
;ok ListVars()

;Menu, Tray, Add  ; Creates a separator line.
;Menu, Tray, Add, Item1, MenuHandler  ; Creates a new menu item.
Menu("Tray", "Add")
Menu("Tray", "Add", "Item1", "MenuHandler")

MouseMove(400,400,"R")
MouseClick("Right")
Sleep, 1000
MouseMove(80,80)
MouseClick()
Sleep, 1000
;MsgBox

T.Close()
T := ""
ExitApp

MenuHandler:
  MsgBox MenuHandler
Return

Escape::
ExitApp

