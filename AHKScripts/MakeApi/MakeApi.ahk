/*

https://www.autohotkey.com/boards/viewtopic.php?t=49374

======================================================================================================================
Name:						MakeApi.ahk
Description:		Scans a script file for function declarations then outputs an API and Index
								In:		AHKEZ.ahk
								Out:	AHKEZ_API.ahk and AHKEZ_API_Index.ahk
LIB dependency:	AHKEZ
Script version:	0.1.00/2021-03-05/jasc2v8
AHK version:		AHKL v1.1.33.02 (U64)
Credits:
Notes:

	Example function declaration in script:
		FileRename(SourcePattern = "", DestPattern = "", Overwrite = "-Overwrite") {
			FileMove(SourcePattern, DestPattern, Overwrite)
		}

	Example API output:
		FileRename(SourcePattern = "", DestPattern = "", Overwrite = "-Overwrite")

	Example Index output:
		FileRename()

Legal: Dedicated to the public domain without warranty or liability (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
======================================================================================================================	
*/
#SingleInstance, Force
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
;===========================
;
#Include <AHKEZ>

Global FileBuffer, ApiBuffer, IndexBuffer

BW := 80
EW := 560
GuiTitle := "Make API"
DefaultRootDir:=JoinPath(A_MyDocuments, "Autohotkey\Lib\AHKEZ.ahk")
DefaultFilter:="AHK Files (*.ahk)"
hGui 				:=	Gui("New", "+Resize")
								Gui("Font","s12", "Consolas")
hLbl1 			:=	Gui("Add", "Text", "w" EW "h30", "Select Script:")
hEdtSelFile	:=	Gui("Add", "Edit", "vSelectedFile	x16 y38 w" EW "h30", DefaultRootDir)
hBtnBrowse	:= 	Gui("Add", "Button", "x+m w70 h30", "Browse")
hEdtMemo				:=	Gui("Add", "Edit", "xm w" EW "r10")
hBtnClear		:=	Gui("Add", "Button", "xm y+m w100", "Clear")
hBtnIndex		:=	Gui("Add", "Button", "x+m w" BW, "Index")
hBtnAPI			:=	Gui("Add", "Button", "x+m w" BW, "API")
hBtnStart		:=	Gui("Add", "Button", "x+m w" BW,	"START")
hBtnCancel	:=	Gui("Add", "Button", "x+m w" BW, "Cancel")
								Gui("Show", "Autosize", GuiTitle)
ControlSelect(hBtnStart)
Return

GuiSize:
;Return
	BM := 45
  GUIControl("MoveDraw", hEdtMemo,    		"w" A_GUIWidth  - 35 "h" A_GUIHeight - 135)
  GUIControl("MoveDraw", hEdtSelFile,    	"w" A_GUIWidth  - 105)
	GUIControl("MoveDraw", hBtnBrowse,			"x" A_GUIWidth  - 80)
  GUIControl("MoveDraw", hBtnClear,			 	"y" A_GUIHeight - BM)
  GUIControl("MoveDraw", hBtnIndex,			 	"y" A_GUIHeight - BM)
  GUIControl("MoveDraw", hBtnAPI,					"y" A_GUIHeight - BM)
  GUIControl("MoveDraw", hBtnStart,   		"y" A_GUIHeight - BM)
  GUIControl("MoveDraw", hBtnCancel,			"y" A_GUIHeight - BM)
Return

ButtonStart:
	Gui("Submit", "NoHide")
	;SelectedFile := Edit1 vSelectedFile 
	
	If (!FileExist(SelectedFile))
	{
		EditAppend(hEdtMemo, "FILE_NOT_FOUND: " SelectedFile)
		Return
	}

	FileBuffer := FileRead(SelectedFile)
	
	if (ErrorLevel)
	{	
		EditAppend(hEdtMemo, "READ_ERROR: " SelectedFile)
		Return
	}

	StartTick := A_TickCount
	EditAppend(hEdtMemo, "Start     : " FormatTime(A_Now,"yyyy-MM-dd_HH:mm:ss"))

	Gosub ScanFile
	Gosub WriteFiles
	
	ElapsedTick := A_TickCount - StartTick
	EditAppend(hEdtMemo, "Finish    : " FormatTime(A_Now,"yyyy-MM-dd_HH:mm:ss"))
	EditAppend(hEdtMemo, "Elapsed   : " ElapsedTick "ms")
Return

ButtonBrowse:
	Gui, Submit, NoHide
	;note that SelectedFile := Edit1 vSelectedFile 
	RootDir := SelectedFile
	Prompt:="Select file"
	Filter:=DefaultFilter
	SelectedFile := FileSelectFile(RootDir, Prompt, Filter)
	if (SelectedFile = "") {
		EditAppend(hEdtMemo, "No file selected.")
		Return
	}
	ControlSetText(hEdit1, SelectedFile)
Return

ButtonIndex:
	Gui, Submit, NoHide
	;Note SelectedFile := Edit1
	if FileExist(IndexFilename)
		Run, edit %IndexFilename%	
		;only if .txt Run(IndexFilename)
Return

ButtonAPI:
	Gui, Submit, NoHide
	;Note SelectedFile := Edit1
	if FileExist(ApiFilename)
		Run, edit %ApiFilename%
		;only if .txt Run(ApiFilename)
Return

ButtonClear:
	LineCount := 0
	EditClear(hEdtMemo)
Return

ButtonCancel:
Escape::
GuiEscape:
GuiClose:
Gui, Destroy
ExitApp

ScanFile:

	ApiBuffer := ""
	IndexBuffer := ""
	CommentSection := False
	IsBlock := False

	;NextLineArray is used to check if the next line starts with an AHK function block "{"
	NextLineArray := []
	Loop, Parse, FileBuffer, `n, `r%A_Space%%A_Tab%
	{
		if (A_Index > 1)
			NextLineArray[A_Index-1] := SubStr(A_LoopField, 1, 1)
	}

	;OmitChars %A_Space%%A_Tab% will be removed from the beginning and end (but not the middle) of A_LoopField
	Loop, Parse, FileBuffer, `n, `r%A_Space%%A_Tab%
	{	
	
		if IsEmpty(A_LoopField)
			Continue
			
		if StrStartsWith(A_LoopField, ";") 
			Continue

		;Parse will strip NL chars so add them back below, except lines to be joined
		Line := ReplaceWhiteSpaceWithA_Space(A_LoopField)
		Line := RemoveComment(Line)

		;Function()
		;if function definition then must contain { on this line (OTB) or next line (AHK)
		;https://regex101.com/r/jvWtxw/1
		;Needle_Function_With_Params := "S)(*UCP)^\s*([\w$#@]+\(.*\))"
		Needle_Function_With_Params := "S)(*UCP)^\s*([\w$#@]+\(.*\))"
		if RegExMatch(Line, Needle_Function_With_Params, Match) {
			if StrEndsWith(Line, "{") Or (NextLineIsBlock) {
				ApiBuffer   .= Match1 . NL
				IndexBuffer .= RemoveParamsAndComment(Match1) . NL
				Continue
			}
		}

	} ;End_Loop_Parse_FileBuffer
	
Return ;End_ScanFile_Loop

WriteFiles:

	Sort(ApBuffer)
	ApiFilename := SplitPath(SelectedFile).NameNoExt "_API.ahk"
	FileWrite(ApiBuffer, ApiFilename, True)
	EditAppend(hEdtMemo, "API File  : " ApiFilename)

	Sort(IndexBuffer)
	IndexFilename := SplitPath(SelectedFile).NameNoExt "_API_Index.ahk"
	FileWrite(IndexBuffer, IndexFilename, True)
	EditAppend(hEdtMemo, "Index File: " IndexFilename)

Return

	RemoveComment(Haystack) {
		;AutoHotkey sees comments as a semicolon preceded by a space or tab
		Needle := "[ `t]+;.*"
		Return RegExReplace(Haystack, Needle)
	}

	RemoveParamsAndComment(pText) {
		if Instr(pText, "(")
			pText := SubStr(pText, 1, InStr(pText, "(")) . ")"
		Return pText
	}
	
	ReplaceWhiteSpaceWithA_Space(Haystack) {
		;replace all spaces and tabs with a single space
		Return RegExReplace(Haystack, "[ \t]+", A_Space)
	}
