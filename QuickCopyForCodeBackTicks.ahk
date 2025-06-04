; Code Block Formatter - Using Ctrl+F18 followed by a letter key
#Persistent
#SingleInstance Force

; Step 1: Press Ctrl+F18 key
^F18::
    ; Wait for F18 to be released
    KeyWait, F18

    ; Show a tooltip to indicate we're waiting for the next key
    ToolTip, Code Block: Press C for C#, M for Markdown, X for custom, Escape to cancel

    ; Step 2: Wait for a single key press (C, M, or X)
    Input, SingleKey, L1 T3, {Escape}

    ; Clear the tooltip
    ToolTip

    ; Check if user canceled or timed out
    if (ErrorLevel = "Timeout" or ErrorLevel = "EndKey:Escape")
        return

    ; Process the key that was pressed
    if (SingleKey = "c")
        CreateCodeBlock("cs")
    else if (SingleKey = "m")
        CreateCodeBlock("md")
    else if (SingleKey = "j")
        CreateCodeBlock("json")  
    else if (SingleKey = "x") {
        ; Prompt for custom language
        InputBox, langChoice, Code Block Language, Enter language:, , 250, 130
        if (!ErrorLevel) {
            CreateCodeBlock(langChoice)
        }
    }
return

; Function to create code block with specified language
CreateCodeBlock(language) {
    ; Save current clipboard
    ClipSaved := ClipboardAll

    ; Get current clipboard content if any
    currentText := Clipboard

    ; Create the code block with proper triple backticks
    finalText := "``````" . language . "`n" . currentText . "`n``````"

    ; Set to clipboard and paste
    Clipboard := finalText
    ClipWait, 1
    Send ^v

    ; Position cursor appropriately if empty
    if (currentText = "") {
        ; If no text was selected, position cursor inside the block
        Send {Left 4}  ; Move left past the closing ```
    }

    ; Restore original clipboard
    Sleep, 200
    Clipboard := ClipSaved
    ClipSaved := ""  ; Free memory
}