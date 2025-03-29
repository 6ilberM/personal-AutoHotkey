#Persistent
#NoEnv
#SingleInstance Force

; AI Prompt Helper - Block key-down and act on key-up
^F16::return  ; Block the key-down event completely

^F16 Up::  ; Act only on key-up
    ; Use the clipboard method instead of SendInput
    ClipSaved := ClipboardAll  ; Save current clipboard
    Clipboard := ""  ; Clear clipboard

    ; Read the prompt text
    FileRead, AIPromptText, D:\terminalUtilities\TextHelpers\AI_Prompt_Helper_SageDeveloper.txt

    if (AIPromptText != "") {
        Clipboard := AIPromptText  ; Set clipboard to prompt text
        Send ^v  ; Paste
    } else {
        SoundBeep  ; Error sound if file can't be read
    }

    ; Wait for clipboard to be processed
    ClipWait, 1
    Sleep, 100

    ; Restore original clipboard
    Clipboard := ClipSaved
    ClipSaved := ""  ; Free memory
return