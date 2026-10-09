CoordMode "Mouse", "Screen"

global stop := false

; Click dreapta pornește scriptul
RButton::
{
    stop := false
    target := "PFS-ROP4 – neacsa [BRR-WS-941914/CORP-PFS-AP10]"

    if !WinActive(target)
    {
        MsgBox "Fereastra '" target "' nu este activă!"
        return
    }

    if stop
        return
    
    Click 953, 504
    Click 947, 505
    SendText("defect trecut de 2x")

    Sleep 20
    SendText("defect trecut de 2x")
Sleep 200    
Click 782, 356
    Sleep 200
    Click 712, 293
    Click 712, 293
    SendText("NO_REF_BAR0000269-LF")
    Sleep 200

    Click 364, 297
    SendText("REPAIR (Repair defect)")
    Sleep 20

    Click 471, 566
Click 830, 672
    Sleep 100
    SendText("Indepartat R197")

    Sleep 2000

}
