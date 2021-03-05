HCADacct := "Clipboard"
Gui, Add, Edit, vCADacct w110, HCADacct ; %HCADacct%
;Gui, Add, DropDownList, vYearPick, 2017|2016||2015|2014  ;The Pipe character placed after shows which one is the Default. 
Gui, Add, Button, vBtnOK Default, Okay
GuiControl, Focus, BtnOK
Gui, Show
Return

Escape::ExitApp