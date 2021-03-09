/*
  ==================================================================================================
  Title:
    GuiDemo.ahk
  About:  
    The Gui demonstration script for AHKEZ
  Usage:  
    #Include <AHKEZ>
  GitHub: 
    https://github.com/jasc2v8/AHKEZ
  Version:
		0.1.6/2021-03-09_13:57/jasc2v8/initial commit
    AHK_L_v1.1.10.01 (U64)
  Credits:
    https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/
  License:
    Public Domain: https://creativecommons.org/publicdomain/zero/1.0/
  ==================================================================================================
  This software is provided 'as-is', without any express or implied warranty.
  In no event will the authors be held liable for any damages arising from the use of this software.
  ==================================================================================================
*/
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
#Persistent
; ** Start Auto-execute Section

Global MyTabs
Global WB

Gosub Create_Gui

; ** End Auto-execute Section
Return

; Gui, Add, Text, x5 y5 w150 0x10  ;Horizontal Line > Etched Gray
; Gui, Add, Text, x5 y5 h150 0x11  ;Vertical Line > Etched Gray
; Gui, Add, Text, x5 y155 w150 h1 0x7  ;Horizontal Line > Black
; Gui, Add, Text, x155 y5 w1 h150 0x7  ;Vertical Line > Black

Create_Gui:

  ;Input: Button, Checkbox, ComboBox. DropDownList, Radio, Slider, UpDown
  ;Output: Picture, GroupBox, Progress, StatusBar, Tab, Edit
  ;List: ListBox, ListView, TreeView
  ;DateTime:  DateTime, MonthCal
  ;Other: Link, Hotkey,
  ;ActiveX (e.g. Internet Explorer Control)
  ;Custom

  MyEdit := "My Edit"
  MyRadio1 := 1
  MyRadio2 := 0
  MyRadio3 := 0
  MyCheckBox := 1
  MyUpDown := 0
  MyDropDown := ""
  MyComboBox := ""
  MyListBox := ""
  MyHotkey := "^x"
  MyDateTime := FormatTime(Now, "YYYYMMDD")
  MyMonthCal := MyDateTime

  GuiScale := 0.50
  GW := Round(A_ScreenWidth  * GuiScale,0)
  GH := Round(A_ScreenHeight * GuiScale,0)

  hGui := Gui("DEMO:New","+MaximizeBox -Resize")

  Gui("Font", "s11", "Consolas")

  ; hCtl := Gui("Add", )
  ; Gui("Show", "w800 h400")
  TabAbout := "About"
  TabInput := "Input"
  TabList := "List"
  TabDateTime := "DateTime"
  TabActiveX := "ActiveX"
  TabCustom := "Custom"
  TabHeaders := TabAbout "|" TabInput "|" TabList "|" TabDateTime "|" TabActiveX "|" TabCustom

  ;Gui,Add,Tab3,x10 y10 w600 h400 , %TabName1%|Tab 2|Tab 3|
  hTab := Gui("Add","Tab3","vMyTabs gTabChanged x10 y10 w" GW "h" GH, TabHeaders)

_Gui_Tab_About:

  Gui("Tab", TabAbout)
    ;Gui("Color", "cTeal", "cBlack")
    Gui("Font", "cBlue Bold s12", "Consolas")
    hAboutText := Gui("Add","Text","+ReadOnly", GetAboutText())
    ;Gui("Color", "cDefault", "cDefault")
    Gui("Font", "cDefault", "Consolas")
    Gui("Add", "Button", "x640 y140 w60 h24 gBtnAbout", Chr(916))

_Gui_Tab_Input:

  Gui("Tab", TabInput)
    Gui("Font", "Bold")
    Gui, Add, Text, , My Text
    Gui("Font", "Normal")
    hEdit := Gui("Add", "Edit", "w200 gChangeEdit", MyEdit)
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeEdit", Chr(916))
  
    Gui("Font", "Bold")
    Gui("Add", "Text", "x24 y+m", "My Radio Group")
    Gui("Font", "Normal")
    hRadio1 := Gui("Add", "Radio", "Group vMyRadioSelected", "Radio1")
    hRadio2 := Gui("Add", "Radio", "x+0", "Radio2")
    hRadio3 := Gui("Add", "Radio", "x+0", "Radio3")
    GuiControl(, hRadio1, 1)
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeRadio", Chr(916))

    Gui("Font", "Bold")
    Gui, Add, Text, x24 y+m, My UpDown
    Gui("Font", "Normal")
    Gui, Add, Edit
    hUpDown := Gui("Add", "UpDown", "vMyUpDown gChangeUpDown Range0-100", MyUpDown)
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeUpDown", Chr(916))

    Gui("Font", "Bold")
    Gui("Add", "Text", "x24 y+m", "My DropDownList")
    Gui("Font", "Normal")111
    hDDL := Gui("Add", "DropDownList", "gChangeDDL", "Item1|Item2|Item3")
    GuiControl("ChooseString", MyDropDown, MyDropDown)
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeDDL", Chr(916))

    Gui("Font", "Bold")
    Gui("Add", "Text", "x24 y+m", "My Slider")
    Gui("Font", "Normal")
    hSlider := Gui("Add", "Slider", "gChangeSlider  Range1-100")
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeSlider", Chr(916))

    Gui("Font", "Bold")
    Gui("Add", "Text", "x24 y+m", "My ComboBox")
    Gui("Font", "Normal")
    hComboBox := Gui("Add", "ComboBox", "gChangeComboBox", "Item1|Item2|Item3")
    GuiControl("Text", MyComboBox, MyComboBox)
    Gui("Add", "Button", "x340 yp w60 h24 gBtnChangeComboBox", Chr(916))

    Gui("Font", "Bold")
    Gui("Add", "Text", "x24 y+m", "My Hotkey")
    Gui("Font", "Normal")
    Gui, Add, Hotkey, vMyHotkey, %MyHotkey%
    Gui("Font", "Normal")

    Gui("Font", "Bold")
    Gui("Add", "GroupBox", "w300 h70", "My GroupBox")
    Gui("Font", "Normal")
    hBtnOK      := Gui("Add", "Button", "x44 yp+25 w100 Default", "OK")
    hBtnCancel  := Gui("Add", "Button", "x+m w100", "Cancel")

_Gui_Tab_List:

  Gui("Tab", TabList)
    Gui("Add", "Text", , "My ListBox")
    Gui("Add", "Text", "x+60", "My ListView (My Documents)")
    Gui("Add", "Text", "x+140", "My TreeView")

    hListBox := Gui("Add", "ListBox", "x20 y+m w120 gChangeListBox", "Item1|Item2|Item3")
    Gui("Add", "Button", "x24 yp+75 w60 h24 gBtnChangeListBox", Chr(916))
    GuiControl("ChooseString", MyListBox, MyListBox)

    hListView := Gui("Add", "ListView", "x+90 y75 w350 r16 gChangeListView", "Name|KB")
    Gui("Add", "Button", "x170 yp+415 w60 h24 gBtnChangeListView", Chr(916))
    Gosub ChangeListView

    hTreeView := Gui("Add", "TreeView", "x+320 y75 w350 r16 gChangeTreeView")
    Gui("Add", "Button", "x550 yp+415 w60 h24 gBtnChangeTreeView", Chr(916))
    Gosub LoadTreeView

_Gui_Tab_DateTime:

  Gui("Tab", TabDateTime)
    Gui, Add, Text, , My DateTime
    hDateTime := Gui("Add", "DateTime", "vMyDateTime gDateTimeChange") ;Choose%MyDateTime%, yyyy/MM/dd HH:mm:ss

    Gui, Add, Text, , My MonthCal
    hMonthCal := Gui("Add", "MonthCal", "vMyMonthCal gMonthCalChange", MyMonthCal)

    MyMonthCal := MyDateTime

_Gui_Tab_ActiveX:

  Gui("Tab", TabActiveX)
    ;Nice HTMLBox function in a separate window: https://sites.google.com/site/ahkref/custom-functions/htmlbox
    ;
    ;The following is Browser-dependent.
    ;My default browser is chrome and works well on these pages
    ;Other pages not so well, e.g. Autohotkey.com - probably would be fine in IE Explorer?
    ;
    ;URL       := "http://www.kbdedit.com/manual/low_level_vk_list.html"
    ;URL       := "https://www.webfx.com/blog/images/assets/cdn.sixrevisions.com/0435-01_html5_download_attribute_demo/samp/htmldoc.html"
    URL       := "http://help.websiteos.com/websiteos/example_of_a_simple_html_page.htm"

    VideoURL  := "https://www.youtube.com/watch?v=dAiBHjCS9Qk&t=22s"
    
    ;Options to load html from file:
      ; Gui Add, ActiveX, vWB w800 h600 +VScroll +HScroll, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
      ; document := WB.Document
      ; document.open()
      ; html := FileRead("index.html")
      ; document.write(html)
      ; document.close()
    ;FileURL := "file:///" A_ScriptDir "\hello.html"
    FileURL := "c:\"

    Gui("Font", "Bold")
    hTxtURL := Gui("Add","Text","","URL:")
    Gui("Font", "Normal")
    hEdtURL := Gui("Add", "Edit", "w720 -Wrap r1", URL)
    hBtnLoadURL := Gui("Add", "Button", "x+m w60 h24 gLoadURL", "Load")

    Gui("Font", "Bold")
    hTxtVideo := Gui("Add","Text","x24 y+m","YouTube Video:")
    Gui("Font", "Normal")
    hEdtVideo := Gui("Add", "Edit", "w720 -Wrap r1", VideoURL)
    hBtnVideo := Gui("Add", "Button", "x+m w60 h24 gLoadVideo", "Load")

    Gui("Font", "Bold")
    hTxtFile := Gui("Add","Text","x24 y+m","File:")
    Gui("Font", "Normal")
    hEdtFile := Gui("Add", "Edit", "w720 -Wrap r1", FileURL)
    hBtnFile := Gui("Add", "Button", "x+m w60 h24 gLoadFile", "Load")

_Gui_Tab_Custom:

  Gui("Tab", TabCustom)
    Gui("Add", "Text", , "IP Address")
    ;https://www.autohotkey.com/docs/commands/GuiControls.htm#Custom
    hIPControl := Gui("Add", "Custom", "ClassSysIPAddress32 r1 w150 gIPControlEvent")
    ;Gui, Add, Custom, ClassSysIPAddress32 r1 w150 hwndhIPControl gIPControlEvent
    Gui("Add", "Button", "Default", "Set IP")
    IPCtrlSetAddress(hIPControl, A_IPAddress1)

Gui("Tab") ; exit Tabs

_GuiShow:

  hSB := Gui("Add","StatusBar","","Ready")
  SB_SetIcon("Shell32.dll", 222)

  Gui("Show", "AutoSize", "AHKEZ Gui Demo")

  SplashStatus("Loading...", 1000)

Return

DEMOButtonSetIP:
  SplashStatus("You chose " IPCtrlGetAddress(hIPControl))
Return

IPControlEvent:
if (A_GuiEvent = "Normal")
{
    ; WM_COMMAND was received.

    if (A_EventInfo = 0x0300)  ; EN_CHANGE
        ;ToolTip Control changed!
        SplashStatus("IPControl changed!")
}
else if (A_GuiEvent = "N")
{
    ; WM_NOTIFY was received.

    ; Get the notification code. Normally this field is UInt but the IP address
    ; control uses negative codes, so for convenience we read it as a signed int.
    nmhdr_code := NumGet(A_EventInfo + 2*A_PtrSize, "int")
    if (nmhdr_code != -860)  ; IPN_FIELDCHANGED
        return

    ; Extract info from the NMIPADDRESS structure
    iField := NumGet(A_EventInfo + 3*A_PtrSize + 0, "int")
    iValue := NumGet(A_EventInfo + 3*A_PtrSize + 4, "int")
    if (iValue >= 0)
        ;ToolTip Field #%iField% modified: %iValue%
        SplashStatus("Field " iField " modified: " iValue)
    else
        ;ToolTip Field #%iField% left empty
        SplashStatus("Field " iField " left empty")
}
return

IPCtrlSetAddress(hControl, IPAddress)
{
    static WM_USER := 0x0400
    static IPM_SETADDRESS := WM_USER + 101

    ; Pack the IP address into a 32-bit word for use with SendMessage.
    IPAddrWord := 0
    Loop, Parse, IPAddress, .
        IPAddrWord := (IPAddrWord * 256) + A_LoopField
    SendMessage IPM_SETADDRESS, 0, IPAddrWord,, ahk_id %hControl%
}

IPCtrlGetAddress(hControl)
{
    static WM_USER := 0x0400
    static IPM_GETADDRESS := WM_USER + 102

    VarSetCapacity(AddrWord, 4)
    SendMessage IPM_GETADDRESS, 0, &AddrWord,, ahk_id %hControl%
    return NumGet(AddrWord, 3, "UChar") "." NumGet(AddrWord, 2, "UChar") "." NumGet(AddrWord, 1, "UChar") "." NumGet(AddrWord, 0, "UChar")
}

ResetWB:
  Reload
Return

LoadURL:
  Gui("Tab", TabActiveX)
  hBtnStop := Gui("Add", "Button", "x900 y40 w60 h24 gResetWB", "Reset")
  URL := EditGetText(hEdtURL)
  Gosub HideControls
  hWB :=  Gui("Add", "ActiveX", "vWB x15 yp+15 w800 h600 +VScroll +HScroll", "<!DOCTYPE html>")
  WB.Navigate(URL)
  Gui("Show")
Return

LoadVideo:
  Gui("Tab", TabActiveX)
  hBtnStop := Gui("Add", "Button", "x900 y40 w60 h24 gResetWB", "Reset")
  URL := EditGetText(hEdtVideo)
  Gosub HideControls
  hWB :=  Gui("Add", "ActiveX", "vWB x15 yp+15 w800 h600 +VScroll +HScroll", "<!DOCTYPE html>")
  WB.Navigate(URL)
  Gui("Show")
Return

LoadFile:
  Gui("Tab", TabActiveX)
  hBtnStop := Gui("Add", "Button", "x900 y40 w60 h24 gResetWB", "Reset")
  URL := EditGetText(hEdtFile)

 Gosub HideControls
  hWB :=  Gui("Add", "ActiveX", "vWB x15 yp+15 w800 h600 +VScroll +HScroll", "<!DOCTYPE html>")
  WB.Navigate(URL)
  Gui("Show")
Return

HideControls:
  For control, id in list := [hTxtURL, hEdtURL, hBtnLoadURL, hTxtVideo, hEdtVideo, hBtnVideo, hTxtFile, hEdtFile, hBtnFile]
    GuiControl("Hide", id)
Return

TabChanged:
  SplashStatus("Tab Changed to: ?", 1)
Return

DEMOButtonOK:
  SplashStatus("OK button pressed")
Return

BtnAbout:
  Colors := ["Black", "Silver", "Gray", "White", "Maroon", "Red", "Purple", "Fuschia"
    , "Green", "Lime", "Olive", "Yellow", "Navy", "Blue", "Teal", "Aqua"]
  n := Random(1, Colors.Length())
  Gui("Font", "c" Colors[n] " Bold") ;, Verdana  ; If desired, use a line like this to set a new default font for the window.
  GuiControl("Font", hAboutText)
  ;SoundPlay("*64")
  SplashStatus("Font color changed to: " Colors[n])
Return

BtnChangeComboBox:
  v := GuiControlGet(, hComboBox)
  Switch v
  {
    Case "Item1":
      NewV := 2
    Case "Item2":
      NewV := 3
    Case "Item3":
      NewV := 1
    Default:
      NewV := 3
  }
  GuiControl("Choose", hComboBox, newV)
  SplashStatus("Combo Box Changed to: " newV)
Return

BtnChangeDDL:
  v := GuiControlGet(, hDDL)
  Switch v
  {
    Case "Item1":
      NewV := 2
    Case "Item2":
      NewV := 3
    Case "Item3":
      NewV := 1
    Default:
      NewV := 3
  }
  GuiControl("Choose", hDDL, newV)
  SplashStatus("Drop Down List Changed to: " newV)
Return

BtnChangeEdit:
  v := EditGetText(hEdit)
  v := v = "My Edit" ? "My Edit Changed" : "My Edit"
  EditSetText(hEdit, v)
  SplashStatus("Edit Changed to: " v)
Return

BtnChangeSlider:
  v := GuiControlGet(, hSlider)
  v++
  if (v>100)
    v := 1
  GuiControl(, hSlider, v)
  SplashStatus("Slider Changed to: " v)
Return

BtnChangeUpDown:
  v := GuiControlGet(, hUpDown)
  v++
  GuiControl(, hUpDown, v)
  SplashStatus("UpDown Changed to: " v)
Return

BtnChangeListBox:
  v := GuiControlGet(, hListBox)
  Switch v
  {
    Case "Item1":
      NewV := 2
    Case "Item2":
      NewV := 3
    Case "Item3":
      NewV := 1
    Default:
      NewV := 3
  }
  GuiControl("Choose", hListBox, newV)
  SplashStatus("ListBox Changed to: " newV)
Return

BtnChangeListView:
  row := LV_GetNext() ;StartingRowNumber, RowType)
  LV_Modify(row, "-Select")
  row++
  if (row > LV_GetCount())
    row := 1
  LV_Modify(row, "Select")
  LV_GetText(text, row) ;RowNumber , ColumnNumber)
;  LV_Modify(row, "-Select")
  SplashStatus("ListView Row: " row ", Text: " text)
Return

BtnChangeTreeView:
  Gui, DEMO:Default
  TVAction := TVAction = "-Expand" ? "Expand" : "-Expand"
  GuiControl, -Redraw, hTreeView
  For key, value in ParentIDArray
  {
    ;MB(0,,key " : " ParentIDArray[key])
    TV_Modify(value, TVAction)
  }
  GuiControl, +Redraw, hTreeView
Return

BtnChangeRadio:
  R1 := GuiControlGet(, hRadio1)
  R2 := GuiControlGet(, hRadio2)
  R3 := GuiControlGet(, hRadio3)
  S1 := R3 = 1 ? 1 : 0
  S2 := R1 = 1 ? 1 : 0
  S3 := R2 = 1 ? 1 : 0
  GuiControl(, hRadio1, S1)
  GuiControl(, hRadio2, S2)
  GuiControl(, hRadio3, S3)
  SplashStatus("Radio Group Change")
  ;ListVars(1,,R1, R2, R3, S1, S2, S3)
Return

ChangeComboBox:
  v := GuiControlGet(, hComboBox)
  SplashStatus("Combo Box Changed to: " v)
Return

ChangeEdit:
  v := EditGetText(hEdit) ; GuiControlGet(, hDDL)
  SplashStatus("Edit Changed to: " v)
Return

ChangeDDL:
  v := GuiControlGet(, hDDL)
  SplashStatus("UpDown Changed to: " v)
Return

ChangeUpDown:
  v := GuiControlGet(, hUpDown)
  SplashStatus("UpDown Changed to: " v)
Return

ChangeSlider:
  v := GuiControlGet(, hSlider)
  SplashStatus("Slider Changed to: " v)
Return

ChangeListBox:
  v := GuiControlGet(, hListBox)
  SplashStatus("Slider Changed to: " v)
Return

ChangeListView:
  Gui, DEMO:Default
  Loop, %A_MyDocuments%\*.*
      LV_Add("", A_LoopFileName, A_LoopFileSizeKB)

  LV_ModifyCol()  ; Auto-size each column to fit its contents.

  SplashStatus("ListView Changed")
Return

ChangeTreeView:
  Switch A_GuiEvent
  {
    Case "DoubleClick":
      event := A_GuiEvent
    Case "S":
      event := "Select"
    Default:
      event := A_GuiEvent
  }
  SplashStatus("TreeView Event: " event)
Return

LoadTreeView:
  Gui, DEMO:Default
  n := TV_GetCount()
  n++
  P1      := TV_Add("Parent 1") ; ,, "Expand")
  P1C1    := TV_Add("Parent 1 Child 1", P1)
  P1C2    := TV_Add("Parent 1 Child 2", P1)
  P1C3    := TV_Add("Parent 1 Child 3", P1)
  P2      := TV_Add("Parent 2") ; ,, "Expand")
  P2C1    := TV_Add("Parent 2 Child 1", P2)
  P2C2    := TV_Add("Parent 2 Child 2", P2) ; , "Expand")
  P2C2C1  := TV_Add("Parent 2 Child 2, 1", P2C2)
  P2C2C2  := TV_Add("Parent 2 Child 2, 2", P2C2)
  P2C2C3  := TV_Add("Parent 2 Child 2, 3", P2C2)
  P2C3    := TV_Add("Parent 2 Child 3", P2) ; , "Expand")

  ;not efficient, just hard code for this demo
  Global ParentIDArray := [P1, P1C1, P1C2, P1C3, P2, P2C1, P2C2, P2C2C1, P2C2C2, P2C2C3, P2C3]
  Global TVAction := "Expand"
Return

Radio1Change:
Radio2Change:
Radio3Change:
  Gui, Submit, NoHide
  SB_SetText("Radio Change")
  EditSetText(hEdit, "Radio " MyRadioSelected " Selected.")
Return

DateTimeChange:
  Gui, Submit, Nohide
  ;vMyDateTime
  SB_SetText(MyDateTime)
  GuiControl,, %hMonthCal%, %MyDateTime%
Return

MonthCalChange:
  Gui, Submit, Nohide
  ;vMyMonthCal
  SB_SetText(vMyMonthCal)
  GuiControl,, %hDateTime%, %MyMonthCal%
Return

GetAboutText() {
about_text =
(Join`r`n

About`:
    This is a demo of all Gui controls supported by AutoHotkey (AHK_L)
    All controls except DateTim:
        - Have "g" labels"
        - Have a change button - the greek letter delta (triangle)
    Press the change button to programmatically change controls

Keyboard Shortcuts:
    Escape: Close Gui

License:
    Public Domain: https://creativecommons.org/publicdomain/zero/1.0/

    ==================================================================================================
    This software is provided 'as-is', without any express or implied warranty.
    In no event will the authors be held liable for any damages arising from the use of this software.
    ==================================================================================================

Inspired by:
    https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/

)
Return about_text
}

SplashStatus(Text = "", Duration = 1000) {
  SetTimer("SplashOff", Duration)
  SB_SetText(Text)
}

SplashOff:
  Gui, DEMO:Default
  SetTimer("SplashOff", "Off")
  SB_SetText("Ready")
Return

^x::
  SoundBeep
  Gui("DEMO:Default")
  SplashStatus("Ctrl-X pressed")
Return

DEMOButtonCancel:
  MsgBox(0x34, "CANCEL", "Are you sure?")
  IfMsgBox No
    Return

DEMOGuiEscape:
DEMOGuiClose:
  WB.Document.Close
  WB := ""
	ExitApp

; ** End Script
ExitApp
;Escape::ExitApp