
#Include <AHKEZ>
#Include <AHKEZ_UnitTest>

T := New UnitTest()

DEBUG := T.GetOption("Debug") ;DEBUG := True

;** START TEST

IniFile := A_ScriptDir "\TestFile.ini"

IniWrite("this is a new value", IniFile, "section2", "MyKey")
IniWrite("MyKey2=this is another new value", IniFile, "section3")

v := IniRead(IniFile, "section3", "MyKey2", "MyDefault")
T.Assert(A_ScriptName, A_Linenumber, v , "this is another new value")

v := IniRead(IniFile, "section3", "MyKey_INVALID", "MyDefault")
T.Assert(A_ScriptName, A_Linenumber, v , "MyDefault")

IniDelete(IniFile, "section3", "MyKey2")
v := IniRead(IniFile, "section3", "MyKey2")
T.Assert(A_ScriptName, A_Linenumber, v , "ERROR")

v := IniRead(IniFile, "section3", "MyKey2", "MyDefault")
T.Assert(A_ScriptName, A_Linenumber, v , "mydefault")

FileDelete(IniFile)

T.Close()
T := ""
ExitApp

Escape::ExitApp

