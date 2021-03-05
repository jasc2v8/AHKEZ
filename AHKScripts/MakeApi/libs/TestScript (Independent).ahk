 #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

;#Include <AHKLX_LIB>

FileAppend(Text = "", Filename = "", Encoding = "") {
	FileAppend, %Text%, %Filename%, %Encoding%
} ; FileAppend(Text, Filename) ; FileAppend("v=" v, Filename)

FileCopy(SourcePattern = "", DestPattern = "", Overwrite = "-Overwrite") {
	Overwrite := Overwrite = "-Overwrite" ? 0 : 1
	FileCopy, %SourcePattern%, %DestPattern%, %Overwrite%
}

FileCopyDir(Source = "", Dest = "", Overwrite = "-Overwrite") {
	Overwrite := Overwrite = "-Overwrite" ? 0 : 1
	FileCopyDir, %Source%, %Dest%, %Overwrite%	
}

FileCreateDir(DirName = "") {
	FileCreateDir, %DirName%
}

FileDelete(FilePattern = "") {
	FileDelete, %FilePattern%
} ; FileDelete(FilePattern) ; FileDelete("f.tmp") ; FileDelete("*.tmp")  ; FileDelete(A_ScriptDir "\*.tmp") ; Loop, 10 {	FileAppend("TMP", "File_" A_Index ".tmp") } FileDelete(A_ScriptDir "\*.tmp")

v := "The rain in Spain"
File := "Test_File.txt"
FileDelete(File)
FileAppend(v, File)
MsgBox %v%
Return

Escape::
ExitApp
