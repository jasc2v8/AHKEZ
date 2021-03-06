if (!A_IsCompiled && A_LineFile == A_ScriptFullPath) {
 MsgBox % "This file was not #included."
 ExitApp
}
/*
  ======================================================================================================================
  Title:   AHKEZ_Debug.ahk
  About:   A window to display debug information while testing a script
           A very useful ListVars() function at the bottom of this script
           Search below for Help_Pages for declaration, options, and functions
  Usage:   #Include <AHKEZ_Debug>
  GitHub:  https://github.com/jasc2v8/AHKEZ
  Version: 0.1.1/2021-03-05_22:19/jasc2v8/Indent with spaces not tabs
           0.1.0/2021-03-04_23:45/jasc2v8
           AHK_L_v1.1.10.01 (U64)
  Credits:
    Class encapsulation of the Gui with event handling: https://www.autohotkey.com/boards/viewtopic.php?t=68912
  License:
    Public Domain: https://creativecommons.org/publicdomain/zero/1.0/
 ======================================================================================================================
 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from the use of this software.
 ======================================================================================================================
*/

#Include <AHKEZ>
	
Class DebugGUI
{

  Append(pText) {
    this.Paste(pText . this.opt.NL)
    Return
  }
 
  Clear() {
    this.opt.LineNumber:=0  
    this.gui.HelpPage := 1
    EditClear(this.gui.hEdit)
  }
 
  Close() {
   PostMessage(WM_SYSCOMMAND:=0x112, SC_CLOSE:=0xF060, this.gui.hGui)
  }
 
  GuiSize(Option) {
    Switch Option
    {
      Case 0, "-", "S", "Small", "GuiSizeSmall":
        WinMove(ahkid(this.gui.hGui),, 1475, 21, 435, 420)
        this.gui.Size := "Small"
      Case 1, "+", "L", "Large", "GuiSizeLarge":
        WinMove(ahkid(this.gui.hGui),, 925, 42, 980, 960)
        this.gui.Size := "Large"
      Default:
        WinMove(ahkid(this.gui.hGui),, 1475, 21, 435, 420)
        this.gui.Size := "Small"
    }
  }

  Hide() {
    WinHide(ahkid(this.gui.hGUI))
  }

  ListArray(Title, array) {
   vOut := ""
   for key, value in array
     vOut .=  key ": " array[key] . this.opt.NL
   MB(0, Title, vOut)
  }

  Log(Text := "", Filename := "", TimeFormat := "", Overwrite := False ) {
    if IsEmpty(Filename)
      Filename := JoinPath(A_ScriptDir, "Debug.Log")
    if (Overwrite)
      FileDelete(Filename)
    if !IsEmpty(TimeFormat) {
      TimeTag := FormatTime(A_Now, TimeFormat)
      Text := TimeTag ": " Text
    }
    Text := Text this.opt.NL
    FileAppend(Text, Filename)
  }

  Out(pText) {
    This.Append(pText)
  }

  P(Text:="Press Resume to continue...") {
    this.Pause(Text)
  }

  Paste(pText) {
    Text .= this._AddTag(pText)
    EditPaste(this.gui.hEdit, Text)
  }

  PasteArray(Title, array) {
    this.Paste(Title ": ")
    for key, value in array
      this.Paste(key ": " array[key])
  }

  Pause(Text:="Press Resume to continue...") {
    this.Show()
    this.Append(Text)
    GuiControl("Show", this.gui.hResume)
    ControlSelect(this.gui.hResume, this.gui.hGui)
    this.gui.Paused:=True
    While (this.gui.Paused)
    {
      Sleep, 200
    }
  }

  SetText(pText) {
    this._WinActivate()
    this.Clear()
    vText .= pText . this.opt.NL
    ControlSetText(this.gui.hEdit, vText)
    ControlSend(this.gui.hEdit, "{Ctrl Down}{End}{Ctrl Up}")
  }

  Show() {
    WinShow(ahkid(this.gui.hGUI))
  }

  Splash(Title:="DEBUG", Text:="Note the Debug Gui", Duration:=4000, x:="Center", y:="Center", w:=180, h:=140) {
    Switch x
    {
      Case "Center":
        x := A_ScreenWidth  / 2 - (w/2)
        y := A_ScreenHeight / 2 - (h/2)
      Case "UL", "UpperLeft":
        x := 40
        y := 40
      Case "UR", "UpperRight":
        x := A_ScreenWidth  - ( w + 20 )
        y := 40
      Case "LL", "LowerLeft":
        x := 40
        y := A_ScreenHeight - ( w + 20 )
      Case "LR", "LowerRight":
        x := A_ScreenWidth - ( w + 20 )
        y := A_ScreenHeight - ( w + 20 )
   }
   SplashTextOn, %w%, %h%, %Title%, %Text%
   hSplash := WinGetID(Title)
   WinMove(ahkid(hSplash),, x, y)
   SetTimer("SplashTimerOff", Duration)
   this.gui.SplashOn:=True
   While (this.gui.SplashOn)
   {
     Sleep, 200
   }
   Return

  SplashTimerOff:
    SplashTextOff
    this.gui.SplashOn:=False
    Return
  }

  ;** Helper Functions

  _AddTag(pText) {
    this.opt.LineNumber++
    if (this.opt.LineNumber > 9999)
      this.opt.LineNumber := 1
    if (this.opt.Tag = "LineNumbers") {
      vText .= Format("{:0.4d}: {}", this.opt.LineNumber, pText)
    } else if (this.opt.Tag = "Timestamp") {
      FormatTime, vTime, Now, HH:mm:ss
      vText .= vTime "." Format("{:03d}",SubStr(A_TickCount ,-2)) ": " pText 
    } else if (this.opt.Tag = "DateTime") {
      FormatTime, vTime, Now, yyyy-MMM-dd HH:mm:ss
      vText .= vTime ": " pText
    } else {
      vText := pText
    }
    return vText
  }
 
  _GetThemeSettings(Theme) {
    ;Monotype fonts: Consolas, Lucida Console, Courier New
    ;NOTE: Hex Colors must start with "0x"
    Switch Theme
    {
      Case "Cmd":
        this.opt.WindowColor := "Default"
        this.opt.ControlColor := "0x0C0C0C" ;Hex Colors must start with "0x"
        this.opt.FontColor  := "0xF3F3F3"
        this.opt.FontName   := "Consolas"
       ;this.opt.FontSize   := this.opt.FontSize ; set by _ParseParams()
     Case "CRT":
       this.opt.WindowColor := "Default"
       this.opt.ControlColor := "0x0C0C0C"
       this.opt.FontColor  := "0x00d900"
       this.opt.FontName   := "Consolas"
     Case "PowerShell":
       this.opt.WindowColor := "Default"
       this.opt.ControlColor := "0x012456"
       this.opt.FontColor  := "0xF3F3F3"
       this.opt.FontName   := "Consolas"
     Default:
       this.opt.WindowColor := "Default"
       this.opt.ControlColor := "Default"
       this.opt.FontColor  := "Default"
       this.opt.FontName   := "Default"
    }
  } 

  _ParseParams(ParamsCSV) {
    Loop, Parse, ParamsCSV, CSV
    { 
      param := Trim(A_LoopField) 
      if (SubStr(param,1,1)="+")
        param := SubStr(param,2)
      if StrStartsWith(param, "FontSize") {
        this.opt.FontSize := SubStr(param,9)
        Continue
      }
      Switch param
      {
        Case "Small", "GuiSizeS", "GuiSizeSmall", "Large", "GuiSizeL", "GuiSizeLarge":
          this.opt.GuiSize := param
        Case "PowerShell", "Cmd", "Default":
          this.opt.Theme := param
        Case "Show", "Hide":
          this.opt.ShowHide := param
       Case "-Tag", "LineNumbers", "Timestamp", "DateTime":
         this.opt.Tag := param
       Default:
         this.opt.Title := param
     }
   }
  }

  _PauseHelp(Text:="Press HELP to continue...") { 
    this.Paste(Text)
    ControlSelect(this.gui.hResume, this.gui.hGui)
    this.gui.Paused:=True  
    While (this.gui.Paused)
    {
      Sleep, 200
    }
  }

  ;** Class Functions

  __New(ParamsCSV := "") {
 
    this.gui := {}
    this.opt := {}
 
Help_Pages:
;======================================================================
;----------------------------------------------------------------------

help_page_1 =
(Join`r`n

Help for Class_DebugGUI                                  (page 1 of 2)
======================================================================

Keyboard Shortcuts:
  Ctrl + NumpadAdd+ : Gui Size Large / Small (Toggle)
  Ctrl + NumpadSub- : Gui Size Small
  Escape            : Close Gui

Declaration: Debug := New DebugGUI("Option1, Option2, Option3, OptionN")
Example:     Debug := New DebugGUI("My Custom Title, Cmd, LineNumbers")

Parameters (CSV):

  Debug := new DebugGUI("
    , ALL OPTIONS:
      , GuiSizeLarge       Size   : Gui initial size Large
      , GuiSizeSmall       Size   : Gui initial size Small (DEFAULT)
      , LineNumbers        Tag    : 000001: The quick brown fox
      , Timestamp          Tag    : 24:59:59.999: The quick brown fox
      , DateTime           Tag    : 2021-12-30 24:59:59: The quick brown fox
      , -Tag               Tag    : No tags (LineNumbers, Timestamp, DateTime)
      , Default            Theme  : Windows default font and background colors
      , CMD                Theme  : White Font, Black Background
      , CRT                Theme  : Green Font, Black Background
      , Powershell         Theme  : White Font, Blue Background
      , FontSizeNN         Theme  : Set font size to integer NN, default is 12
      , Hide               Visible: Hide the Debug GUI
      , Show               Visible: Show the Debug GUI
      , My Custom Title    Title  : Default is "Debug GUI"
    , DEFAULT OPTIONS:     Duplicate options overwrite previous options
      , FontSize12
      , GuiSizeSmall
      , PowerShell
      , Show
      , -Tag
      , "Debug GUI")

Press HELP to continue...
)

help_page_2 =
(Join`r`n

Help for Class_DebugGUI                                  (page 2 of 2)
======================================================================
 
Functions:

  Append(Text) ; append text with CRLF

  Clear() ; clears text

  Close() ; close the Gui

  GuiSize(Option) ; "Small", "GuiSizeSmall", "Large", "GuiSizeLarge"

  ListArray(Title, Array) ; List array in a new GUI

  Log(Text:="", Filename:="", TimeFormat:="", Overwrite:=False )

  Out(Text) ; abbreviation for Append

  P(Text)   ; abbreviation for Pause

  Paste(Text) ; paste text (no CRLF)

  PasteArray(Title, Array) ; Paste array items e.g. 1: item

  Pause(Text:="Press Resume to continue...") ; waits for user button press

  SetText(Text) ; overwrites text (no CRLF)

  Splash(Title:="DEBUG", Text="Note the Debug Gui", Duration:=4000, w:=180, h:=140)

Press HELP to continue...
)"

Gui_Default_Params:
  
  this.opt.ControlColor := "Default"
  this.opt.FontColor    := "Default"
  this.opt.FontName     := "Default"
  this.opt.FontSize     := 12
  this.opt.GuiSize      := "Small"       ; "GuiSizeSmall, GuiSizeLarge"
  this.opt.LineNumber   := 0
  this.opt.NL           := "`r`n"
  this.opt.ShowHide     := "Show"        ; "Show, Hide"
  this.opt.Tag          := "-Tag"        ; "LineNumbers, Timestamp, DateTime"
  this.opt.Theme        := "PowerShell"  ; "Cmd, Default, PowerShell"
  this.opt.Title        := "Debug GUI"
  this.opt.WindowColor  := "Default"
  
  this._ParseParams(ParamsCSV)

  this._GetThemeSettings(this.opt.Theme)

  Gui_Create:

  static GuiName := "DEBUG:"
  
  hGUI     := Gui(GuiName "New", "+Resize +AlwaysOnTop", this.opt.Title)
              Gui("Font", "s" this.opt.FontSize "c" this.opt.FontColor, this.opt.FontName)
              Gui("Color", this.opt.WindowColor, this.opt.ControlColor)
  hEdit    := Gui("Add", "Edit", "w390 r15 -Wrap +HScroll")
              Gui("Font", "s9") ;button size to fit W050
  hResume  := Gui("Add", "Button", "y+m w120 h030 +Hidden Default", "&RESUME")
  hClear   := Gui("Add", "Button", "x+m w050 h030", "&Clear")
  hCopy    := Gui("Add", "Button", "x+m w050 h030", "C&opy")
  hHelp    := Gui("Add", "Button", "x+m w050 h030", "&Help")
  hExitApp := Gui("Add", "Button", "x+m w060 h030", "&ExitApp")

  Gui("+LastFound")  ; Set our GUI as LastFound window (affects next 3 lines)
  hICON := this._HICON()                      ; Create a HICON
  SendMessage, ( WM_SETICON:=0x80 ), 0, hIcon ; Set the Titlebar icon
  SendMessage, ( WM_SETICON:=0x80 ), 1, hIcon ; Set the Alt-Tab icon

Gui_Params:

  this.gui.AGui        := StrEndsWith(GuiName, ":") ? SubStr(GuiName,1,-1) : GuiName
  this.gui.hGUI        := hGUI
  this.gui.hEdit       := hEdit
  this.gui.hClear      := hClear
  this.gui.hCopy       := hCopy
  this.gui.hHelp       := hHelp
  this.gui.hExitApp    := hExitApp
  this.gui.hResume     := hResume
  this.gui.Paused      := False
  this.gui.SplashOn    := False
  this.gui.Size        := 0
  this.gui.Timer       := 0
  this.gui.HelpPage    := 1
  this.gui.help_page_1 := help_page_1
  this.gui.help_page_2 := help_page_2

  ;ok ListVars(1,,this.gui.hGUI , this.gui.hEdit, this.gui.hResume, this.gui.hClear, this.gui.hCopy, this.gui.hHelp, this.gui.hExitApp)

Gui_Show:

  Gui(GuiName "Show", "AutoSize")
  this.GuiSize("Small")
  
  if (this.opt.ShowHide="Hide")
   this.Hide()

Gui_Button_Handlers:

  buttonHandler_Resume  := ObjBindMethod(this, "_OnResume")
  buttonHandler_Clear   := ObjBindMethod(this, "_OnClear")
  buttonHandler_Copy    := ObjBindMethod(this, "_OnCopy")
  buttonHandler_Help    := ObjBindMethod(this, "_OnHelp")
  buttonHandler_ExitApp := ObjBindMethod(this, "_OnExitApp")

  GuiControl( hGui ":+g", this.gui.hResume, buttonHandler_Resume )
  GuiControl( hGui ":+g", this.gui.hClear, buttonHandler_Clear )
  GuiControl( hGui ":+g", this.gui.hCopy, buttonHandler_Copy)
  GuiControl( hGui ":+g", this.gui.hHelp, buttonHandler_Help )
  GuiControl( hGui ":+g", this.gui.hExitApp, buttonHandler_ExitApp)

  OnMessage(0x05,  ObjBindMethod(this, "_WM_SIZE"))
  OnMessage(0x112, ObjBindMethod(this, "_WM_SYSCOMMAND"))

Gui_Timer_Start:

  this.gui.Timer := {}
  this.gui.Timer := ObjBindMethod(this, "_OnTick")
  SetTimer(this.gui.Timer, 100)

 } ; End__New

  _OnTick() {
    if !WinActive(ahkid(this.gui.hGUI))
      Return
    if GetKeyState("Escape", "P") { 
      if WinActive(ahkid(this.gui.hGui))
        Gui, % this.gui.hGUI . ":Destroy"
    }
    if GetKeyState("Control", "P") And GetKeyState("NumPadAdd", "P") {
      this.gui.Size = "Large" ? this.GuiSize("Small") : this.GuiSize("Large")
      Return
    }
    if GetKeyState("Control", "P") And GetKeyState("NumPadSub", "P") {
      this.GuiSize("Small")
    }
  }

  _OnHelp() {
    if (this.gui.Size = "Small")
      this.GuiSize("Large")
    if (this.gui.HelpPage = 1) {
      EditSetText(this.gui.hEdit, this.gui.help_page_1)
      this.gui.HelpPage := 2
    } else {
      EditSetText(this.gui.hEdit, this.gui.help_page_2)
      this.gui.HelpPage := 1
    }
  }

  _OnClear() {
    EditClear(this.gui.hEdit)
  }

  _OnCopy() {
    ControlGetText, vText,, % "ahk_id " this.gui.hEdit
    if (StrLen(vText)=0) {
      ;this.Append("Nothing to copy")
      SoundBeep
      Return
    }
    prompt := ""
     . "Press YES to Copy and open in Notepad`n`n"
     . "Press NO to Copy and continue`n`n"
     . "Press CANCEL to skip copy and continue"
    MsgBox, 0x40023, % this.opt.Title, % prompt
    ClipboardSaved := Clipboard
    Clipboard := ""
    Clipboard := vText
    Clipwait, 1
    If (ErrorLevel) {
      MsgBox ERROR copying to Clipboard
    }
    IfMsgBox Cancel, {
      Clipboard := ClipboardSaved
      Return
    } else IfMsgBox NO, {
      Return
    } else {
      Run Notepad.exe
      Sleep, 100
      SendInput ^v
    }
  }

  _OnExitApp() {
    MsgBox, 0x40044, % this.opt.Title, Are you sure you want to ExitApp?
    IfMsgBox, No
      Return 1
    ExitApp
  }

  _OnResume() {
    this.gui.HelpPage := 1
    this.gui.Paused:=False
    GuiControl("Hide", this.gui.hResume)
    ControlSelect(this.gui.hResume, this.gui.hGui)
  }

   __Delete() {
    try Gui, % this.gui.hGUI . ":Destroy"
    this._Dispose()
   }

  _Dispose() {
    OnMessage(0x5, this.OnResize, 0)
    OnMessage(0x112, this.OnSysCommand, 0)
    buttonHandler_Clear  := ""
    buttonHandler_Close  := ""
    buttonHandler_ExitApp := ""
    buttonHandler_Resume  := ""
    SetTimer(this.gui.Timer, "Off")
    this.gui.Timer := ""
    this.theme := ""
    this.opt := ""
    this.gui := ""
  }

  _WM_SIZE(wParam, lParam) {
    static SIZE_MINIMIZED := 0x0001
    if (A_Gui != this.gui.AGui || wParam = SIZE_MINIMIZED)
      Return

    ;https://www.reddit.com/r/AutoHotkey/comments/i2r6d9/help_with_adding_guisize_inside_a_class/
    VarSetCapacity(rc, 16)
    DllCall("GetClientRect", "uint", this.gui.hGUI, "uint", &rc)
    GuiWidth := NumGet(rc, 8, "int")
    GuiHeight := NumGet(rc, 12, "int")

    GUIControl("Move", this.gui.hEdit,    "w" GuiWidth  - 35 "h" GuiHeight - 55)
    GUIControl("Move", this.gui.hResume,  "y" GuiHeight - 40)
    GUIControl("Move", this.gui.hClear,   "y" GuiHeight - 40)
    GUIControl("Move", this.gui.hCopy,    "y" GuiHeight - 40) 
    GUIControl("Move", this.gui.hHelp,    "y" GuiHeight - 40) 
    GUIControl("Move", this.gui.hExitApp, "y" GuiHeight - 40) 
    Return
  }
 
  _WM_SYSCOMMAND(wp, lp) {
    static SC_CLOSE := 0xF060
    if (A_Gui != this.gui.AGui || wp != SC_CLOSE)
      Return

    ;/*
      MsgBox, 0x40020, DebugGUI, Close the GUI?
      IfMsgBox, No
        Return 1
    ;*/
  
    Gui, %A_Gui%: Destroy
  
    this._Dispose()
  } 
 
  _HICON() { ; Reference Png2HICON.ahk 
  B64 := "
  (Join LTrim
  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
  )"
  DllCall("Crypt32.dll\CryptStringToBinary" . (A_IsUnicode?"W":"A"),UInt,&B64,UInt,StrLen(B64),UInt,1,UInt,0,UIntP,nBytes,Int,0,Int,0,"CDECL Int")
  VarSetCapacity(Bin,Req:=nBytes*(A_IsUnicode?2:1))
  DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",StrLen(B64),"UInt",0x1,"Ptr",&Bin,"UIntP",nBytes,"Int",0,"Int",0)
  Return hICON:=DllCall("CreateIconFromResourceEx","Ptr",&Bin,"UInt",nBytes,"Int",True,"UInt",0x30000,"Int",0,"Int",0,"UInt",0,"UPtr")
  }

} ;End_Class_DebugGUI

  ListVars(vars*){
    ;vars1:   0=single line, 1=multi-line, 2=No list: return single line, 3=return multi-line
    ;vars2:   Title of MsgBox
    ;vars3-N: Variables to List or Return
    ;Credit: lexikos https://www.autohotkey.com/boards/viewtopic.php?p=56458#p56458
    ex := Exception("", -1)
    FileReadLine line, % ex.File, % ex.Line
    RegExMatch(line, "i)" . ex.What . "\s*\(\K[^\)]*", Match)
    vNames := StrSplit(Match, ",")
    for key, value in vNames
      vNames[key] := Trim(value)
    MultiLine := False
    vTitle := "DEBUG"
    vOut := ""
    for index, item in vars {
      if (index = 1) {
        MultiLine  := (item = 1) Or (item = 3) ? True : False
        ReturnOnly := (item > 1) ? True : False
        Continue
      }
     if (index = 2) And (item != "") {
       Title := item
       Continue
     }
     if (item.MaxIndex()) {
       vArray := MultiLine ? "" : NL
       for i, v in item {
         if (i > 1)
           vArray .= Join(3, A_Space)
        temp := i ": " item[i]
        vArray .= i = item.MaxIndex() ? temp : temp . NL
       }
       item := vArray
     }
     vOut .= index - 2 . ": " . vNames[index] . " = "
     vOut := (Multiline) ? vOut . NL . Join(3, A_Space) . item . NL : vOut . item
     if(index != vars.length())
       vout .= NL
    }
    if (ReturnOnly) {
      vOut := vTitle != "" ? vTitle . ":" . NL . vOut : vOut
      Return vOut
    }
    MsgBox(0, vTitle, vOut)
  }
