;2021-03-03_04:19:PM
#NoEnv
; #Warn
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
; ==================
#NoTrayIcon
#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

Global SelectedFolder
Global IniFile := JoinPath(A_Temp, "UnitTest.ini")
Global LogFile := JoinPath(A_Temp, "UnitTest.log")

Global T := New UnitTest

;clear log and reset options
T.ClearLog()
T.ClearOptions()
T.SetOptions("-Debug, Log")

SelectedFolder := A_ScriptDir
Title :=  "Select Folder, then Tests, then press START (F1 for Help)"
hGui := Gui("New", "+Resize -DPIScale -AlwaysOnTop", Title)
Gui("Color", "cTeal", "cDefault")
Gui("Font", "s11", "Consolas")
hSelDir := Gui("Add", "Edit", "w400 r1", SelectedFolder)
hBtnBrowse := Gui("Add", "Button", "x+m w80 h28","Browse")
hListBox := Gui("Add", "ListBox", "xm w410 r20 Multi Sort vListItems", FileList)
hBtnEdit := Gui("Add", "Button", "y+m w80","Edit")
hBtnLog := Gui("Add", "Button", "x+m yp w80","Log")
hBtnStart := Gui("Add", "Button", "x+m yp w80 Default","START")
hBtnCancel := Gui("Add", "Button", "x+m yp w80","Cancel")
Gui("Font", "s11 cWhite", "Consolas")
hCBDebug := Gui("Add", "CheckBox", "x+m vOptDebug", "Debug")
hCBLog := Gui("Add", "CheckBox", "y+m", "Log")
Gui("Show", "w800 AutoSize")

Option := T.GetOption("Debug")
Action := Option ? "Check" : "UnCheck"
Control(Action,,,ahkid(hCBDebug))

Option := T.GetOption("Log")
Action := Option ? "Check" : "UnCheck"
Control(Action,,,ahkid(hCBLog))

;#Include <AHKEZ_Debug>
;ok ListVars(1,"start",hGui,hListBox,hBtnEdit,hBtnLog,hBtnStart,hBtnCancel)

ListBoxSetText(hListBox, SelectedFolder)

Return

GuiSize:
  GUIControl("Move",      hSelDir,     "w" A_GUIWidth  - 120)
  GUIControl("Move",      hListBox,    "w" A_GUIWidth  - 35 "h" A_GUIHeight - 100)
  GUIControl("Move",      hBtnBrowse,  "x" A_GUIWidth  - 100)
  GUIControl("Move",      hBtnEdit,    "y" A_GUIHeight - 45)
  GUIControl("Move",      hBtnLog,     "y" A_GUIHeight - 45)
  GUIControl("Move",      hBtnStart,   "y" A_GUIHeight - 45)
  GUIControl("Move",      hBtnCancel,  "y" A_GUIHeight - 45)
  GUIControl("MoveDraw",  hCBDebug,    "y" A_GUIHeight - 55)
  GUIControl("MoveDraw",  hCBLog,      "y" A_GUIHeight - 30)
Return

GetFiles(Folder) {
  List := ""
  Loop, Files, %Folder%\Test_*.ahk
  {
    if !IsEmpty(A_LoopFileFullPath) 
      List .= A_LoopFileFullPath . NL
  }
  Return List
}

ListBoxSetText(hLB, Folder) {
  FileList := GetFiles(Folder)
  Loop, Parse, FileList, `r, `n
  {
    if !IsEmpty(A_LoopField)
      List .= SplitPath(A_LoopField).FileName . "|"
  }
  GuiControl(,hLB, List)
}

ButtonBrowse:
  Title:= "Select Folder"
  FileSelectFolder, SelectedFolder, *%A_ScriptDir%, (1+4), % Title
  if IsEmpty(SelectedFolder)
    Return
  EditSetText(hSelDir, SelectedFolder)
  GuiControl(,hListBox,"|")
  ListBoxSetText(hListBox, SelectedFolder)
Return

ButtonEdit:
  Gui("Submit", "NoHide")
  ;ListItems := from ListBox "one|two|three"
  if IsEmpty(ListItems) {
    SoundBeep
    Return
  }
  Loop, Parse, ListItems, "|"
  {
    Run(ComSpec " /c code " JoinPath(A_ScriptDir, A_LoopField), , "Hide")
  }
Return

ButtonLog:
  if (!FileExist(LogFile)) {
    SoundBeep
    Return
  }
	if (FileExist(LogFile)) {
    WinMinimize(hGui)
		;ok RunWait, edit %LogFile%
		;ok RunWait("edit " LogFile)
    T.EditLog()
    WinRestore(hGui)
  }
Return

SetOptions:
  OptDebug      := ControlGet("Checked",,, ahkid(hCBDebug))
  OptDebugText  := OptDebug ? "+Debug" : "-Debug"

  OptLog        := ControlGet("Checked",,, ahkid(hCBLog))
  OptLogText    := OptLog ? "+Log" : "-Log"
  
  T.SetOptions(OptDebugText "," OptLogText)
Return

ButtonStart:
  Gui("Submit", "NoHide")

  Gosub SetOptions

  if IsEmpty(ListItems) {
    SoundBeep
    Return
  }

  WinMinimizeAll

  if (!optDebug)
    Gosub Show_Splash
  
  RunList := ""
  Loop, Parse, ListItems, "|"
  {
    RunList .= JoinPath(SelectedFolder, A_LoopField) . NL
  }

  if !IsEmpty(RunList)
    T.Run(RunList)

  Gui("SPLASH:Hide")

  WinMinimizeAllUndo
  
  Gosub ButtonLog
Return

Show_Splash:
  Gui("SPLASH:Show")
  hSPLASHGui := Gui("SPLASH:New", "-AlwaysOnTop -Owner", A_Space) ;+Disabled prevents user click
  hSPLASHUnselect := Gui("Add", "Text", "w0 h0 Hide")
  Gui("Color", "cYellow", "cYellow")
  Gui("Font", "s18 cRed", "Consolas Bold")
  hSPLASHMainText := Gui("Add", "Text", "w300 Center", "TESTING IN PROGRESS")
  Gui("Font", "s14 cNavy Bold Italic", "Consolas")
  hSPLASHSubText := Gui("Add", "Text", "w300 Center", "Please don't press any keys" NL NL "until tests are complete")
  ;Gui("Show", "NoActivate AutoSize") ;Enables SPLASHEscape when a secondary Gui
  Gui("Show", "AutoSize") ;Enables SPLASHEscape for this test
  WinSet("Style", -0xC00000, ahkid(hSPLASHGui))
Return

~^a::
  if !WinActive(ahkid(hGui))
    Return
  NumberSelected := SendMessage(LB_GETSELCOUNT := 0x0190, 0, 0, , ahkid(hListBox))
  if (!NumberSelected) {
    PostMessage(LB_SETSEL := 0x0185, 1, -1, , ahkid(hListBox)) ; Select all items.
  } else {
    PostMessage(LB_SETSEL := 0x0185, 0, -1, , ahkid(hListBox)) ; Select no items.
  }
Return

~f1::
  if !WinActive(ahkid(hGui))
    Return

Gui("HELP:Show")

  help_page_1 =
(Join`r`n

About:
  Scans folder for Test_*.ahk files
  User selects test(s) to run
  User selects Debug and Log options

Keyboard Shortcuts:
  Ctrl+A: Toggle Select All / None
  Escape: Close Gui

Buttons:
  Browse: Select the folder
  Edit:   Edits the selected script
  Log:    Open log file
  Start:  Start selected scripts
  Cancel: Close Gui

Debug Checkbox:
  Checked:   Pause and ListVars on error
  Unchecked: No Pause

Log Checkbox:
  Checked:   A_Temp:\UnitTest.log
  Unchecked: No LogFile

)
  Title :=  "Run_Tests HELP"
  Gui("HELP:New", "+AlwaysOnTop +Disabled -SysMenu +Owner", Title)
  Gui("Color", "cGreen", "cGreen")
  Gui("Font", "s12 cWhite", "Consolas")
  Gui("Add", "Edit", "w400 -VScroll", help_page_1)
  hHELPBtnOK := Gui("Add", "Button", "xm w400 Default", "OK")
  Gui("Show", "AutoSize")
  ControlSelect(hHELPBtnOK)
Return

HELPButtonOK:
  Gui("HELP:Hide")
Return

HELPGuiEscape:
  Gui("HELP:Hide")
Return

GuiEscape:
ButtonCancel:
  Gui("1:Destroy")
  Gui("HELP:Destroy")
  Gui("SPLASH:Destroy")
  ExitApp
Return
;Escape::ExitApp
