; Timewarrior Game Jam Controls - Using only F17-F20 with modifiers
^F17::  ; Ctrl+F17 - Start jam timer
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew start 'LAGS Jam' game-jam""",, Hide
    TrayTip, LAGS Jam Timer, Started tracking game jam time, 2
return

!F17::  ; Alt+F17 - Stop timer
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew stop""",, Hide
    TrayTip, LAGS Jam Timer, Stopped tracking time, 2
return

^F19::  ; Ctrl+F19 - Continue last timer
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew continue""",, Hide

    ; Get what we're now tracking to show in the notification
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew"" > %TEMP%\timew_current.txt",, Hide
    FileRead, currentTracking, %TEMP%\timew_current.txt
    RegExMatch(currentTracking, "Tracking (.+)\r?\n", trackingWhat)

    if (trackingWhat1 != "") {
        TrayTip, LAGS Jam Timer, Resumed tracking: %trackingWhat1%, 3
    } else {
        TrayTip, LAGS Jam Timer, Resumed previous tracking, 2
    }
return

!F19::  ; Alt+F19 - Continue @2
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew continue @2""",, Hide
    TrayTip, LAGS Jam Timer, Resumed tracking @2, 2
return

^F20::  ; Ctrl+F20 - Show status
    ; Show summary in a tray tip
    RunWait, %comspec% /c "wsl -e bash -l -c ""timew"" > %TEMP%\timew_current.txt",, Hide
    FileRead, currentTracking, %TEMP%\timew_current.txt

    TrayTip, Timewarrior Status, % currentTracking, 5
return