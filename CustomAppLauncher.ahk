#Requires AutoHotkey v2.0
#SingleInstance Force

DetectHiddenWindows True

#o::SmartActivate("ahk_exe Obsidian.exe", "C:\Program Files\Obsidian\Obsidian.exe")

SmartActivate(winTitle, targetPath)
    {
    if WinExist(winTitle)
        {
        if WinActive(winTitle)
            {
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
