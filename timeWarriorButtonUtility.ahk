#Persistent
#SingleInstance Force

; Path to the file containing tags (relative to the script location)
global tagFilePath := A_ScriptDir "\tracking_tags.txt"

; Remove ToolTip after timer expires
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

; Get current tracking info and format it nicely
GetTrackingInfo() {
    FileDelete, %TEMP%\timew_current.txt
    RunWait, %comspec% /c wsl -e timew > %TEMP%\timew_current.txt,, Hide
    FileRead, currentTracking, %TEMP%\timew_current.txt
    return currentTracking
}

; Read tags from file or use default
GetTags() {
    if FileExist(tagFilePath) {
        FileRead, tags, %tagFilePath%
        StringTrimRight, tags, tags, 1  ; Remove any trailing newline
        if (tags != "") {
            return tags
        }
    }
    return "coding dev"  ; Default tags
}

!F17::  ; Alt+F17 - Stop timer
    Run, %comspec% /c wsl -e timew stop,, Hide
    Sleep, 500
    ; Show what was stopped
    FileDelete, %TEMP%\timew_summary.txt
    RunWait, %comspec% /c wsl -e timew summary :ids :day > %TEMP%\timew_summary.txt,, Hide
    FileRead, summary, %TEMP%\timew_summary.txt
    ToolTip, Stopped tracking time`n%summary%
    SetTimer, RemoveToolTip, 3000
return

^F19::  ; Ctrl+F19 - Continue last timer
    Run, %comspec% /c wsl -e timew continue,, Hide
    Sleep, 500
    ; Get what we're now tracking
    tracking := GetTrackingInfo()
    RegExMatch(tracking, "Tracking (.+)", trackingWhat)
    if (trackingWhat1 != "") {
        ToolTip, Resumed tracking: %trackingWhat1%`n%tracking%
    } else {
        ToolTip, Resumed previous tracking`n%tracking%
    }
    SetTimer, RemoveToolTip, 3000
return


^F20::  ; Ctrl+F20 - Show status
    tracking := GetTrackingInfo()
    ToolTip, %tracking%
    SetTimer, RemoveToolTip, 5000
return