#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"
SetTitleMatchMode 2

target := "PFS-ROP4"

WinWaitActive(target,,20)

if !WinActive(target)
{
    MsgBox("Fereastra PFS nu este activă!")
    ExitApp
}

; =====================================
; CODUL TAU AICI
; =====================================

ExitApp