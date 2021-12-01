#!/bin/bash
# This sets the variable for jamfHelper results from which button was clicked
buttonClicked=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/HCS.png -title "HCS Technology Group" -heading "My First Jamf Helper Window" -description "This is anexample of my first Jamf Helper Utility Window" -button1 "OK" -button2 "Cancel")
if [ $buttonClicked == 0 ]; then
    # Buttion 1 was Clicked
    echo "OK"
elif [ $buttonClicked == 2 ]; then
    # Buttion 2 was Clicked
    echo "Cancel"
fi