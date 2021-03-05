/*

AHK v2 Edit Functions:

  EditGetCurrentCol	Returns the column number in an Edit control where the caret (text insertion point) resides.
  EditGetCurrentLine	Returns the line number in an Edit control where the caret (text insert point) resides.
  EditGetLine	Returns the text of the specified line in an Edit control.
  EditGetLineCount	Returns the number of lines in an Edit control.
  EditGetSelectedText	Returns the selected text in an Edit control.
  EditPaste Pastes the specified string at the caret (text insertion point) in an Edit control.
  
AHKEZ Functions tested:

  EditAppend
  EditClear
  EditGetCurrentCol
  EditGetCurrentLine
  EditGetLineCount
  EditGetSelectedText
  EditGetText
  EditPaste
  EditSetText

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
#Include <AHKEZ_Debug>

;** START TEST

T := New UnitTest

DEBUG := T.GetOption("Debug") ;DEBUG := True

Global BtnOKClicked := False
Global GroupActivateLabelGoSub := False

GuiTitle := "TEST"
Gui("Add", "Button", "w0 h0", "Added here to allow BthOK to receive Default focus")
hEdit := Gui("Add", "Edit", "w200 r10")
hBtnOK := Gui("Add", "Button", "w80 Default", "OK") ;gButton1Click 
hGui := Gui("Show", "w800 h1200 AutoSize", GuiTitle)

;hGui from Gui "Show" command, there is no "New" command above
v := IsEmpty(hGui) ? False : True
T.Assert(A_ScriptName, A_Linenumber, True , v)

hID := WinGetID(GuiTitle)
T.Assert(A_ScriptName, A_Linenumber, hID , hGui)

Test_EditAppend:
  Text := "TEST APPEND"
  EditAppend(hEdit, Text) ;NL is added by Append
  EditAppend(hEdit, Text) ;NL is added by Append
  v := EditGetText(hEdit) ;NL is returned
  T.Assert(A_ScriptName, A_Linenumber, ">" v "<", ">TEST APPEND`r`nTEST APPEND`r`n<")

Test_EditClear:
  EditClear(hEdit)

Test_EditPaste:
  Text := "TEST PASTE"
  EditPaste(hEdit, Text) ; no NL
  EditPaste(hEdit, Text) ; no NL
  v := EditGetText(hEdit)
  T.Assert(A_ScriptName, A_Linenumber, v, Text . Text)

Test_EditGetCurrentCol:
  v := EditGetCurrentCol(hEdit)
  T.Assert(A_ScriptName, A_Linenumber, v, 21)

Test_EditGetCurrentLine:
  EditAppend(hEdit) ; Append(NL)
  EditAppend(hEdit, Text)
  v := EditGetCurrentLine(hEdit)
  T.Assert(A_ScriptName, A_Linenumber, v, 3)

Test_EditGetLineCount:
  v := EditGetLineCount(hEdit)
  T.Assert(A_ScriptName, A_Linenumber, v, 3)

Test_EditGetText:
  EditClear(hEdit)
  Text := "TEST GET TEXT"
  EditPaste(hEdit, Text)
  v := EditGetText(hEdit)
  T.Assert(A_ScriptName, A_Linenumber, v, Text)

Test_EditGetSelectedText:
Test_EditSetText:
  Text := "TEST GET SELECTED TEXT"
  EditSetText(hEdit, Text)
  ;ok ControlFocus(, ahkid(hEdit))
  ControlSelect(hEdit)
    Send("{CtrlDown}{a}{CtrlUp}")
  v := EditGetSelectedText(hEdit)
  ;MB(0,"EditGetSelectedText1", v)
  T.Assert(A_ScriptName, A_Linenumber, v , Text)

;ListVars(1,"UnitTest",hEdit, hBtnOK, hGui)

GoSub GuiClose

Escape::
GuiClose:
  Gui, Destroy
  D.Close()
  T.Close()
  T := ""
ExitApp
