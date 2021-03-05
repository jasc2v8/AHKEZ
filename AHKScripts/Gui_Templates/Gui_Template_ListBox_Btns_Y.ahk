#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

;Global NL:="`r`n"
Global LogFile := JoinPath(SplitPath(A_ScriptDir).Dir, SplitPath(A_ScriptDir).NameNoExt "_Log.txt")

FileDelete(LogFile)

FileList := ""
Loop, Files, %A_ScriptDir%\*.ahk
{
  if !StrIsEmpty(A_LoopFileName) {
    FileList .= A_LoopFileName . "|"
    FileAppend(A_LoopFileName . NL, LogFile)
  }
}

; Buttons stacked vertical (y)
hGui := Gui("New", "+Resize +AlwaysOnTop", "Gui Template")
Gui("Font", "s12", "Consolas")
hListBox := Gui("Add", "ListBox", "w400 r20 Multi Sort vListItems", FileList)
hBtnEdit := Gui("Add", "Button", "wp","Edit")
hBtnLog := Gui("Add", "Button", "wp","Log")
hBtnStart := Gui("Add", "Button", "wp Default","START")
hBtnCancel := Gui("Add", "Button", "wp","Cancel")
Gui("Show", "w800 AutoSize")
ControlSelect(hBtnStart)
Return
; ** End Auto-execute Section

GuiSize:
  GUIControl("Move", hListBox,    "w" A_GUIWidth  - 35 "h" A_GUIHeight - 200)
  GUIControl("Move", hBtnEdit,    "w" A_GUIWidth  - 35 "y" A_GUIHeight - 185)
  GUIControl("Move", hBtnLog,     "w" A_GUIWidth  - 35 "y" A_GUIHeight - 140)
  GUIControl("Move", hBtnStart,   "w" A_GUIWidth  - 35 "y" A_GUIHeight - 95)
  GUIControl("Move", hBtnCancel,  "w" A_GUIWidth  - 35 "y" A_GUIHeight - 50)
Return

ButtonEdit:
  Gui("Submit", "NoHide")
  Loop, Parse, ListItems, "|"
  {
    RunWait("edit " JoinPath(A_ScriptDir, Trim(A_LoopField))) ; notepad or associated editor
    ;Run(ComSpec " /c code " JoinPath(A_ScriptDir, A_LoopField), , "Hide") ; VSCode
  }
Return

ButtonLog:
	if (FileExist(LogFile))
		Run, edit %LogFile%
Return

ButtonStart:
  Gui("Submit", "NoHide") ;ListItems := from vListItems
  Loop, Parse, ListItems, "|"
  {
    RunWait(JoinPath(A_ScriptDir, A_LoopField))
  }
Return

; ** End Script
GuiEscape:
ButtonCancel:
  Gui("Destroy")
  ExitApp
Return
;Escape::ExitApp
