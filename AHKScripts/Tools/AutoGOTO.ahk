;AutoGOTO_v0.94
/** TODO LIST AT TOP

	FIX:
	Send ^S to save file
	maybe not: Start on entry, not F12 hotkey
	Press F12 when AutoGoto window is open will close the window, not restart
	edit to work on other editors SCITA4K, notepad++?
	Scanfile disable scan between () example help_text at bottom
	
	EDIT:
	Global G object G.Title, G.hGui etc.
	Ajust Gui to fit on different size moniitor example on GAME-PC
	TV right-click context menu: Theme (Default/Dark)?, Save Position xy? help?
	1LabelA:,  1.2.3.4LabelB: ~!n = renumber lables 1LabelA:, 2LabelB
	Remember TV which items are expanded/collapsed
	needs work: move STOP to DebugClass.ahk outside the class
	Hide Jump to window?
	Auto change the version at the top of the scrip?
		
*/

	#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	;#Warn  ; Enable warnings to assist with detecting common errors.
	SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
	SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	#SingleInstance force
	FileEncoding UTF-8
	SetBatchLines, -1
	#NoTrayIcon

Globals:

	Global Title:="AutoGOTO"
	Global Theme:="CRT"

	Global ED1, TV1, LB1, BN1
	Global hGui, hTV1, hLB1, hBN1

	Global ParentNames := "C=DocComments, #=#Directives, F=Functions, G=GUIs, H=HotKeys, L=Labels, T=TODOs"
	Global ParentIDArray := []
	Global ParentNameArray := []

	Global NL := "`r`n"
	Global RS := "|"
	Global SelectedItem
	Global TVBuffer, LBBuffer, ScanBuffer
	Global LN := Object()

	Global SearchStartingWith:=True
	Global SearchContaining:=False
	
	; start on entry TBD Gosub Main
	
HotKeyEvents:

	!F12::	;EXIT
	KeyWait F12
	Gosub 60GuiContextMenuItem2
	
	F12::	;START (will hijack AutoGUI designer mode)
	KeyWait F12
	
	/** todo
		if gui open
			gui +Hide (not close)
		Else
			Main
			
	#IfWinActive, AutoGOTO
		Gui, 60: Submit, NoHide
	#IfWinActive

	*/

Main:
	Gosub Initialize
	Gosub ReadFile
	Gosub ScanFile
	Gosub GuiNew	;** New if first time else show -Hide
	Gosub TVLoad
	Gosub GuiShow ;Load then show reduces minor flicker
Return

Initialize:
	;init parent names array
	Loop, Parse, ParentNames, CSV, % A_Space
	{
		Array := StrSplit(A_LoopField , "=")
			Index:=Array[1] ;PARENT_KEY
		Value:=Array[2] ;PARENT_NAME
		ParentNameArray[Index]:=Value
	}
Return

ReadFile:

	WinGetActiveTitle, EditorWindowTitle
	
	if !( Instr(EditorWindowTitle, ".ahk") and Instr(EditorWindowTitle, ":\") ) {
		SoundBeep
		MsgBox No filename in the Editor window title`n`nOpen an AHK script then try again
		Return
	}
	
	Filename:=Trim(Substr(EditorWindowTitle, temp:=Instr(EditorWindowTitle, ":\")-1, Instr(EditorWindowTitle, ".ahk", 0, 0)-temp+4))
	
	FileGetSize, OldFileSize, % Filename
	
	Send ^s	;save edits before AutoGOTO starts

	;wait until save is finished
	Loop, 5
	{
		count:=A_Index
		Sleep, 50
		FileGetSize, NewFileSize, % Filename
		if (NewFileSize!=OldFileSize)
			Break
	}
	
	;if no changes to the file, the loop will timeout. limited testing showed a count of only 1 loop
	;MsgBox % "count=" count "`n`nOldFileSize=" OldFileSize "`n`nNewFileSize=" NewFileSize

	FileRead, FileBuffer, % Filename 	;FileBuffer contains spaces, tabs, and special chars

Return

ScanFile:

	;OmitChars %A_Space%%A_Tab% will be removed from the beginning and end (but not the middle) of A_LoopField
	TVBuffer:=""
	Loop, Parse, FileBuffer, `n, `r%A_Space%%A_Tab%
	{	
		Line := ReplaceWhitespaceWithA_Space(A_LoopField)
		
		;if end of block comment
		if ( (BlockComment) and ( SubStr(Line,1,2) !="*/") )  {
			Continue			
		} else {
			BlockComment:=False
		}

		;	;** one-liner DocComment
		if ( (SubStr(Line,1,3)=";**") ) {
			Key:="C"
			Line:=FixTodo(Line)
			TVBufferAppend(Key, Line, A_Index) 
			Continue
		}

		;	/** block DocComment
		if ( (SubStr(Line,1,3)="/**" ) )  {
			Key:="C"
			Line := RegExReplace(Line, ("i)todo:","todo", "TODO")) ;make TODOs look consistent
			TVBufferAppend(Key, Line, A_Index) 
			BlockComment:=True
			Continue
		}

		;remove in-line comments
		p := InStr(Line,";")
		if (p !=0)
			Line := SubStr(Line, 1, p-1)
		Line:=RTrim(Line)

		;#Directives
		if (SubStr(Line,1,1)="#") {
			Key:="#"
			TVBufferAppend(Key, Line, A_Index) 
			Continue
		}
		
		;Function end if no left brace to start a function
		;}
		if (SubStr(Line,1,1)!="{")
			SavedLine:=""
	
		;Function()
		;{
		if (SubStr(Line,0)=")") and (InStr(Line,"(") !=0) {
			;if no space to the left of the "(" then this line may be a function versus command
			if ( InStr( SubStr(Line,1, Instr(Line,"(") ), A_Space)=0 )  {
				SavedLine:=Line	;could be a function if next line starts with {
				Continue				
			}
		}
		
		; Function()
		; {
		if ( (SubStr(Line,1,1)="{")  and (SavedLine != "") ) {
			Key:="F"
			SavedLine:=RemoveFunctionParams(SavedLine)
			TVBufferAppend(Key, SavedLine, A_Index - 1) 
			SavedLine:=""
			Continue
		}
		
		; Function() {
		if (SubStr(Line,0)="{") and (InStr(Line,")") !=0) {
			if ( InStr( SubStr(Line,1, Instr(Line,"(") ), A_Space)=0  )  {
				Line:=RTrim(SubStr(Line,1,-1)) ; no longer needed?
				Key:="F"
				Line:=RemoveFunctionParams(Line)
				TVBufferAppend(Key, Line, A_Index) 
				Continue
			}
		}
		
		; GUIs
		if (InStr(Line, "Gui,") =1) {
			temp:=""
			p:= InStr(Line, "New")
			if (p!= 0)
				temp:=SubStr(Line,1,p+2)
			p:= InStr(Line, "Show")
			if (p!= 0)
				temp:=SubStr(Line,1,p+3)
			if (temp!="") {
				Key:="G"
				TVBufferAppend(Key, temp, A_Index) 
			}
			Continue
		}
		
		; the following order is signifcant: Hotstring, then Hotkey, then Label
		
		; ::HotString::	
		if (SubStr(Line,1,2)="::") {
			Key:="H"
			TVBufferAppend(Key, Line, A_Index) 
			Continue
		}
		
		; HotKey ^NumpadAdd::		
		if (SubStr(Line,-1,2)="::") {
			Key:="H"
			TVBufferAppend(Key, Line, A_Index) 
			Continue
		}

		; Label:	
		if (SubStr(Line,0)=":") {
			if ( InStr( SubStr(Line,1, Instr(Line,":") ), A_Space)=0  )  {
				Key:="L"
				TVBufferAppend(Key, Line, A_Index) 
				Continue
			}
		}
	}
	
;MARK_Sort
	Sort, TVBuffer
Return

GuiNew:

	if (Theme = "CRT") {
		WindowColor:="Default"
		ControlColor:="272822"	; windows command background
		FontColor:="00d900"		; legacy CRTgreen50%=00FF00 45%=00e600 [43%00d900] 40%=00cc00 30%=009900<=AutoGUI Dark Theme
		FontSize:=12
		FontName:="Consolas"
	} else {
		WindowColor:="Default"
		ControlColor:="Default"
		FontColor:="Default"
		FontSize:="Default"
		FontName:="Default"
	}

	Gui, 60:New, +HwndhGui +AlwaysOnTop +ToolWindow +Owner +Resize
	Gui, 60:Font, q2 s%FontSize% c%FontColor%, %FontName%
	Gui, 60:Color , %WindowColor%, %ControlColor%
	Gui, 60:Add, Edit, x15 y10 w420 h30 vED1 hwndhED1 gSearchEvent
	Gui, 60:Add, TreeView, x15 y50 w420 h890 vTV1 hwndhTV1 gTV1_Event 
	Gui, 60:Add, ListBox, +Hidden Sort x15 y50 w420 h890 vLB1 hwndhLB1 gLB1_Event
	Gui, 60:Add, Button, x325 y50 w80 h30 +Default +Hidden vBN1 hwndhBN1, Enter

	Menu, 60:GuiContextMenu, Add, Help, 60GuiContextMenuItem1
	Menu, 60:GuiContextMenu, Add, Exit, 60GuiContextMenuItem2

	MenuItemName1:="Search Starting With..."
	MenuItemName2:="Search Containing..."

	Menu, 60:LB1ContextMenu, Add, Help, 60GuiContextMenuItem1
	Menu, 60:LB1ContextMenu, Add,		% MenuItemName1, LB1ContextMenuItem1
	Menu, 60:LB1ContextMenu, Add,		% MenuItemName2, LB1ContextMenuItem2
	Menu, 60:LB1ContextMenu, Check,	% MenuItemName1
Return

GuiShow:
	Gui, 60:Show, x1460 y5 w450 h955, %Title%
Return

	60GuiContextMenu:
	if A_GuiControl = TV1
		Menu, 60:GuiContextMenu, Show, %A_GuiX%, %A_GuiY%
	
	if A_GuiControl <> LB1
		Return
	Menu, 60:LB1ContextMenu, Show, %A_GuiX%, %A_GuiY%
	Return
	
	60GuiContextMenuItem1:
	Gosub Help
	Return

	60GuiContextMenuItem2:
	MsgBox 0x40024, Exit App, Are you sure you want to exit?
	IfMsgBox Yes, {
		Gosub 60GuiClose
	} Else IfMsgBox No, {
		Return
	}

;MARK_SearchStartinWith

	LB1ContextMenuItem1:
	;Search Starting With...
	Menu, 60:LB1ContextMenu, ToggleCheck, % MenuItemName1
	Menu, 60:LB1ContextMenu, ToggleCheck, % MenuItemName2
	SearchStartingWith:=!SearchStartingWith
	SearchContaining:=!SearchContaining
	;copy text in LB
	;reload LB
	;paste text to redo the filter with the new search starting or containing
	Return

	LB1ContextMenuItem2:
	;Search Containing...
	Menu, 60:LB1ContextMenu, ToggleCheck, % MenuItemName1
	Menu, 60:LB1ContextMenu, ToggleCheck, % MenuItemName2
	SearchStartingWith:=!SearchStartingWith
	SearchContaining:=!SearchContaining
	Return

TVLoad:

	if (TVBuffer="") {
		MsgBox INTERNAL ERROR TVBuffer is empty
		Return	
	}

	;TVBuffer:		"PARENT_KEY|LINE`n"		This buffer can be sorted with a line ending`n

;MARK_TVLoad

	GuiControl, -Redraw, TV1

	ParentIDArray := []
	LBBuffer:=""
	TV_Delete()

	;Note: Parse will replace tabs with blanks
	Loop, Parse, TVBuffer, `n ; KEY|LINE`n SplitString KEY, LINE
	{
	
		temp:=StrSplit(A_LoopField, "|")
		
		Parent:=temp[1]
		Child:=temp[2]

		ParentID := ParentIDArray[Parent]
		If (ParentID="")  {
			ParentNameKey:=Parent
			ParentName:=ParentNameArray[ParentNameKey]
			ParentID:=TV_Add(ParentName, 0, "Expand")
			ParentIDArray[ParentNameKey]:=ParentID
		}
		ChildName:=Child
		if (ChildName!="") {
			TV_Add(ChildName, ParentID)
			LBBuffer .= ChildName . RS
		}
	}
	
	GuiControl, +Redraw, TV1
	TV_Modify(ParentIDArray["#"], "Select")	
Return

LBLoad:
	GuiControl, -Redraw, LB1
	Guicontrol, ,LB1, | ;clear LB
	Guicontrol, ,LB1, %LBBuffer%
	Control, Choose, 1 , LB1 ;choose 1st item
	SendMessage 390, 0, 0,, ahk_id %hLB1% ;LB_SETCURSEL Select the first item.
	GuiControl, +Redraw, LB1
Return

SearchEvent:

	;get the text to search
	Gui, 60:Default
	GuiControlGet, txt,, ED1, 

	;+Hide TV, -Hide LB
	GuiControl, Hide, TV1
	GuiControl, Show, LB1

	;if no search text, reset LB
	if (txt="") {
		Gosub LBLoad
		Return
	}

	;peform the search and show results in the ListBox
	SearchBuffer:=""
	Loop, Parse, LBBuffer, % RS
	{
		   
		If (A_LoopField:="")
			Continue
			
		if (SearchStartingWith) {
			if (InStr(A_LoopField, txt)=1 )  ; starts with
				SearchBuffer .= A_LoopField . RS			
		} else {
			if (InStr(A_LoopField, txt)!=0 )  ; contains
				SearchBuffer .= A_LoopField . RS
		}
	}

	GuiControl, -Redraw, LB1
	Guicontrol, ,LB1, | ;clear LB
	Guicontrol, ,LB1,% SearchBuffer		
	Control, Choose, 1 , LB1 ;choose 1st item
	SendMessage 390, 0, 0,, ahk_id %hLB1% ;Select the first item. LB_SETCURSEL
	GuiControl, +Redraw, LB1
Return
	
	UpperCase(Text) {
		StringUpper, Result, Text
		Return, Result	
	}

	IsVisible(pControlwhnd) {
		result:=false
		ControlGet, IsVisible, Visible,,,ahk_id %pControlwhnd%
		if (IsVisible=1)
			result:=true
		return result
	}
	
	TVExpand(Action="+Expand") {
		Gui, 60:Default
		GuiControl, -Redraw, TV1
		For key, value in ParentIDArray
		{
			TV_Modify(value, Action)
		}
		GuiControl, +Redraw, TV1
	}

;MARK_TVBufferAppend

	TVBufferAppend(RecordKey, RecordValue, LineNumber) {
		TVBuffer .= RecordKey . "|" . RecordValue . "`n"
		LN.Insert(RecordValue, LineNumber)
	}
	
	RemoveFunctionParams(pText) {
		if (Instr(pText,"(")!=0)
			pText:=SubStr(pText, 1, InStr(pText, "(")) . ")"
		Return pText
	}
			
	ReplaceAnyNonWordCharWithA_Space(pText) {
		;Replace any non-word char except [a-zA-Z0-9_] with A_Space
		Return Result:=RegExReplace(pText, "[\W]", A_Space)
	}
	
	ReplaceWhitespaceWithA_Space(Haystack) {
		;\s matches any single whitespace character: space, tab, and newline (`r and `n)
		;Haystack:=StrReplace(Haystack, A_Tab, A_Space)
		;Needle:=RegExReplace(StrReplace(Haystack, A_Tab, A_Space),"\s+", A_Space) 
		Return Needle:=RegExReplace(StrReplace(Haystack, A_Tab, A_Space),"\s+", A_Space) 		
	}
	
	FixTodo(Line) {
		Line:=StrReplace(Line, "todo:", "TODO", count) 
		if (count=0)
			Line:=StrReplace(Line, "todo", "TODO") 
		return Line:=StrReplace(Line, "**todo", "** TODO") 
	}
		
ControlEvents:

#IfWinActive, AutoGOTO

	~BS::
	Gui, 60:Default
	GuiControlGet, txt,, ED1, 
	;if no search text, hide LB1, show TV1
	if (txt="") {
		GuiControl, Hide, LB1
		Gosub TVLoad
		GuiControl, Show, TV1
	}
	Return

	Up::
	if IsVisible(hLB1) {
		ControlSend,, {Up}, ahk_id %hLB1%	
	} else {
		if IsVisible(hTV1)
			ControlSend,, {Up}, ahk_id %hTV1%
	}
	Return

	Down::
	if IsVisible(hLB1) {
		ControlSend,, {Down}, ahk_id %hLB1%
	} else {
		if IsVisible(hTV1)
			ControlSend,, {Down}, ahk_id %hTV1%
	}
	Return

	^NumpadAdd::
	if IsVisible(hTV1)
		TVExpand()
	Return

	^NumpadSub::
	if IsVisible(hTV1)
		TVExpand("-Expand")
	Return
	
	60ButtonEnter:
	Gui, 60: Submit, NoHide

	if IsVisible(hLB1) {
		DoJump(LB1)
	} else {
		if IsVisible(hTV1)
		TV_GetText(SelectedItem, TV_GetSelection())
		if (Instr(ParentNames, "=" . SelectedItem)) {
			if ( TV_Get(TV_GetSelection(), "Expanded") ) {
				TV_Modify(TV_GetSelection(), "-Expand")
			} else {
				TV_Modify(TV_GetSelection(), "+Expand")
			}
			Return			
		}
		DoJump(SelectedItem)
	}
	Return
	
	60GuiSize:
	if (A_EventInfo = 1)
		Return
	WinGet, ActiveControlList, ControlList, A
	Loop, Parse, ActiveControlList, `n
	{
		if (SubStr(A_LoopField,1,4) = "Edit") {
			AutoXYWH("w", A_LoopField)
		} else if (SubStr(A_LoopField,1,6) = "Button") {
			AutoXYWH("x", A_LoopField)
		} else { 
			AutoXYWH("wh", A_LoopField)
		}
	}
	Return

	LB1_Event:
	if A_GuiEvent <> DoubleClick
		Return
	Gui, 60: Submit, NoHide
	DoJump(LB1)
	Return

	TV1_Event:
	if A_GuiEvent <> DoubleClick
		Return
	TV_GetText(SelectedItem, A_EventInfo)
	;if a parent item, dont jump. Return to allow TV to expand/collapse on double-click
	if (Instr(ParentNames, "=" . SelectedItem)!=0)
		Return
	DoJump(SelectedItem)
	Return

	60GuiEscape:
	Gui, 60: Hide
	Return
	
	60GuiClose:
	Gosub HelpGuiClose
	Gui, 60: Destroy
	ExitApp
	
#IfWinActive

DoJump(SelectedItem)
{
	LineNumber:=LN[SelectedItem]

	if (LineNumber="") {
		;SoundBeep
		Return
	}

	Gui, 60: Destroy
	
	BlockInput, On
	SendInput, ^g
	Sleep, 100 ; wait for goto input box
	SendInput,% LineNumber "{Enter}"
	Sleep, 100
	Send, {ShiftDown}{End}{ShiftUp}
}

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
	static cInfo := {}
	
	If (DimSize = "reset")
		Return cInfo := {}
	
	For i, ctrl in cList {
		ctrlID := A_Gui ":" ctrl
		If ( cInfo[ctrlID].x = "" ){
			GuiControlGet, i, %A_Gui%:Pos, %ctrl%
			MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
			fx := fy := fw := fh := 0
			For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
				If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
					f%dim% := 1
			cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
		}Else If ( cInfo[ctrlID].a.1) {
			dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
			For i, dim in cInfo[ctrlID]["a"]
				Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
			GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }

Help:
IfWinExist, Help
	Return

HelpText = 
(
AutoGOTO Version %Version%

A simple way to store and use text snippets in any windows program.
https://github.com/ethanpil/snips

---Instructions---
* Activate Snips using the hotkey (Default is CTRL+Backtick)
* Search box is active by default so you can instantly type to search snippets. (File names) 
* Hit the down arrow to activate the tree or search resuls box. Use the arrow keys to navigate 
* Press enter or double click to copy a snippet to clipboard
* Escape key will close Snips and return you to your previous window
* CTRL+R will refresh your list of snippets from disk
* A tray icon is displayed, which you can use to manage Snips or terminate the program.

All snippets are plain text files stored in the \snips folder under the program binary. One snippet per file. 

---Options---
Snips.ini the the program folder sets a few options:

    folder=snips   ; The subfolder under snips.exe which contains all the snippets.
    key=^`         ; An autohotkey code that activates the snippets window.

---Snippet Files---
All snippets are plain text files stored in the \snips folder under the program binary. One snippet per file. Edit the contents of the \snips folder in the program root to modify your collection. The tree view will mirror your folder structure. Filenames are the Snippet titles displayed in search and tree.

---Position the Cursor---
You can tell Snips to position the cursor with anoptional command code exclusively on the last line of a snippet file: <<-X   
Replace X with the number of spaces FROM THE END OF THE FILE to reverse the cursor. 

For example if your snippet file contained the following code:

    #include <>
    <<-2

The <<-2 on the last line of the file tells snips to position the cursor 2 characters from the end of the previous line. Therefore, after the snippet is inserted, the cursor will be positioned between the brackets. <|>.

---Thanks---
Autohotkey developers and forums.

---License and Copyright---
Copyright (C) Ethan Piliavin
Released under the GPLv3 license, included as license.txt
)

Gui, Help:New, +AlwaysOnTop +ToolWindow
Gui, Help:Font, q2 s12 cDefault Bold, Consolas
Gui, Help:Add, Button, Default x0 y0 w0 h0 +Hide gHelpGuiClose, OK
Gui, Help:Add, Edit, +ReadOnly +VScroll x10 y10 w620 h460 HwndhHelpEdit, %HelpText%
Gui, Help:Show, Center w640 h480, Help
Return

HelpGuiEscape:
HelpGuiClose:
Gui, Help:Destroy
Return

