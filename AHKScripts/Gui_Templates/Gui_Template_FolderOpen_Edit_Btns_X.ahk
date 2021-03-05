#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

MyTitle := "Gui Template"
SearchFilesPrompt:=Format("Files to Search ({} {} {} {} {} {} {} {} {}) :"
  ,  "file.ext", ";" , "file.*", ";" , "*.ext", ";" , "*.*", ";", "*", ") :")
; Buttons placed horizontal (x) on the same row
hGui := Gui("New", "+Resize -DPIScale")
        Gui("Font", "s12 cDefault", "Segoe UI Semi Bold")
hLblFolder := Gui("Add", "Text",, "Folder to Search:")
hSearchFolder := Gui("Add", "Edit", "vSearchFolder w800 r1", A_ScriptDir) ;Edit1, SearchFolder
hBtnBrowse := Gui("Add", "Button",  "x+m w100 h30  Default", "Browse")
hLblFiles := Gui("Add", "Text","xm", SearchFilesPrompt)
hEditSearchFiles:= Gui("Add", "Edit", "xm vSearchFiles w800 r1", "*.ahk") ;*.ini ;Edit2, SearchFiles
hBtnSearch := Gui("Add", "Button",  "x+m w100 h30", "Search")
hMemo := Gui("Add", "Edit", "xm -Wrap +HScroll w915 r20")		;Edit3, Edit

hBtnClear := Gui("Add", "Button", "xm w100 h30", "Clear")
hBtnOK    := Gui("Add", "Button", "x+m w100 h30 Default", "OK")
hBtnCancel := Gui("Add", "Button", "x+m w100 h30", "Cancel")

;#Include <AHKEZ_DEBUG>
;ListVars(1,"DEBUG", hGui, hLblFolder, hSearchFolder, hBtnBrowse, hLblFiles, hLblSearchFiles, hMemo, hBtnClear, hBtnOK, hBtnCancel)

ControlFocus(hBtnOK) ; Change Focus to unselect the initial text in an Edit control
Gui("Show", "w600 AutoSize", MyTitle)
Return
; ** End Auto-execute Section

GuiSize:
  GUIControl("MoveDraw", hSearchFolder,     "w" A_GUIWidth  - 145)
  GUIControl("MoveDraw", hEditSearchFiles,  "w" A_GUIWidth  - 145)
  GUIControl("MoveDraw", hBtnBrowse,				"x" A_GUIWidth  - 120)
  GUIControl("MoveDraw", hBtnSearch, 				"x" A_GUIWidth  - 120)
  GUIControl("MoveDraw", hMemo,    		 			"w" A_GUIWidth  - 35 "h" A_GUIHeight - 200)
  GUIControl("MoveDraw", hBtnClear, 				"y" A_GUIHeight - 40)
  GUIControl("MoveDraw", hBtnOK,    				"y" A_GUIHeight - 40)
  GUIControl("MoveDraw", hBtnCancel,				"y" A_GUIHeight - 40)
Return

ButtonOK:
  Gui, Submit, NoHide
  ;SearchFiles := vSearchFiles

  EditAppend(hMemo, SearchFiles)
Return

ButtonBrowse:
  Gui, Submit, NoHide
  SearchFolder := vSearchFolder
  ControlGetText, FolderPattern, Edit1
  FolderPattern:="*" . FolderPattern
  Title:=" "
  FileSelectFolder, SelectedFolder, % FolderPattern, (1+4), % Title
  if SelectedFolder =
  {
    EditAppend(hMemo, "No file selected.")
    Return
  } else {
    ControlSetText, Edit1, % SelectedFolder
  }
Return

ButtonSearch:
  Gui("Submit", "NoHide")
  ;SearchFolder := vSearchFolder
  ;SearchFiles := vSearchFiles
  SearchPath := JoinPath(SearchFolder, SearchFiles)
  FoundList := ""
  Loop, Files, %SearchPath%
  {
    if !IsEmpty(A_LoopFileName)
      FoundList .= A_LoopFileName . NL
  }
  EditPaste(hMemo, FoundList)
Return

ButtonClear:
  EditClear(hMemo)
Return

; ** End Script
ButtonCancel:
GuiEscape:
GuiClose:
Gui, Destroy
ExitApp
;Escape::ExitApp