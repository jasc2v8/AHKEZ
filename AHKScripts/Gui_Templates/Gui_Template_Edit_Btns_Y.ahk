#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

; Buttons stacked vertical (y)
hGui        := Gui("New", "+Resize +AlwaysOnTop", "Gui Template")
               Gui("Font", "s12", "Consolas")
hEdit       := Gui("Add", "Edit", "w400 r20 vEditText", "The rain in Spain falls on the plain.")
hBtnClear   := Gui("Add", "Button", "wp","Clear")
hBtnOK      := Gui("Add", "Button", "wp Default","OK")
hBtnCancel  := Gui("Add", "Button", "wp","Cancel")
               Gui("Show", "w800 AutoSize")
ControlSelect(hBtnOK) ;unselect text in Edit control
Return
; ** End Auto-execute Section

GuiSize:
  GUIControl("Move", hEdit,       "w" A_GUIWidth  - 35 "h" A_GUIHeight - 155)
  GUIControl("Move", hBtnClear,   "w" A_GUIWidth  - 35 "y" A_GUIHeight - 130)
  GUIControl("Move", hBtnOK,      "w" A_GUIWidth  - 35 "y" A_GUIHeight - 90)
  GUIControl("Move", hBtnCancel,  "w" A_GUIWidth  - 35 "y" A_GUIHeight - 50)
Return

ButtonClear:
  EditClear(hEdit)
Return

ButtonOK:
  Gui("Submit", "NoHide") ;EditText := from vEditText
  EditClear(hEdit)
  EditAppend(hEdit, "Text from Edit Control: " NL EditText)
Return

; ** End Script
GuiEscape:
ButtonCancel:
  Gui("Destroy")
  ExitApp
Return
;Escape::ExitApp
