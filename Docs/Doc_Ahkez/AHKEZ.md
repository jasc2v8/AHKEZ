
<!-- reminder: replace = "" with = \"\" -->

---
title: AHKEZ
author: jasc2v8
date: March 5th, 2021
---

# TOC

The table of contents is listed above.

# Quick Reference

This doc is for the additional Functions included in the AHKEZ.ahk library.  
For all AHK built-in commands and functions see the [AutoHotkey Quick Reference](https://www.autohotkey.com/docs/AutoHotkey.htm)

[AutoHotkey EZ ](https://github.com/jasc2v8/AHKEZ) is a free and open source version of [AHK_L_v1.1.33.02](https://github.com/AutoHotkey/AutoHotkey) 

License: Dedicated to the public domain without warranty or liability [(CC0 1.0)](http://creativecommons.org/publicdomain/zero/1.0/)

**Doc Conventions**
~ ControlID is the HWND of a control e.g. hBtnOK
~ WindowID &nbsp;is the HWND of a window &nbsp;e.g. hMainGui

*([TOC])*

# Ahk\[Class|Exe|Group|Id|Pid\]

Returns the \"ahk_type\" WinTitle:

<p style="padding:0.5em;background-color:#ffffaa;">
	AhkClass(p), AhkExe(p), AhkGroup(p), AhkId(p), AhkPid(p)
</p>

## Parameters {.unlisted .unnumbered}

### p = [WinTitle](https://www.autohotkey.com/docs/misc/WinTitle.htm) {.unlisted .unnumbered}

## Returns {.unlisted .unnumbered}

-----------   ---------
\"ahk_class\"   WinTitle  
\"ahk_exe\"     WinTitle  
\"ahk_group\"   WinTitle  
\"ahk_id\"      WinTitle  
\"ahk_pid\"     WinTitle  
-----------   ---------

## Remarks {.unlisted .unnumbered}

Helper function - Instead of:
  ~ ahk_id %MyTitle% or % \"ahk_id\" WinTitle  

Use:
  ~ AhkId(MyTitle)

## Examples {.unlisted .unnumbered}
	AHK_L: Control, %SubCommand%, %Value%, %Control%, ahk_id %WinTitle%
	 AHKEZ: Control("SubCommand", "Value", "Control", AhkId("MyWinTitle"))

*([TOC])*

# ControlSelect

Selects a control

<p style="padding:0.5em;background-color:#ffffaa;">
	ControlSelect(ControlID, WindowID = \"\") 
</p>

## Parameters {.unlisted .unnumbered}

### ControlID {.unlisted .unnumbered}

> ControlID is the HWND of a control e.g. hBtnOK

### WindowID {.unlisted .unnumbered}

> WindowID is the HWND of a window e.g. hMainGui

## Returns {.unlisted .unnumbered}

> The control is selected

## Remarks {.unlisted .unnumbered}

If the WindowID is empty, the ancestor window of the ControlID will be used.

## Examples {.unlisted .unnumbered}
	AHK_L: PostMessage, WM_NEXTDLGCTL:=0x0028, %hBtnOK%, 1, , ahk_id %hMainGui% 
	 AHKEZ: ControlSelect(hBtnOK, hMainGui)

*([TOC])*

# Edit Functions

These functions set or return the text in an Edit control.  

<p style="padding:0.5em;background-color:#ffffaa;">
EditAppend(ControlID, String = \"\")  
EditClear(ControlID)  
EditGetCurrentCol(ControlID)  
EditGetCurrentLine(ControlID)  
EditGetLineCount(ControlID)  
EditGetText(ControlID)  
EditGetSelectedText(ControlID)  
EditPaste(ControlID, String = \"\")  
EditSetText(ControlID, NewText = \"\")
</p>

EditAppend - appends text at caret position **with** a CRLF (\`r\`n)  
EditClear - clears the text  
EditGetCurrentCol - gets the current column number  
EditGetCurrentLine - gets the current line number  
EditGetLineCount - gets the line count number  
EditGetText - gets all the text  
EditGetSelectedText - gets selected text  
EditPaste - paste text at caret position **without** a CRLF  
EditSetText - sets all the text **without** a CRLF  

## Parameters {.unlisted .unnumbered}

### ControlID {.unlisted .unnumbered}

> Type: Integer  
>
> The ControlID is the HWND of a control e.g. hBtnOK

## Return Value {.unlisted .unnumbered}

>	Type: String or Integer
>
>	The returned string might end in a carriage return (\`r) or a carriage return + linefeed (\`r\`n).

## Remarks {.unlisted .unnumbered}

The ControlID is set with a Gui(\"New\") or Gui(\"Add\") function.  
The ControlID is found using WinGet(,\"MyTitle\").

## Examples {.unlisted .unnumbered}

#1: Using the ControlID

	AHK_L: Control, EditPaste, %String%, , ahk_id %hEditMemo%
	 AHKEZ: EditPaste(hEditMemo, "String")

#1: Using AhkId() to get the ControlID from the ClassNN

	AHK_L: Control, EditPaste, %String%, ahk_class Edit1, ahk_id %hEditMemo%
	 AHKEZ: EditPaste(AhkId("Edit1"), "String")

*([TOC])*

# FileWrite

Writes text to a file with option to overwrite.  

<p style="padding:0.5em;background-color:#ffffaa;">
FileWrite(Text = \"\", Filename = \"\", Overwrite = 0, Encoding = \"\")
</p>

## Parameters {.unlisted .unnumbered}

### Text {.unlisted .unnumbered}

> Type: String  
>
> The string to be written to the Filename.

### Filename {.unlisted .unnumbered}

> Type: String  
>
> The Filename to write the string to.

### Overwrite {.unlisted .unnumbered}

> Type: Boolean or Integer  
>
> True = 1 = Overwrite, False = 0 = No Overwrite

### Encoding {.unlisted .unnumbered}

> Type: String  
>
> Overrides the default encoding set by [FileEncoding](https://www.autohotkey.com/docs/commands/FileEncoding.htm), where Encoding follows the same format.

## Return Value {.unlisted .unnumbered}

>	Type: String or Integer
>
>	ErrorLevel is set to 1 if there was a problem or 0 otherwise.  
A_LastError is set to the result of the operating system's GetLastError() function.

## Remarks {.unlisted .unnumbered}

Function wrapper for [FileDelete](https://www.autohotkey.com/docs/commands/FileDelete.htm) and [FileAppend](https://www.autohotkey.com/docs/commands/FileAppend.htm)

## Examples {.unlisted .unnumbered}

	AHK_L: FileDelete, %FileName%
	 AHK_L: FileAppend, %String%, %FileName%, 1
	 
	 AHKEZ: FileWrite(String, FileName, 1)

*([TOC])*

# Gui

Creates and manages windows and controls. 

<p style="padding:0.5em;background-color:#ffffaa;">
Gui(SubCommand = \"New\", Value1 = \"\", Value2 = \"\", Value3 = \"\") 
</p>

## Return Value {.unlisted .unnumbered}

> Type: Integer  
>
> The WindowID of the Control or Gui is returned for \"New\", \"Add\", and \"Show\" SubCommands.

## Remarks {.unlisted .unnumbered}

Implementation of [Gui](https://www.autohotkey.com/docs/commands/Gui.htm)

AHK_L returns the Control or Gui ID with the \"+HWND\" option.  

AHKEZ doesn't support this option, instead the HWND is obtains as follows:  

		hGui := Gui("New"...)  
		 hControl := Gui("Add", Control...)  
		 hGui := Gui("Show"...)  ; in case the "New" SubCommand is not present  

## Examples {.unlisted .unnumbered}

	AHK_L:

		Gui, New, +HWNDhGuiA, MyTitle
		MsgBox % "HWNDhGui = " hGuiA
		Gui, Destroy

	 AHKEZ:
	 
		hGuiB := Gui("New", , "MyTitle")
		MsgBox % "HWNDhGui = " hGuiB

*([TOC])*

# Is Functions

These functions test a variable and return True or False.

<p style="padding:0.5em;background-color:#ffffaa;">
IsBlank(var)  
IsEmpty(var)  
IsType(ByRef var, type)
</p>

IsBlank - Returns True if var is A_Space or A_Tab, else False.  
IsEmpty - Returns True if var is "", else False.   
IsType - Returns True if var is type, else False.  

## Parameters {.unlisted .unnumbered}

### var {.unlisted .unnumbered}

> Type: Variable  
>
> The ControlID is the HWND of a control e.g. hBtnOK

### type {.unlisted .unnumbered}

> Type: String  
>
> One of the following in quotes: integer, float, number, digit, xdigit, alpha, upper, lower, alnum, space, time, string, object.
>
>Added for AHKEZ is type \"string\" and \"object\".

## Return Value {.unlisted .unnumbered}

> Type: Boolean or Integer  
>
> True = 1, False = 0

## Remarks {.unlisted .unnumbered}

Function wrapper for [IfIs](https://www.autohotkey.com/docs/commands/IfIs.htm)  

## Examples {.unlisted .unnumbered}

	AHK_L:

		If var is integer  
			MsgBox, %var% is an integer

	 AHKEZ:

		If IsBlank(MyVar, "A_Space")  
			MsgBox("is blank")

		If IsEmpty(MyVar, "")  
			MsgBox("is empty")

		If IsType(MyVar, "integer")  
			MsgBox("is integer")

		If IsType(MyVar, "string")  
			MsgBox("is string")

*([TOC])*

# Join

Concatenates strings together, or multiples of the same string.

<p style="padding:0.5em;background-color:#ffffaa;">
Join(Separator, Params*) 
</p>

## Parameters {.unlisted .unnumbered}

### Separator {.unlisted .unnumbered}

> Type: Integer or String  
>
> If Integer, the number of times to concatenate Params*
>
> If String, the separator used to concatenate Params*

### Params* {.unlisted .unnumbered}

> Type: Variadic comma separated variables.  
>
> One or more Variables to concatenate.

## Return Value {.unlisted .unnumbered}

> Type: String 
>
> The String and Separator concatenated together.

## Remarks {.unlisted .unnumbered}

Params* = [Variadic variables](https://www.autohotkey.com/docs/Functions.htm#Variadic)  

## Examples {.unlisted .unnumbered}

	AHK_L:

		If var is integer  
			MsgBox, %var% is an integer

	 AHKEZ:

		v := Join(3, A_Space)
			MsgBox(">" v "<") ; 3 spaces

		v := Join(A_Space, "The", "cold", "rain.")
			MsgBox(v) ; "The cold rain."

		v := Join(":", "The result is ", 3.14)
			MsgBox(var) ; "The result is: 3.14"

		v := Join(":", "The result is ", MyValue := -3.14)
		 MsgBox(var) ; "The result is: -3.14"
		

*([TOC])*

# JoinPath

Concatenates Dir and File, fixing directory separator if necessary. 

<p style="padding:0.5em;background-color:#ffffaa;">
JoinPath(Dir, File)
</p>

## Parameters {.unlisted .unnumbered}

### Dir {.unlisted .unnumbered}

> Type: String  
>
> The directory with or without the ending directory separator \"\\\"

### File {.unlisted .unnumbered}

> Type: String  
>
> The filename to concatenate with the Dir.

## Return Value {.unlisted .unnumbered}

> Type: String
>
> The concatenated Dir and File.

## Remarks {.unlisted .unnumbered}

Note the AHKEZ examples below with minimal confusion of var or %var%

## Examples {.unlisted .unnumbered}

	AHK_L:

		f := A_WinDir "\System32\shell32.dll"
		FileGetAttrib, v, %f%
			MsgBox, %v%

		FileGetAttrib, v, % A_WinDir "\System32\shell32.dll"
			MsgBox, %v%

	 AHKEZ:

		v := A_WinDir "\System32\shell32.dll"
			MsgBox(v)

		attrib := FileGetAttrib(v)
			MsgBox(attrib)

		MsgBox(FileGetAttrib(JoinPath(A_WinDir, "\System32\shell32.dll")))

*([TOC])*

# MsgBox [MB]

MB is an abbreviation for MsgBox(). 

<p style="padding:0.5em;background-color:#ffffaa;">
MB(Options = \"\", Title = \"\", Text = \"\", Timeout = \"\")  
MsgBox(Options = \"\", Title = \"\", Text = \"\", Timeout = \"\")
</p>

## Remarks {.unlisted .unnumbered}

Function wrapper for [MsgBox](https://www.autohotkey.com/docs/commands/MsgBox.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		MsgBox, The result is: %v%

		MsgBox, % "The result is:" v

	 AHKEZ:

		MB("The result is:" v)  
		
		MsgBox("The result is:" v)

*([TOC])*

# SetTitleMatchMode

Sets the matching behavior of the WinTitle parameter in Win commands.

<p style="padding:0.5em;background-color:#ffffaa;">
SetTitleMatchMode(MatchMode = \"\", Speed = \"\")
</p>

## Parameters {.unlisted .unnumbered}

### MatchMode {.unlisted .unnumbered}

> Type: Integer or String  
>
> \"Starts\" or 1 (Default)    
> \"Contains\" or 2  
> \"Exact\" or 3  

### MatchMode {.unlisted .unnumbered}

> Type: Integer or String  
>
> \"Fast\" (Default)  
> \"Slow\"  

## Remarks {.unlisted .unnumbered}

Function wrapper for [SetTitleMatchMode](https://www.autohotkey.com/docs/commands/SetTitleMatchMode.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		SetTitleMatchMode, 3
		
		SetTitleMatchMode, Fast

	 AHKEZ:

		SetTitleMatchMode(3, "Fast")  
		
		SetTitleMatchMode("Exact", "Fast")

# SplitPath

Separates a file name or URL into its name, directory, extension, and drive.

<p style="padding:0.5em;background-color:#ffffaa;">
SplitPath(Path = \"\")
</p>

## Parameters {.unlisted .unnumbered}

### Path {.unlisted .unnumbered}

> Type: String  
>
> The path to split.

## Return Value {.unlisted .unnumbered}

> Type: Object  
>
> Obj.FileName  
> Obj.Dir  
> Obj.Extension  
> Obj.NameNoExt  
> Obj.Drive

## Remarks {.unlisted .unnumbered}

Function wrapper for [SplitPath](https://www.autohotkey.com/docs/commands/SplitPath.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		FullFileName := "C:\My Documents\Address List.txt"  
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
   
		; The above will set the variables as follows:  
		; name = Address List.txt  
		; dir = C:\My Documents  
		; ext = txt  
		; name_no_ext = Address List  
		; drive = C:

	 AHKEZ:
	
		Obj := SplitPath(FullFileName)  
		MsgBox(Obj.FileName)  
		
		v := SplitPath(FullFileName).FileName  
		MsgBox("FileName: " v)
		
		MsgBox(SplitPath(JoinPath(A_WinDir, "\System32\shell32.dll")).FileName)

*([TOC])*

# StrContains

Searches for a given occurrence of a string, from the left or the right.

<p style="padding:0.5em;background-color:#ffffaa;">
StrContains(Haystack, Needle, CaseSensitive = false, StartingPos = 1, Occurrence = 1)
</p>

## Return Value {.unlisted .unnumbered}

> Type: Boolean or Integer  
>
> True = 1 if Haystack contains Needle, else False = 0

## Remarks {.unlisted .unnumbered}

Function wrapper for [InStr](https://www.autohotkey.com/docs/commands/InStr.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		MsgBox % InStr("123abc789", "abc") ; Returns 4

	 AHKEZ:
	
		MsgBox(StrContains("123abc789", "abc")) ; Returns True = 1
		MsgBox(StrContains("123abc789", "def")) ; Returns False = 0

*([TOC])*

# StrDeRef

Expands variable references and escape sequences contained inside other variables. 

<p style="padding:0.5em;background-color:#ffffaa;">
StrDeRef(String)
</p>

## Remarks {.unlisted .unnumbered}

Implementation of [ExDeref](https://www.autohotkey.com/docs/commands/RegExMatch.htm#ExDeref)

## Examples {.unlisted .unnumbered}

	AHK_L:

		var1 := "abc"
		var2 := 123
		MsgBox % StrDeref("%var1%def%var2%")  ; Reports abcdef123

	 AHKEZ:
	 
		MsgBox(StrDeref("%var1%def%var2%"))  ; Reports abcdef123

*([TOC])*

# StrEndsWith

Searches for a given occurrence of a string, from the right to the left.

<p style="padding:0.5em;background-color:#ffffaa;">
StrEndsWith(Haystack, Needle, CaseSensitive := False, Occurrence = 1)
</p>

## Return Value {.unlisted .unnumbered}

> Type: Boolean or Integer  
>
> True = 1 if Needle matches end of Haystack, else False = 0

## Remarks {.unlisted .unnumbered}

Implementation of [SubStr](https://www.autohotkey.com/docs/commands/SubStr.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		String := "The Quick Brown Fox Jumps Over the Lazy Dog"
		MsgBox % SubStr(String, -7)  ; Returns "Lazy Dog"

	 AHKEZ:
	 
		MsgBox(StrEndsWith(String, "Lazy Dog"))  ; Reports True = 1

*([TOC])*

# StrsStartsWith

Searches for a given occurrence of a string, from the left to the right.

<p style="padding:0.5em;background-color:#ffffaa;">
StrStartsWith(Haystack, Needle, CaseSensitive := False, Occurrence = 1)
</p>

## Return Value {.unlisted .unnumbered}

> Type: Boolean or Integer  
>
> True = 1 if Needle matches the start of Haystack, else False = 0

## Remarks {.unlisted .unnumbered}

Implementation of [InStr](https://www.autohotkey.com/docs/commands/InStr.htm)

## Examples {.unlisted .unnumbered}

	AHK_L:

		String := "The Quick Brown Fox Jumps Over the Lazy Dog"
		MsgBox % InStr(String, "The Quick") ; Returns 1

	 AHKEZ:
	 
		MsgBox(StrStartsWith(String, "The Quick")) ; Reports True = 1

*([TOC])*

# Donations

[![Donate](https://img.shields.io/badge/Buy_me_a_cup_of_Coffee-PayPal-red.svg)](https://www.paypal.me/JimDreherHome)

If AHKEZ helps you in some way, then please buy me a cup of coffee by clicking on the donation button above. Thank you.

*([TOC])*
