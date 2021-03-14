#NoEnv
; #Warn
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
; ==================

#Include <AHKEZ_UnitTest>
#Include <AHKEZ_DEBUG>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

/*
PostMessage: Asynchronous, no return value
  ErrorLevel is 1 if problem such as the target window or control not existing.
  Otherwise, it is set to 0.

SendMessage: Synchronous, return value in ErrorLevel
  ErrorLevel is set to the word FAIL if there was a problem or the command timed out.
  Otherwise, it is set to the numeric result of the message or a "reply"
*/

;** START TEST

TestList := "Apple|Banana|Cherry|Date"
hListBox := Gui("Add", "ListBox", "Multi Sort W180", TestList)
hGui := Gui("Show", "AutoSize", "TEST")

;ok ListVars(1,"start",hGui,hListBox,hBtnEdit,hBtnLog,hBtnStart,hBtnCancel)

;Gui +LastFound  ; Avoids the need to specify WinTitle below.

;Choose() ; LB_Choose(-1) = all
PostMessage(LB_SETSEL := 0x0185, 1, -1,, ahkid(hListBox)) ;Select all items
Sleep(0) ;ProcessMessages

;GetSelCount()
;ok commands:
  ;LB_GETSELCOUNT := 0x0190
  ;SendMessage, % LB_GETSELCOUNT, 0, 0, , % "ahk_id " . hListBox
  ;SendMessage, % LB_GETSELCOUNT, 0, 0, ListBox1, TEST
  ;LB_SelCount := ErrorLevel
;ok function:
LB_SelCount := SendMessage(LB_GETSELCOUNT := 0x0190, 0, 0,, ahkid(hListBox))
T.Assert(A_ScriptName, A_Linenumber, LB_SelCount , 4)

;SendMessage(Msg, wParam = "", lParam = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "", Timeout = "") {

;Choose(0)
PostMessage(LB_SETSEL := 0x0185, 0, -1,, ahkid(hListBox)) ;Select no items
Sleep(0) ;ProcessMessages
LB_SelCount := SendMessage(LB_GETSELCOUNT := 0x0190, 0, 0,, ahkid(hListBox))
T.Assert(A_ScriptName, A_Linenumber, LB_SelCount , 0)

;Choose(3)
;ok commands:
Row := 3
  ;LB_SETSEL := 0x0185
  ;SendMessage, % LB_SETSEL, 1, % (Row - 1),, % "ahk_id " . hListBox
;ok functions:
SendMessage(LB_SETSEL := 0x0185, 1, Row - 1,, ahkid(hListBox))
;GuiControl("Choose", "ListBox1", 3) ;0=none

;GetRow
;ok commands:
  ; LB_GETCURSEL := 0x0188
  ; SendMessage, % LB_GETCURSEL, 0, 0, , % "ahk_id " . hListBox
  ; LB_GetRow := ErrorLevel + 1
LB_GetRow := SendMessage(LB_GETCURSEL := 0x0188, 1, 0,, ahkid(hListBox)) + 1 ;LB is zero-based index
T.Assert(A_ScriptName, A_Linenumber, LB_GetRow , 3)

;GetCount
;SendMessage, (LB_GETCOUNT := 0x18B), 0, 0, ClassNN, WinTitle
LB_Count := SendMessage(LB_GETCOUNT := 0x18B, 0, 0,, ahkid(hListBox)) ;- 1 ;LB is zero-based index

;works, but geez, too complicated
;SendMessage, 0x0188, 0, 0, ListBox1, WinTitle  ; 0x0188 is LB_GETCURSEL (for a ListBox).
;ChoicePos := ErrorLevel<<32>>32  ; Convert UInt to Int to have -1 if there is no item selected.
;ChoicePos += 1  ; Convert from 0-based to 1-based, i.e. so that the first item is known as 1, not 0.
;MB(0,"ChoicePos", ChoicePos)

;GetChoice
Choice := ControlGet("Choice",,,ahkid(hListBox))
;MB(0,"choice", choice)

;FindString
LB_FindRow := ControlGet("FindString",Choice,,ahkid(hListBox))
T.Assert(A_ScriptName, A_Linenumber, LB_FindRow , 3)

;Add()
String := "Grape"
;SendMessage, 0x180, 0, % &String, , % "ahk_id " hListBox
r := SendMessage(LB_ADDSTRING := 0x180, 0, &String,,ahkid(hListBox)) + 1 ;LB is zero-based index

;GetRow( FindString() )
LB_FindRow := ControlGet("FindString",String,,ahkid(hListBox))
T.Assert(A_ScriptName, A_Linenumber, LB_FindRow , 5)

;ListVars(1,"start",hGui,hListBox,Choice, FindRow, LB_Count, r, FindRow2) ;,hBtnEdit,hBtnLog,hBtnStart,hBtnCancel)

GoSub GuiClose

Escape::
GuiClose:
  Gui, Destroy
  T.Close()
  T := ""
ExitApp
