; Coordonatele mouse-ului sunt relative la ecran
CoordMode "Mouse", "Screen"

global stop := false

; Ctrl+K oprește scriptul
RButton::
{
    stop := true
}

; Ctrl+J pornește scriptul
^j::
{
    stop := false
    target := "PFS-ROP4 – neacsa [BRR-WK941197/CORP-PFS-AP11]"
    maxCycles := 400

    if !WinActive(target)
    {
        MsgBox "Fereastra '" target "' nu este activă!"
        return
    }

    Loop maxCycles
    {
        if stop
            break

        Click 442, 464
        Click 559, 392
        Sleep 200
        Send "^v"
        Click 1001, 528
        Sleep 50

         
    }

    MsgBox "Script oprit. Cicluri efectuate: " (A_Index - 1)
}
