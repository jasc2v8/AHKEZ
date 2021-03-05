;https://rcmdnk.com/blog/2017/11/07/computer-windows-autohotkey/
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

MyText := "My Text"
MyRadio1 := 1
MyRadio2 := 0
MyRadio3 := 0
MyCheckBox := 1
MyCount := 0
MyDropDown := ""
MyComboBox := ""
MyListBox := ""
MyHotkey := "^x"
MyMonthCal := 20151031103040
MyDateTime := 20151031103040

  Gui, Add, Text, , Settings

  Gui, Add, Edit, W200 vMyText, %MyText%
 
  Gui, Add, Radio, Group vMyRadio1, Radio1
  Gui, Add, Radio, x+0 vMyRadio2, Radio2
  Gui, Add, Radio, x+0 vMyRadio3, Radio3
  
  if(MyRadio1 == 1){
    GuiControl, , MyRadio1, 1
  }else if(MyRadio2 == 1){
    GuiControl, , MyRadio2, 1
  }else{
    GuiControl, , MyRadio3, 1
  }

  Gui, Add, Checkbox, xm vMyCheckBox, My CheckBox
  if(MyCheckBox == 1){
    GuiControl, , MyCheckBox, 1
  }

  Gui, Add, Text, , My Count
  Gui, Add, Edit
  Gui, Add, UpDown, vMyCount Range0-10, %MyCount%

  Gui, Add, Text, , My DropDownList
  Gui, Add, DropDownList, vMyDropDown, Item1|Item2|Item3
  GuiControl, ChooseString, MyDropDown, %MyDropDown%

  Gui, Add, Text, , My ComboBox
  Gui, Add, ComboBox, vMyComboBox, Item1|Item2|Item3
  GuiControl, Text, MyComboBox, %MyComboBox%

  Gui, Add, Text, , My ListBox
  Gui, Add, ListBox, vMyListBox, Item1|Item2|Item3
  GuiControl, ChooseString, MyListBox, %MyListBox%

  Gui, Add, Text, , My Hotkey
  Gui, Add, Hotkey, vMyHotkey, %MyHotkey%

  Gui, Add, Text, , My DateTime
  Gui, Add, DateTime, vMyDateTime Choose%MyDateTime%, yyyy/MM/dd HH:mm:ss

  Gui, Add, Text, , My MonthCal
  Gui, Add, MonthCal, vMyMonthCal, %MyMonthCal%

  Gui, Add, Button, W100 X25 Default , OK
  Gui, Add, Button, W100 X+0, Cancel
  Gui, Show, , Input Test

Return

ButtonOK:
  Gui, Submit, NoHide

  ControlGet, item, Choice,, ComboBox1, Input Test

  ;MsgBox, 1:%item% 2:%MyListBox%

  if (item = "Item1") {
    GuiControl, Choose, MyDropDown, 0
    GuiControl, Text, MyComboBox,
    GuiControl, Choose, MyListBox, 0
  } else {
    GuiControl, ChooseString, MyDropDown, Item1
    GuiControl, Text, MyComboBox, Item2
    GuiControl, ChooseString, MyListBox, Item3
  }


  ; ControlGet, Item, List,, MyDropDown
  ; MsgBox, %Item%
  ; ControlGet, Item, List,, MyComboBox
  ; MsgBox, %Item%
Return

ButtonCancel:
GuiClose:
  Gui, Destroy
Return

^x::
  MsgBox Ctrl-X pressed
Return

; ** End Auto-execute Section

; ** End Script
ExitApp
Escape::ExitApp