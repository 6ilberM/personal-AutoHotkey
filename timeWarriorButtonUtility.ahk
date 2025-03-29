#Persistent
#SingleInstance Force

; Global variables
global useToolTip := true

;; Toggle notification type with Ctrl+Alt+F20
; ^!F20::
;     useToolTip := !useToolTip
;     if (useToolTip) {
;         ShowNotification("Notification Mode", "Switched to ToolTip notifications")
;     } else {
;         ShowNotification("Notification Mode", "Switched to TrayTip notifications")
;     }
; return

; Function to show notification based on current mode
ShowNotification(title, message, duration := 3000) {
    if (useToolTip) {
        ToolTip, %message%
        SetTimer, RemoveToolTip, %duration%
    } else {
        TrayTip, %title%, %message%, 2
    }
}

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

^F17::  ; Ctrl+F17 - Start jam timer
    Run, %comspec% /c wsl -e timew start "LAGS Jam" game-jam,, Hide
    Sleep, 500  ; Give the command time to execute

    ; Get what we're now tracking
    tracking := GetTrackingInfo()
    ShowNotification("LAGS Jam Timer", "Started tracking game jam time`n" . tracking)
return

!F17::  ; Alt+F17 - Stop timer
    Run, %comspec% /c wsl -e timew stop,, Hide
    Sleep, 500

    ; Show what was stopped
    FileDelete, %TEMP%\timew_summary.txt
    RunWait, %comspec% /c wsl -e timew summary :ids :day > %TEMP%\timew_summary.txt,, Hide
    FileRead, summary, %TEMP%\timew_summary.txt

    ShowNotification("LAGS Jam Timer", "Stopped tracking time`n" . summary)
return

^F19::  ; Ctrl+F19 - Continue last timer
    Run, %comspec% /c wsl -e timew continue,, Hide
    Sleep, 500

    ; Get what we're now tracking
    tracking := GetTrackingInfo()

    RegExMatch(tracking, "Tracking (.+)", trackingWhat)
    if (trackingWhat1 != "") {
        ShowNotification("LAGS Jam Timer", "Resumed tracking: " . trackingWhat1 . "`n" . tracking)
    } else {
        ShowNotification("LAGS Jam Timer", "Resumed previous tracking`n" . tracking)
    }
return

!F19::  ; Alt+F19 - Continue @2
    Run, %comspec% /c wsl -e timew continue @2,, Hide
    Sleep, 500

    ; Get what we're now tracking
    tracking := GetTrackingInfo()
    ShowNotification("LAGS Jam Timer", "Resumed tracking @2`n" . tracking)
return

^F20::  ; Ctrl+F20 - Show status
    tracking := GetTrackingInfo()
    ShowNotification("Timewarrior Status", tracking)
return