
<!-- reminder: replace = "" with = \"\" -->

---
title: AHKEZ_UnitTest
author: jasc2v8
date: March 13, 2021
---

# TOC

The table of contents is listed above.

# Overview

A unit test class for AHKEZ.

Designed to be used with \UnitTest\Run_Tests.ahk

All functions documented below assume the Debug class has been instantiated:

    T := New UnitTest

[AutoHotkey EZ ](https://github.com/jasc2v8/AHKEZ) is a free and open source version of [AHK_L_v1.1.33.02](https://github.com/AutoHotkey/AutoHotkey) 

License: Dedicated to the public domain without warranty or liability [(CC0 1.0)](http://creativecommons.org/publicdomain/zero/1.0/)

*([TOC])*

# Assert

Asserts that the test value matches the expected value.

<p style="padding:0.5em;background-color:#ffffaa;">
 Assert(SN, LN, IS, SB) 
</p>

## Parameters {.unlisted .unnumbered}

> Type: String  
>
> SN = The script name from which the Assert was called
> LN = The script line number from which the Assert was called
> IS = The result "is"
> SB = The result "should be"

## Remarks {.unlisted .unnumbered}

If the assert fails it will be noted in the log file.
If the option "Debug" is set, then a message box will be shown.

## Examples {.unlisted .unnumbered}

    T.Assert(A_ScriptName, A_LineNumber, v, True)

*([TOC])*

# ClearLog

Clears and deletes the log file.

<p style="padding:0.5em;background-color:#ffffaa;">
ClearLog()
</p>

*([TOC])*

# ClearOption

Clears the options and deletes the ini file.

<p style="padding:0.5em;background-color:#ffffaa;">
ClearOptions()
</p>

*([TOC])*

# EditLog

Opens the log file using the system default editor for the log file type.

<p style="padding:0.5em;background-color:#ffffaa;">
EditLog()
</p>

*([TOC])*

# WriteLog

Appends text to the log file.

<p style="padding:0.5em;background-color:#ffffaa;">
WriteLog(LogFile = "", Text = "") 
</p>

*([TOC])*

# GetOption

Gets an option setting.

<p style="padding:0.5em;background-color:#ffffaa;">
 GetOption(Option)
</p>

## Parameters {.unlisted .unnumbered}

### Option {.unlisted .unnumbered}

> Type: String
>
> "Debug", "+Debug", "-Debug",
> "Log", "+Log", "-Log"
> "+Debug, -Log"

*([TOC])*

#  SetOption

Sets an option setting.

<p style="padding:0.5em;background-color:#ffffaa;">
 SetOption(OptionsCSV)
</p>

## Parameters {.unlisted .unnumbered}

### OptionsCSV {.unlisted .unnumbered}

> Type: String
>
> "Debug", "+Debug", "-Debug",
> "Log", "+Log", "-Log"
> "+Debug, -Log"

## Remarks {.unlisted .unnumbered}

See Append()

## Examples {.unlisted .unnumbered}

    D.Out("Result: " vResult)

*([TOC])*

# GetSavedWinText()

Gets text saved from a window - see StartSendKeyTimer below.

P is an abbreviation for Pause().

<p style="padding:0.5em;background-color:#ffffaa;">
GetSavedWinText()
</p>

*([TOC])*

# StartSendKeyTimer(Duration, Keys = "{Enter}")

Save the text in the active window to be retrived late by GetWinText().

Send a key to the active window, typically used to press the default button to execute a test or close the test window.

<p style="padding:0.5em;background-color:#ffffaa;">
StartSendKeyTimer(Duration, Keys = "{Enter}")
</p>

## Parameters {.unlisted .unnumbered}

### Duration {.unlisted .unnumbered}

> Type: Integer  
>
> The duration of the timer in milliseconds.

### Keys {.unlisted .unnumbered}

> Type: String  
>
> The keys to send.

## Examples {.unlisted .unnumbered}

    StartSendKeyTimer(2000) ; wait 2 seconds then send the {Enter} key

*([TOC])*

# MillisecToTime

Converts milliseconds to hours:minutes:seconds "HH:MM:SS".

<p style="padding:0.5em;background-color:#ffffaa;">
MillisecToTime(msec)
</p>

*([TOC])*

# Donations

[![Donate](https://img.shields.io/badge/Buy_me_a_cup_of_Coffee-PayPal-red.svg)](https://www.paypal.me/JimDreherHome)

If AHKEZ helps you in some way, then please buy me a cup of coffee by clicking on the donation button above. Thank you.

*([TOC])*
