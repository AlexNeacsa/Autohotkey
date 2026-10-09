#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"
SetTitleMatchMode 2

serial := A_Args.Length ? A_Args[1] : ""

if (serial != "")
{
    ; GUI-ul a trimis serialul
}

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