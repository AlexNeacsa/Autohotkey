#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"
SetTitleMatchMode 2

serial := A_Args[1]

target := "PFS-ROP4"

WinWaitActive(target, , 20)

if !WinActive(target)
{
    MsgBox("Fereastra '" target "' nu este activă!")
    ExitApp
}

; Dacă trebuie introdus serialul
; Click 517, 176
; SendText(serial)
; Send("{Enter}")
; Sleep 2000

; PASS
Click 158, 244
Click 158, 244

SendText("PASS")

Click 818, 142

Sleep 500

ExitApp
