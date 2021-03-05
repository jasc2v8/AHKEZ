#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

; Buttons placed horizontal (x) on the same row
hGui        := Gui("New", "+Resize -DPIScale", "Gui Template")
               Gui("Font", "s12", "Consolas")
hEdit       := Gui("Add", "Edit", "w400 r20 vEditText", "The rain in Spain falls on the plain.")
hBtnClear   := Gui("Add", "Button", "y+m w80","Clear")
hBtnOK      := Gui("Add", "Button", "x+m yp w80 Default","OK")
hBtnCancel  := Gui("Add", "Button", "x+m yp w80","Cancel")
               Gui("Show", "w800 h420 AutoSize")
ControlSelect(hBtnOK) ;unselect text in Edit control
Return
; ** End Auto-execute Section

GuiSize:
  GUIControl("Move", hEdit,     "w" A_GUIWidth  - 35 "h" A_GUIHeight - 55)
  GUIControl("Move", hBtnClear, "y" A_GUIHeight - 40)
  GUIControl("Move", hBtnOK,    "y" A_GUIHeight - 40)
  GUIControl("Move", hBtnCancel,"y" A_GUIHeight - 40)
Return

ButtonClear:
  EditClear(hEdit)
Return

ButtonLog:
	if (FileExist(LogFile))
		Run, edit %LogFile%
Return

ButtonOK:
  Gui("Submit", "NoHide") ;EditText := text from vEditText
  EditClear(hEdit)
  EditPaste(hEdit, "Text from the Edit control: " EditText)
Return

; ** End Script
GuiEscape:
ButtonCancel:
  Gui("Destroy")
  ExitApp
Return
;Escape::ExitApp
