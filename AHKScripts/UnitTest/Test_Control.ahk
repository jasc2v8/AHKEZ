/*
Functions Tested:
  Control(SubCommand, Value = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlClick(ControlOrPos = "", WinTitle = "", WinText = "", WhichButton = "", ClickCount = "", Options = "", ExcludeTitle = "", ExcludeText = "") {
  ControlFocus(Control, WinTitle, WinText, ExcludeTitle, ExcludeText) {
  ControlGet(SubCommand, Value = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGetFocus(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGetID(Control = "", WindowID = "") {
  ControlGetPos(ByRef X, ByRef Y, ByRef Width, ByRef Height, ControlID) {
  ControlGetText(Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlMove(Control, X = "", Y = "", Width = "", Height = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSelect(ControlID, WindowID = "") {
  ControlSend(Control = "", Keys = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSendRaw(Control = "", Keys = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSetText(Control = "", NewText = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  SetTitleMatchMode("exact")
  WinGetID(GuiTitle)
  WinKill(hGui)

  SetTitleMatchMode
    1 or "starts"    (default)
    2 or "contains"
    3 or "exact"

  WinTitle	Matching Behavior
    A	The Active Window
    ahk_class	Window Class
    ahk_id	Unique ID/HWND    ahkid(hGui)
    ahk_pid	Process ID
    ahk_exe	Process Name/Path
    ahk_group	Window Group
      Multiple Criteria
    (All empty)	Last Found Window
*/
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

;** START TEST

Global ButtonOKClicked := False

GuiTitle := "My Test Gui"
hListBox := Gui("Add", "ListBox", "Multi r3", "Apple|Banana|Cherry")
hEdit := Gui("Add", "Edit", "y+m w400 r10")
;hButton1 := Gui("Add", "Button", "xm y+m w80 h30 Default", "OK") ;not Default for test
hButton1 := Gui("Add", "Button", "xm y+m w80 h30", "OK")
Gui("Show", "w800 h1200 AutoSize", GuiTitle)

hGui := WinGetID("A")
WinTitle := WinGetTitle(ahkID(hGui))
hBtnOK := ControlGetID("Button1", GuiTitle) ; ahkid(hGui))

;ListVars(1,,hGui, hListBox, hEdit, hBtnOK, hButton1, WinTitle)

;ControlFocus(,ahkid(hBtnOK))

Test_ControlFocus:
  EditAppend(hEdit, "Verify Button OK is Focused")
  ControlFocus(,ahkid(hBtnOK))
  ;MB(0,,"Button OK is focused?")

Test_ControlSelect:
  ControlSelect(hButton1)

  If (DEBUG) {
    MB(0,,"OK Button is selected.`n`nPress ENTER twice to validate.")
    Return
  }

Test_ControlClick:
  ;ok ControlClick("Button1", GuiTitle)
  ControlClick(, ahkid(hBtnOK))
  Sleep(100)
  T.Assert(A_ScriptName, A_Linenumber, ButtonOKClicked , True)

Test_Control:
  Control("Choose",2,,ahkid(hListBox))

Test_ControlGet:
  ;ok ListBoxText := ControlGet("List",,,"ahk_id" hListBox)
  ;ok ListBoxText := ControlGet("List",,, "ahk_id" ControlGetID("ListBox1", hGui))
  ;ok ListBoxText := ControlGet("List",,, ahkid(ControlGetID("ListBox1", hGui)))
  ;ok ListBoxText := ControlGet("List",,"ListBox1", "A")
  ;ok ListBoxText := ControlGet("List",,"ListBox1", "My Test Gui")
  ;ok ListBoxText := ControlGet("List",,"ListBox1", WinGetTitle(ahkid(hGui)))
  ListBoxText := ControlGet("List",,, ahkid(hListBox))
  Text := ControlGet("Choice",,,ahkid(hListBox))
  Row := ControlGet("FindString", "Cherry",,ahkid(hListBox)) -1 ;LB is zero based index

  ;ListVars(1,,WinTitle, hGui, hBtnOK, hListBox, ListBoxText, Text, Row, ahkid(hListBox))

  SetTitleMatchMode("exact")

Test_ControlGetID:
    hEdit := ControlGetID("Edit1", ahkid(hGui))
    T.Assert(A_ScriptName, A_Linenumber, IsEmpty(hEdit), False)

    hEdit := ControlGetID("Edit1", "A")
    T.Assert(A_ScriptName, A_Linenumber, IsEmpty(hEdit), False)

    Gui("+LastFound")
    hEdit := ControlGetID("Edit1")
    T.Assert(A_ScriptName, A_Linenumber, IsEmpty(hEdit), False)

    ;ListVars(1,,WinTitle, hGui, hBtnOK, hListBox, hEdit)

Test_ControlGetText:
  EditClear(hEdit)
  Text := "This is a test"
  Control("EditPaste", Text,,ahkid(hEdit))
  v := ControlGetText(, ahkid(hEdit))
  T.Assert(A_ScriptName, A_Linenumber, v , Text)

Test_ControlSetText:
  Text := "This is another test"
  ControlSetText(, Text, ahkid(hEdit))
  v := ControlGetText(, ahkid(hEdit))
  T.Assert(A_ScriptName, A_Linenumber, v , Text)

Test_ControlSend:
  Text := "AbC"
  ControlSetText(, "", ahkid(hEdit))
  ControlSend(, Text, ahkid(hEdit))
  v := ControlGetText(, ahkid(hEdit))
  T.Assert(A_ScriptName, A_Linenumber, v , Text)

Test_ControlSendRaw:
  ControlSetText(, "", ahkid(hEdit))
  ControlSendRaw(, Text, ahkid(hEdit))
  v := ControlGetText(, ahkid(hEdit))
  T.Assert(A_ScriptName, A_Linenumber, v , Text)

Test_ControlMove:
  ;MB(0,,"Note position of Edit control BEFORE move...")
  ControlMove(,15, 120, 400, 200, ahkid(hEdit))
  ControlGetPos(X, Y, Width, Height, hEdit)
  T.Assert(A_ScriptName, A_Linenumber,  x . y . Width . Height, "15120400200")
  ;MB(0,,"Note position of Edit control AFTER move...")

Test_ControlGetFocus:
  ControlName := ControlGetFocus(ahkid(hGui))
  T.Assert(A_ScriptName, A_Linenumber, ControlName, "Button1")

  WinKill(ahkid(hGui))
  Sleep 250
  hGui := WinGetID(GuiTitle)
  T.Assert(A_ScriptName, A_Linenumber, hGui , "")

Goto GuiClose
Escape::
GuiClose:
  Gui, Destroy
  D.Close()
  T.Close()
  T := ""
ExitApp

ButtonOK:
  ButtonOKClicked := True
  If (DEBUG)
  MB(,,"CLICK", "ButtonOK")
Return