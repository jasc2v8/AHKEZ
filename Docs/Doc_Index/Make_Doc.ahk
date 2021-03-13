;2021-03-13_13:02
/*
  Converts Markdown document to index.html

  1 Reads .ini file
  2 If Pandoc path not specified, prompts to select
  3 Prompts for Markdown document
  4 Runs pandoc to convert markdown to html
  5 Opens index.html in default browser

 Escape::
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
;#Include <AHKEZ_Debug>

Global IniFile := SplitPath(A_ScriptName).NameNoExt . ".ini"

PandocExe := IniRead(IniFile, "SETTINGS", "PANDOC_EXE", "")
DocMD     := IniRead(IniFile, "SETTINGS", "DOC_MD", "")

if (PandocExe = "ERROR") {
  SelectedFile := FileSelectFile(Options, A_ScriptDir, "Select Path to your Pandoc.exe file:")
  if IsEmpty(SelectedFile) {
    MB(0x30,"No Selection Made", "No Pandoc file selected, press OK to Exit.")
    Return
  }
  IniWrite(SelectedFile, IniFile, "SETTINGS", "PANDOC_EXE")
  PandocExe := SelectedFile
}
SelectedFile := FileSelectFile(Options, DocMD, "Select Path to your Markdown file:")
if IsEmpty(SelectedFile) {
  MB(0x30,"No Selection Made", "No Markdown file selected, press OK to Exit.")
  Return
}
IniWrite(SelectedFile, IniFile, "SETTINGS", "DOC_MD")
DocMD := SelectedFile

MsgBox 0x24, Table of Contents, Include a Table of Contents?

IfMsgBox Yes, {
  toc := "--toc"
} Else IfMsgBox No, {
  toc := " "
}

RunWait(ComSpec " /c " PandocExe " -s " toc " -c ahk-theme.css -A footer.html " DocMD " -o index.html", , "Hide")
Run("Open " JoinPath(A_ScriptDir,"index.html"))
ExitApp

Escape::ExitApp