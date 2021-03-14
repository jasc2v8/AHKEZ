#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force

; ** Start Auto-execute Section

#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

/*
Three versions off a SplitPath MyFunction
AHKEZ will use the SplitPathObj version
*/

SplitPathObj_TEST(File = "") {
	SplitPath, File, FileName, Dir, Ext, NameNoExt, Drive
	Return ({"FileName": FileName, "Dir": Dir, "Ext": Ext, "NameNoExt": NameNoExt, "Drive": Drive})
} ; SplitPathObj(Filename).NameNoExt

SplitPathArray_TEST(InputVar) {
  v := []
	;SplitPath, SelectedFile , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	SplitPath, InputVar , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	v["OutFileName"]	:= OutFileName
	v["OutDir"]				:= OutDir
	v["OutExtension"]	:= OutExtension
	v["OutNameNoExt"]	:= OutNameNoExt
	v["OutDrive"]			:= OutDrive
	Return v
}

SplitPath_TEST(ByRef InputVar, ByRef OutFileName = "", ByRef OutDir = "", ByRef OutExtension = "", ByRef OutNameNoExt = "", ByRef OutDrive = "") {
	SplitPath, InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
}

path := "C:\Windows\System32\shell32.dll"

T.Assert(A_ScriptName, A_Linenumber, SplitPathObj_TEST(path).Filename, "shell32.dll")
T.Assert(A_ScriptName, A_Linenumber, SplitPathObj_TEST(path).Dir, "C:\Windows\System32")
T.Assert(A_ScriptName, A_Linenumber, SplitPathObj_TEST(path).Ext, "dll")
T.Assert(A_ScriptName, A_Linenumber, SplitPathObj_TEST(path).NameNoExt, "shell32")
T.Assert(A_ScriptName, A_Linenumber, SplitPathObj_TEST(path).Drive, "C:")

v := SplitPathObj_TEST(path)

T.Assert(A_ScriptName, A_Linenumber, v.Filename, "shell32.dll")
T.Assert(A_ScriptName, A_Linenumber, v.Dir, "C:\Windows\System32")
T.Assert(A_ScriptName, A_Linenumber, v.Ext, "dll")
T.Assert(A_ScriptName, A_Linenumber, v.NameNoExt, "shell32")
T.Assert(A_ScriptName, A_Linenumber, v.Drive, "C:")

Goto GuiClose
Escape::
GuiClose:
  Gui, Destroy
  T.Close()
  T := ""
ExitApp
