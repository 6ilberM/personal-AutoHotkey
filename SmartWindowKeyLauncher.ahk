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

#1::  ; Win+1 - Fork
    SmartLaunch("ahk_exe Obsidian.exe", "C:\Program Files\Obsidian\Obsidian.exe")
return

#2::  ; Win+2 - Codecks
    SmartLaunch("ahk_exe Fork.exe", "C:\Users\maste\AppData\Local\Fork\current\Fork.exe")
return

#3::  ; Win+3 - Rider
    SmartLaunch("ahk_exe chrome.exe", """C:\Program Files (x86)\Google\Chrome\Application\chrome_proxy.exe""", "--profile-directory=Default --app-id=meldmicckmmgjdjkggleklmejbbedoae")
return

#4::  ; Win+4 - Obsidian
    SmartLaunch("ahk_exe rider64.exe", "C:\Users\maste\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\Rider Release.lnk")
return

#5::  ; Win+5 - Smart Unity
    if (ProcessExist("Unity.exe")) {
        ; Unity editor is running, switch to most recent one
        WinActivate, ahk_exe Unity.exe
    }
return