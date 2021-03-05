/*

https://www.autohotkey.com/boards/viewtopic.php?t=49374

======================================================================================================================
Name:						MakeApi.ahk
Description:		Scans a script file for function declarations then outputs an API and Index
								In:		AHKEZ.ahk
								Out:	AHKEZ_API.ahk, AHKEZ_API_Index.ahk
AHK version:		AHKL v1.1.33.02 (U64)
LIB dependency:	AHKEZ
Script version:	0.1.00/2021-02-13/jasc2v8
	0.0.00/Initial release
Credits:
Notes:

	Example function declaration in script:
		FileRename(SourcePattern = "", DestPattern = "", Overwrite = "-Overwrite") {
			FileMove(SourcePattern, DestPattern, Overwrite)
		} ; FileRename(OldName, NewName, "Overwrite")

	Example API output:
		FileRename(SourcePattern = "", DestPattern = "", Overwrite = "-Overwrite") {
			; FileRename(OldName, NewName, "Overwrite")

Legal: Dedicated to the public domain without warranty (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
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
#Include <AHKEZ_Debug>
;
;** globals
;
Global hGui, hEdit, EditText
;Global EditText
Global FileBuffer
Global ApiBuffer
Global IndexBuffer
Global LineCount := 0
Global SelectedFile
;
GuiNew:
;
GuiTitle := "Make API"
DefaultRootDir:=JoinPath(A_MyDocuments, "Autohotkey\Lib\AHKEZ.ahk")
DefaultFilter:="AHK Files (*.ahk)"
hGui 				:=	Gui("New", "-Resize -MaximizeBox")
								Gui("Font","s12 Norm cBlack", "Consolas")
;hBtnDummy		:=	Gui("Add", "Button", "w0 h0", "Dummy")
hLbl1 			:=	Gui("Add", "Text", "x16 y8 w829 h30", "Select Script:")
hEdit1 			:=	Gui("Add", "Edit", "vSelectedFile	x16 y38 w829 h30", DefaultRootDir) ;Edit1
hBtnBrowse	:= 	Gui("Add", "Button", "x856 y38 w100 h30",	"Browse")
hMemo				:=	Gui("Add", "Edit", "vEditText x16 y80 w940 h340	+Multi") ;Edit2  -Wrap +HScroll 
hBtnClear		:=	Gui("Add", "Button", "x16 y432 w100 h30", "Clear")
hBtnIndex		:=	Gui("Add", "Button", "x128 y432 w96 h30", "Index")
hBtnAPI			:=	Gui("Add", "Button", "x238 y432 w96 h30", "API")
hBtnStart		:=	Gui("Add", "Button", "x744 y432 w100 h30",	"START")
hBtnCancel	:=	Gui("Add", "Button", "x856 y432 w100 h30", "Cancel")
								Gui("Show", "w970 h480", "GuiTitle")

; 	hWndParent := DllCall("user32\GetAncestor", Ptr,hCtl, UInt,1, Ptr) ;GA_PARENT := 1
; 	hWndRoot := DllCall("user32\GetAncestor", Ptr,hCtl, UInt,2, Ptr) ;GA_ROOT := 2
; 	hWndOwner := DllCall("user32\GetWindow", Ptr,hCtl, UInt,4, Ptr) ;GW_OWNER = 4
; ;ListVars(1,"handles", hGui, hBtnStart, hWnd)
; ;MB(0,"hGui",hGui)
;HWND := DllCall("user32\GetAncestor", Ptr,hBtnStart, UInt,1, Ptr) ;GA_PARENT := 1
;SendMessage, 0x0028, %hBtnStart%, 1, , ahk_id %HWND% ;WM_NEXTDLGCTL=0x0028
;ControlSelect(hBtnStart, hgui)

ControlSelect(hBtnStart)

Return

ButtonStart:
	Gui("Submit", "NoHide")
	;SelectedFile := Edit1 vSelectedFile 
	
	If (!FileExist(SelectedFile))
	{
		EditAppend("FILE_NOT_FOUND: " SelectedFile, hMemo)
		Return
	}

	FileBuffer := FileRead(SelectedFile)
	
	if (ErrorLevel)
	{	
		EditAppend("READ_ERROR: " SelectedFile, hMemo)
		Return
	}

	StartTick := A_TickCount
	EditAppend("Start     : " FormatTime(A_Now,"yyyy-MM-dd_HH:mm:ss"), hMemo)

	Gosub ScanFile
	Gosub WriteFiles
	
	ElapsedTick := A_TickCount - StartTick
	EditAppend("Finish    : " FormatTime(A_Now,"yyyy-MM-dd_HH:mm:ss"), hMemo)
	EditAppend("Elapsed   : " ElapsedTick "ms", hMemo)
Return

ButtonBrowse:
	Gui, Submit, NoHide
	;note that SelectedFile := Edit1 vSelectedFile 
	RootDir := SelectedFile
	Prompt:="Select file"
	Filter:=DefaultFilter
	SelectedFile := FileSelectFile(RootDir, Prompt, Filter)
	if (SelectedFile = "") {
		EditAppend("No file selected.", hMemo)
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
	EditClear(hMemo)
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
	
		;Parse will strip NL chars so add them back below, except lines to be joined
		Line := ReplaceWhiteSpaceWithA_Space(A_LoopField)
					
		if StrIsEmpty(Line)
			Continue
			
		if StrStartsWith(Line, "/*") {
			CommentSection := True
			if StrStartsWith(Line, "/**") {
				DocCommentSection := True
				ApiBuffer .= line . NL
			}		
			Continue
		}
				
		if StrStartsWith(Line, "*/") {
			CommentSection := False		
			if (DocCommentSection) {
				DocCommentSection := False
				ApiBuffer .= line . NL
			}
 			Continue
		}

		;save DocComments
		if (DocCommentSection) {
			ApiBuffer .= line . NL				
			Continue
		}
		
		; skip comment section
		if (CommentSection) {
			Continue
		}
		
		;	Save one-liner DocComment
		if StrStartsWith(Line, ";**") {
			ApiBuffer .= line  . NL
			Continue
		}

		;	Skip comments
		if StrStartsWith(Line, ";") 
			Continue

		;iterate through the previously flagged block
		;this must appear before the function detect sections below
		;this algorithm allows braces in the function block end comment
		if (IsBlock) {		
			if StrContains(Line, "}") and StrContains(Line, "{") {
				BraceCount += 0
			} else if StrContains(Line, "{") {
				BraceCount += 1
			} else if StrContains(Line, "}") {
				BraceCount -= 1
			}
			if (BraceCount = 0) {
				IsBlock := False
				pos := InStr(Line, ";")
				if (pos) {
					doc_comment := Trim( SubStr(Line, pos) )
					if (doc_comment) {
						ApiBuffer   .= A_Space . doc_comment
						IndexBuffer .= A_Space . doc_comment
					}
				}
				ApiBuffer   .= NL
				IndexBuffer .= NL
			}
			Continue
		}
		
		;Function()
		;if function definition then must contain { on this line (OTB) or next line (AHK)
		;https://regex101.com/r/jvWtxw/1
		Needle_Function_With_Params := "S)(*UCP)^\s*([\w$#@]+\(.*\))"
		if RegExMatch(Line, Needle_Function_With_Params, Match) {
			if StrEndsWith(Line, "{") Or (NextLineIsBlock) {
				ApiBuffer   .= Match1
				IndexBuffer .= Match1
				IsBlock := True
				if (NextLineIsBlock) {
					BraceCount := 0
				} else {
					BraceCount := 1
				}
				Continue
			}
		}

	} ;End_Loop_Parse_FileBuffer
	
	;split the function and comment
	;Write the function first, then the comment on the next line
	ApiOutBuffer := ""
	Loop, Parse, ApiBuffer, `n, `r
	{
		pos := InStr(A_LoopField, ";")
		if (pos = 0) {
			ApiOutBuffer .= A_LoopField . NL			
		} else {
			function := SubStr(A_LoopField, 1, pos-1)
			comment  := SubStr(A_LoopField, pos-1)
			ApiOutBuffer .= function . NL
			ApiOutBuffer .= comment . NL
		}
	}
Return ;End_ScanFile_Loop

WriteFiles:
	;TimeStamp := FormatTime(now,"yyyyMMdd_HHmmss")
	;ApiFilename := SplitPath(SelectedFile).OutNameNoExt "_" TimeStamp "_Doc.ahk"
	ApiFilename := SplitPath(SelectedFile).NameNoExt "_API.ahk"
	FileWrite(ApiOutBuffer, ApiFilename)
	EditAppend("API File  : " ApiFilename, hMemo)

	Sort(IndexBuffer)

	;IndexFilename := SplitPath(SelectedFile).OutNameNoExt "_" TimeStamp "_API_Index.ahk"
	IndexFilename := SplitPath(SelectedFile).NameNoExt "_API_Index.ahk"
	FileWrite(IndexBuffer, IndexFilename)
	EditAppend("Index File: " IndexFilename, hMemo)
Return

ReplaceWhiteSpaceWithA_Space(Haystack) {
	;replace all spaces and tabs with a single space
	Return RegExReplace(Haystack, "[ \t]+", A_Space)
}

