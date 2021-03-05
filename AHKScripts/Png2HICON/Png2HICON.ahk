;2021-03-01-03:56:PM
/*
	Title:
		Image2HICON.ahk
	About:
		Create an HICON from a PNG image which will internally create a bitmap/icon
		Sets the HICON in the Gui: Titlebar and Alt-Tab Icons
		Designed for PNG images 32x32 or 48x48, and up to 32bit True Color		
		Encodes image to Base64, copies to clipboard, option to append to ahk script
	AHK version: 1.1.10.01 (U64)
	Script version: 1.0.0/2021-03-01/jasc2v8
	Version history:
    0.0.11/2021-03-01/jasc2v8
	Legal:
	  Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
	Credits:
		Image2Include by just me:
			https://gist.github.com/AHK-just-me/5559658#file-image2include-ahk
		Bitmap creation based on work by SKAN:
			http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
		VarSetCapacity( Bin, Req := nBytes * ( A_IsUnicode ? 2 : 1 ) ) by lifeweaver:
			https://www.autohotkey.com/boards/viewtopic.php?p=49863#p49863
*/
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>
; ** Start Auto-execute Section

#Include <AHKEZ_DEBUG>

DefaultPNG := "\png\Image2HICON_32_32bit.png"
DefaultAHK := "\Png2HICON_Template - Copy.ahk"

#NoTrayIcon
EW := 600
BW := 80
Gui("Font", "s12", Segoe UI)
Gui("Add", "Text", "xm cNavy", "Select PNG and AHK Files, then press OK to add HICON to AHK file:")
hEditPngFile 		:= Gui("Add", "Edit", "xm w" EW " +ReadOnly", DefaultPNG)
hBtnSelectPng		:= Gui("Add", "Picture", "x+m yp-12 hp gSelectPNG w48 h48 Icon130", "C:\Windows\System32\Shell32.dll")
									 Gui(Add, Text, "xm y+15 cNavy", "Select AHK File:")
hEditAhkFile		:= Gui("Add", "Edit", "xm y+5 w" EW " +ReadOnly", DefaultAHK)
hBtnSelectAhk		:= Gui("Add", "Picture", "x+m yp-12 w48 h48 gSelectAHK Icon127", "C:\Windows\System32\Shell32.dll")
hBtnClean				:= Gui("Add", "Button", "xm y+m w" BW, "Clean")
hBtnViewAhk			:= Gui("Add", "Button", "x+m w" BW, "View AHK")
hBtnOK					:= Gui("Add", "Button", "x+m Default w" BW, "OK")
hBtnCancel			:= Gui("Add", "Button", "x+m yp  w100", "Cancel")
									 Gui("Add", "StatusBar",,"Select PNG file:")
									 SB_SetIcon("Shell32.dll", 222)
									 Gui("Show", "AutoSize", "Convert PNG to Base64 HICON")

ControlSelect(hBtnOK) ;unselect text in Edit control

;Control("Hide",,, ahkid(hBtnSelectAhk))
;Control("Disable",,, ahkid(hBtnSelectAhk))
;Control("Disable",,, ahkid(hBtnViewAhk))
;Control("Disable",,, ahkid(hBtnOK))

Gui("+LastFound")                       ; Set our GUI as LastFound window (affects next two lines)
hICON := _HICON()                				; Create a HICON
SendMessage(WM_SETICON:=0x80, 0, hIcon)	; Set the Titlebar icon
SendMessage(WM_SETICON:=0x80, 1, hIcon) ; Set the Alt-Tab icon
Gui("Show")

if FileExist(JoinPath(A_ScriptDir,DefaultPNG)) {
	Clipboard := DoEncode(PngFile)
	SoundPlay("*64")
	SB_SetText("Base64 copied to Clipboard. Select AHK Script file:")
} else {
	EditClear(hBtnSelectPng)
}

Return 

ButtonClean:
	MsgBox(0x31, "Clean Copies", "Press OK to delete copies of the Template")
	IfMsgBox OK, {
		FileDelete("Png2HICON_Template - Copy*.ahk")
		FileCopy("Png2HICON_Template.ahk","Png2HICON_Template - Copy.ahk")
		SB_SetText("Template copies deleted and a new Template copy created.")
	} Else IfMsgBox Cancel, {
		SB_SetText("Action canceled. No files deleted.")
	}

Return

SelectPNG:
	Filter := "PNG Images (*.png)"
	PngFile := FileSelectFile(3, , "Select a file", Filter) ; 3=1: File Must Exist + 2: Path Must Exist
	if IsEmpty(PngFile) {
			SB_SetText("No file selected.")
			Return
	}
	if (FileGetSize(PngFile) > 10000) {
		SoundBeep
		SB_SetText("Max PNG size is 10KB.")
		Return
	}
	Clipboard := DoEncode(PngFile)

	PngFileRelative := StrReplace(PngFile, A_ScriptDir)

;ListVars(1,,A_ScriptDir, A_ScriptFullPath, PngFileRelative)

	ControlSetText(,PngFileRelative, ahkid(hEditPngFile))
	
	SoundPlay("*64")
	SB_SetText("Base64 copied to Clipboard. Select AHK Script file:")
	;Control("Show",,, ahkid(hBtnSelectAhk))

Return

SelectAhk:
	AhkFile := FileSelectFile(3, , "Select a file", "AHK Scripts (*.ahk)")
	if IsEmpty(AhkFile) {
		SoundBeep
		SB_SetText("No file selected.")
		Exit
	}
	if SplitPath(AhkFile).Filename = "Png2HICON_Template.ahk" {
		SoundBeep
		SB_SetText("Please make a copy of the Template, then select the copy.")
		Exit
	}
	
	if SplitPath(AhkFile).FileName = "Image2HICON.ahk" {
			;too many _HICON references to resolve in this script, change the B64 encoded text manually
			SoundBeep
			SB_SetText("Manually paste the Clipboard to the HICON section of this script: Image2HICON.ahk")
			Return
	}
	AhkFileRelative := StrReplace(AhkFile, A_ScriptDir)

;ListVars(1,,A_ScriptDir, A_ScriptFullPath, AhkFileRelative)

	ControlSetText(,AhkFileRelative,ahkid(hEditAhkFile))
	SB_SetText("Press OK to Append HICON to AHK:")
	;Control("Enable",,, ahkid(hBtnViewAhk))
	;Control("Enable",,, ahkid(hBtnOK))
Return

ButtonOK:
	SB_SetText("")
	;SelectedPNG := vSelectedPNG
	;SelectedAHK := vSelectedAHK
	SelectedPNG := JoinPath(A_ScriptDir, EditGetText(hEditPngFile))
	SelectedAHK := JoinPath(A_ScriptDir, EditGetText(hEditAhkFile))

	;ListVars(1,,SelectedPNG, SelectedAHK)

	if IsEmpty(SelectedPNG) Or IsEmpty(SelectedAHK) {
		SoundBeep
		SB_SetText("Select files then press OK.")
		Exit
	}
	Gui, Submit, NoHide
	B64 := DoEncode(SelectedPNG)
	Script := DoCreateScript(B64)
	DoUnAppend(SelectedAHK, "_HICON() {")
	DoAppend(SelectedAhk, Script)
	SB_SetText("Appended.")
	;Control("Enable",,, ahkid(hBtnViewAhk))
	SoundPlay, *64 ; 64=Asterisk (info) Same as Simple Beep
Return

ButtonViewAhk:
	SB_SetText("Ready.")
	SelectedAHK := JoinPath(A_ScriptDir, EditGetText(hEditAhkFile))
	if !FileExist(SelectedAHK) {
		SoundBeep
		SB_SetText("AHK file doesn't exist.")
		Exit
	}
	Run edit %SelectedAHK%
Return

ButtonCancel:
GuiEscape:
Gui, Destroy
ExitApp

DoAppend(SelectedAhk, Script) {
	TimeStamp := FormatTime(Now, "yyyyMMddhhss")
	BackupAhk := SelectedAhk  "_" TimeStamp ".ahk"
	FileCopy(SelectedAhk, BackupAhk)
	Buffer := FileRead(SelectedAhk)


	;Buffer := RTrimBeforeNL(Buffer) . RTrimBeforeNL(Script)	
	Buffer := RTrim(Buffer) . RTrim(Script)	


	FileWrite(Buffer, SelectedAhk, "-Prompt")
}

DoUnAppend(File, AppendStart) {
	UnAppending := False
	OutBuffer := ""
	Buffer := FileRead(File)
	Loop, Parse, Buffer, `n, `r
	{
		if (InStr(A_LoopField, AppendStart) != 0) {
			UnAppending := True
			Continue
		}
		
		if ( (UnAppending) and (InStr(A_LoopField, "}")!=0) ) {			
			UnAppending := False
			Continue
		}
		
		if (UnAppending) {
			Continue			
		}
			
		OutBuffer .= A_LoopField "`r`n"
	}
;Clipboard := OutBuffer
;MB("Clipboard=OutBuffer")
;Clipboard := RTrim(OutBuffer, " `r`n`t")
;MB("Clipboard=RTrim(OutBuffer)")

	OutBuffer := RTrim(OutBuffer, " `r`n`t")
	FileWrite(OutBuffer, File, "-Prompt")
	Return OutBuffer
}

DoEncode(PngFile) {

	File := FileOpen(PngFile, "r")
	nBytes := File.Length
	File.RawRead(Bin, nBytes)
	File.Close()

	;Option for longer line length
	;	Global MaxLineLen := 16000 ; The maximum length of each line in a script is 16,383 characters
	;	LeadingSpaces := 0
	;	B64 := Base64Enc(Bin, nBytes, MaxLineLen, LeadingSpaces := 0 ) ;all B64 chars on one line
	
	B64 := Base64Enc(Bin, nBytes, LineLength:=128, LeadingSpaces := 2 ) ; 128 chars per line with 2 leading zeros
	Clipboard := B64
	Return B64
}

DoCreateScript(B64) {
	 
	Buffer =
	
	header =
	(Join`n LTrim
	
	_HICON() { 	; Reference Png2HICON.ahk
	
		; Move the following up in the script before the Gui, Show command:
		;	  hIcon := _HICON()                           ; Create a HICON from the embedded Base64 image
		;	  Gui +LastFound                              ; Set our GUI as LastFound window (affects next two lines)
		;	  SendMessage, ( WM_SETICON:=0x80 ), 0, hIcon ; Set the Titlebar Icon
		;	  SendMessage, ( WM_SETICON:=0x80 ), 1, hIcon ; Set the Alt-Tab icon
		;	  Gui, Show
		;Leave this _HICON function at the end of the script
		
	B64 := "
	(Join LTrim

	)
	Buffer .= header
	
	Buffer .= B64

	function = 
	(Join`n LTrim
	
	`)"
		DllCall("Crypt32.dll\CryptStringToBinary" . (A_IsUnicode?"W":"A"),UInt,&B64,UInt,StrLen(B64),UInt,1,UInt,0,UIntP,nBytes,Int,0,Int,0,"CDECL Int")
		VarSetCapacity(Bin,Req:=nBytes*(A_IsUnicode?2:1))
		DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",StrLen(B64),"UInt",0x1,"Ptr",&Bin,"UIntP",nBytes,"Int",0,"Int",0)
		Return hICON:=DllCall("CreateIconFromResourceEx","Ptr",&Bin,"UInt",nBytes,"Int",True,"UInt",0x30000,"Int",0,"Int",0,"UInt",0,"UPtr")
	}
	) 
	Buffer .= function	
	Return Buffer
}

Base64Enc( ByRef Bin, nBytes, LineLength := 64, LeadingSpaces := 0 ) { ; By SKAN / 18-Aug-2017
	Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1  ; CRYPT_STRING_BASE64 := 0x1
  DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin ,"UInt",nBytes, "UInt",0x1, "Ptr",0,   "UIntP",Rqd )
  VarSetCapacity( B64, Rqd * ( A_Isunicode ? 2 : 1 ), 0 )
  DllCall( "Crypt32.dll\CryptBinaryToString", "Ptr",&Bin, "UInt",nBytes, "UInt",0x1, "Str",B64, "UIntP",Rqd )
  If ( LineLength = 64 and ! LeadingSpaces )
    Return B64
  B64 := StrReplace( B64, "`r`n" )        
  Loop % Ceil( StrLen(B64) / LineLength )
    B .= Format("{1:" LeadingSpaces "s}","" ) . SubStr( B64, N += LineLength, LineLength ) . "`n" 
Return RTrim( B,"`n" )    
}

_HICON() {
B64 := "
(Join LTrim
  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
  RFCrZB1xiwKzAbXpPwFGfZxygLO2k7aNncl0QPco1YGPselTtFf/npWZfx85WJwuDVf/QgJzVHpNwNFoWCzsW47kmadXFn8xhHl+kKAQIvsMDAjdT6/Vqndea7tW7K8R
  4HJAbfo48Hag0GG3d9tejSsQo/YC2cYjNGa/y/LZ08OTtQPlsfqXTRC8S3whhvH3q+ZMTISlqNpSPfPM2uorq2RP1wguFjEl4wrJHg2I+G3bx9Ms8I8h8G1gCbgf1zIG
  PUAT0BZoE5tlaBajuo6mc7SvP8Xa+edJGq3SyNBwZXzksyYM7hMRUVUIDfKWUYhT9OIKahURCYNC+IGhfaOzyVrze2fWmqsztB9/DwO/fSvFOyvI+BCBDLrSbBDXg1Rx
  fUAuzdTjfQL4sfhOrIxr5yp0Z/g4BohRG7N+pUhzbpi0BWkzQdM0t46xu45+pDhY/poYM6I+UpojezD3H4Y4JXviPPr69dycsNZeba02/mZx5vx/0m1oFGhXkfm/ZjSO
  MAUPvMDm0YubHfgBQJ5Cm8BrN4zBi2dApI5revKhrq3uH52MKqVPIDKCz5QyXsWc3I8MlUAVc88Bso3zripCEZG9UXXgk+Xx+nPN+ZUlv14LWFzjxMY33cQ98+duSCEX
  f+y+7dYT57+7LHPdP6yeM1+qVY+JCd4mIi7Vl0LMXRPIeBXxXmcmh+H4BNmvX0OTDBEREwbHB+qDR5rzKwu48coi0BSe+d8wb2FgK9AbUwYse9PaA0QmDMcRPw5RkLEq
  cqiOGNMpOSQQ5HAdeXEenV/3QUyqQVQY9aawDGzcFPJtDLxxssA1IBYjNRMGkVvHhVmpREgUdLWWh75iASpFemZXUThQDMSYebU2uRXw0N9sdKM+fXAxKBZcP5G7fRRs
  LuTzr6FAcdMYtBAUwuDQgyfSPjD0N52ujtcDXPw2LvoIFIKdBzkiSBj4qSiIiAGKmtlujX0L1O/7gQgXr/1q4sxnt7IyMECnKXGv1PrE0C8DBVzu8D0gTgM7kQDBtiFJ
  dLsZ2PKiTpyUd6vrZdvRjrXKzdCb+pKvC0m2G3VPRPK09XXa/wMGrKKLDeyrbhYiAmqk06zrWrvDp6eMPt+T9cuAe3PUw4B9YQFeXnLHeYmeV7/xpu5VcRn4tjLQxmVR
  7VShSbYVaJdcBs6PWrghbV8M9OvE67iy9opnwm1ml02kd055AfdfK31RX28Ihw9NgGssDDCBG303cXVN2x8nbLZ1BS4C3wEee+2JZ2+5jAD4H9A7Z4SpjdUaAAAAJXRF
  WHRkYXRlOmNyZWF0ZQAyMDEwLTA2LTA5VDE3OjM2OjM5LTA2OjAwpntVmwAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMC0wNi0wOVQxNzozNjozOS0wNjowMNcm7ScAAAAt
  dEVYdExpY2Vuc2UAVmFyaW91cywgc2VlIGRvY3MvQVVUSE9SU19hcHAtaW5zdGFsbMjQbocAAAAZdEVYdFNvZnR3YXJlAHd3dy5pbmtzY2FwZS5vcmeb7jwaAAAAF3RF
  WHRTb3VyY2UAYXBwLWluc3RhbGwtZGF0Yaa4D0YAAAA8dEVYdFNvdXJjZV9VUkwAaHR0cDovL3BhY2thZ2VzLmRlYmlhbi5vcmcvbGVubnkvYXBwLWluc3RhbGwtZGF0
  YRmznPIAAAAASUVORK5CYII=
)"
DllCall("Crypt32.dll\CryptStringToBinary" . (A_IsUnicode?"W":"A"),UInt,&B64,UInt,StrLen(B64),UInt,1,UInt,0,UIntP,nBytes,Int,0,Int,0,"CDECL Int")
VarSetCapacity(Bin,Req:=nBytes*(A_IsUnicode?2:1))
DllCall("Crypt32.dll\CryptStringToBinary","Str",B64,"UInt",StrLen(B64),"UInt",0x1,"Ptr",&Bin,"UIntP",nBytes,"Int",0,"Int",0)
Return hICON:=DllCall("CreateIconFromResourceEx","Ptr",&Bin,"UInt",nBytes,"Int",True,"UInt",0x30000,"Int",0,"Int",0,"UInt",0,"UPtr")
}
