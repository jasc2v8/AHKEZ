#NoEnv
; #Warn
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#Include <AHKEZ>
; ** Start Auto-execute Section

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

; Buttons placed horizontal (x) on the same row
hGui := Gui("New", "+Resize +DPIScale", "Select Files then press START")
Gui("Font", "s12", "Consolas")
hListBox := Gui("Add", "ListBox", "w400 r20 Multi Sort vListItems", FileList)
hBtnEdit := Gui("Add", "Button", "y+m w80","Edit")
hBtnLog := Gui("Add", "Button", "x+m yp w80","Log")
hBtnStart := Gui("Add", "Button", "x+m yp w80 Default","START")
hBtnCancel := Gui("Add", "Button", "x+m yp w80","Cancel")
Gui("Show", "w800 h400 AutoSize")
Return
; ** End Auto-execute Section

GuiSize:
  GUIControl("Move", hListBox,    "w" A_GUIWidth  - 35 "h" A_GUIHeight - 55)
  GUIControl("Move", hBtnEdit,    "y" A_GUIHeight - 45)
  GUIControl("Move", hBtnLog,     "y" A_GUIHeight - 45)
  GUIControl("Move", hBtnStart,   "y" A_GUIHeight - 45)
  GUIControl("Move", hBtnCancel,  "y" A_GUIHeight - 45)
Return

ButtonEdit:
  Gui("Submit", "NoHide")
  Loop, Parse, ListItems, "|"
  {
    RunWait("edit " JoinPath(A_ScriptDir, Trim(A_LoopField))) ; notepad or associated editor
    ;Run(ComSpec " /c code " JoinPath(A_ScriptDir, A_LoopField), , "Hide") ; VSCode
  }
  ;WinShow(hGui)
Return

ButtonLog:
	if (FileExist(LogFile))
		Run, edit %LogFile%
Return

ButtonStart:
  Gui("Submit", "NoHide")
  ;ListItems := from LisBox "one|two|three"
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
