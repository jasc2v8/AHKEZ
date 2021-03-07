if (!A_IsCompiled && A_LineFile == A_ScriptFullPath) {
  MsgBox % "This file was not #included."
  ExitApp
}
/*
  ==================================================================================================
  Title:
    AHKEZ.ahk
  About:  
    The standard library for AHKEZ
  Usage:  
    #Include <AHKEZ>
  GitHub: 
    https://github.com/jasc2v8/AHKEZ
  Version:
		0.1.3/2021-03-05_22:16/iPhilip/fix IsType and added "object"
    0.1.2/2021-03-05_19:58/jasc2v8/Indent with spaces not tabs
    0.1.1/2021-03-05_17:48/jasc2v8/Fix Join to omit the Separator after the last Param*
    0.1.0/2021-03-04_23:30/jasc2v8/Initial Commit
    AHK_L_v1.1.10.01 (U64)
  Credits:
    Functions.ahk Version 1.41 <http://www.autohotkey.net/~polyethene/#functions>
  Objectives:
    1. Promote the use of AutoHotkey for programmers of all skill levels and languages
    2. Make AutoHotkey **Easy**, Effective, and Fun to use 
    3. Minimize the confusion when to use percent signs: `variable` or `%variable%` ?
    4. For AHK_L_v1.1 only, I have no plans to update for the forthcoming AHL_L_v2
  License:
    Public Domain: https://creativecommons.org/publicdomain/zero/1.0/
  ==================================================================================================
  This software is provided 'as-is', without any express or implied warranty.
  In no event will the authors be held liable for any damages arising from the use of this software.
  ==================================================================================================
*/
;
;Globals
;
Global DQ := """"
Global CR := "`r"
Global LF := "`n"
Global CRLF := "`r`n"
Global NL := "`r`n"
Global STX := Chr(0x02)
Global ETX := Chr(0x03)
Global TAB := "`t"
;
;Helpers
;
AhkClass(WinTitle) {
  Return "ahk_class" WinTitle
}
AhkId(WinTitle) {
  Return "ahk_id" WinTitle
}
AhkPid(WinTitle) {
  Return "ahk_pid" WinTitle
}
AhkExe(WinTitle) {
  Return "ahk_exe" WinTitle
}
AhkGroup(WinTitle) {
  Return "ahk_group" WinTitle
}
;
;Functions
;
AutoTrim(Options = "") {
  AutoTrim, %Options%
}
BlockInput(Options = "") {
  BlockInput, %Options%
}
Click(Options = "") {
  Click, %Options%
}
ClipWait(Timeout = "", WaitForAnyData = "") {
  ClipWait , %Timeout%, %WaitForAnyData%
}
Control(SubCommand, Value = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  Control, %SubCommand%, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlClick(ControlOrPos = "", WinTitle = "", WinText = "", WhichButton = "", ClickCount = "", Options = "", ExcludeTitle = "", ExcludeText = "") {
  ControlClick, %ControlOrPos%, %WinTitle%, %WinText%, %WhichButton%, %ClickCount%, %Options%, %ExcludeTitle%, %ExcludeText%
}
ControlFocus(Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlFocus, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlGet(SubCommand, Value = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGet, v, %SubCommand%, %Value%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
ControlGetFocus(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGetFocus, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
ControlGetID(Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGet, v, Hwnd,, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return v
}
ControlGetPos(ByRef X, ByRef Y, ByRef Width, ByRef Height, ControlID) {
  ControlGetPos, X, Y, Width, Height, , ahk_id %ControlID%
}
ControlGetText(Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlGetText, v, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
ControlMove(Control = "", X = "", Y = "", Width = "", Height = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlMove, %Control%, %X%, %Y%, %Width%, %Height%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSelect(ControlID, WindowID = "") {
  if (WindowID = "")
    WindowID := DllCall("user32\GetAncestor", Ptr, ControlID, UInt, GA_PARENT:=1, Ptr)
  PostMessage, WM_NEXTDLGCTL:=0x0028, %ControlID%, 1, , ahk_id %WindowID%
} ;Custom - Post/SendMessage requires the WinTitle parameter
ControlSend(Control = "", Keys = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSend, %Control%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSendRaw(Control = "", Keys = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSendRaw, %Control%, %Keys%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
ControlSetText(Control = "", NewText = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  ControlSetText, %Control%, %NewText%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
CoordMode(TargetType, RelativeTo := "Screen") {
  CoordMode, %TargetType%, %RelativeTo%
}
Critical(OnOffNumeric = "On") {
  Critical, %OnOffNumeric%
}
DetectHiddenText(OnOff) {
  DetectHiddenText, %OnOff%
}
DetectHiddenWindows(OnOff) {
  DetectHiddenWindows, %OnOff%
}
Drive(SubCommand = "", Value1 = "", Value2 = "") {
  Drive, %SubCommand%, %Value1%, %Value2%
}
DriveGet(SubCommand, Value = "") {
  DriveGet, v, %SubCommand%, %Value%
  Return, v
}
DriveSpaceFree(Path) {
  DriveSpaceFree, v, %Path%
  Return, v
}
Edit() {
  Edit
}
EditAppend(ControlID, String = "") {
  String .= "`r`n"
  Control, EditPaste, %String%,,ahk_id %ControlID%
}
EditClear(ControlID) {
  ControlSetText,,,ahk_id %ControlID%
}
EditGetCurrentCol(ControlID) {
  ControlGet, OutputVar, CurrentCol,,,ahk_id %ControlID%
  Return OutputVar
}
EditGetCurrentLine(ControlID) {
  ControlGet, OutputVar, CurrentLine,,,ahk_id %ControlID%
  Return OutputVar
}
EditGetLineCount(ControlID) {
  ControlGet, OutputVar, LineCount,,,ahk_id %ControlID%
  Return OutputVar
}
EditGetText(ControlID) {
  ControlGetText, v, , ahk_id %ControlID%
  Return v
}
EditGetSelectedText(ControlID) {
  ControlGet, OutputVar, Selected,,,ahk_id %ControlID%
  Return OutputVar
}
EditPaste(ControlID, String = "") {
  Control, EditPaste, %String%,,ahk_id %ControlID%
}
EditSetText(ControlID, NewText = "") {
  ControlSetText,, %NewText%, ahk_id %ControlID%
}
EnvAdd(ByRef Var, Value = "" , TimeUnits = "") {
  EnvAdd, Var, %Value% , %TimeUnits%
}
EnvGet(EnvVarName) {
  EnvGet, v, %EnvVarName%
  Return, v
}
EnvSet(EnvVar, Value) {
  EnvSet, %EnvVar%, %Value%
}
EnvSub(ByRef Var, Value = "" , TimeUnits = "") {
  EnvSub, Var, %Value% , %TimeUnits%
}
EnvUpdate() {
  EnvUpdate
}
FileAppend(Text = "", Filename = "", Encoding = "") {
  FileAppend, %Text%, %Filename%, %Encoding%
}
FileCopy(SourcePattern = "", DestPattern = "", Overwrite = "") {
  FileCopy, %SourcePattern%, %DestPattern%, %Overwrite%
}
FileCopyDir(Source = "", Dest = "", Overwrite = "") {
  FileCopyDir, %Source%, %Dest%, %Overwrite%
}
FileCreateDir(DirName = "") {
  FileCreateDir, %DirName%
}
FileCreateShortcut(Target, ByRef LinkFile, WorkingDir = "", Args = "", Description = "", IconFile = "", ShortcutKey = "", IconNumber = "", RunState = "") {
  FileCreateShortcut, %Target%, %LinkFile% , %WorkingDir%, %Args%, %Description%, %IconFile%, %ShortcutKe%, %IconNumber%, %RunState%
}
FileDelete(FilePattern = "") {
  FileDelete, %FilePattern%
}
FileEncoding(Encoding = "") {
  FileEncoding, %Encoding%
}
;FileExist() ;built-in
FileGetAttrib(Filename = "") {
  FileGetAttrib, v, %Filename%
  Return, v
}
FileGetShortcut(LinkFile = "") {
  FileGetShortcut, %LinkFile%, Target, Dir, Args, Description, Icon, IconNum, RunState
  Return ({"Target": Target, "Dir": Dir, "Args": Args, "Description": Description, "Icon": Icon, "IconNum": IconNum, "RunState": RunState})
}
FileGetSize(Filename = "", Units = "") {
  FileGetSize, v, %Filename%, %Units%
  Return, v
}
FileGetTime(Filename = "", WhichTime = "") {
  FileGetTime, v, %Filename%, %WhichTime%
  Return, v
}
FileGetVersion(Filename = "") {
  FileGetVersion, v, %Filename%
  Return, v
}
FileInstall(Source, Dest, Overwrite = "") {
  FileInstall, Source, Dest, %Overwrite%
}
FileMove(SourcePattern = "", DestPattern = "", Overwrite = 0) {
  FileMove, %SourcePattern%, %DestPattern%, %Overwrite%
}
FileMoveDir(Source = "", Dest = "", Flag = "") {
  FileMoveDir, %Source%, %Dest% , %Flag%
}
;FileOpen() built-in
FileRead(Filename) {
  FileRead, v, %Filename%
  Return, v
}
FileReadLine(Filename, LineNum) {
  FileReadLine, v, %Filename%, %LineNum%
  Return, v
}
FileRecycle(FilePattern = "") {
  FileRecycle, %FilePattern%
}
FileRecycleEmpty(DriveLetter = "") {
  FileRecycleEmpty, %DriveLetter%
}
FileRemoveDir(DirName, Recurse = "") {
  FileRemoveDir, %DirName%, %Recurse%
}
FileRename(SourcePattern = "", DestPattern = "", Overwrite = 0) {
  FileMove(SourcePattern, DestPattern, Overwrite)
} ;Custom
FileSelectFile(Options = "", RootDir = "", Prompt = "", Filter = "") {
  FileSelectFile, v, %Options%, %RootDir%, %Prompt%, %Filter%
  Return, v
}
FileSelectFolder(StartingFolder = "", Options = "", Prompt = "") {
  FileSelectFolder, v, %StartingFolder%, %Options%, %Prompt%
  Return, v
}
FileSetAttrib(Attributes = "", FilePattern = "", OperateOnFolders = "", Recurse = "") {
  FileSetAttrib, %Attributes%, %FilePattern%, %OperateOnFolders%, %Recurse%
}
FileSetTime(YYYYMMDDHH24MISS = "", FilePattern = "", WhichTime = "", OperateOnFolders = "", Recurse = "") {
  FileSetTime, %YYYYMMDDHH24MISS%, %FilePattern%, %WhichTime%, %OperateOnFolders%, %Recurse%
}
FileWrite(Text = "", Filename = "", Overwrite = 0, Encoding = "") {
  If (Overwrite)
     FileDelete(Filename)
   FileAppend(Text, Filename, Encoding)
} ;Custom
FormatTime(YYYYMMDDHH24MISS = "", Format = "") {
  FormatTime, v, %YYYYMMDDHH24MISS%, %Format%
  Return, v
} ; FormatTime(Now, "yyyy-MM-dd-hh:ss")
GroupActivate(GroupName, Mode = "") {
  GroupActivate, %GroupName%, %Mode%
}
GroupAdd(GroupName, WindowID, Label = "") {
  GroupAdd, %GroupName%, ahk_id %WindowID%, , %Label%
}
GroupClose(GroupName, Mode = "") {
  GroupClose, %GroupName%, %Mode%
}
GroupDeactivate(GroupName, Mode = "") {
  GroupDeactivate, %GroupName%, %Mode%
}
GuiControl(Subcommand = "", ControlID = "", Value = "") {
  GuiControl, %Subcommand%, %ControlID%, %Value% ; supports ObjBindMethod(this, "MyFunction")
}
GuiControlGet(Subcommand = "", ControlID = "", Param4 = "") {
  GuiControlGet, v, %Subcommand%, %ControlID%, %Param4%
  Return, v
}
IfBetween(ByRef var, LowerBound, UpperBound) {
  If var between %LowerBound% and %UpperBound%
  Return, true
}
IfIn(ByRef var, MatchList) {
  If var in %MatchList%
  Return, true
}
IfNotIn(ByRef var, MatchList) {
  If var not in %MatchList%
  Return, true
}
IfContains(ByRef var, MatchList) {
  If var contains %MatchList%
  Return, true
}
IfNotContains(ByRef var, MatchList) {
  If var not contains %MatchList%
  Return, true
}
ImageSearch(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2, ImageFile) {
  ImageSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ImageFile%
}
IniDelete(Filename, Section, Key = "") {
  if IsEmpty(Key) {
    IniDelete, %Filename%, %Section%
  } else {
    IniDelete, %Filename%, %Section%, %Key%
  }
}
IniRead(Filename, Section, Key = "", Default = "") {
  IniRead, v, %Filename%, %Section%, %Key%, %Default%
  Return, v
}
IniWrite(ValueOrPairs = "", Filename = "", Section = "", Key="") {
  IniWrite, %ValueOrPairs%, %Filename%, %Section%, %Key%
}
Input(Options = "", EndKeys = "", MatchList = "") {
  Input, v, %Options%, %EndKeys%, %MatchList%
  Return, v
}
InputBox(Title = "", Prompt = "", HIDE = "", Width = "", Height = "", X = "", Y = "", Font = "", Timeout = "", Default = "") {
  InputBox, v, %Title%, %Prompt%, %HIDE%, %Width%, %Height%, %X%, %Y%, , %Timeout%, %Default%
  Return, v
}
IsBlank(var) {
  Return RegExMatch(var, "^[\s]+$")
} ;Custom
IsEmpty(var) {
  Return (var = "")
} ;Custom
;IsObject() built-in
IsType(ByRef var, type) {
   if (type = "object")
      Return IsObject(var)
   if (type = "array") 
      Return (var.Length() >= 0)
   if (type = "string")
      Return ObjGetCapacity([var], 1) != ""
   if var is %type%
      Return true
   Return false
}
Join(Separator, params*) {
  v := ""
  if IsType(Separator, "integer") {
    Loop, %Separator%
    {
      v .= params.1
    }
    Return v
  }
  for index, p in params
    v .= p . Separator
  Return SubStr(v,1,StrLen(v)-StrLen(Separator))
} ; MsgBox % Join("`n", "one", "two", "three") ; MsgBox % ">" Join(5, "X") "<"
JoinPath(Dir, File) {
  Dir := Trim(Dir)
  File := Trim(File)
  if (SubStr(Dir,0) = "\")
    Dir := SubStr(Dir,1,-1)
  if (SubStr(File,1,1) = "\") ;
    File := SubStr(File,2)
  Return % Dir . "\" . File
} ; MsgBox % JoinPath(A_ScriptDir, "Filename.exe")
KeyHistory() {
  KeyHistory
}
KeyWait(KeyName, Options = "") {
  KeyWait, %KeyName% , %Options%
}
ListHotkeys() {
  ListHotkeys
}
ListLines(OnOff = "") {
  ListLines, %OnOff%
}
Menu(MenuName, SubCommand, Value1 = "", Value2 = "", Value3 = "", Value4 = "") {
  Menu, %MenuName%, %SubCommand%, %Value1%, %Value2%, %Value3%, %Value4%
}
MouseClick(WhichButton = "", X = "", Y = "", ClickCount = "", Speed = "", DownOrUp = "", Relative = "") {
  MouseClick, %WhichButton%, %X%, %Y%, %ClickCount%, %Speed%, %DownOrUp%, %Relative%
}
MouseClickDrag(WhichButton, X1, Y1, X2, Y2, Speed = "", Relative = "") {
  MouseClickDrag, %WhichButton%, %X1%, %Y1%, %X2%, %Y2%, %Speed%, %Relative%
}
MouseGetPos(ByRef OutputVarX = "", ByRef OutputVarY = "", ByRef OutputVarWin = "", ByRef OutputVarControl = "", Mode = "") {
  MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, %Mode%
}
MouseMove(X, Y, Speed = "", Relative = "") {
  MouseMove, %X%, %Y%, %Speed%, %Relative%
}
MB(Options = "", Title = "", Text = "", Timeout = "") {
  MsgBox(Options, Title, Text, Timeout)
}
MsgBox(Options = "", Title = "", Text = "", Timeout = "") {
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
OutputDebug(Text) {
  OutputDebug, %Text%
}
PixelGetColor(X, Y, RGB = "") {
  PixelGetColor, v, %X%, %Y%, %RGB%
  Return, v
}
PixelSearch(ByRef OutputVarX, ByRef OutputVarY, X1, Y1, X2, Y2, ColorID, Variation = "", Mode = "") {
  PixelSearch, OutputVarX, OutputVarY, %X1%, %Y1%, %X2%, %Y2%, %ColorID%, %Variation%, %Mode%
}
PostMessage(Msg, wParam = "", lParam = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  PostMessage, %Msg%, %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
Process(SubCommand, PIDOrName = "", Value = "") {
  Process, %SubCommand%, %PIDOrName%, %Value%
}
Random(Min = "", Max = "") {
  Random, v, %Min%, %Max%
  Return, v
}
RegDelete(KeyName , ValueName = "") {
  RegDelete, %KeyName%, %ValueName%
}
RegRead(RootKey, SubKey, ValueName = "") {
  RegRead, v, %RootKey%, %SubKey%, %ValueName%
  Return, v
}
RegWrite(Valuetype = "", RootKey = "", SubKey = "", ValueName = "", Value = "") {
  RegWrite, %ValueType%, %RootKey%, %SubKey%, %ValueName%, %Value%
}
Reload() {
  Reload
}
Run(Target = "", WorkingDir = "", Mode = "") {
  Run, %Target%, %WorkingDir%, %Mode%, v
  Return, v
} ; Run("edit " TxtFile) ;notepad, Run(TxtFile) ;notepad++ if associated with .txt
RunAs(User = "", Password = "", Domain = "") {
  RunAs, %User%, %Password%, %Domain%
}
RunWait(Target, WorkingDir = "", Mode = "") {
  RunWait, %Target%, %WorkingDir%, %Mode%, v
  Return, v
}
Send(Keys) {
  Send %Keys%
}
SendRaw(Keys) {
  SendRaw %Keys%
}
SendInput(Keys) {
  SendInput %Keys%
}
SendPlay(Keys) {
  SendPlay %Keys%
}
SendEvent(Keys) {
  SendEvent %Keys%
}
SendLevel(Level) {
  SendLevel, %Level%
}
SendMessage(Msg, wParam = "", lParam = "", Control = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "", Timeout = "") {
  SendMessage, %Msg%, %wParam%, %lParam%, %Control%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%, %Timeout%
  Return ErrorLevel
}
SendMode(Mode) {
  SendMode %Mode%
}
SetBatchLines(Value) {
  SetBatchLines, %Value%
}
SetCapsLockState(State) {
  SetCapsLockState, %State%
}
SetControlDelay(Delay) {
  SetControlDelay, %Delay%
}
SetDefaultMouseSpeed(Speed) {
  SetDefaultMouseSpeed, %Speed%
}
SetKeyDelay(Delay = "", PressDuration = "", Play = "") {
  SetKeyDelay, %Delay%, %PressDuration%, %Play%
}
SetMouseDelay(Delay, Play = "") {
  SetMouseDelay, %Delay% , %Play%
}
SetNumLockState(State) {
  SetNumLockState, %State%
}
SetRegView(RegView) {
  SetRegView, %RegView%
}
SetScrollLockState(State) {
  SetScrollLockState, %State%
}
SetStoreCapsLockMode(OnOff) {
  SetStoreCapsLockMode, %OnOff%
}
SetTimer(Label = "", PeriodOnOffDelete = "", Priority = "") {
  SetTimer, %Label%, %PeriodOnOffDelete%, %Priority%
}
SetTitleMatchMode(MatchMode = "", Speed = "") {
  if !IsEmpty(MatchMode) {
    Switch MatchMode
    {
      Case "starts":    Option := 1
      Case "contains":  Option := 2
      Case "exact":     Option := 3
      Default:          Option := 1
    }
    SetTitleMatchMode, %Option%
  }
  if !IsEmpty(Speed) {
    Switch Speed
    {
      Case "fast":      Option := Speed
      Case "slow":      Option := Speed
      Default:          Option := "fast"
    }
    SetTitleMatchMode, %Option%    
  }
}
SetWinDelayDelay(Delay) {
  SetWinDelay, %Delay%
}
SetWorkingDir(DirName) {
  SetWorkingDir, %DirName%
}
Shutdown(Code) {
  Shutdown, %Code%
}
Sleep(DelayInMilliseconds) {
  Sleep, %DelayInMilliseconds%
}
Sort(ByRef VarName, Options = "") {
  Sort, VarName, %Options%
}
SoundBeep(Frequency = "", Duration = "") {
  SoundBeep, %Frequency%, %Duration%
}
SoundGet(ComponentType = "", ControlType = "", DeviceNumber = "") {
  SoundGet, v, %ComponentType%, %ControlType%, %DeviceNumber%
  Return, v
}
SoundGetWaveVolume(DeviceNumber = "") {
  SoundGetWaveVolume, v, %DeviceNumber%
  Return, v
}
SoundPlay(Filename, Wait = "") {
  SoundPlay, %Filename%, %Wait%
}
SoundSet(NewSetting, ComponentType = "", ControlType = "", DeviceNumber = "") {
  SoundSet, %NewSetting%, %ComponentType%, %ControlType%, %DeviceNumber%
}
SoundSetWaveVolume(Percent , DeviceNumber = "") {
  SoundSetWaveVolume, %Percent%, %DeviceNumber%
}
SplitPath(Path = "") {
  SplitPath, Path, FileName, Dir, Ext, NameNoExt, Drive
  Return ({"FileName": FileName, "Dir": Dir, "Ext": Ext, "NameNoExt": NameNoExt, "Drive": Drive})
} ; SplitPathObj(Filename).NameNoExt
StatusBarGetText(Part = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  StatusBarGetText, v, %Part%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
StatusBarWait(BarText = "", Timeout = "", Part# = "", WindowID = "") {
  StatusBarWait, %BarText%, %Timeout%, %Part#%, ahk_id %WindowID%
}
StrContains(Haystack, Needle, CaseSensitive = false, StartingPos = 1, Occurrence = 1) {
  Return Instr(Haystack, Needle, CaseSensitive, StartingPos, Occurrence) > 0
}
StrDeRef(String) {
 spo := 1
 out := ""
 while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
 {
  out .= SubStr(String, spo, fpo-spo)
  spo := fpo + StrLen(m)
  if (m1)
   out .= %m2%
  else switch (m3)
  {
   case "a": out .= "`a"
   case "b": out .= "`b"
   case "f": out .= "`f"
   case "n": out .= "`n"
   case "r": out .= "`r"
   case "t": out .= "`t"
   case "v": out .= "`v"
   default: out .= m3
  }
 }
 Return out SubStr(String, spo)
} ;https://www.autohotkey.com/docs/commands/RegExMatch.htm#ExDeref
StrEndsWith(Haystack, Needle, CaseSensitive := false, Occurrence = 1) {
  Return SubStr(Haystack, Instr(Haystack, Needle, CaseSensitive, 0, Occurrence)) = Needle
}
;StrLen() built-in
;StrPut() built-in
;StrReplace() built-in
StrStartsWith(Haystack, Needle, CaseSensitive := false, Occurrence = 1) {
  Return (Instr(Haystack, Needle, CaseSensitive, 1, Occurrence) = 1)
}
StrLower(ByRef InputVar, T = "") {
  StringLower, v, InputVar, %T%
  Return, v
}
;StrSplit() built-in
;StrReplace()  built-in
StrUpper(ByRef InputVar, T = "") {
  StringUpper, v, InputVar, %T%
  Return, v
}
StringCaseSense(OnOffLocale) {
  StringCaseSense, %OnOffLocale%
}
StringLower(ByRef InputVar, T = "") {
  StringLower, v, InputVar, %T%
  Return, v
}
StringUpper(ByRef InputVar, T = "") {
  StringUpper, v, InputVar, %T%
  Return, v
}
;SubStr() built-in
Suspend(Mode = "") {
  Suspend, %Mode%
}
SysGet(Subcommand, Param3 = "") {
  SysGet, v, %Subcommand%, %Param3%
  Return, v
}
Thread(SubCommand, Value1 = "", Value2 = "") {
  Thread, %SubCommand% , %Value1%, %Value2%
}
Throw(Expression = "") {
  Throw, %Expression%
}
ToolTip(Text = "", X = "", Y = "", WhichToolTip = "") {
  ToolTip, %Text%, %X%, %Y%, %WhichToolTip%
}
TrayTip(Title = "", Text = "", Seconds = "", Options = "") {
  TrayTip, %Title%, %Text%, %Seconds%, %Options%
}
UrlDownloadToFile(URL, Filename) {
  UrlDownloadToFile, %URL%, %Filename%
}
;WinActive() built-in
WinActivate(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinActivate, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinActivateBottom(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinActivateBottom, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinGetActiveStats(ByRef Title, ByRef Width, ByRef Height, ByRef X, ByRef Y) {
  WinGetActiveStats, Title, Width, Height, X, Y
}
WinGetActiveTitle() {
  WinGetActiveTitle, v
  Return, v
}
WinClose(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinClose, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
;WinExist() built-in, same as WinGetID()
WinGet(SubCommand = "", WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGet, v, %SubCommand%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
WinGetClass(OutputVar , WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGetClass, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
WinGetID(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGet, v, ID, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return v
} ;from AHKv2, same as WinExist
WinGetPos(ByRef X, ByRef Y, ByRef Width, ByRef Height, WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGetPos, X, Y, Width, Height, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinGetText(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGetText, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
WinGetTitle(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinGetTitle, v, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
  Return, v
}
WinHide(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinHide, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinKill(WinTitle = "", WinText = "", SecondsToWait = "", ExcludeTitle = "", ExcludeText = "") {
  WinKill, %WinTitle%, %WinText%, %SecondsToWait%, %ExcludeTitle%, %ExcludeText%
}
WinMaximize(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinMaximize, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinMenuSelectItem(WinTitle, WinText, Menu, SubMenu1 = "", SubMenu2 = "", SubMenu3 = "", SubMenu4 = "", SubMenu5 = "", SubMenu6 = "") {
  WinMenuSelectItem, %WinTitle%, %WinText%, %Menu% , %SubMenu1%, %SubMenu2%, %SubMenu3%, %SubMenu4%, %SubMenu5%, %SubMenu6%
}
WinMinimize(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") { 
  WinMinimize, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinMinimizeAll() {
  WinMinimizeAll
}
WinMinimizeAllUndo() {
  WinMinimizeAllUndo
}
WinMove(WinTitle, WinText = "", X = "", Y = "", Width = "", Height = "", ExcludeTitle = "", ExcludeText = "") {
  WinMove, %WinTitle%, %WinText%, %X%, %Y% , %Width%, %Height%, %ExcludeTitle%, %ExcludeText%
}
WinRestore(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinRestore, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinSet(SubCommand, Value, WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinSet, %SubCommand%, %Value%, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinSetTitle(WinTitle, WinText = "", NewTitle = "", ExcludeTitle = "", ExcludeText = "") {
  WinSetTitle, %WinTitle%, %WinText%, %NewTitle%, %ExcludeTitle%, %ExcludeText%
}
WinShow(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinShow, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
WinWait(WinTitle = "", WinText = "", TimeOut = "", ExcludeTitle = "", ExcludeText = "") {
  WinWait, %WinTitle%, %WinText%, %TimeOut%, %ExcludeTitle%, %ExcludeText%
}
WinWaitActive(WinTitle = "", WinText = "", TimeOut = "", ExcludeTitle = "", ExcludeText = "") {
  WinWaitActive, %WinTitle%, %WinText%, %TimeOut%, %ExcludeTitle%, %ExcludeText%
}
WinWaitNotActive(WinTitle = "", WinText = "", TimeOut = "", ExcludeTitle = "", ExcludeText = "") {
  WinWaitNotActive, %WinTitle%, %WinText%, %TimeOut%, %ExcludeTitle%, %ExcludeText%
}
WinWaitClose(WinTitle = "", WinText = "", ExcludeTitle = "", ExcludeText = "") {
  WinWaitClose, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
}
;
; <AHKEZ_GUI>
;
  Gui(SubCommand = "New", Value1 = "", Value2 = "", Value3 = "") {

  ;match gui options first char
  Static GuiOptNeedle := "iS)(*UCP)([x|y|w|h|c|r|s|q]\d{1})(?<!c0x)"

  ;if "GuiName:" found, combine with SubCommand
  ; calling code must add trailing colon ":", to the GuiName eg:
  ; Static GuiName := "DEBUG:"
  pos := StrContains(Subcommand, ":")
  Subcommand := Trim(Subcommand)
  if (pos) {
    GuiCommand := SubStr(Subcommand, 1, pos) . SubStr(Subcommand, pos + 1)
  } else {
    GuiCommand := Subcommand
  }

  ;Gui, Add, ControlType , Options, Text
  ;Gui, SubCommand, Value1, Value2, Value3
  if StrEndsWith(SubCommand, "Add") {
    controlType := value1
    options := "+HWNDhID " RegExReplace(Value2, GuiOptNeedle, " $1")
    text := Value3
    Gui, %subCommand%, %controlType%, %options%, %text%
    Return hID
  }


  ;Gui, Color, WindowColor(Default, HtmlName, RGB, % var), ControlColor(Default, HtmlName, RGB, % var)
  ;Gui, SubCommand, Value1, Value2, Value3
  if StrEndsWith(SubCommand, "Color") {
    Static StripLeading_C_Needle := "iS)(*UCP)^c?(.*)"
    ;Gui, Color doesn't support a leading "c" for colors, strip off if present
    windowColor  := RegExReplace(Trim(Value1), StripLeading_C_Needle, "$1")
    controlColor := RegExReplace(Value2, StripLeading_C_Needle, "$1")
    Gui, %subCommand%, %windowColor%, %controlColor%
    Return
  }

  ;Gui, Font, Options(cswq), FontName
  ;Gui, SubCommand, Value1, Value2, Value3
  if StrEndsWith(SubCommand, "Font") {
    Options := RegExReplace(Value1, GuiOptNeedle, " $1") ;note A_Space . "$1"
    FontName := Value2
    Gui, %SubCommand%, %Options%, %FontName%
    Return
  }

  ;Gui, GuiName:New, Options, Title
  ;Gui, SubCommand, Value1, Value2, Value3
  if StrEndsWith(SubCommand, "New") {
    Options := "+HWNDhID " RegExReplace(Value1, GuiOptNeedle, " $1") ;note A_Space . "$1"
    Title := Value2
    Gui, %GuiCommand%, %Options%, %Title%
    Return hID
  }

  ;Gui, Show, Options, Title
  ;Gui, SubCommand , Value1, Value2, Value3
  if StrEndsWith(SubCommand, "Show") {
    Options := RegExReplace(Value1, GuiOptNeedle, " $1") ;note A_Space . "$1"
    Title := Value2
    Gui, %subCommand%, %options%, %Title%
    hID := WinGetID("A")
    Return hID
  }

  Static GuiSubCommands := "Cancel,Destroy,Flash,Hide,Margin,Minimize,Maximize,Menu,Restore,Submit"
  ;Gui, SubCommand , Value1, Value2, Value3
  if StrContains(GuiSubCommands, SubCommand) {
    Gui, %subCommand%, %Value1%, %Value2%, %Value3%
    Return
  }

  ;Gui, +/-Option1 +/-Option2 ...
  ;Gui, SubCommand , Value1, Value2, Value3
  ;no gui options with first char to match
  ;Options here are all strings, eg: "+E0x40000 -Theme +Owner"
  options := SubCommand
  Gui, %options%

} ; End_Gui()