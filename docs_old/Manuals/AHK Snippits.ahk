if ( A_ScriptName = "AHK Quick Reference.ahk" )
	ExitApp

About_Snippits:
	Snippets for quick reference
	Use your IDE code browser to find topic by label name

AHK_Syntax_And_Operators:

	; AHK chars that need to be escaped \.*?+[{|()^$ also escape "
	;"\\\.\*\?\+\[\{\|\(\)\^\$\""
	; source:https://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm#fundamentals

	https://www.autohotkey.com/docs/Concepts.htm#variables
	Maximum length: 253 characters.
	Allowed characters: Letters, numbers, non-ASCII characters, and the following symbols: _ # @ $
	Due to style conventions, name your variables using only letters, numbers, and the underscore character
	Although a variable name may consist entirely of digits, this is generally used only for incoming command line parameters.
	Such numeric names cannot be used in expressions because they would be seen as numbers rather than variables.
	It is best to avoid starting a name with a digit, as such names are confusing and will be considered invalid in AutoHotkey v2.
	As the following characters may be reserved for other purposes in AutoHotkey v2, it is recommended to avoid using them: # @ $

	line continuations: "and", "or", ||, &&, a comma, or a period 

Arrays_Simple_Arrays:

	Global MyArray:=[]

	after creation before adding items:
	MaxIndex:=MyArray.MaxIndex() ;blank if empty
	Length:=MyArray.Length()	;0 if empty

	after adding items:
	MaxIndex:=MyArray.MaxIndex() ;number of items in array
	Length:=MyArray.Length()	;number of items in array
		
	Array.InsertAt(Index, Value, Value2, ...)
	Array.Push(Value, Value2, ...)
	RemovedValue := Array.RemoveAt(Index)
	RemovedValue := Array.Pop()

Arrays_Simple_Arrays_2D:

	Basic2D() {
			Arr := [] 
			Arr[0, 0] := "0,0"
			Arr[0, 1] := "0,1"
			Arr[1, 0] := "1,0"
			Arr[1, 1] := "1,1"
			return Arr
	}

	ParseArray[1, 1] := 1
	Array[1, 2] := 3

	;ParseArray[1,1] := "one"
	ParseArray[1,2] := "two"

	v := ParseArray[1,1]
	MsgBox %v%
	v := Array[1,2]
	MsgBox %v%
	
	;table
	MyTable := []
	MyTable[1, 1] := "d"
	MyTable[1, 2] := "o"
	MyTable[1, 3] := "g"
	MyTable[2, 1] := "e"
	For Each, Row in MyTable
	For, Each, item in Row
		MsgBox %item%

	;array
	ParsedAndSortedScript := ParseAHK_TV(Line, hTempTV, DocComment)
	Gui, TEMP:Destroy	
	;1D array
	TempArray := StrSplit(ParsedAndSortedScript, "|")
	;1D to 2D array
	Array :=[]
	index1 := index2 := 0
	saved_name := ""
	Loop % TempArray.MaxIndex()
	{
		name := TempArray[A_Index]
		if (name != saved_name) {
			index1++
			Array[index1,0] := name			
		} else {
			Array[index1, index2] := name
			index2++
		}
	}	
	Return Array
	
	;alt method not using StrSplit
	Array :=[]
	index1 := index2 := 0
	saved_name := ""
	Loop, Parse, ParsedAndSortedScript, "|" ;`n, `r
	{
		name := A_LoopField
		if (name != saved_name) {
			index1++
			Array[index1,0] := name
			index2 := 1
			Continue
		}		
		Array[index1, index2] := name
		index2++
	}
	Return Array
	
Arrays_Associative_Arrays_Objects:

	#Include <Class_DebugGUI>
	d:=new debugGui

	array := []

	Array["A_UserName"] := A_UserName
	v1 := Array.A_UserName
	v2 := Array["A_UserName"]
	d.pause("v1=" v1 ", v2=" v2)

	array := {"A_UserName":A_UserName,"A_Programs":A_Programs}

	key:="A_Programs"
	d.pause("v3=" array["A_UserName"])
	d.pause("v4=" array["A_Programs"])
	d.pause("v5=" array[key])

	array := {1:A_UserName,2:A_Programs}

	d.pause("v6=" array.1)
	d.pause("v7=" array.2)
	d.pause()
	ExitApp

Coding_Style:

	https://wiki.freepascal.org/Coding_style

	_GUI_CONTROLS
	__ControlSet

	_GUI
	__Gui_Hide_Show

Compiled_Script:

	Edit the exe file to see the script text at the end of the File
	All #Includes are merged and compiled so no #Includes performed at run time.

ErrorLevel:

	0 usually indicates success, and any other value usually indicates failure.
	You can also set the value of ErrorLevel yourself.
	Success = 0
	Failure = 1

	If (ErrorLevel)
		;Failure
		
	If (!ErrorLevel)
		;Success
	
File:

	file = %A_ScriptDir%\spawn.tmp ;must be file space = space)
	filename = %A_Desktop%\file.txt
	DebugFile:=A_ScriptDir "\debug.txt"
	FileAppend, hello world, %filename%
	FileAppend, "TEST WRITE TO DEBUG.TXT", % DebugFile
	FileAppend, "TEST WRITE TO DEBUG.TXT", % A_ScriptDir "\debug.txt"

	FileDelete, % A_ScriptDir "\debug.txt"

	FileGetSize, NewFileSize, % Filename

	FileRead, FileBuffer, %filename%
	FileRead, Results, %file%
	FileRead, Results, %A_ScriptDir%\spawn.tmp

	MsgBox Read debug.txt

Gui_Commands:

	Gui, +HwndhGui

	G:= this.controls.hGui
	Gui, %G%: Hide

	Gui, % this.controls.hGui ":Hide"

	hGui := WinExist("A")  ; Get the HWND of active Window


	MsgBox did browser activate 2?
			
	Gui, New, +hwndhGui Options, % this.Title ; % "+hwndhGui " 
	this.hGui := hGui
	this.ahk_id := "ahk_id" hGui

	PostMessage, 0x112, 0xF060,,, % "ahk_id " this.hGui ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
	PostMessage, 0x112, 0xF060,,, % this.GuiID ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE

	Gui, 60:Default

Gui_Controls:

	Gui +LastFound  ; Avoids the need to specify WinTitle below.

	GuiControl,, Edit1 ; clear the control text
	GuiControl,, Edit1, %DefaultRootDir% ; If Edit1 is selected when Gui, Show, this will set the unselected text
	GuiControl, Hide, %hResumeButton%

	ControlGetText, text, , ahk_id %hEdit%
	ControlGetText, text, , % "ahk_id " hEdit

	ControlSetText, Edit1 ;clear the control text
	ControlSetText, Edit1, % vText ;if called by a button press, Edit1 doesn't have to be declared Global
	ControlSetText,, %vText%, ahk_id %hMemo% ;HWND must be declared as Global hMemo

	SendMessage Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]
	SendMessage, 0x0028, hControl, 1, , ahk_id %hGui% ; WM_NEXTDLGCTL=0x0028, wParam=hControl, wParam=True
	SendMessage, 0x0028, hControl,  , , %GuiTitle%    ; WM_NEXTDLGCTL=0x0028, wParam, wParam= non-standard per Win32 API

	;focus and highlight next control in gui
	SendMessage, 0x0028, , , , %GuiTitle%
	SendMessage, 0x0028, , , , % "ahk_id" hGui  					; WM_NEXTDLGCTL = 0x0028 control handle not needed if next in tab order
	SendMessage, 0x0028, this.controls.hResumeButton, 1, , % "ahk_id" this.controls.hGui  ; WM_NEXTDLGCTL = 0x0028

	this.PushBtnSetFocus(this.controls.hMBOXGui, this.controls.hMBOXButton)
	PushBtnSetFocus(HGUI, HBTN) { ; WM_NEXTDLGCTL = 0x0028
		 SendMessage, 0x0028, HBTN, 1, , ahk_id %HGUI%
	}

Include_Libraries:

	;in search order: Local, User, Standard
	%A_ScriptDir%\Lib\  ; Local library - requires [v1.0.90+].
	%A_MyDocuments%\AutoHotkey\Lib\  ; User library.
	directory-of-the-currently-running-AutoHotkey.exe\Lib\  ; Standard library.

Instr_SubStr:

	;In: "<Class_Debug>", Out: "Class_Debug"
	pos1 := Instr(Text, "<")
	if (pos1 != 0) {
		;pos2 := Instr(Text, ">")
		;fname := SubStr(Text, pos1+1, pos2-pos1-1)
		fname := SubStr(Text, pos1+1, Instr(Text, ">")-pos1-1)
		
Labels:

	aLabel := "Test" . vInput
	Gosub %aLabel%

Loop:

	;OmitChars %A_Space%%A_Tab% will be removed from the beginning and end (but not the middle) of A_LoopField
	Loop, Parse, FileBuffer, `n, `r%A_Space%%A_Tab%
	{	
		Line := A_LoopField . "`n" ;Loop, Parse excludes the delimiter from A_LoopField
	}
	
	
	Loop, % MyArray.Length()

	;Outer/Inner Loop
	
	;this.Options:="ThemePowerShell, ThemeCmd, ThemeDefault, LineNumbers, DateTime, Time" ;not used, just for documentation
	IsOptionSet(pOption) {
		result:=false
		pOptionArray:=StrSplit(pOption, ",", " ")
		SetOptionsArray:=StrSplit(this.Options, ",", " ")
		Loop % pOptionArray.Length()
		{
			OuterLoopIndex:=A_Index
			Loop % SetOptionsArray.Length()
			{
				if ( (SetOptionsArray[A_Index]="") or (pOptionArray[OuterLoopIndex] =""))
					Continue
				if ( SetOptionsArray[A_Index] = pOptionArray[OuterLoopIndex] )
					result:=true			
			}
		}
		return result
	}

MsgBox:

	MsgBox, % "HELLO" Chr(116) Chr(0x0a) Chr(116) ; Shows "t".
	n1:=Chr(0x0a) ; nl:="`n"
	msgbox % "Hello from spawned script!" Chr(11) two

	MsgBox,0x01, DEBUG, before= %A_LoopField% `n`n after= %Line%
	IfMsgBox Cancel
		ExitApp

	SysGet, Mon, MonitorWorkArea
	MsgBox % "MonRight=" MonRight
	MsgBox MonRight=%MonRight%

RegExMatch_RegExReplace:

	/*
		
	https://regex101.com/

	ESCAPED CHARACTERS: \.*?+[{|()^$
	
			\w Matches any single "word" character, namely alphanumeric or underscore.
			This is equivalent to [a-zA-Z0-9_]. Conversely, capital \W means "any non-word character".
			
	The \s metacharacter is used to find a whitespace character.
		A whitespace character can be:
			A space character
			A tab character
			A carriage return character
			A new line character
			A vertical tab character
			A form feed character

	Line := "var := Function(p1)"
	v := RegExReplace(Line, "(\w+)\s:=\s(\w+)([\(])([\w\s,]*)([\)])", $2)
	
	$0 var := Function(p1)
	$1 var
	$2 Function 
	$3 (
	$4 p1,p2
	$5 )
	*/

	\w Matches any single "word" character, namely alphanumeric or underscore.
	This is equivalent to [a-zA-Z0-9_]. Conversely, capital \W means "any non-word character".
	Line := RegExReplace(A_LoopField, "[\W]", "_")
		
	AGT__ReplaceAnyNonWordCharWithA_Space(pText) {
	;Replaces any non-word char except [a-zA-Z0-9_] with A_Space
	Return Result:=RegExReplace(pText, "[\W]", A_Space)
	}
	
	AGT__ReplaceWhitespaceWithA_Space(Haystack) {
	;\s matches any single whitespace character: space, tab, and newline (`r and `n)
	Return Needle:=RegExReplace(StrReplace(Haystack, A_Tab, A_Space),"\s+", A_Space) 
	}

	;https://regex101.com/

	(\w+)\s:=\s(\w+)([\(])([\w\s,]*)([\)])
	$0 var := Function(p1)
	$1 var
	$2 Function 
	$3 (
	$4 p1,p2
	$5 )
	
	(?!) - negative lookahead
	(?=) - positive lookahead
	(?<=) - positive lookbehind
	(?<!) - negative lookbehind

	Static Needle_Call_Class    := "iS)(*UCP)^.*:=\s*New ([\w$#@.]+)" ; i) = case insenstive
	Static Needle_Call_Function := "S)(*UCP)([\w$#@]+)\("							; S) (*UCP) = Study Unicode

	;Search for anything that matches
	MatchArray := []
	p := 1, m := ""
	while p := RegExMatch(Line, "S)(*UCP)([\w$#@]+)\(", m, p + StrLen(m))
			MatchArray[A_Index] := m1

Run_RunWait:

	Run(IniFile) ; notepad++
	Run("myfile.ini") ; notepad++
	Run("edit myfile.ini") ; notepad

	Run, edit "C:\My File.txt"	; notepad
	Run, edit %TxtFile%					; notepad
	Run, %TxtFile%							; notepad++

	RunWait, edit %LogFile%
	RunWait("edit " LogFile)

	spawnfile:= % A_ScriptDir "\spawn_test.ahk"
	RunWait, %spawnfile%, ,UseErrorLevel, OutputVarPID
	RunWait, % A_ScriptDir "\spawn_test.ahk", ,UseErrorLevel, OutputVarPID
	if (ErrorLevel = "ERROR")
			MsgBox The spawn file could not be launched.

		Run, notepad.exe "%Filename%"
		Sleep, 500
		Send, This is a spawned process.
		Sleep, 1000
		WinClose, A ;also works send !{f4}
		send {n}

Sleep:

	MS:=250
	Sleep, MS

SoundBeep:

	SoundBeep [, Frequency, Duration]
	SoundPlay Filename [, wait]
	*-1: Simple beep. If the sound card is not available, the sound is generated using the speaker.
	*16: Hand (stop/error)
	*32: Question
	*48: Exclamation
	*64: Asterisk (info)
	SoundPlay *16 ; Hand (stop/error)
	SoundPlay *64 ; Asterisk (info)

Strings:

	StringReplace,aTest,aTest,`n,,A
	
	Line := SubStr(Line, 1, Instr(Line, "(") - 1) ; -1 to exclude the needle
	;In:		v := Function(params)
	;Out:	v := Function
	
Strings_Join:

	;(LTrim Join`r`n
	Prompt=
	(LTrim
	1. Append
	2. Clear
	3. SetText
	Press Enter to Exit
	)
	
	String := "
	(`
	- avocado
	- banana
	- mango
	)"

	String =
	(
	if ifequal ifexist ifgreater 
	ifgreaterorequal ifinstring 
	)

	String_all := ""
		. String1
		. String2
		. String3

Switch_Case:

		Switch Theme
		{
			Case "Cmd":
				this.opt.WindowColor	:= "Default"
				this.opt.ControlColor	:= "0C0C0C"
				this.opt.FontColor		:= "F3F3F3"
				this.opt.FontName			:= "Consolas"
			Case "PowerShell":
				this.opt.WindowColor	:= "Default"
				this.opt.ControlColor	:= "012456"
				this.opt.FontColor		:= "F3F3F3"
				this.opt.FontName			:= "Consolas"
			Default:
				this.opt.WindowColor	:= "Default"
				this.opt.ControlColor	:= "Default"
				this.opt.FontColor		:= "Default"
				this.opt.FontName			:= "Default" ; Courier New
		}
	}
	
SplitPath:

	SelectedFile := "C:\Folder\Script.ahk"
	SplitPath, SelectedFile , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	msgbox % "-" OutFileName "`n" OutDir "`n" OutExtension "`n" OutNameNoExt "`n" OutDrive
	ListVars
	Pause

	OutDir							:	D:\Software\DEV\Work\AHK
	OutDrive						: D:
	OutExtension				: ahk
	OutFileName					: test.ahk
	OutNameNoExt				: test
	SelectedFile				: D:\Software\DEV\Work\AHK\test.ahk

	SplitPathArray(SelectedFile).OutNameNoExt ; "Script"

Time_TickCount:

	TimeStamp := FormatTime, now,, yyyyMMddHHmmss

	StartTime := A_TickCount
	ElapsedTime := A_TickCount - StartTime
	MsgBox,  %ElapsedTime% milliseconds have elapsed.

	;seconds to HH:mm:ss
	vSec := 10921
	MsgBox, % Format("{:02}:{:02}:{:02}", Floor(vSec/3600), Floor(Mod(vSec, 3600)/60), Mod(vSec, 60)) ;03:02:01

	FormatTime(pTime) {
		;FormatTime, now,, yyyy-MM-ddTHH:mm:ss ;ISO 8601 format (2013-04-01T13:01:02)
		;FormatTime, now,, yyyy-MM-dd_HH:mm:ss
		;FormatTime, now,, yyyy-MM-dd-HH:mm:ss ; easy to read and type
		;FormatTime, now,, yyyyMMddHHmmss
		FormatTime, pTime,, HH:mm:ss
		Return pTime
	}

TreeView:

	;Although any length of text can be stored in each item of a TreeView, only the first 260 characters are displayed.

	TVLength:=TV_GetCount()
	
TrueFalse:

	The words true and false are built-in variables containing 1 and 0.
	True  = 1
	False = 0

Variadic_Params:

	;example from AHK Help doc
	JoinTEST(sep, params*) {

		;test if variadic is empty
		if (not params[1]) {
			SoundBeep
			ln := Exception("", -1).Line
			MsgBox 0, WARN - Empty Variadic, Function called from Line: %ln%`n`nPress OK to ExitApp
			Return
		}
		
		;show how a variadic is a simple array
		_d("Arrays []",, params[1], params[2], params[3])
		
		;alternate array reference
		_d("Arrays [n]",, params.1, params.2, params.3)

		;split
			for index,param in params
					str .= param . sep
			return SubStr(str, 1, -StrLen(sep))
	}
	MsgBox 0,Example from Help, % JoinTEST("`n", "one", "two", "three")

	;will MsgBox Variadic is Empty
	JoinTEST("")
	
Web:

	WinActivate, ahk_exe chrome.exe
	SendInput, ^l
	Sleep 500
	SendInput, www.apple.com{enter}

Windows_Gui:

	WinActivate, HPE Casper DC Bulk Submit (DCBS)
	WinActivate, ahk_id %hGui%
	WinActivate, % "ahk_id" hGui
	WinActivate, ahk_class IEFrame
	WinActivate, ahk_class Notepad++
	;NO WinActivate, ahk_exe iexplore.exe
	;NO WinActivate, "ahk_pid" hGui
	;ok WinActivate, WinActivate, ahk_class Chrome_WidgetWin_1
	if WinExist("Chrome Legacy Window") ;will find minimized window
			WinActivate			
	if WinExist("ahk_class Chrome_WidgetWin_1")
		WinActivate
	prev:=WinActive("A")
	WinGet hGui,ID,A ; Get ID from Active window.
	WinMaximize, %hwnd%
	WinMaximize, A
	WinSet, AlwaysOnTop, On, %hwnd%
	WinSet, AlwaysOnTop, Off, A
	WinSet, Style, -0xC40000, %hwnd%
	WinWaitActive, ahk_class Chrome_WidgetWin_1

	_WinRestoreIfMinimized(Title) {
		WinGet, OutputVar, MinMax, %Title%
		if (OutputVar!=0)
			WinRestore % "ahk_id" this.gui.hGui
	}
	
	_WinShowIfHidden(Title) {
		WinGet,Style,Style, %Title%
		if (Style & 0x10000000) { ;WS_VISIBLE
			;Return True ; window is visible
		}
		WinShow %Title%
		;return False ; windows is not visible (hidden)
	}
