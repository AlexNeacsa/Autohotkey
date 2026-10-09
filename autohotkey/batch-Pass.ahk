#Requires AutoHotkey v2.0

global ScriptFolder := "P:\Neacsa Alexandru\misc\autohotkey\Scripst"

global Running := false
global Paused := false
global Processed := 0
global TotalCount := 0
global NCount := 1

ScriptList := []

LoadScripts()

MainGui := Gui(, "PFS Batch Assistant")

ChkActivatePFS := MainGui.AddCheckBox(
    "x10 y40",
    "Auto activate PFS"
)

ChkWarnings := MainGui.AddCheckBox(
    "x180 y40",
    "Auto close Warning windows (N)"
)

ChkActivatePFS.Value := 0
ChkWarnings.Value := 0

MainGui.AddText("x10 y10", "Script")

DDL := MainGui.AddDropDownList(
    "x70 y8 w350"
)

for item in ScriptList
    DDL.Add([item])

BtnRefresh := MainGui.AddButton(
    "x420 y8 w70",
    "Refresh"
)

BtnEdit := MainGui.AddButton(
    "x500 y8 w70",
    "Edit"
)

BtnNew := MainGui.AddButton(
    "x580 y8 w70",
    "New"
)

MainGui.AddText("x10 y55", "Seriale")

EditSerials := MainGui.AddEdit(
    "x10 y70 w640 h220"
)

BtnLoadTxt := MainGui.AddButton(
    "x10 y300 w100",
    "Load TXT"
)

BtnClipboard := MainGui.AddButton(
    "x120 y300 w100",
    "Clipboard"
)

BtnStart := MainGui.AddButton(
    "x240 y300 w90",
    "Start Batch"
)

BtnPause := MainGui.AddButton(
    "x340 y300 w70",
    "Pause"
)

BtnStop := MainGui.AddButton(
    "x420 y300 w70",
    "Stop"
)

BtnRunOnce := MainGui.AddButton(
    "x500 y300 w90",
    "Run Once"
)

BtnRunOnce.OnEvent("Click", RunSingle)

MainGui.AddText("x600 y304 w20", "N:")

DDLN := MainGui.AddDropDownList(
    "x620 y300 w40 Choose2",
    ["0","1","2"]
)

LblTotal := MainGui.AddText(
    "x10 y350 w200",
    "Total: 0"
)

LblDone := MainGui.AddText(
    "x10 y375 w200",
    "Procesate: 0"
)

LblRemain := MainGui.AddText(
    "x10 y400 w200",
    "Ramase: 0"
)

LogBox := MainGui.AddListBox(
    "x10 y440 w640 h180"
)

BtnLoadTxt.OnEvent("Click", LoadTxt)
BtnClipboard.OnEvent("Click", LoadClipboard)
BtnStart.OnEvent("Click", StartBatch)
BtnPause.OnEvent("Click", PauseBatch)
BtnStop.OnEvent("Click", StopBatch)

BtnRefresh.OnEvent("Click", RefreshScripts)
BtnEdit.OnEvent("Click", EditScript)
BtnNew.OnEvent("Click", NewScript)

MainGui.Show("w680 h650")

; =====================================================

LoadScripts()
{
    global ScriptFolder
    global ScriptList

    ScriptList := []

    Loop Files ScriptFolder "\*.ahk"
    {
        ScriptList.Push(A_LoopFileName)
    }
}

RefreshScripts(*)
{
    global DDL

    LoadScripts()

    DDL.Delete()

    for item in ScriptList
        DDL.Add([item])
}

LoadTxt(*)
{
    global EditSerials

    file := FileSelect(1, , "TXT")

    if !file
        return

    EditSerials.Value := FileRead(file)
}

LoadClipboard(*)
{
    global EditSerials

    EditSerials.Value := A_Clipboard
}

StartBatch(*)
{
    global Running
    global Paused
    global Processed
    global TotalCount
    global EditSerials
    global DDLN
    global NCount

    Running := true
    Paused := false

    Processed := 0

    TotalCount := 0

	NCount := Integer(DDLN.Text)

    lines := StrSplit(EditSerials.Value,"`n","`r")

    for line in lines
    {
        if Trim(line) != ""
            TotalCount++
    }

    UpdateLabels()

    SetTimer(ProcessNext,100)
}

PauseBatch(*)
{
    global Paused
    global BtnPause

    Paused := !Paused

    if Paused
        BtnPause.Text := "Resume"
    else
        BtnPause.Text := "Pause"
}

StopBatch(*)
{
    global Running

    Running := false

    SetTimer(ProcessNext,0)
}

ProcessNext()
{
    global Running
    global Paused
    global EditSerials
    global DDL
    global ScriptFolder
    global Processed
    global LogBox

    if !Running
        return

    if Paused
        return

    rows := StrSplit(EditSerials.Value,"`n","`r")

    serial := ""
    foundRow := 0

    Loop rows.Length
    {
        txt := Trim(rows[A_Index])

        if txt != ""
        {
            serial := txt
            foundRow := A_Index
            break
        }
    }

    if serial = ""
    {
        Running := false
        SetTimer(ProcessNext,0)

        MsgBox("Procesare terminata!")

        return
    }

    script := ScriptFolder "\" DDL.Text

    try
{
    WinWaitActive("PFS-ROP4", , 20)

    Click 454, 238
    Click 454, 238

    SendText(serial)

    Sleep 200
    Send("{Enter}")

    Loop NCount
    {
        Sleep 400
        Send("n")
    }

    Sleep 300

    if ChkActivatePFS.Value
{
    WinActivate("PFS-ROP4")
    Sleep(500)
}

if ChkWarnings.Value
{
    HandleWarnings()
}
RunWait('"' A_AhkPath '" "' script '" "' serial '"')
        rows.RemoveAt(foundRow)

        newText := ""

        for line in rows
            newText .= line "`r`n"

        EditSerials.Value := newText

        Processed++

        UpdateLabels()

        LogBox.Add([
            serial "  OK"
        ])

        FileAppend(
            A_Now " | "
            serial
            " | OK`n",
            A_ScriptDir "\BatchLog.txt"
        )
    }
    catch
    {
        LogBox.Add([
            serial "  ERROR"
        ])
    }
}

UpdateLabels()
{
    global LblTotal
    global LblDone
    global LblRemain
    global TotalCount
    global Processed

    LblTotal.Text := "Total: " TotalCount
    LblDone.Text := "Procesate: " Processed
    LblRemain.Text := "Ramase: " (TotalCount - Processed)
}

EditScript(*)
{
    global ScriptFolder
    global DDL

    if DDL.Text = ""
        return

    file := ScriptFolder "\" DDL.Text

    Run('notepad.exe "' file '"')
}

NewScript(*)
{
    global ScriptFolder

    ib := InputBox(
        "Introdu numele scriptului",
        "Script Nou"
    )

    if (ib.Result != "OK")
        return

    result := MsgBox(
        "YES = Batch Script`nNO = Single Run Script",
        "Tip Script",
        "YesNo"
    )

    newFile := ScriptFolder "\" ib.Value ".ahk"

    if FileExist(newFile)
    {
        Run('notepad.exe "' newFile '"')
        return
    }

    if (result = "Yes")
        template := "P:\Neacsa Alexandru\misc\autohotkey\modele\Batch_Template.ahk"
    else
        template := "P:\Neacsa Alexandru\misc\autohotkey\modele\SingleRun_Template.ahk"

    FileCopy(template, newFile)

    Run('notepad.exe "' newFile '"')
}

RunSingle(*)
{
    global ScriptFolder
    global DDL
    global ChkActivatePFS
    global ChkWarnings

    if ChkActivatePFS.Value
    {
        WinActivate("PFS-ROP4")
        Sleep(500)
    }

    if ChkWarnings.Value
    {
        HandleWarnings()
    }

    script := ScriptFolder "\" DDL.Text

    RunWait('"' A_AhkPath '" "' script '"')
}


HandleWarnings()
{
    SendText("n")
    Sleep(500)

    SendText("n")
    Sleep(500)
}