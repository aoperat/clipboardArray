#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

global ClipBoardContents := []
global indexNum := 1

GetClipboardContent() {
    SavedClip := ClipboardAll
    Send, ^c
    Sleep, 500
    NewClip := Clipboard
    Clipboard := SavedClip
    return NewClip
}

AddToClipboardArray(clipContent) {
    global ClipBoardContents
    if (clipContent != "") {
        ClipBoardContents.Push(clipContent)
    }
}

PasteFromClipboard(text) {
    SavedClip := ClipboardAll
    Clipboard := text
    Sleep, 200
    Send, ^v
    Sleep, 200
    Clipboard := SavedClip
}


ResetIndex() {
    global indexNum
    indexNum := 1
}

^#c::
    clipContent := GetClipboardContent()
    AddToClipboardArray(clipContent)
Return

^#v::
    if (ClipBoardContents.Length() >= indexNum) {
        PasteFromClipboard(ClipBoardContents[indexNum])
        Sleep, 100
        ;Send, {Enter}
        global indexNum := indexNum + 1
    } else {
        MsgBox, The index has exceeded the array size.
    }
Return

^+#v::
    if (ClipBoardContents.Length() > 0) {
        Loop, % ClipBoardContents.Length() {
            PasteFromClipboard(ClipBoardContents[A_Index])
            Sleep, 100
            Send, {Enter}
            Sleep, 100
        }
    } else {
        MsgBox, Array Write, The array is empty.
    }
Return

^#x::
    ResetIndex()
Return

^+#x::
    ClipBoardContents := []
    ResetIndex()
    MsgBox, Array Reset, The array has been reset.
Return