;2021-03-05_09:21:AM
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

hGui := Gui("New", "+ToolWindow")
hEdit := Gui("Add", "Edit", "w200 r10")
hButton := Gui("Add", "Button", "w80", "Press Me")
Gui("Show", "Autosize", "Hello, World!")
Return

; ** End Auto-execute Section

ButtonPressMe:
	EditAppend(hEdit, "Hello, World!")
Return

; ** End Script
ExitApp
Escape::ExitApp