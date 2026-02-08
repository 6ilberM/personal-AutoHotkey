#Requires AutoHotkey v2.0
#SingleInstance Force

DetectHiddenWindows True

#o::SmartActivate("ahk_exe Obsidian.exe", "C:\Program Files\Obsidian\Obsidian.exe")

; Use "Codecks" in the title to differentiate from regular Chrome windows
#2::SmartActivate("Codecks ahk_exe chrome.exe", 'C:\Program Files (x86)\Google\Chrome\Application\chrome_proxy.exe --profile-directory=Default --app-id=meldmicckmmgjdjkggleklmejbbedoae')

; Unity: If active, we minimize (hiding). If not, we activate.
#F1::
{
    if WinActive("ahk_exe Unity.exe")
        WinMinimize("ahk_exe Unity.exe")
    else
        SmartActivate("ahk_exe Unity.exe", "") ; Path empty as Unity is usually launched via Hub
}

; Fork
#1::SmartActivate("ahk_exe Fork.exe", "C:\Users\" . A_UserName . "\AppData\Local\Fork\current\Fork.exe")
SmartActivate(winTitle, targetPath)
    {
    if WinExist(winTitle)
        {
        if WinActive(winTitle)
            {
            WinMinimize(winTitle)
            return
        }
        WinActivate(winTitle)
    }
    else
    {
        try
        {
            Run(targetPath)
        }
        catch
        {
            MsgBox("Error: Could not launch " . targetPath)
        }
    }
}
