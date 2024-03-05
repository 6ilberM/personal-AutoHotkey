; Hotkey to decrease volume for Spotify
^F22:: Run, nircmd changeappvolume "Spotify.exe" - 0.05 return

; Hotkey to increase volume for Spotify
^F24:: Run, nircmd changeappvolume "Spotify.exe" + 0.05 return

; Hotkey to decrease volume for Slack and Discord
^F21::
    Run, nircmd changeappvolume "slack.exe" - 0.05
    Run, nircmd changeappvolume "Discord.exe" - 0.05
return

; Hotkey to increase volume for Slack and Discord
^F23::
    Run, nircmd changeappvolume "slack.exe" + 0.05
    Run, nircmd changeappvolume "Discord.exe" + 0.05
return
