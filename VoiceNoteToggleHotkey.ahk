#Requires AutoHotkey v2.0
#SingleInstance Force

; Update this to your actual path
VNT_Batch := "D:\terminalUtilities\VoiceNote_Toggle.bat"

#c:: { ; Win+C
    ; RunWait returns the ExitCode of the batch file directly in v2
    ExitCode := RunWait(VNT_Batch, , "Hide")

    if (ExitCode == 1) {
        ToolTip("🔴 RECORDING...")
        SetTimer(() => ToolTip(), -2000)
    } else {
        ToolTip("✅ SAVED TO VAULT")
        SetTimer(() => ToolTip(), -3000)
    }
}
