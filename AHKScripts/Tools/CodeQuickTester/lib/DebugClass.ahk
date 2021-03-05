/**
	DebugClass_v1.1		Jim Dreher 12/20/2020
	Ref: DebugHelper.ahk from https://www.autohotkey.com/boards/viewtopic.php?f=6&t=37113
	
		Append
		Clear
		Close
		Hide
		MsgBox (always on top) *****set OK button as default, user can press escape but want to include enter
		SetText
		Show
		Var			"pVar=" pVar
		Out ; same as append
		MB ; same as MsgBox

	GuiEscape:	The GuiEscape handler won't trigger inside a class, you have to build a custom event handler
							Instead, put the following hotkey in the main thread creating the gui class:
								Escape::
								ExitApp


DOESN'T WORK:		debugSave .= "Parent number " A_Index
		D.Append("debugSave=" debugSave)
		D.Var("debugSave")

		when a lot of text, append will add at bottm but doesn't scroll up so we can see the last line.

pTest:="this is a test"
Msgbox % MySpecialFunction("pTest")
ExitApp

MySpecialFunction(var)
{
	return var " : " (%var%)
}

D:=NEW DEBUG
T:=""
lOOP, 8096
{
	T .= "THE RAIN IN SPAIN " A_Index "`r`n"
}
D.SETTEXT(T)
MsgBox
ExitApp

d:=new debug
d.mb("hello world")
ExitApp


*/	
;#Include D:\Software\DEV\Programs\AHK\AutoGUI\Tools\CodeQuickTester\lib\DebugClass.ahk

global Edit1
global hEdit1
;global DebugGui

Class Debug
{
	;** static variables
	static DebugGui
	static hGui
	static LineNumber
	static Options:=""
	;static ValidOptions:="ThemePowerShell, ThemeCmd, ThemeDefault, LineNumbers, Time" ; be careful not to duplicate an option example: "DateTime" will match "Time"

	_Init()
	{
	
		SysGet, Mon, Monitor
		PAD:=5
		Ew:=400, Eh:=MonBottom
		Gx:=MonRight-Ew-(PAD*5) , Gy:=MonTop
		Gx:=MonRight/2 , Gy:=MonTop
		FS:=11
		
		;Menu, tray, Icon , debug.ico, 1, 1 ; optional
		
		Gui, DebugGui:New ,  +hwndhGui +Resize +AlwaysOnTop, % this.Title

		if (this.IsOptionSet("ThemePowerShell")) {
			Gui, Color, 012456, 012456
			Gui, Font, q5 cF3F3F3 s%FS%, Consolas ;Consolas, Lucida Console, Courier New
		} else if (this.IsOptionSet("ThemeCmd")) {
			Gui, Color, 0C0C0C, 0C0C0C
			Gui, Font, q5 cF3F3F3 s%FS%, Consolas ;Consolas, Lucida Console, Courier New
		} else {
			Gui, Color, Default, Default
			Gui, Font, q5 cDefault s%FS% bold, Courier New ;q5
		}

		Gui, Add, Edit, -Wrap +HScroll x0 y0 w%Ew% h%Eh% hwndhEdit1 vEdit1 
		
		Gui, Show,  x%Gx% y%Gy%
		
		this.hGui := hGui
		WinSet, Disable ,, hGui
		
	}
	
	;** Class Functions
	
	Append(pText)
	{
		ControlGetText, vText,, % "ahk_id " hEdit1

		;**todo test:
		;vText .= this.AddTag(PText)
		
		vText .= PText "`r`n"
		ControlSetText,, % vText, % "ahk_id " hEdit1
		ControlSend, , {End}, ahk_id %hEdit1%
		;https://autohotkey.com/board/topic/87514-sendmessage-scroll-down-a-certain-number-of-lines/
		;EM_LINESCROLL := 0xB6
		;PostMessage, EM_LINESCROLL, 0, 4096-1, , ahk_id %hEdit1% ; 'lines-1' makes the line you wish to jump to visible
	}
	
	Clear() {
		this.LineNumber:=0		
		ControlSetText,,, % "ahk_id " hEdit1
	}
	
	Close() {
		PostMessage, 0x112, 0xF060,,, % "ahk_id " this.hGui ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
	}
	
	Hide() {
		Gui, Hide
	}

	MB(pText:="Press OK to continue.")
	{
		This.MsgBox(pText)
	}

	MsgBox(pText:="Press OK to continue.")
	{
		MsgBox, 262144, Debug, %pText% ; 262144=AlwaysOnTop
	}

	Out(pText) {
		This.Append(pText)		
	}

	SetText(pText)
	{
		this.LineNumber:=0		
		vText .= this.AddTag(pText)
		;ok vText:="this is another test"
		ControlSetText,, % vText, % "ahk_id " hEdit1
		;https://autohotkey.com/board/topic/87514-sendmessage-scroll-down-a-certain-number-of-lines/
		EM_LINESCROLL := 0xB6
		PostMessage, EM_LINESCROLL, 0, 4096-1, , ahk_id %hEdit1% ; 'lines-1' makes the line you wish to jump to visible

	}

	Show() {
			Gui, DebugGui:Show ; ,  x%Gx% y%Gy%
	}

	Var(pVar)
	{
		;VarText:=pVar
		VarValue:=VarText + 0
		VarText:=pVar
		This.Append(VarText "=" %VarValue%)
	}

	;** helper functions
	
	AddTag(pText)
	{
		this.LineNumber++		
		if (this.IsOptionSet("LineNumbers")) {
			vText .= Format("{:0.2d}: {}`r`n", this.LineNumber, pText)
		} else if (this.IsOptionSet("Time")) {
			FormatTime, vTime, Now, HH:mm:ss
			vText .= vTime "." Format("{:03d}",SubStr(A_TickCount ,-2)) ": " pText ; "`r`n" 		
		} else if (this.IsOptionSet("DateTime")) {
			FormatTime, vTime, Now, yyyy-MMM-dd HH:mm:ss
			vText .= vTime ": " pText ; "`r`n"
		} else {
			vText := pText ; "`r`n"
		}
		return vText
	}
	
	IsOptionSet(pOption) {
		;ValidOptions:="ThemePowerShell, ThemeCmd, ThemeDefault, LineNumbers, Time"
		if ( InStr(this.Options, pOption)=0 )	;** todo err msg
			Return false
		Return true
	}

    __New(pOptions:="ThemePowerShell, LineNumbers", pTitle:="Debug Window")
    {
		this.Options:=pOptions	
		this.Title := pTitle
		this.LineNumber:=0		
		this._Init()
    }
     __Delete()
    {
        ; ok MsgBox __Delete called!
    } 	
}

;** DebugWindow events

DebugGuiGuiSize(GuiHwnd, EventInfo, Width, Height)
{
	; The window has been minimized.  No action needed.
	if(EventInfo <> 1)
	{
		Gui, DebugGui:Default
		GuiControl, Move, Edit1, % "H" . (Height) . " W" . (Width)
	}
	return
}

;STOP:
;Gui, STOP:New, +HwndhGuiSTOP +AlwaysOnTop +ToolWindow +Owner
;gui, add, text, , STOP
;gui, add, button, Default xm gContinue w40, Continue
;gui, add, button, x+10 gNo w40, No
;gui, show, x20 y120, STOP ; w100 h80
;SoundBeep
;SoundBeep
;SoundBeep
;Sleep, 2147483647
;return