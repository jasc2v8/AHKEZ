if (!A_IsCompiled && A_LineFile == A_ScriptFullPath) {
 MsgBox % "This file was not #included."
 ExitApp
}
/*
 ======================================================================================================================
 Title:   AHKEZ_UnitTest.ahk
  About:  Unit testing for AHKEZ
  Usage:  #Include <AHKEZ_UnitTest>
  GitHub: https://github.com/jasc2v8/AHKEZ
 Version: 0.1.1/2021-03-07_14:44/jasc2v8/add GetSavedWinText()/Text saved from window before SendKey _OnTick
          0.1.0/2021-03-04_23:48/jasc2v8/initial commit
      AHK_L_v1.1.10.01 (U64)
  Notes:
    Use with Run_Tests.ahk
 License:
  Public Domain: https://creativecommons.org/publicdomain/zero/1.0/
 ======================================================================================================================
 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from the use of this software.
 ======================================================================================================================
*/
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
#Include <AHKEZ_Debug>
; ** Start Auto-execute Section

/*
 Name:  AHKEZ_UnitTest
 About: Simple test framework for AutHotkey V1
 Notes: Instantiated as a class:
     T := New TestUnit(ScriptName, Options)
*/

Class UnitTest {

    __Delete() {
        this.timer := ""
    }

  __New() {

   this.IniFile     := JoinPath(A_Temp, "UnitTest.ini")
   this.LogFile     := JoinPath(A_Temp, "UnitTest.log")
   this.LogFileBackup := JoinPath(A_Temp, "UnitTest.bak")
   this.TestFile    := JoinPath(A_Temp, "UnitTestPass.log")
   this.FailFile    := JoinPath(A_Temp, "UnitTestFail.log")

   this.ErrorCount := 0
   this.NL := "`r`n"

   this.opt := {}
   this.opt.Debug := this.GetOption("Debug")
   this.opt.Log  := this.GetOption("Log")   
   
   this.timer := {}
   this.timer.Timer := ObjBindMethod(this, "_OnTick")
   this.timer.Duration := 250
   this.timer.SendKeys := "{Enter}"
   this.timer.StartTick := 0

   this.LogHeader  := ""
   this.LogFooter  := ""

   this.LogBuffer  := ""
   this.PassBuffer := ""
   this.FailBuffer := ""
   this.SavedWinText    := ""

  }
  
 Run(ScriptFileList) {
  if IsEmpty(ScriptFileList)
   Return

  this.ClearLog()

  this.WriteLog(, "Start Time : " FormatTime(A_Now, "yyyy-MM-dd_HH:mm:ss"))

  this.StartTick := A_TickCount

  Loop, Parse, ScriptFileList, `n, `r
  {
   if IsEmpty(A_LoopField)
    Continue
   RunWait(A_LoopField)
  }

  this.WriteLog(,"End Time   : " FormatTime(A_Now, "yyyy-MM-dd_HH:mm:ss"))
  
  time := this.MillisecToTime(A_TickCount - this.StartTick)
  
  this.WriteLog(,"Elapsed    : " time)

  TextBuffer := FileRead(this.FailFile)
  if IsEmpty(TextBuffer) {
   this.WriteLog(,"FAIL List  : NONE")
  } else {
   this.WriteLog(,"FAIL List  :" . this.NL . TextBuffer)
  }

  TextBuffer := FileRead(this.TestFile)
  Sort(TextBuffer, "U")
  if IsEmpty(TextBuffer) {
   this.WriteLog(,"TEST List  : NONE")
  } else {
   this.WriteLog(,"TEST List  :" . this.NL . TextBuffer)
  }

  FileDelete(this.TestFile)
  FileDelete(this.FailFile)

 }

 ClearLog() {
  FileCopy(this.LogFile, this.LogFileBackup, 1)
  FileDelete(this.LogFile)
  FileDelete(this.TestFile)
  FileDelete(this.FailFile)
 }

 ClearOptions() {
  FileDelete(this.IniFile)
 }

 WriteLog(LogFile = "", Text = "") {
  if (!this.opt.Log)
   Return
  LogFile := IsEmpty(LogFile) ? this.LogFile : LogFile
  FileAppend(Text . this.NL, LogFile)
 }

 EditLog() {
  if FileExist(this.LogFile)
   RunWait(this.LogFile)
 }

 ;SN = The script name from which the Assert was called
 ;LN = The script line number from which the Assert was called
 ;IS = The result "is"
 ;SB = The result "should be"

 Assert(SN, LN, IS, SB) {
  if (IS != SB) {
   this.ErrorCount++
   v := ""
   . "Script Name:`n" SN Join(2,this.NL)
   . "Line Number:`n" LN Join(2,this.NL)
   . "Result Is:`n" IS Join(2,this.NL)
   . "Result Should Be:`n" SB Join(2,this.NL)

   if (this.opt.Debug)
    MsgBox 0x30, Unit Test FAIL, %v%

   ;MB(0,"this.FailBuffer", SN ", " LN)

   this.WriteLog(this.FailFile, Join(2, A_Space) SN "_" LN)

  } else {

    this.WriteLog(this.TestFile, Join(2, A_Space) SN)

  }
 }
 
 GetOption(Option) {
  Return IniRead(this.IniFile, "OPTIONS", Option, False)
 }

 SetOptions(OptionsCSV) {
  Loop, Parse, OptionsCSV, CSV
  {
   ;MB(0,,">" Trim(A_LoopField) "<")
   Option := Trim(A_LoopField)
   switch Option
   {
    Case "Debug"  , "+Debug": this.opt.Debug := True
    Case "NoDebug", "-Debug": this.opt.Debug := False
    Case "Log"    , "+Log" : this.opt.Log  := True
    Case "NoLog"  , "-Log" : this.opt.Log  := False
    Default:
     this.opt.Debug := False
     this.opt.Log  := True
   }
  }
  ;ListVars(1,,this.opt.Debug, this.opt.Log)
  IniWrite(this.opt.Debug, this.IniFile, "OPTIONS", "Debug")
  IniWrite(this.opt.Log  , this.IniFile, "OPTIONS", "Log"  )
  Return
 }

 GetSavedWinText() {
   Return this.SavedWinText
 }

 StartSendKeyTimer(Duration, Keys = "{Enter}") {
  this.timer.Duration := IsEmpty(Duration) ? this.timer.Duration : Duration
  this.timer.SendKeys := IsEmpty(Keys)     ? this.timer.SendKeys : Keys
  SetTimer(this.timer.Timer, this.timer.Duration)
 }

 _OnTick() {
  SetTimer(this.timer.Timer,"Off")
  this.SavedWinText := WinGetText("A")
  Send(this.timer.SendKeys)
 }

 Exist(Text := "") {
  if !IsEmpty(Text)
   MB(0x40, "Class TestUnit Exists", Text)
  Return True
 }
 
 ;https://www.autohotkey.com/boards/viewtopic.php?t=45476
 MillisecToTime(msec) {
  secs := floor(mod((msec / 1000),60))
  mins := floor(mod((msec / (1000 * 60)), 60) )
  hour := floor(mod((msec / (1000 * 60 * 60)) , 24))
  return Format("{:02}:{:02}:{:02}",hour,mins,secs)
 }

}
