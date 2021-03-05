﻿#SingleInstance, force
/*
  2021-03-03_03:11:PM by jasc2v8
    Add FileDelete, %A_Temp%\aria-debug*.log (apparently from VSCode?)
    Add Pause:: Send ^J to close output window in VSCode (code.exe)
    Add DateFormats yyyy-MM-dd_hh:mm:tt ;My Format - 12hr clock
    Add #SingleInstance, force
    Mod Change "Edit QuickLinks" to "Open QuickLinks"
    Mod QL_LinksHandler: Add multiple files
*/
;
; February 6, 2020 QuickLinksTimeDateSubMenuSwitch
;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Jack Dunning <ComputorEdge@gmail.com>
;
; Script Function:
;  Create a menu for quick launching program shortcuts and links by categories (folders).
; Date: January 14, 2013
; Updated: August 8, 2017 This version is the most recent version including a function for adding icons to the menu items.
/*
September 26, 2017

Win+Z, Alt+, (comma), and CTRL+right-click all open the QuickLinks menu. I personally use
XButton1 (left extra mouse button) to activate the menu, but I needed to override the built-in
setting in the software for my mouse by adding one of the other hotkey combinations.

This updated version of QuickLinks includes a number of new features.

1. Icons are added to the menu in different ways.

First, you find the function, AddIcon(TopMenu,SubMenu), for adding icons to the top-level
folders and specific shortcuts on the second level.

Second, specific IfInString command lines change/insert specific types of icons.

Third, program icons are drawn directly from EXE files.

Fourth, you can manually change shortcut icon (.lnk) in Windows (File) Explorer which
then automatically appear in the menu. This does not work for Web links (.url).

Caution: If you have previously setup personalized icon statements in your version of QuickLinks,
be sure to copy and transfer that icon setting code to this version. Otherwise, they may be
overwritten. (In other words, backup your old copy of QuickLinks.ahk before overwriting it.)

2. QuickLinks now includes the secret Windows Tools (God Mode) link in the Tools folder for quick access
to over 200 Windows settings and features. This feature automatic renews if deleted. If you don't 
want it then delete the code which adds it.

Note: When editing shortcuts in Windows (File) Explorer, the name of the Windows Tools shortcut
appear blanks. Do not edit or add a different name. That process will disable the shortcut.

3. With the exception of the above Windows Tools folder, QuickLinks only launches .lnk and .url shortcuts.

4. You can now directly add new links to the menu by selecting a file in Windows (File) Explorer or the 
address bar (URL) of a Web page and selecting Add Links with the appropriate submenu from your QuickLinks
menu. You may want to later edit the shortcut in Windows (File) Explorer to change the name and possibly
add a shortcut icon. Select Edit Quicklinks to open the QuickLinks folder.

October 4, 2017 

I encapsulated the QuickLinks.ahk auto-execute section by adding the Labels QuickLinksSetup:
and QuickLinksReset: for adding the app to any AutoHotkey script. By adding GoSub, QuickLinksSetup
to the auto-execute section (in top or file) of the compilation file and including 
(#Include [path]\QuickLinks.ahk) in the target script anywhere after the end of the auto-execute
section (probably toward the end of the file). You can continue to run the script as an independent app. 

May 24, 2018

The most recent version of QuickLinks implements code generated by Khanh Ngo which adds another 
dimension to the app. You can now highlight a file in Windows File Explorer and open it with a compatible 
shortcut in your QuickLinks menu. For example, if you include Windows Notepad in your QuickLinks 
menu, selecting any text file in Windows File Explorer and activating that Notepad menu item loads the 
file into a Notepad window.

This new capability also allow you to use print parameters to send files to your printer (e.g. Notepad /P). 
Just add the print parameter to the Target field in the Shortcut Properties window in the appropriate QuickLinks
folder.

January 18, 2020 

This version of the script adds a dynamic TimeDate submenu that updates each time you show the
QuickLinks menu.

January 22, 2020

I change all of the deprecated IfInString commands used for loading icons to the new Switch/Case statements.
This gives a number of advantages such as reading icons from shortcuts if available and stopping after successful 
evaluation. Added Menu, MenuName, UseErrorLevel to prevent script abort when icon not found. Need the latest 
version of AutoHotkey (November 2019 or later) for the Switch/Case command to work.

Tip: To automatically add icons to Web page menu items, use the "Add Links" feature in the main QuickLinks menu. This creates an Internet shortcut with the "lnk" extension in which icons can be read by AutoHotkey. Then manually add the desired icon to the shortcut in Windows. The "url" extension shortcuts created via Windows cannot provide
icon information.

February 6, 2020

Replaced deprecated code for adding icons with the QL_GetIcon() function.

*/

FileDelete, %A_Temp%\aria-debug*.log

QuickLinksSetup:

Menu, MenuName, UseErrorLevel

IfNotExist, C:\Users\%A_UserName%\QuickLinks\
    FileCreateDir, C:\Users\%A_UserName%\QuickLinks\

IfNotExist, C:\Users\%A_UserName%\QuickLinks\Tools\
   FileCreateDir, C:\Users\%A_UserName%\QuickLinks\Tools\

; These two lines add the Windows Tools menu item (God Mode) if missing. Delete if you don't want it.

IfNotExist, C:\Users\%A_UserName%\QuickLinks\Tools\Windows Tools.{ED7BA470-8E54-465E-825C-99712043E01C}
   FileCreateDir, C:\Users\%A_UserName%\QuickLinks\Tools\Windows Tools.{ED7BA470-8E54-465E-825C-99712043E01C}

Menu, Tray, Add, Reload QuickLinks, QL_ReloadHandler
Menu, Tray, Icon, Reload QuickLinks, Shell32.dll, 85  ; Change icon to a menu tree
Menu, Tray, Icon, Shell32.dll, 85  ; Change icon to a menu tree


QuickLinksReset:

Loop, C:\Users\%A_UserName%\QuickLinks\*.*, 2 , 0  
{
   QL_MainMenu := A_LoopFileName
   Menu, QuickLinks, Add,%A_LoopFileName%, QL_MenuHandler
   QL_GetIcon("QuickLinks",QL_MainMenu)

; This creates the menu for automatically adding new menu items
   Menu, QL_AddLinksMenu, Add, %A_LoopFileName%, QL_LinksHandler
   QL_GetIcon("QL_AddLinksMenu",QL_MainMenu)

    CountLoop := 0
    Loop, %A_LoopFileFullPath%\*.*, 1 , 0
    {
     If A_LoopFileAttrib contains H,R,S  ;Skip any file that is 
       continue         ; H, R, or S (System).
    QL_NewName := A_LoopFileName
    StringReplace, QL_NewName,QL_NewName, .%A_LoopFileExt%
    Menu, %QL_MainMenu%, Add, %QL_NewName%, QL_MenuHandler
    QL_GetIcon(QL_MainMenu,QL_NewName)

      CountLoop := 1
    }
   If (CountLoop = 1)
    {
      Menu, QuickLinks, Add, %QL_MainMenu%, :%QL_MainMenu%
    }
   Else
    {
      Menu, QuickLinks, Add, %QL_MainMenu%, QL_FolderHandler
    }
}

; Add Time/Date submenu

Menu, TimeDate, Add, Time/Date, QuickLinksHandler ; Dummy item
Menu, QuickLinks, Add, Insert Time/Date, :TimeDate
Menu, QuickLinks, Icon, Insert Time/Date, %A_Windir%\system32\SHELL32.dll, 266,

Menu, QuickLinks, Add ;Add a separator bar
; This next menu item creates a submenu for creating new shortcuts (.lnk)
; and adding them directly to the QuickLinks subdirectory. 

 Menu, QuickLinks, Add, Add Links, :QL_AddLinksMenu
 Menu, QuickLinks, Add, Open QuickLinks, QuickLinksHandler
 Menu, QuickLinks, Add, Reload QuickLinks, QL_ReloadHandler
 Menu, QuickLinks, Icon, Add Links, C:\WINDOWS\system32\wmploc.DLL, 12

Menu, QuickLinks, Add ;Add a separator bar
 Menu, QuickLinks, Add, About, QL_HelpHandler

 Menu, Tray, Add, Reload QuickLinks, QL_ReloadHandler
 Menu, Tray, Icon, Reload QuickLinks, Shell32.dll, 85  ; Change icon to a tree sturcture

Return

QL_MenuHandler:
If A_ThisMenuItem contains Windows Tools
   {
   Run, "C:\Users\%A_UserName%\QuickLinks\%A_ThisMenu%\Windows Tools.{ED7BA470-8E54-465E-825C-99712043E01C}"
   } 
Else
  {
      IfExist, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenu%\%A_ThisMenuItem%.url
         Run, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenu%\%A_ThisMenuItem%.url
      Else  
        { 
 ; The following snippet added by Khanh Ngo enables the opening of files selected in Windows File Explorer

        Clip0 := ClipboardAll        ; Backup current clipboard's content
        Clipboard :=                      ; Clear clipboard
        SendInput, ^c                    ; copy selected file's path to clipboard
        ClipWait 0

          If Clipboard
            {
              Run, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenu%\%A_ThisMenuItem%.lnk "%clipboard%"
             }
          Else
            {
               Run, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenu%\%A_ThisMenuItem%.lnk
            }

  Clipboard := Clip0           ; Restore original ClipBoard
  VarSetCapacity(Clip0, 0)      ; Free memory
        }
    }
Return

QuickLinksHandler:
run, C:\Users\%A_UserName%\QuickLinks\
Return

QL_FolderHandler:
run, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenuItem%
Return

; Subroutine for automatically adding new shortcuts to 
; MOD to add multiple selected files

QL_LinksHandler:
  Clipboard :=
  SendInput, ^c  ;text pre-selected
  ClipWait 0
  If ErrorLevel
  {
    MsgBox, Please select a file or URL!
    Return
  }
  Loop, Parse, Clipboard, `n, `r
  {
    if (A_LoopField != "")
      AddShortcut(A_LoopField)
  }
Return

AddShortcut(filename) {

  SplitPath, filename, Name, Dir, Ext, Name_no_ext, Drive

  ;MsgBox, 0, Clipboard, %Clipboard%

  If (Instr(filename,"http")) {
    Name_no_ext := RegExReplace(filename, "https?://(.+?)(/|\?).*" , "$1")
    Icon := A_Windir . "\system32\SHELL32.dll"
    IconNumber := 15
  } else {
    Icon := ""
    IconNumber := ""
  }
  ;  MsgBox Clipboard, Name, Dir, Ext, Name_no_ext, Drive`r%Clipboard%, %Name%, %Dir%, %Ext%, %Name_no_ext%, %Drive%
  IfExist, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenuItem%\%Name_no_ext%.lnk
  {
    MsgBox, %Name_no_ext% previously added to the %A_ThisMenuItem% QuickLinks folder.
  } Else {
    If (Ext ="lnk") {
      FileCopy, %filename%, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenuItem%\
      MsgBox, Shortcut %Name_no_ext% copied to the %A_ThisMenuItem% QuickLinks folder.   
    } Else {
      FileCreateShortcut, %filename%, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenuItem%\%Name_no_ext%.lnk,,,,%Icon%,,%IconNumber%
      MsgBox, %Name_no_ext%.lnk Link added to the %A_ThisMenuItem% QuickLinks folder.
      ;  Run, explorer.exe /select, C:\Users\%A_UserName%\QuickLinks\%A_ThisMenuItem%\%Name_no_ext%.lnk
    }
  }
GoSub, QL_ReloadHandler
}

;  Recreates the QuickLinks menu

QL_ReloadHandler:
  Menu, QuickLinks, Delete
  Loop, C:\Users\%A_UserName%\QuickLinks\*.*, 2 , 0  
  {  
    Menu, %A_LoopFileName%, Delete
  }
  GoSub, QuickLinksReset
Return

QL_HelpHandler:
  Run, http://www.computoredge.com/AutoHotkey/AutoHotkey_Quicklinks_Menu_App.html
Return

; Assigned Hotkey combinations

Pause::
	#IfWinActive ahk_exe Code.exe
  Send ^j
	#IfWinActive
Return

; ^RButton::Menu, QuickLinks, Show
 ^RButton::
; #z::
; !,::
   Menu, TimeDate, DeleteAll
   List := DateFormats(A_Now)
   TextMenuDate(List,"TimeDate","DateAction")
   Menu, QuickLinks, Show
Return

; Add or delete statement in the QL_GetIcon() function to change icon settings.

QL_GetIcon(menuitem,submenu)
{

; Probe shortcut data—if available
  FileGetShortcut, C:\Users\%A_UserName%\QuickLinks\%menuitem%\%submenu%.lnk
     , QL_OutTarget, QL_OutDir, QL_OutArgs, QL_OutDescription, QL_OutIcon
    , QL_OutIconNum, QL_OutRunState
; Save file attributes    
  FileGetAttrib, QL_FileAttrib , %QL_OutTarget%
; Save .url type shortcut file name  
  Webfile := "C:\Users\" A_UserName "\QuickLinks\" menuitem "\" submenu ".url"
; Read embedded folder icon 
  IniRead, OutputVar, C:\Users\%A_UserName%\QuickLinks\%submenu%\desktop.ini, .ShellClassInfo , IconResource                                              

; This conditional Switch/Case command uses icon data stored in the shortcut (if any) to set menu icon.
; To activate and/or change a particular icon manually open the folder/shortcut Properties window in Windows File Explorer
; (right-click on filename and select Properties) and Change icon..., OK, then Apply.

  Switch
  {
  ; Check for embedded folder icon
    Case (menuitem = "QuickLinks" or menuitem = "QL_AddLinksMenu") and (OutputVar != "Error"):
      Array := StrSplit(OutputVar,",")
             Path := Array[1]
             Icon := Array[2] +1    
      Menu, %menuitem%, Icon, %submenu%, %path% , %icon%
  ; Check for embedded shotcut icon
    Case (QL_OutIcon != ""):
      Menu, %menuitem%, Icon, %submenu%
      , %QL_OutIcon%, %QL_OutIconNum%
  ; Set program file icon
    Case Instr(QL_OutTarget,"exe"):
      Menu, %menuitem%, Icon, %submenu%, %QL_OutTarget%, 1
  ; Set Web page icon
    Case Instr(QL_OutDir,"http"), Instr(QL_OutTarget,"http"):
      Menu, %menuitem%, Icon, %submenu%
      , %A_Windir%\system32\SHELL32.dll, 15,
  ; Set Web page icon for .url type shortcuts
    Case FileExist(Webfile):
      Menu, %menuitem%, Icon, %submenu%
      , %A_Windir%\system32\SHELL32.dll, 14,
; Set Windows Tools folder icon
     Case Instr(submenu,"Tools"):
        Menu, %menuitem%, Icon, %submenu%
       ,  C:\WINDOWS\System32\SHELL32.dll,36
 ; Set folder shortcut icon
    Case Instr(QL_FileAttrib,"D"):
       Menu, %menuitem%, Icon, %submenu%
       , %A_Windir%\system32\imageres.dll, 4,
  ; Set icon based on file extension
    Case RegExMatch(QL_OutTarget,"\.\w+$",extension): 
      Switch extension
      {
        Case ".jpg",".png":
          Menu, %menuitem%, Icon, %submenu%, %A_Windir%\system32\SHELL32.dll, 142,
        Case ".epub",".mobi",".pdf":
          Menu, %menuitem%, Icon, %submenu%, C:\AutoHotkey\Icons\Books.ico,0
        Case ".ahk":
          Menu, %menuitem%, Icon, %submenu%
                      , C:\Program Files\AutoHotkey\AutoHotkeyU64.exe, 2
      ; Jump to default
        Default: goto LastWord
      }
    ; Add default icon
      Default:
        LastWord:
        Menu, %menuitem%, Icon, %submenu%
          , %A_Windir%\system32\SHELL32.dll, 85,
    }
}

; Creates string of formatted dates

DateFormats(Date)
{
FormatTime, OutputVar , %Date%, yyyy-MM-dd_hh:mm:tt ;My Format - 12hr clock
List := OutputVar
FormatTime, OutputVar , %Date%, h:mm tt ;12 hour clock
List := List . "|" . OutputVar
FormatTime, OutputVar , %Date%, HH:mm ;24 hour clock
List := List . "|" . OutputVar
FormatTime, OutputVar , %Date%, ShortDate ; 11/5/2015
List := List . "|" . OutputVar
FormatTime, OutputVar , %Date%, MMM. d, yyyy
List := List . "|" . OutputVar
FormatTime, OutputVar , %Date%, MMMM d, yyyy
List := List . "|" . OutputVar
FormatTime, OutputVar , %Date%, LongDate
List := List . "|" . OutputVar
FormatTime, OutputVar, %Date%, h:mm tt, dddd, MMMM d, yyyy
List := List . "|" . OutputVar
FormatTime, OutputVar, %Date%, dddd MMMM d, yyyy hh:mm:ss tt
List := List . "|" . OutputVar
Return List
}

; Creates DateTime Submenu

TextMenuDate(TextOptions,Menu,Action)
{
  StringSplit, MenuItems, TextOptions , |
  Loop %MenuItems0%
  {
    Item := MenuItems%A_Index%
    Menu, %Menu%, add, %Item%, %Action%
    Switch 
    {
    Case (InStr(Item,":") and InStr(Item,"`,")):
      Menu, TimeDate, Icon, %Item%, %A_Windir%\System32\timedate.cpl
    Case (InStr(Item,":")):
      Menu, TimeDate, Icon, %Item%, %A_Windir%\System32\shell32.dll, 240
    Default:
      Menu, TimeDate, Icon, %Item%, %A_Windir%\System32\ieframe.dll, 46
    }
  }
}

; DateTime submenu action

DateAction:
  SendInput %A_ThisMenuItem%{Raw}%A_EndChar%
Return