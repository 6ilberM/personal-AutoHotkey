ProcessExist(ProcessName) {
    Process, Exist, %ProcessName%
    return ErrorLevel
}

vol_spotify := 0.5
vol_slack_discord := 0.5
vol_adjustment := 0.02

^F22::
if (ProcessExist("Spotify.exe")) {
    vol_spotify -= vol_adjustment
    if (vol_spotify < 0)
        vol_spotify := 0
    Run, nircmd setappvolume "Spotify.exe" %vol_spotify%
}
return

^F24::
if (ProcessExist("Spotify.exe")) {
    vol_spotify += vol_adjustment
    if (vol_spotify > 1)
        vol_spotify := 1
    Run, nircmd setappvolume "Spotify.exe" %vol_spotify%
}
return

^F23::
if (ProcessExist("slack.exe") or ProcessExist("Discord.exe")) {
    vol_slack_discord -= vol_adjustment
    if (vol_slack_discord < 0)
        vol_slack_discord := 0
    Run, nircmd setappvolume "slack.exe" %vol_slack_discord%
    Run, nircmd setappvolume "Discord.exe" %vol_slack_discord%
}
return

^F23::
if (ProcessExist("slack.exe") or ProcessExist("Discord.exe")) {
    vol_slack_discord += vol_adjustment
    if (vol_slack_discord > 1)
        vol_slack_discord := 1
    Run, nircmd setappvolume "slack.exe" %vol_slack_discord%
    Run, nircmd setappvolume "Discord.exe" %vol_slack_discord%
}
return