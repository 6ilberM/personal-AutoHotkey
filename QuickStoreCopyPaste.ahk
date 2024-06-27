#Persistent
#NoEnv
#SingleInstance Force

; Variable to store clipboard content, initialized with "t:prefab"
clipboardContent := "t:prefab"

; F15 to store clipboard content
F15::
    clipboardContent := Clipboard ; Ensure we're capturing the current clipboard text
    if (clipboardContent = "") {
        SoundBeep ; Play the default beep sound to indicate empty clipboard
    } else {
        Tooltip, Clipboard content stored! ; Show a tooltip as confirmation
        SetTimer, RemoveTooltip, -2000 ; Remove tooltip after 2 seconds
    }
return

RemoveTooltip:
    Tooltip ; Clear the tooltip
return

; F16 to output stored clipboard content using the clipboard for pasting
F16::
    if (clipboardContent != "") {
        Clipboard := clipboardContent ; Set the clipboard to the stored content
        SendInput ^v ; Simulate Ctrl+V to paste
    } else {
        SoundBeep ; Play the default beep sound to indicate nothing is stored
    }
return
