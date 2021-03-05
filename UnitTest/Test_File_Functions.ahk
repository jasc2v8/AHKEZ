/*AHKEZ Functions tested:

FileAppend	Writes text to the end of a file (first creating the file, if necessary).
FileCopy	Copies one or more files.
FileCopyDir	Copies a folder along with all its sub-folders and files (similar to xcopy).
FileCreateDir	Creates a folder.
FileCreateShortcut	Creates a shortcut (.lnk) file.
FileDelete	Deletes one or more files.
FileEncoding	Sets the default encoding for FileRead, FileReadLine, Loop Read, FileAppend, and FileOpen().
FileExist()	Checks for the existence of a file or folder and returns its attributes.
FileInstall	Includes the specified file inside the compiled version of the script.
FileGetAttrib	Reports whether a file or folder is read-only, hidden, etc.
FileGetShortcut	Retrieves information about a shortcut (.lnk) file, such as its target file.
FileGetSize	Retrieves the size of a file.
FileGetTime	Retrieves the datetime stamp of a file or folder.
FileGetVersion	Retrieves the version of a file.
FileMove	Moves or renames one or more files.
FileMoveDir	Moves a folder along with all its sub-folders and files. It can also rename a folder.
FileOpen()	Opens a file to read specific content from it and/or to write new content into it.
FileRead	Reads a file's contents into a variable.
FileReadLine	Reads the specified line from a file and stores the text in a variable.
FileRecycle	Sends a file or directory to the recycle bin if possible, or permanently deletes it.
FileRecycleEmpty	Empties the recycle bin.
FileRemoveDir	Deletes a folder.
FileSelectFile	Displays a standard dialog that allows the user to open or save file(s).
FileSelectFolder	Displays a standard dialog that allows the user to select a folder.
FileSetAttrib	Changes the attributes of one or more files or folders. Wildcards are supported.
FileSetTime

*/
#NoEnv
; #Warn
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
; ==================

#Include <AHKEZ>
#Include <AHKEZ_UnitTest>
#Include <AHKEZ_Debug>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

TIMER_DURATION := 1000

Test_Start:

	D := new DebugGUI()
	
	Gosub Test_Initialize

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	D.Pause("Press RESUME to ExitApp...")
	GoSub GuiClose
Return

Test_Initialize:
	TempDir  		:= JoinPath(A_Temp, "Test_Temp")
	TempSubDir  := JoinPath(TempDir, "SubDir")
	TempFile 		:= JoinPath(TempDir, "TempFile.dat")
	LinkFile 		:= JoinPath(TempDir, "MyLink.lnk")

	;ok ListVars(1,,TempDir, TempFile)

Test_File_Create:

	FileCreateDir(TempDir)
	v := ErrorLevel = 0 ? True : False
	T.Assert(A_ScriptName, A_Linenumber, v , True)

	FileCreateShortcut(A_ScriptFullPath, LinkFile,,, "My Link File", A_ScriptFullPath)
	success := FileExist(LinkFile)
	success := "" ? False : True
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	v := FileGetShortcut(LinkFile).Description
	T.Assert(A_ScriptName, A_Linenumber, v, "My Link File")

Test_File_Copy:

	FileCopy(A_ScriptFullPath, TempDir, Overwrite := True)
	success := ErrorLevel = 0 ? True : False
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	FileAppend(";Test_File_Functions", TempFile)
	success := ErrorLevel = 0 ? True : False
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	success := FileExist(TempFile)
	success := "" ? False : True
	T.Assert(A_ScriptName, A_Linenumber, success, True)
	
	FileBuffer := FileRead(TempFile)
	success := IsEmpty(FileBuffer) ? False : True
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	FileWrite("Test FileWrite", TempFile, 1)
	Line := FileReadLine(TempFile, 1)
	T.Assert(A_ScriptName, A_Linenumber, Line, "Test FileWrite")

Test_File_Binary:
	;TODO needs work...
	DLLFile := JoinPath(A_WinDir, "System32\shell32.dll")
	Bin := FileRead("*c " . DLLFile )
	T.Assert(A_ScriptName, A_Linenumber, NumGet( Bin, 4, "UInt" ), 3)

Test_File_Options:

Test_File_Attributes:
	; FileGetAttrib	Reports whether a file or folder is read-only, hidden, etc.
	; FileGetShortcut	Retrieves information about a shortcut (.lnk) file, such as its target file.
	; FileGetSize	Retrieves the size of a file.
	; FileGetTime	Retrieves the datetime stamp of a file or folder.
	; FileGetVersion
	; FileSetAttrib	Changes the attributes of one or more files or folders. Wildcards are supported.
	; FileSetTime

Test_File_Move:
	; FileMove	Moves or renames one or more files.
	; FileMoveDir	Moves a folder along with all its sub-folders and files. It can also rename a folder.

Test_File_Delete:
	;FileRecycle

	FileDelete(TempDir "\Test_*.*")
	success := ErrorLevel = 0 ? True : False
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	FileDelete(TempFile)
	success := ErrorLevel = 0 ? True : False
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	v := FileExist(TempFile)
	T.Assert(A_ScriptName, A_Linenumber, v, "")

	FileCreateDir(TempSubDir)
	FileCopy(A_ScriptFullPath, TempSubDir, Overwrite := True)
	v := FileExist(JoinPath(TempSubDir, A_ScriptName))
	success := !IsEmpty(v) ? True : False
	T.Assert(A_ScriptName, A_Linenumber, success, True)

	FileRemoveDir(TempDir, 1)
	v := FileExist(TempSubDir)
	T.Assert(A_ScriptName, A_Linenumber, v, "")
	v := FileExist(TempDir)
	T.Assert(A_ScriptName, A_Linenumber, v, "")

Return

Escape::
GuiClose:
  ;Gui, Destroy
  D.Close()
  T.Close()
  T := ""
ExitApp
