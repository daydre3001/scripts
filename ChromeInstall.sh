#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       ChromeInstall.sh -- Installs Google Chrome
#
# SYNOPSIS
#       sudo ChromeInstall.sh
#
####################################################################################################
#
#       Version: 1.0
#
#       - Andres Sanchez, 8.11.2021
#       
#
####################################################################################################
# Script to download and install Google Chrome.

logfile="/Library/Logs/ChromeInstall.log"
imgfile="googlechrome.dmg"

if  [[ `arch` == arm64 ]]; then
        echo "Architecture is Apple ARM"
        curl -L -s -S -o /tmp/${imgfile} https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
    else
        echo "Architecture is Intel X86"
        curl -L -s -S -o /tmp/${imgfile} https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
fi

echo "Deleting old version of Chrome" >> ${logfile}
rm -rf /Applications/Google\ Chrome.app
cho "Attaching and installing Chrome" >> ${logfile}
/usr/bin/hdiutil attach --quite --nobrowse /tmp/${imgfile}
cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
/bin/sleep 5
echo "Cleaning up" >> ${logfile}
/usr/bin/hdiutil detach /Volumes/Google\ Chrome/
/bin/rm /tmp/${imgfile}
/bin/sleep 5

echo "Setting AutoUpdate for Google Chrome" >> ${logfile}
python ChromeAutoUpdate.py