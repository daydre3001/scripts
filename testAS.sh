#!/bin/bash 
sudo osascript <<EOF 

  delay 3

  tell application "System Events"
      keystroke "student"
      keystroke return

      delay 2

      keystroke "student"
      keystroke return
      delay 20
  end tell

      tell application "Native Access"
      activate
      delay 5
      
      tell application "System Events"

      keystroke (ASCII character 9)
      keystroke "dreday"
      end tell
end tell

EOF