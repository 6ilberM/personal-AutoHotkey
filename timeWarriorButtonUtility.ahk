#Persistent
#SingleInstance Force

; Global variables
global currentMode := "GameJam"  ; Default mode

; Mode switcher
^!F20::  ; Ctrl+Alt+F20 to cycle modes
    if (currentMode = "GameJam") {
        currentMode := "Unity"
        ToolTip, Switched to Unity tracking mode
    } else if (currentMode = "Unity") {
        currentMode := "Personal"
        ToolTip, Switched to Personal tracking mode
    } else {
        currentMode := "GameJam"
        ToolTip, Switched to Game Jam tracking mode
    }
    SetTimer, RemoveToolTip, 3000
return

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

^F17::  ; Ctrl+F17 - Start timer based on mode
    if (currentMode = "GameJam") {
        Run, %comspec% /c wsl -e timew start "LAGS Jam" game-jam,, Hide
        Sleep, 500
        tracking := GetTrackingInfo()
        ToolTip, Started Game Jam tracking`n%tracking%
    } else if (currentMode = "Unity") {
        Run, %comspec% /c wsl -e timew start "Unity Dev" coding unity,, Hide
        Sleep, 500
        tracking := GetTrackingInfo()
        ToolTip, Started Unity development tracking`n%tracking%
    } else {
        Run, %comspec% /c wsl -e timew start "Personal" learning,, Hide
        Sleep, 500
        tracking := GetTrackingInfo()
        ToolTip, Started Personal time tracking`n%tracking%
    }
    SetTimer, RemoveToolTip, 3000
return

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

!F19::  ; Alt+F19 - Continue @2
    Run, %comspec% /c wsl -e timew continue @2,, Hide
    Sleep, 500

    ; Get what we're now tracking
    tracking := GetTrackingInfo()
    ToolTip, Resumed tracking @2`n%tracking%
    SetTimer, RemoveToolTip, 3000
return

^F20::  ; Ctrl+F20 - Show status
    tracking := GetTrackingInfo()
    ToolTip, %tracking%
    SetTimer, RemoveToolTip, 5000
return