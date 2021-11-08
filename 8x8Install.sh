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
#       Version: 2.3
#
#       - Andres Sanchez, 8.11.2021
#       
#
####################################################################################################
# Script to download and install/update 8x8 Work.
#

workPID=$(pgrep '8x8')
logfile="/Library/Logs/8x8InstallScript.log"
url=`/usr/bin/curl -s -A "$userAgent" https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep '.dmg' | awk -F'https://' '{print $2}' | awk -F'href' 'NR==1 {print $1}' | sed 's/"//'`
imgfile=`echo ${url} | cut -d '/' -f3`

latestver=`expr "$imgfile" : '.*\(v[0-9].*[0-9]\)'`
latestver=${latestver/v/}
latestver=${latestver/-/.}

echo "Checking for installed version"
isinstalled=`ls /Applications/ | grep "8x8"`
if [ "${isinstalled}" ]; then
    currentinstalledver=`/usr/bin/defaults read /Applications/8x8\ Work.app/Contents/Info CFBundleVersion`
    currentinstalledver=${currentinstalledver//(*)/}
    echo "Current installed version is: $currentinstalledver" >> ${logfile}

    if [ "${latestver}" = "${currentinstalledver}" ]; then
        echo "8x8 is current. Exiting" >> ${logfile}
        echo "8x8 is current. Exiting"
        exit 0
        else
        echo "Downloading and Installing 8x8"
                ## Close 8x8 if runnig
            if [ "${workPID}" != "" ]; then
                    kill ${workPID}
                    echo "`date` : closing 8x8 " >> ${logfile}
            fi
            # unmounting all other images
            images=$(ls /Volumes/ | grep "8x8")
            if [ "$images" ]; then
                echo "Ejecting old 8x8 images" >> ${logfile}
                echo "$images" | while read line ; do
                hdiutil detach /Volumes/"$line"
                done
            else
                echo "No other 8x8 images mounted" >> ${logfile}
            fi
    fi
    else
    echo "8x8 not installed"
    echo "8x8 not installed" >> ${logfile}
fi

## Get OS version and adjust for use with the URL string
OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

## Set the User Agent string for use with curl
userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

set -e
## Download the latest 8x8 image
echo "`date` : Downloading 8x8 image" >> ${logfile}
echo "`date` : Downloading 8x8 image"
/usr/bin/curl -L -s -S -o /tmp/${imgfile} ${url}

if [ "${isinstalled}" ]; then
    echo "`date` : Deleting 8x8" >> ${logfile}
    /bin/rm -r -f "/Applications/8x8 Work.app"
fi

echo "Installing 8x8"
## Attach and copy the 8x8 app
echo "`date` : Attaching image ${imgfile}" >> ${logfile}
/usr/bin/hdiutil attach -nobrowse -quiet /tmp/${imgfile}
installvol=$(ls /Volumes/ | grep 8x8)
appName=`ls "/Volumes/${installvol}/" | grep 8x8`
echo "`date` : Copying $appName to Applications folder" >> ${logfile}
/bin/cp -R "/Volumes/${installvol}/${appName}" /Applications/

## Detach and remove image
echo "`date` : Detaching $installvol and cleaning up" >> ${logfile}
/usr/bin/hdiutil detach /Volumes/"${installvol}"
/bin/rm /tmp/${imgfile}
echo "`date` : 8x8 is ready" >> ${logfile}

exit 0