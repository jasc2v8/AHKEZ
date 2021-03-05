#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

	;AHK_L:

		Gui, New, +HWNDhGui, MyTitle
		MsgBox % "HWNDhGui = " hGui
    Gui, Destroy

	 ;AHKEZ:
	  
		hGuiB := Gui("New", , "MyTitle")
		MsgBox % "HWNDhGui = " hGuiB
    Gui("Destroy")

	;AHK_L:

		String := "The Quick Brown Fox Jumps Over the Lazy Dog"
		MsgBox % SubStr(String, -7)  ; Returns "Lazy Dog"

	 ;AHKEZ:
	 
		MsgBox(StrEndsWith(String, "Lazy Dog"))  ; Reports abcdef123


var1 := "abc"
var2 := 123
MsgBox % StrDeref("%var1%def%var2%")  ; Reports abcdef123.
MsgBox(StrDeref("%var1%def%var2%"))  ; Reports abcdef123.

	;AHK_L:

		MsgBox % InStr("123abc789", "abc") ; Returns 4

	 ;AHKEZ:
	
		MsgBox(StrContains("123abc789", "abc")) ; Returns TRUE
		MsgBox(StrContains("123abc789", "def")) ; Returns False


	;AHK_L:

		FullFileName := "C:\My Documents\Address List.txt"
		SplitPath, FullFileName, name, dir, ext, name_no_ext, drive
   
		; The above will set the variables as follows:
		; name = Address List.txt
		; dir = C:\My Documents
		; ext = txt
		; name_no_ext = Address List
		; drive = C:

	 ;AHKEZ:

   	Obj := SplitPath(FullFileName)  
		MsgBox(Obj.FileName)  
		

		v := SplitPath(FullFileName).FileName

		MsgBox("FileName: " v)
		
		MsgBox(SplitPath(JoinPath(A_WinDir, "\System32\shell32.dll")).FileName)

SetTitleMatchMode()
SetTitleMatchMode("starts", "fast")
SetTitleMatchMode("contains", "slow")
SetTitleMatchMode("exact")

MyVar := "My Text"
Options := MyVar " is string 3"
MsgBox(Options)
MsgBox(MyVar " is string 3")

f := A_WinDir "\System32\shell32.dll"
FileGetAttrib, v, %f%
MsgBox, %v%

FileGetAttrib, v, % A_WinDir "\System32\shell32.dll"
MsgBox, %v%

v := A_WinDir "\System32\shell32.dll"
MsgBox(v)

attrib := FileGetAttrib(v)
MsgBox(attrib)

MsgBox(FileGetAttrib(JoinPath(A_WinDir, "\System32\shell32.dll")))


		var := Join(3, A_Space)
			MsgBox(">" var "<") ; 3 spaces

		var := Join(A_Space, "The", "cold", "rain.")
			MsgBox(var) ; "The cold rain."

		var := Join(":", "The result is ", 3.14)
			MsgBox(var) ; "The result is: 3.14"

		var := Join(":", "The result is", MyValue := -3.14)
			MsgBox(var) ; "The result is: -3.14"

MyVar := "My Text"
MyRadio1 := 1
MyCount := 0

If IsType(MyVar, "string")
  MsgBox("is string0")

MsgBox, String_1
MsgBox, %MyVar% String_2

MsgBox(MyVar " is string 1")
MsgBox(0,,MyVar " is string 2")

v := % MyVar
If IsType(MyVar, "string")
  MsgBox(v " is string 3")
  
  ;MsgBox, String
; ** End Auto-execute Section

; ** End Script
ExitApp
Escape::ExitApp