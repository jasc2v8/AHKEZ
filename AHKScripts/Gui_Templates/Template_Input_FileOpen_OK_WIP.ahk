;Change AHK Editor Gui v1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;
;globals
;
Global hGui, hEdit
Global FileList
Global LineCount :=0
Global NL := Chr(0x0d) . Chr(0x0a) ; Chr(13) . Chr(10)
Global RS := Chr(0x1e) ; Chr(30))
Global CountFolders, CountFiles
Global TextBuffer
;
;gui
;
MyTitle := "AHK File Scanner"
MyGuiScale := .5    ;percent of screen size
GW:=A_ScreenWidth*MyGuiScale, GH:=A_ScreenHeight*MyGuiScale / 2.5
BW := 100, BH := 30
EW:=GW-BW-30

RegRead, CurrentEditor, HKEY_CLASSES_ROOT, AutoHotkeyScript\Shell\Edit\Command

if FileExist(A_ScriptDir "\AutoGUI.exe") {
	NewEditor:=A_ScriptDir "\AutoGUI.exe"
} else {
	NewEditor:=""
}

Gui, New, HwndhGui -Resize ;  ToolWindow
Gui, Font, s12 cDefault, Consolas
Gui, Add, Text, ReadOnly, Current Registry Setting:
Gui, Add, Edit, ReadOnly HwndhEdit1 w%EW% h%BH%, % CurrentEditor
Gui, Add, Text, ReadOnly y+20, Change Editor To:
Gui, Add, Edit, HwndhEdit2 w%EW% h30, % NewEditor
Gui, Add, Button, x+5  w%BW% h%BH% Default, Browse
Gui, Add, Button, y+20 w%BW% h%BH%, Cancel
Gui, Add, Button, xp-105 %FW% w%BW% h%BH%, OK
Gui, Show, w%GW% h%GH%, Change AHK Editor Gui
ControlFocus, ,ahk_id %hEdit2%
Return

ButtonBrowse:
Gui, Submit, NoHide
ControlGetText, FolderPattern, Edit2
FileSelectFile, SelectedFile, , % FolderPattern, Select new AHK default editor, Executable Files (*.exe)
if SelectedFile =
	Return
ControlSetText, Edit2, % SelectedFile
Return

ButtonOK:
Gui, Submit, NoHide
RegWrite, REG_SZ, HKEY_CLASSES_ROOT, AutoHotkeyScript\Shell\Edit\Command,, "%SelectedFile%" "`%1"
if (ErrorLevel) {
	Msgbox ERROR setting registry key.
} else {
	MsgBox Success!
}
Return

ButtonCancel:
GuiEscape:
GuiClose:
Gui, Destroy
ExitApp
