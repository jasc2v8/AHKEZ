
# AHKEZ Changelog

## v0.1.5

  1. Fix: Lib\AHKEZ.ahk
      1. MsgBox() didn't work as expected, fixed
      1. Removed GuiCommand, change Gui New from GuiCommand to SubCommand
      1. Gui(): Added "Tab" to list of controls - line ~841
      1. Credit iPhilip: Remove IsType, "string", invalid for AHK_L_v1
  1. Fix: Lib\Template.ahk
      1. Indent with spaces, not tabs
  1. Add: Lib\AHKEZ_UnitTest.ahk: GetSaveWinText()
  1. Add: UnitTest\Test_MsgBox.ahk
  1. Fix: UnitTest\Test_If: Fix per the IsType "string" change above

## v0.1.4

  1. Merged with v0.1.5
  
## v0.1.3

  1. Fix: Credit iPhilip: IsType, fix "string", add "object"
  1. Indent with spaces, not tabs

  
