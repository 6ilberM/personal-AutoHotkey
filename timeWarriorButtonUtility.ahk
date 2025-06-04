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

^F17::  ; Ctrl+F17 - Quick start timer with tags from file
    tags := GetTags()
    Run, %comspec% /c wsl -e timew start %tags%,, Hide
    Sleep, 500
    tracking := GetTrackingInfo()
    ToolTip, Started tracking: %tags%`n%tracking%
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

F23::  ; F23 - Show focus session tracker with daily goal progress
    ; --- Count Overall Focus Sessions
    FileDelete, %TEMP%\focus_count.txt
    RunWait, %comspec% /c wsl -e timew summary :day | grep -E "focus|h\^" | wc -l > %TEMP%\focus_count.txt,, Hide
    FileRead, overallFocusCount, %TEMP%\focus_count.txt
    overallFocusCount := Trim(overallFocusCount)
    if (overallFocusCount = "")
        overallFocusCount := 0

    ; --- Count Rusty-Imber Focus Sessions
    FileDelete, %TEMP%\rusty_count.txt
    RunWait, %comspec% /c wsl -e timew summary :day | grep -E "focus|h\^" | grep "rusty-imber" | wc -l > %TEMP%\rusty_count.txt,, Hide
    FileRead, rustyCount, %TEMP%\rusty_count.txt
    rustyCount := Trim(rustyCount)
    if (rustyCount = "")
        rustyCount := 0

    ; --- Get total focus time in seconds
    FileDelete, %TEMP%\focus_time_seconds.txt
    RunWait, %comspec% /c wsl -e timew summary :day focus:normal focus:h^ | grep "Total" | awk '{print $3}' > %TEMP%\focus_time_seconds.txt,, Hide
    FileRead, focusTimeSeconds, %TEMP%\focus_time_seconds.txt
    focusTimeSeconds := Trim(focusTimeSeconds)
    if (focusTimeSeconds = "")
        focusTimeSeconds := 0

    ; --- Get formatted focus time
    FileDelete, %TEMP%\focus_time.txt
    RunWait, %comspec% /c wsl -e timew summary :day focus:normal focus:h^ | grep "Total" | awk '{print $2}' > %TEMP%\focus_time.txt,, Hide
    FileRead, focusTime, %TEMP%\focus_time.txt
    focusTime := Trim(focusTime)
    if (focusTime = "")
        focusTime := "0:00:00"

    ; --- Calculate hours worked
    hoursWorked := focusTimeSeconds / 3600
    hoursWorkedFormatted := Round(hoursWorked, 1)  ; Round to 1 decimal place

    ; --- Set daily goals
    minGoalHours := 4
    idealGoalHours := 6

    ; --- Calculate goal percentages
    minGoalPercent := Min(Round((hoursWorked / minGoalHours) * 100), 100)
    idealGoalPercent := Min(Round((hoursWorked / idealGoalHours) * 100), 100)

    ; --- Determine status message
    if (hoursWorked >= idealGoalHours)
        statusMsg := "GOAL ACHIEVED! You can chill now."
    else if (hoursWorked >= minGoalHours)
        statusMsg := "Minimum goal met! " . (idealGoalHours - hoursWorked) . " more hours for ideal."
    else
        statusMsg := "Need " . (minGoalHours - hoursWorked) . " more hours to reach minimum goal."

    ; --- Format the tooltip text
    tooltipText := "=== DAILY WORK TRACKER ===`n`n"
    tooltipText .= "Hours Worked: " . hoursWorkedFormatted . " / " . idealGoalHours . " hours`n"
    tooltipText .= "Minimum Goal (4h): " . minGoalPercent . "% complete`n"
    tooltipText .= "Ideal Goal (6h): " . idealGoalPercent . "% complete`n`n"
    tooltipText .= "Focus Sessions: " . overallFocusCount . " total (" . rustyCount . " on Rusty-Imber)`n`n"
    tooltipText .= "STATUS: " . statusMsg

    ; --- Display the tooltip
    ToolTip, %tooltipText%
    SetTimer, RemoveToolTip, 10000
return

