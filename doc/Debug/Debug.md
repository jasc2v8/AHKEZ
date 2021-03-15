
<!-- reminder: replace = "" with = \"\" -->

---
title: AHKEZ_Debug
author: jasc2v8
date: March 13, 2021
---

# TOC

The table of contents is listed above.

# Overview

A window to display debug information while testing a script

Very useful debug functions at the bottom of this script (static outside the Class):

- ListVars()

- ListArray()

All functions documented below assume the Debug class has been instantiated:

    D := New Debug

[AutoHotkey EZ ](https://github.com/jasc2v8/AHKEZ) is a free and open source version of [AHK_L_v1.1.33.02](https://github.com/AutoHotkey/AutoHotkey) 

License: Dedicated to the public domain without warranty or liability [(CC0 1.0)](http://creativecommons.org/publicdomain/zero/1.0/)

*([TOC])*

# Append

Appends text with a newline ending (CRLF)

<p style="padding:0.5em;background-color:#ffffaa;">
Append(Text)
</p>

## Parameters {.unlisted .unnumbered}

### Text {.unlisted .unnumbered}

Text to be shown in the Debug window.

## Returns {.unlisted .unnumbered}

No return value.

## Remarks {.unlisted .unnumbered}

No remarks.

## Examples {.unlisted .unnumbered}

| D.Append("Value=" v)

*([TOC])*

# Clear

Clears the text from the Debug window.

<p style="padding:0.5em;background-color:#ffffaa;">
Clear() 
</p>

## Examples {.unlisted .unnumbered}

| D.Clear()

*([TOC])*

# Close

Closes and destroys the Debug window.

<p style="padding:0.5em;background-color:#ffffaa;">
D.Close()
</p>

## Examples {.unlisted .unnumbered}

| D.Close()

*([TOC])*

# GuiSize

Sets the size of the Debug window.  

<p style="padding:0.5em;background-color:#ffffaa;">
GuiSize(Option)
</p>

## Parameters {.unlisted .unnumbered}

### Option {.unlisted .unnumbered}

> Type: String  
>
> For a Small window specify one of: 0, "-", "S", "Small", "GuiSizeSmall"
>
> For a Large window specify one of: 1, "+", "L", "Large", "GuiSizeLarge"
>
> The default size (empty paramter) is "Small".

## Remarks {.unlisted .unnumbered}

Function wrapper for [FileDelete](https://www.autohotkey.com/docs/commands/FileDelete.htm) and [FileAppend](https://www.autohotkey.com/docs/commands/FileAppend.htm)

## Examples {.unlisted .unnumbered}

    D.GuiSize()         ;default is "Small"

    D.GuiSize("Large")  ;change to "Large"

*([TOC])*

# Hide

Hides the Debug window - opposite of Show()

<p style="padding:0.5em;background-color:#ffffaa;">
Hide()
</p>

## Examples {.unlisted .unnumbered}

    D.Hide()

*([TOC])*

# ListArray

List a one dimension array in a Message Box.

<p style="padding:0.5em;background-color:#ffffaa;">
ListArray(MyArray)
</p>

## Parameters {.unlisted .unnumbered}

### Title {.unlisted .unnumbered}

> Type: String  
>
> The title of the listing in the Message Box.

### Array {.unlisted .unnumbered}

> Type: Array[]  
>
> A one-dimension array

## Examples {.unlisted .unnumbered}

    D.ListArray("My Title, MyArray)

*([TOC])*

# Log

Writes a string to a log file.

<p style="padding:0.5em;background-color:#ffffaa;">
Log(Text := "", Filename := "", TimeFormat := "", Overwrite := False )
</p>

## Parameters {.unlisted .unnumbered}

### Text {.unlisted .unnumbered}

> Type: String
>
> The text to write to the log file.

### Filename {.unlisted .unnumbered}

> Type: String.
>
> The log filename.ext

### TimeFormat {.unlisted .unnumbered}

> Type: String
>
> If present, pre-pends a timestamp to the text.

### Overwrite {.unlisted .unnumbered}

> Type: Boolean
>
> True to Overwrite, or False to not Overwrite.

## Examples {.unlisted .unnumbered}

    D.Log("Starting My Text", JoinPath(A_ScriptDir, "MyLogFile.log")),,True)

*([TOC])*

# Out

Synonym for Append. 

<p style="padding:0.5em;background-color:#ffffaa;">
Out(Text)
</p>

## Remarks {.unlisted .unnumbered}

See Append()

## Examples {.unlisted .unnumbered}

    D.Out("Result: " vResult)

*([TOC])*

# Pause [P]

Appends Text to the Debug Window then waits for User input.  

P is an abbreviation for Pause().

<p style="padding:0.5em;background-color:#ffffaa;">
Pause(Text := "Press Resume to continue...")
P(Text := "Press Resume to continue...")
</p>

## Remarks {.unlisted .unnumbered}

No remarks.

## Examples {.unlisted .unnumbered}

    D.P("DEBUG - Value is:  v)

    D.Pause()  ; Press Resume to continue...

*([TOC])*

# Paste

Pastes text to Debug window without line ending (CRLF).

<p style="padding:0.5em;background-color:#ffffaa;">
Paste(Text)
</p>

## Parameters {.unlisted .unnumbered}

### Text {.unlisted .unnumbered}

> Type: String  
>
> The text to paste in the Debug window.

## Examples {.unlisted .unnumbered}

    D.Paste("The time is: " Now)

# PasteArray

Pastes a one dimension array in the Debug window.

<p style="padding:0.5em;background-color:#ffffaa;">
PasteArray(Title, array)
</p>

## Parameters {.unlisted .unnumbered}

### Title {.unlisted .unnumbered}

> Type: String  
>
> The title of the listing in the Debug window.

### Array {.unlisted .unnumbered}

> Type: Array[]  
>
> A one-dimension array

## Examples {.unlisted .unnumbered}

    D.ListArray("My Title, MyArray))

*([TOC])*

# SetText

Sets text to Debug window without line ending (CRLF).

<p style="padding:0.5em;background-color:#ffffaa;">
SetText(String)
</p>

## Examples {.unlisted .unnumbered}

    D.SetText("Test finished!")

*([TOC])*

# Show

Shows the Debug window - opposite of Hide()

<p style="padding:0.5em;background-color:#ffffaa;">
Show()
</p>

## Examples {.unlisted .unnumbered}

    D.Show()

# Splash

Shows a Splash window with options.

<p style="padding:0.5em;background-color:#ffffaa;">
Splash(Title:="DEBUG", Text:="Note the Debug Gui", Duration:=4000, x:="Center", y:="Center", w:=180, h:=140)
</p>

## Remarks {.unlisted .unnumbered}

Implementation of [SplashTextOn/Off](https://www.autohotkey.com/docs/commands/SplashTextOn)

## Examples {.unlisted .unnumbered}

    Splash(,,5000,80,80) ; Splash defaults for 5 seconds in upper left corner

*([TOC])*


# Donations

[![Donate](https://img.shields.io/badge/Buy_me_a_cup_of_Coffee-PayPal-red.svg)](https://www.paypal.me/JimDreherHome)

If AHKEZ helps you in some way, then please buy me a cup of coffee by clicking on the donation button above. Thank you.

*([TOC])*
