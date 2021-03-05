#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

;Gui, +HWNDhGui SysMenu
Gui("Add", "Text", ,"1. Note the HICON`n`n2. Note the HICON with Alt-Tab")

Gui("+LastFound")                       ; Set our GUI as LastFound window (affects next two lines)
hICON := _HICON()                				; Create a HICON
SendMessage(WM_SETICON:=0x80, 0, hIcon)	; Set the Titlebar icon
SendMessage(WM_SETICON:=0x80, 1, hIcon) ; Set the Alt-Tab icon
Gui("Show")
Return

GuiEscape:
GuiClose:
Gui("Destroy")
ExitApp