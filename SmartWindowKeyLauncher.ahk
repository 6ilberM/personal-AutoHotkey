#Persistent
#NoEnv
#SingleInstance Force

ProcessExist(ProcessName) {
    Process, Exist, %ProcessName%
    return ErrorLevel
}

; Function to smart launch programs
SmartLaunch(windowTitle, exePath, args := "") {
    ; Try to activate existing window
    WinActivate, %windowTitle%
    if ErrorLevel {
        ; Window not found, launch program
        if (args != "") {
            Run, %exePath% %args%
        } else {
            Run, %exePath%
        }
    }
}

#1::  ; Win+1 - Obsidian (with fallback)
    WinGet, activeProcess, ProcessName, A
    if (activeProcess = "Obsidian.exe") {
        Send #1
    } else {
        SmartLaunch("ahk_exe Obsidian.exe", "C:\Program Files\Obsidian\Obsidian.exe")
    }
return

#2::  ; Win+2 - Fork (with fallback)
    WinGet, activeProcess, ProcessName, A
    if (activeProcess = "Fork.exe") {
        Send #2
    } else {
        SmartLaunch("ahk_exe Fork.exe", "C:\Users\maste\AppData\Local\Fork\current\Fork.exe")
    }
return

#3::  ; Win+3 - Codecks (better detection)
    WinGet, activeProcess, ProcessName, A
    if (activeProcess = "chrome.exe") {
        Send #3
    } else {
        ; Try to find Codecks-specific window first
        WinActivate, Codecks ahk_exe chrome.exe
        if ErrorLevel {
            ; Fallback to launching the app
            Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome_proxy.exe" --profile-directory=Default --app-id=meldmicckmmgjdjkggleklmejbbedoae, C:\Program Files (x86)\Google\Chrome\Application
        }
    }
return

#4::  ; Win+4 - Rider (with fallback)
    WinGet, activeProcess, ProcessName, A
    if (activeProcess = "rider64.exe") {
        Send #4
    } else {
        SmartLaunch("ahk_exe rider64.exe", "C:\Users\maste\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\Rider Release.lnk")
    }
return

#5::  ; Win+5 - Unity (with fallback)
    WinGet, activeProcess, ProcessName, A
    if (activeProcess = "Unity.exe") {
        WinMinimize, ahk_exe Unity.exe
    } else if (ProcessExist("Unity.exe")) {
        WinActivate, ahk_exe Unity.exe
    } else {
        Send #5
    }
return
