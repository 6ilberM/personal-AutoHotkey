#SingleInstance Ignore

ProcessExist(ProcessName) {
    Process, Exist, %ProcessName%
    return ErrorLevel
}

F23::
    if (ProcessExist("slack.exe")) {
        Run, nircmd changeappvolume "slack.exe" + 0.1
    }
    if (ProcessExist("Discord.exe")) {
        Run, nircmd changeappvolume "Discord.exe" + 0.1
    }
return

F21::
    if (ProcessExist("slack.exe")) {
        Run, nircmd changeappvolume "slack.exe" - 0.1
    }
    if (ProcessExist("Discord.exe")) {
        Run, nircmd changeappvolume "Discord.exe" - 0.1
    }
return

F22::
    if (ProcessExist("Spotify.exe")) {
        Run, nircmd changeappvolume "Spotify.exe" - 0.05
    }
return

F24::
    if (ProcessExist("Spotify.exe")) {
        Run, nircmd changeappvolume "Spotify.exe" + 0.05
    }
return
