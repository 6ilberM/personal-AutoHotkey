; Function to check if a process exists
ProcessExist(ProcessName) {
    Process, Exist, %ProcessName%
    return ErrorLevel
}

; Initialize variables for the current volume level of each application
vol_spotify := 0.5
vol_slack_discord := 0.5

; Define a variable for the volume adjustment amount
vol_adjustment := 0.05

; Hotkey to decrease volume for Spotify
^F22::
    if (ProcessExist("Spotify.exe")) {
        vol_spotify -= vol_adjustment
        if (vol_spotify < 0)
            vol_spotify := 0
        Run, nircmd setappvolume "Spotify.exe" %vol_spotify%
    } else {
        MsgBox, Spotify is not running.
    }
return

; Hotkey to increase volume for Spotify
^F24::
    if (ProcessExist("Spotify.exe")) {
        vol_spotify += vol_adjustment
        if (vol_spotify > 1)
            vol_spotify := 1
        Run, nircmd setappvolume "Spotify.exe" %vol_spotify%
    } else {
        MsgBox, Spotify is not running.
    }
return

; Hotkey to decrease volume for Slack and Discord
^F21::
    if (ProcessExist("slack.exe") or ProcessExist("Discord.exe")) {
        vol_slack_discord -= vol_adjustment
        if (vol_slack_discord < 0)
            vol_slack_discord := 0
        Run, nircmd setappvolume "slack.exe" %vol_slack_discord%
        Run, nircmd setappvolume "Discord.exe" %vol_slack_discord%
    } else {
    }
return

; Hotkey to increase volume for Slack and Discord
^F23::
    if (ProcessExist("slack.exe") or ProcessExist("Discord.exe")) {
        vol_slack_discord += vol_adjustment
        if (vol_slack_discord > 1)
            vol_slack_discord := 1
        Run, nircmd setappvolume "slack.exe" %vol_slack_discord%
        Run, nircmd setappvolume "Discord.exe" %vol_slack_discord%
    } else {
    }
return