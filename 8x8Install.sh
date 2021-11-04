#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       8x8Install.sh -- Installs or updates 8x8 Work
#
# SYNOPSIS
#       sudo 8x8Install.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1
#
#       - Andres Sanchez, 20.4.2021
#       
#
####################################################################################################
# Script to download and install/update 8x8 Work.
#

logfile="/Library/Logs/8x8InstallScript.log"

## Close 8x8
pkill '^8x8 Work$'
/bin/rm -r -f "/Applications/8x8 Work.app"
echo "`date` : Deleting 8x8" >> ${logfile}

## Get OS version and adjust for use with the URL string
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

## Set the User Agent string for use with curl
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

## Get the latest version of Reader available from 8x8 website.
url=`/usr/bin/curl -s -A "$userAgent" https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep '.dmg' | awk -F'https://' '{print $2}' | awk -F'href' 'NR==1 {print $1}' | sed 's/"//'`
imgfile=`echo ${url} | cut -d '/' -f3`

## Download the 8x8 image
/usr/bin/curl -L -o /tmp/${imgfile} ${url}
echo "`date` : Downloading 8x8 image" >> ${logfile}

## Attach and copy the 8x8 app
echo "`date` : Attaching image" >> ${logfile}
/usr/bin/hdiutil attach -nobrowse /tmp/${imgfile}
installvol=$(ls /Volumes/ | grep 8x8)
appName=`ls "/Volumes/${installvol}/" | grep 8x8`
echo "`date` : Copying $appName to Applications folder"
/bin/cp -R "/Volumes/${installvol}/${appName}" /Applications/

## Detach and remove image
echo "`date` : Detaching and cleaning up" >> ${logfile}
/usr/bin/hdiutil detach /Volumes/"${installvol}"
/bin/rm /tmp/${imgfile}
echo "`date` : 8x8 is ready" >> ${logfile}

exit 0