#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

DefaultRootDir:=A_ScriptDir "\"
;DefaultFilter:="" ; Default is (*.txt, *.*)
DefaultFilter:="AHK Files (*.ahk)"

; Buttons placed horizontal (x) on the same row
hGui 						:= Gui("New", "+Resize -DPIScale", "Gui Template")
									 Gui("Font", "s12", "Segoe UI Bold")
hLblSelectFile	:= Gui("Add", "Text", "w600 r1", "Browse to Select File")
									 Gui("Font", "s12", "Segoe UI")
hSelectedFile		:= Gui("Add", "Edit", "vSelectedFile w805 r1", DefaultRootDir) ;Edit1
									 Gui("Font", "s12", "Segoe UI Bold")
hBtnBrowse			:= Gui("Add", "Button", "x+m w100 h30", "Browse") ;Button1
									 Gui("Font", "s12", "Segoe UI")
hMemo				 		:= Gui("Add", "Edit", "xm vEditText -Wrap +HScroll w920 h320", "hMemo") ;Edit2
									 Gui("Font", "s12", "Segoe UI Bold")
hBtnClear				:= Gui("Add", "Button", "w100 h30", "Clear") ;Button2
hBtnOK					:= Gui("Add", "Button", "x+m w100 h30 Default", "OK") ;Button3
hBtnCancel			:= Gui("Add", "Button", "x+m w100 h30", "Cancel") ;Button4

;#Include <AHKEZ_DEBUG>
;ListVars(1,"DEBUG", hGui, hLblSelectFile, hSelectedFile, hBtnBrowse, hMemo, hBtnClear, hBtnOK, hBtnCancel)

;ok ControlFocus(hLblSelectFile) ; Change Focus to unselect the initial text in an Edit control
ControlFocus(hBtnOK) ; Change Focus to unselect the initial text in an Edit control
Gui("Show", "w950", MyTitle)
; ** End Auto-execute Section
Return

GuiSize:
  GUIControl("MoveDraw", hSelectedFile, "w" A_GUIWidth  - 145)
  GUIControl("MoveDraw", hBtnBrowse,		"x" A_GUIWidth  - 120)
  GUIControl("MoveDraw", hMemo,     		"w" A_GUIWidth  - 35 "h" A_GUIHeight - 130)
  GUIControl("MoveDraw", hBtnClear, 		"y" A_GUIHeight - 40)
  GUIControl("MoveDraw", hBtnOK,    		"y" A_GUIHeight - 40)
  GUIControl("MoveDraw", hBtnCancel,		"y" A_GUIHeight - 40)
Return

ButtonBrowse:
	Gui("Submit", "NoHide")
	;SelectedFile := vSelectedFile
	RootDir := SelectedFile
	ControlGetText(RootDir, "Edit1")
	Prompt:="Select file"
	Filter:=DefaultFilter
	FileSelectFile, SelectedFile , , % RootDir, % Prompt, % Filter
	if IsEmpty(SelectedFile) {
		EditAppend(hMemo, "No file selected.")
		Return
	}
	ControlSetText(,SelectedFile, ahkid(hSelectedFile))
	EditAppend(hMemo, "Selected file: " SelectedFile)

Return

ButtonOK:
	Gui("Submit", "NoHide")
	;EditText := vEditText
	Text := EditText
	EditAppend(hMemo, "Text in Memo: " Text)
Return

ButtonClear:
	EditClear(hMemo)
Return

; ** End Script
ButtonCancel:
GuiEscape:
GuiClose:
	Gui("Destroy")
ExitApp
;Escape::ExitApp