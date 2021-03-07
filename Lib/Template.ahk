/*
  ======================================================================================================================
  Title:   Template.ahk
  About:   The standard template for AHKEZ
  Usage:   Copy to C:\Windows\Shellnew\Template.ahk
  GitHub:  https://github.com/jasc2v8/AHKEZ
  Version: 0.1.4/2021-03-06_09:59/jasc2v8
           AHK_L_v1.1.10.01 (U64)
  Credits:
  Notes:
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
; ** Start Auto-execute Section


; ** End Auto-execute Section


; ** End Script
ExitApp
Escape::ExitApp