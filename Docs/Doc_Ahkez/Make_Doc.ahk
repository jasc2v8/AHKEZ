;2021-03-01-01:39:PM
/*
 NOTE: Set your path to pandoc.exe if not on the Windows PATH envar
 
 Builds AHKEZ doc to index.html
 Manually copy to github.io
 
 Ctrl+Alt+P to build:
  Send Ctrl+S to save page in editor
  Run Pandoc to convert Markdown to HTML
  Open HTML in Browser
  
 Ctrl+Shift+Alt+P:
  ExitApp
 
*/
#NoEnv
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1
ListLines, Off
#SingleInstance, Force
#Include <AHKEZ>

PandocExe := "D:\Software\DEV\Programs\Pandoc\pandoc.exe"

DoBuild:
 Send("^s")
 RunWait(ComSpec " /c " PandocExe " -s --toc -c ahk-theme.css -A footer.html AHKEZ.md -o index.html", , "Hide")
 Run("Open " JoinPath(A_ScriptDir,"index.html"))
Return

; Ctrl+Alt+P to build
^!p::
 Gosub DoBuild
 Return

; Ctrl+Shift+Alt+P to ExitApp
^+!p::
 ExitApp
 
;Escape::ExitApp