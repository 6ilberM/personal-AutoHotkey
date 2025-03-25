; AI Prompt Helper - Sage Developer

^F16::
    FileRead, AIPromptText, D:\terminalUtilities\TextHelpers\AI_Prompt_Helper_SageDeveloper.txt
    if (AIPromptText != "") {
        SendInput %AIPromptText%
    } else {
        SoundBeep ; Play error sound if file can't be read
    }
return