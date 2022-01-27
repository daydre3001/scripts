#!/bin/bash 
sudo osascript <<EOF 

tell application "System Events"
    keystroke "student"
    keystroke return

    delay 2

    keystroke "student"
    keystroke return
end tell


tell application "Native Access" to activate

delay 3

tell application "System Events" to tell process "Native Access"

    keystroke "," using command down

        tell window 1
        click button "Extensions" of toolbar 1
        activate "Extensions"
        keystroke return

    end tell
end tell
EOF
