;2021-03-07_15:18
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
;#Include <AHKEZ_Debug>

/*


  IMPORTANT: T.GetSavedWinText() will not work in Debug mode!
  It requires T.StartSendKeyTimer(TIMER_DURATION) to send keys in the non-debug test mode!


Note in AHKEZ.ahk:
  MsbBox()
  IsString := IsType(Options, "string")
  IsXdigit := IsType(Options, "xdigit")

The IsString test must be done before the variable is used otherwise uncertain result.
The xdigit can be included later, but left here just to be consistent with IsString

*/

T := New UnitTest

;T.SetOptions("-Debug,+Log")

; MyVar := "51"
; MB(MyVar, "My Title", "My Text")
; ExitApp

DEBUG := T.GetOption("Debug") ;DEBUG := False

TIMER_DURATION := 1000

Test_Start:

	;D := new DebugGUI()

  MyVar := "51"
  ;MB(0, "IsString", "IsString=" IsType(MyVar, "string") "`n`n" "IsXdigit=" IsType(MyVar, "xdigit"))

  MyVar := 51
  ;MB(0, "IsString", "IsString=" IsType(MyVar, "string") "`n`n" "IsXdigit=" IsType(MyVar, "xdigit"))

  MyVar := 0X33
  ;MB(0, "IsString", "IsString=" IsType(MyVar, "string") "`n`n" "IsXdigit=" IsType(MyVar, "xdigit"))

  ;Gosub Test_KeyDelay

	;Gosub Test_MsgBox_AHK

  Gosub Test_MsgBox_EZ

	if (!DEBUG)
		T.StartSendKeyTimer(TIMER_DURATION)

	MB("Press RESUME to ExitApp...")
	GoSub Finished
Return

/*
For future use if a custom MB option is needed:

AVAILABLE       0x200000  0010 0000 0000 0000 0000 0000
AVAILABLE       0x400000  0100 0000 0000 0000 0000 0000
AVAILABLE       0x800000  1000 0000 0000 0000 0000 0000

MB_RTLREADING   0x100000  0001 0000 0000 0000 0000 0000
MB_RIGHT        0x80000        1000 0000 0000 0000 0000
MB_HELP         0x04000             0100 0000 0000 0000
MB_SYSTEMMODAL  0x01000             0001 0000 0000 0000
MB_YESNOCANCEL  0x01003                            0011
*/

;MsgBox,    0                     ;0
;MsgBox,    0, My Title           ;empty
;MsgBox,    0, My Title, My Text  ;ok

;MsgBox Methods:
;1 - No parameters            MsgBox("Press ok to continue.")
;2 - One param                MsgBox(Options param displayed as Text)
;3 - Options=0 or Options=""  MsgBox(0, Title, Text, Timeout)
;4 - Options is "string"      MsgBox(Parameters are concatenated)
;                               AHK_L: commas are included
;                               AHKEZ: commas are omitted
;                             MsgBox([Options,] . [Title,] . [Text,] . [Timeout])
;                             MsgBox("abc", 33, "def", 51) ; "abc33def51"
;5 - Options is "xdigit"      MsgBox(Options, Title, Text, Timeout)

MB_EZ(Options = "", Title = "", Text = "", Timeout = "") {

  IsString := IsType(Options, "string")
  IsXdigit := IsType(Options, "xdigit")

  if (Options . Title . Text . Timeout = "" ) {
    MsgBox, 0, , Press OK to continue.
  } else if (Title . Text . Timeout = "") {
    MsgBox, %Options%
  } else if (Options=0) Or (Options="") {
    MsgBox, 0, %Title%, %Text%, %Timeout%
  } else if (IsString) {
      concat := Options . Title . Text . Timeout
      MsgBox, %concat%
  } else if (IsXdigit) {
      MsgBox, % Options, %Title%, %Text%, %Timeout%
  }
}

MB_EZ_DEBUG(Options = "", Title = "", Text = "", Timeout = "") {

  ;MB(0, "IsTYPE", "Options=" IsType(Options, "string") "`n`n" "IsString=" IsType(Options, "string") "`n`n" "IsXdigit=" IsType(Options, "xdigit"))
  IsString := IsType(Options, "string")
  IsXdigit := IsType(Options, "xdigit")
  ;ListVars(1, "IsTYPE", Options, IsString, IsXdigit)

  if (Options . Title . Text . Timeout = "" ) {
    MsgBox, 0, PAUSE, Press OK to continue.
  } else if (Title . Text . Timeout = "") {
    MsgBox, %Options%
  } else if (Options=0) Or (Options="") {
    MsgBox, 0, %Title%, %Text%, %Timeout%
  } else if (IsString) {

      ;mb(0,"debug", "is string!")
      
      concat := Options . Title . Text . Timeout
      MsgBox, %concat%
  } else if (IsXdigit) { ; IsType(Options, "xdigit") {
      MsgBox, % Options, %Title%, %Text%, %Timeout%
  } else {
    ; concat := Options . Title . Text . Timeout
    ; MsgBox, %concat%
  }
}

Test_KeyDelay:

  Run, Notepad
  WinWait(ahkclass("Notepad"))

  SendMode("Event")
  SaveDelay := A_KeyDelay

  SetKeyDelay(500)
  Send("test{enter}")

  SetKeyDelay(SaveDelay)
  ;MB(0,,"A_KeyDelay: "  A_KeyDelay) ; 10

  MB(0,,"A_KeyDelay=" A_KeyDelay)
  WinKill(ahkclass("Notepad"))

Return

Test_MsgBox_AHK:

  ;Tip: Pressing Ctrl+C while a message box is active will copy its text to the clipboard.
  ;This applies to all message boxes, not just those produced by AutoHotkey.

  ;1-No Options or params
  MsgBox
  
  ;2-param: Text
  MsgBox, 0
  MsgBox, My Text

  ;3-param: Options, Title, Text
  MsgBox,    0, My Title
  MsgBox,    0, My Title, My Text
  MsgBox, 0x33, My Title, My Text
  MsgBox,   51, My Title, My Text

  ;N-param: Options is non-hex and non-empty, concatenate all CSV params
  MsgBox, Concatenate, My Title, My Text, 2

  MyVar := "String"
  MsgBox, %MyVar%, My Title, My Text, 2

  MyVar := "51"
  MsgBox, % MyVar, My Title, My Text, 2

  ;4-param: Options, Title, Text, Timeout
  MsgBox,    0, WAIT FOR TIMEOUT, Wait for Timeout, 2

  MyArray := ["0","1","2","3","4","5","6","7"]
  index := 1
  ;N-param: Options is non-hex and non-empty, concatenate all CSV params
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2
  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2

  MsgBox, % MyArray[index++], WAIT FOR TIMEOUT, % "Option: " MyArray[index]-1, 2 ; invalid option, won't display
  MsgBox, 8, WAIT FOR TIMEOUT, "Option: 8", 2 ; invalid option, won't display

Return

Test_MsgBox_EZ:

	if (!DEBUG)
   	T.StartSendKeyTimer(TIMER_DURATION)
  MB()
  
	if (!DEBUG)
 	  T.StartSendKeyTimer(TIMER_DURATION)
  MsgBox, 0

  if (!DEBUG)
 	  T.StartSendKeyTimer(TIMER_DURATION)
  MB(0)
  ;MsgBox, 0
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`n0`r`n<")

  if (!DEBUG)
 	  T.StartSendKeyTimer(TIMER_DURATION)
  MB("My Text")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`nMy Text`r`n<")

  ;baseline AHK results
    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    MsgBox, 0 ;0

    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    MsgBox, 0, My Title AHK ;empty

    if (!DEBUG)
      T.StartSendKeyTimer(TIMER_DURATION)
    MsgBox, 0, My Title AHK, My Text ;ok
  
  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB(0)
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`n0`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB(0, "My Title")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB(0, "My Title", "Option = 0")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`nOption = 0`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB(0x33, "My Title", "Option = 0x33")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">&Yes`r`n&No`r`nCancel`r`nOption = 0x33`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB(51, "My Title", "Option = 51") ; IsString=0, IsXdigit=1
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">&Yes`r`n&No`r`nCancel`r`nOption = 51`r`n<")

  ;N-param: Options is non-hex and non-empty, concatenate all CSV params
  ;NOTE: Won't include the commas!
  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MB("Concatenate", "My Title", "My Text", "2")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`nConcatenateMy TitleMy Text2`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MyVar := "String"
  MB(MyVar, "My Title", "My Text", 2)
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`nStringMy TitleMy Text2`r`n<")

  if (!DEBUG)
    T.StartSendKeyTimer(TIMER_DURATION)
  MyVar := "51"
  MB(MyVar, "My Title", "My Text")
  T.Assert(A_ScriptName, A_Linenumber, ">" T.GetSavedWinText() "<", ">OK`r`n51My TitleMy Text`r`n<")

  ;4-param: Options, Title, Text, Timeout
  MB(0, "WAIT FOR TIMEOUT", "Wait for Timeout", 1)

  ;Options must be xdigit, not string!
  ;MyArray := ["0","1","2","3","4","5","6","7"]
  MyArray := [0,1,2,3,4,5,6,7]
  index := 1
  ;N-param: Options is non-hex and non-empty, concatenate all CSV params
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)
  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1)

  MB(MyArray[index++], "WAIT FOR TIMEOUT", "Option: " MyArray[index]-1, 1) ; invalid option, won't display
  MB(8, "WAIT FOR TIMEOUT", "Option: 8", 2) ; invalid option, won't display

Return

Escape::
Finished:
  D.Close()
  T.Close()
  T := ""
ExitApp
