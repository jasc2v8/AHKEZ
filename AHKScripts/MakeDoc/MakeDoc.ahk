;2021-03-16_14:45
/*
  Converts Markdown document to index.html

  1 Reads .ini file
  2 If Pandoc path not specified, prompts to select
  3 Prompts for Markdown document
  4 Runs Pandoc to convert markdown to index.html
    index.html is save to the same folder as the markdown.md doc
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

if !FileExist("ahk-theme.css") {
  MB(0x30,"File Not Found", "File Not Found:`n`nahk-theme.css`n`nPress OK to Exit.")
  Return
}
if !FileExist("footer.html") {
  MB(0x30,"File Not Found", "File Not Found:`n`nfooter.html`n`nPress OK to Exit.")
  Return
}
if !FileExist("header.html") {
  MB(0x30,"File Not Found", "File Not Found:`n`nheader.html`n`nPress OK to Exit.")
  Return
}
if (PandocExe = "ERROR") or !FileExist(PandocExe) {
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

indexFile := SplitPath(DocMD).Dir "\index.html"

MsgBox 0x24, Table of Contents, Include a Table of Contents?

IfMsgBox Yes, {
  toc := "--toc"
} Else IfMsgBox No, {
  toc := " "
}

RunWait(ComSpec " /c " PandocExe " -s " toc " -c ahk-theme.css -B header.html -A footer.html " DocMD " -o " indexFile , , "Hide")

if FileExist(indexFile)
  Run("Open " indexFile)

ExitApp

Escape::ExitApp