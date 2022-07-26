#!/bin/bash
# This sets the variable for jamfHelper results from which button was clicked
buttonClicked=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Emergency Test" -heading "This is only a TEST" -description "This is a test of the emergency notification system" -icon /Users/admin/Documents/new_logo_white.png -button1 "OK" -timeout 10)
if [ $buttonClicked == 0 ]; then
    # Buttion 1 was Clicked
    echo "OK"
elif [ $buttonClicked == 2 ]; then
    # Buttion 2 was Clicked
    echo "Cancel"
fi
