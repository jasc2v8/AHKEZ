; AHK v1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Global IconSelectIndex, IconSelectInputHook, IconIndexArray ; IconSelectStandalone ; IconSelectFile

; ================================================================
; EXAMPLE
; ================================================================
Gui, New,, Icon Picker Test
;Gui, Show, w600 h600 x100 y100
Gui, Show, w10 h10 x10 y10
WinWaitActive, Icon Picker Test
WinGet, hWin, ID, Icon Picker Test

i := "%SystemRoot%\system32\shell32.dll"
oIcon := IconSelectGui(i,hWin)

If (oIcon.handle)
	msgbox % "Index: " oIcon.index "`r`nHandle: " oIcon.handle "`r`ntype: " oIcon.type "`r`nfile: " oIcon.file

ExitApp
; ================================================================
; Parameters
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
; sIconFile = used to save selected icon file
; outputType = "index" or "handle"
; ================================================================
; returns object with properties:
;    type, handle, index, file
IconSelectGui(sIconFile := "",hwnd:=0) {
	Global
	
	IconSelectFileList := "%SystemRoot%\explorer.exe|"
		  . "%SystemRoot%\system32\accessibilitycpl.dll|"
		  . "%SystemRoot%\system32\ddores.dll|"
		  . "%SystemRoot%\system32\gameux.dll|"
		  . "%SystemRoot%\system32\imageres.dll|"
		  . "%SystemRoot%\System32\mmcndmgr.dll|"
		  . "%SystemRoot%\system32\mmres.dll|"
		  . "%SystemRoot%\system32\mstscax.dll|"
		  . "%SystemRoot%\system32\netshell.dll|"
		  . "%SystemRoot%\system32\networkmap.dll|"
		  . "%SystemRoot%\system32\pifmgr.dll|"
		  . "%SystemRoot%\system32\SensorsCpl.dll|"
		  . "%SystemRoot%\system32\setupapi.dll|"
		  . "%SystemRoot%\system32\shell32.dll|"
		  . "%SystemRoot%\system32\UIHub.dll|"
		  . "%SystemRoot%\system32\vpc.exe|"
		  . "%SystemRoot%\system32\wmp.dll|"
		  . "%SystemRoot%\system32\wmploc.dll|"
		  . "%SystemRoot%\system32\wpdshext.dll|"
		  . "%SystemRoot%\system32\wucltux.dll|"
		  . "%SystemRoot%\system32\xpsrchvw.exe"
	
	Loop Parse, IconSelectFileList, |
	{
		sillyFile := StrReplace(A_LoopField,"%SystemRoot%",A_WinDir)
		If (FileExist(sillyFile))
			newList .= sillyFile "|"
	}
	newList := Trim(newList,"|")
	IconSelectFileList := newList
	
	IconSelectIndex := ""
	hwndStr := WinActive("ahk_id " hwnd) ? " +Owner" hwnd : ""
	
    Gui, IconSelect:New, +LabelIconSelect -MaximizeBox -MinimizeBox%hwndStr%, List Icons
    Gui, IconSelect:Add, Text, , File:
    Gui, IconSelect:Add, ComboBox, x+m yp-3 w420 gIconSelectSelFile, %IconSelectFileList% ; Edit1 / vIconSelectFile
	GuiControl, IconSelect:Text, Edit1, % sIconFile
	
    Gui, IconSelect:Add, Button, x+m yp w20 gIconSelectSelFileBtn, ... ; Button1
    ;Gui, IconSelect:Add, ListView, xm w480 h220 Icon gIconSelected, Icon ; SysListView321 / gIconSelectResult
    Gui, IconSelect:Add, ListView, xm w1024 h640 Icon gIconSelected, Icon ; SysListView321 / gIconSelectResult
	Gui, IconSelect:Add, Button, x+-150 y+5 w75 gIconSelected, OK
	Gui, IconSelect:Add, Button, x+0 w75 gIconSelectClose, Cancel
    
	If (WinActive("ahk_id " hwnd)) {
		WinGetPos, x, y, w, h, % "ahk_id " hwnd
		x2 := x + (w / 2) - (261 * (A_ScreenDPI / 96))
		y2 := y + (h / 2) - (149 * (A_ScreenDPI / 96))
		params := "x" x2 " y" y2 ; " w1024 h640"
		;Gui, IconSelect:Show, %params%
		Gui, IconSelect:Show, center
	} Else
		Gui, IconSelect:Show
	
	If (sIconFile)
		IconSelectListIcons(sIconFile)
	
	IconSelectInputHook := InputHook("V") ; "V" for not blocking input
	IconSelectInputHook.KeyOpt("{Escape}","N")
	IconSelectInputHook.OnKeyDown := Func("IconSelectInputHookKeyDown")
	IconSelectInputHook.Start(), IconSelectInputHook.Wait()
	
	GuiControlGet, sIconFile, IconSelect:, Edit1 ; save sIconFile
	sIconFile := StrReplace(sIconFile,"%SystemRoot%",A_WinDir)
	
	oOutput := {}
	If (IconSelectIndex) {
		oOutput := IconIndexArray[IconSelectIndex]
		oOutput.file := sIconFile
	} Else {
		oOutput.index := 0
		oOutput.type := ""
		oOutput.handle := 0
		oOutput.file := ""
	}
	
	IconIndexArray := ""
	Gui, IconSelect:Destroy
	
	return oOutput
}

IconSelectInputHookKeyDown(iHook, VK, SC) { ; input hook ESC event
	IconSelectIndex := 0
	IconSelectInputHook.Stop()
}

IconSelectClose(Hwnd) { ; GUI close sys button
	IconSelectIndex := 0
	IconSelectInputHook.Stop()
}

IconSelectSelFile(CtrlHwnd, GuiEvent, EventInfo) { ; pick file from ComboBox
	If (GuiEvent = "Normal") {
		GuiControlGet, IconSelectFile,, Edit1
		IconFile := StrReplace(IconSelectFile,"%SystemRoot%",A_WinDir)
		IconSelectListIcons(IconFile)
	}
}

IconSelectSelFileBtn() { ; pick file from SelectFile dialog
	FileSelectFile, IconFile, , C:\Windows\System32, Select an icon file:
	If (IconFile) {
		GuiControl, IconSelect:Text, Edit1, % IconFile ; |%IconFile%||%IconSelectFileList%
		IconSelectListIcons(IconFile)
	}
}

IconSelectListIcons(IconFile) { ; list icons after picking file
	IconFile := StrReplace(IconFile,"%SystemRoot%",A_WinDir)
	If (FileExist(IconFile)) {
		IconIndexArray := Object()
		
		Gui, IconSelect:Default
		Gui, ListView, SysListView321
		LV_Delete()
		Gui, ListView, -Redraw
		ImgList := IL_Create(400,5,1), tryAgain := 10
		LV_SetImageList(ImgList,0)
		
		Progress, R1-300 FS8 FM8,,,Loading Icons...
		Progress, 1
		MaxIcons := 0
		Loop {
			Progress, %A_Index%
			handleType := ""
			hPic := LoadPicture(IconFile,"Icon" A_Index,handleType)
			prefix := !handleType ? "HBITMAP" : ((handleType = 2) ? "HCURSOR" : "HICON")
			
			IconIndexObj := {}
			IconIndexObj.type := prefix
			IconIndexObj.handle := hPic
			IconIndexObj.index := A_Index
			IconIndexArray[A_Index] := (IconIndexObj)
			IconIndexObj := ""
			
			result := IL_Add(ImgList,prefix ":" hPic)
			dll := DllCall("DestroyIcon", "ptr", hPic)
			
			If (result)
				MaxIcons++
			Else If (tryAgain)
				tryAgain -= 1, IL_Add(ImgList,"shell32.dll",50) ; add blank icon if needed
			Else
				Break
		}
		
		Loop % MaxIcons {
			Progress, %A_Index%
			LV_Add("Icon" A_Index,A_Index)
		}
		Progress, Off
		
		Gui, ListView, +Redraw
	} Else
		Msgbox % "Invalid file selected."
}

IconSelected(CtrlHwnd, GuiEvent, EventInfo) { ; selected by double-click or OK button
	Gui, IconSelect:Default
	Gui, ListView, SysListView321
	CurRow := LV_GetNext()
	LV_GetText(IconSelectIndex,CurRow)
	IconSelectInputHook.Stop()
}