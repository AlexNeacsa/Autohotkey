#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"
SetTitleMatchMode 2


Click 473, 240
SendText("y301")


Click 324, 241
Click 324, 241
SendText("PCAC08 (ELECTRICALLY DEFECTIVE COMPONENT")

Sleep 200

Click 158, 244
Click 158, 244
SendText("REPLACE (Replace bad component)")

Sleep 200

Click 313, 653
SendText("BRB001056-2639-01377")

Sleep 200

Click 818, 142

Sleep 1000

ExitApp