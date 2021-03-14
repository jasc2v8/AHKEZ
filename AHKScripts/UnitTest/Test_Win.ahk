
#Include <AHKEZ>
#Include <AHKEZ_UnitTest>
#Include <AHKEZ_Debug>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

/*
  SetTitleMatchMode
    1 or "starts"    (default)
    2 or "contains"
    3 or "exact"
*/

;** START TEST

Global Button1Clicked := False
Global GroupActivateLabelGoSub := False

GuiTitle := "My Test Gui"
hEdit := Gui("Add", "Edit")
hBtnOK := Gui("Add", "Button", "gButton1Click", "OK")
hgui := Gui("Show", "w800 h400", GuiTitle)

WinWait(GuiTitle,,5) 

SetTitleMatchMode("exact")

hGui := WinGetID(GuiTitle)
Result := hGui = "" ? "Fail" : "Pass"
;ListVars(0,,hGui, Result)
T.Assert(A_ScriptName, A_Linenumber, Result, "Pass")

;GroupAdd, MyGroup, ahk_id %hGui%, , GroupActivateLabel
;GroupAdd, MyGroup, %GuiTitle%, , GroupActivateLabel
GroupAdd("MyGroup", hGui, "GroupActivateLabel")

;GroupActivate, MyGroup
GroupActivate("MyGroup")
;MsgBox 0, GroupActivate, ErrorLevel=%ErrorLevel%
T.Assert(A_ScriptName, A_Linenumber, GroupActivateLabelGoSub, True)

;ListVars(0,,hGui, hEdit, Result)

WinGetActiveStats(Title, Width, Height, X, Y)
;MsgBox 0, WinGetActiveStats, %Title% %Width% %Height% %X% %Y%
T.Assert(A_ScriptName, A_Linenumber,  Title . Width . Height . X . Y, "My Test Gui806429557305")

WinMove(ahkid(hGui),, 40, 400, 600, 500)
WinGetPos(X, Y, Width, Height, ahkid(hGui))
;ListVars(0,,X, Y, Width, Height)
T.Assert(A_ScriptName, A_Linenumber,  X . Y . Width . Height, "40400600500")

GuiTitle := "My Test Gui New Title"
WinSetTitle(ahkid(hGui),, GuiTitle)
Title := WinGetTitle(ahkid(hGui))
T.Assert(A_ScriptName, A_Linenumber, Title, GuiTitle)

ControlClick(,ahkid(hBtnOK))
Sleep(250)
T.Assert(A_ScriptName, A_Linenumber, Button1Clicked , True)

GroupClose("MyGroup")

WinKill(ahkid(hGui))
Sleep 250
hGui := WinGetID(GuiTitle)
T.Assert(A_ScriptName, A_Linenumber, hGui , "")

Goto GuiClose
Escape::
GuiClose:
  Gui, Destroy
  T.Close()
  T := ""
ExitApp

Button1Click:
  ;MsgBox, CLICK
  Button1Clicked := True
Return

GroupActivateLabel:
  ;MsgBox, GOSUB
  GroupActivateLabelGoSub := True
Return
