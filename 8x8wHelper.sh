#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       8x8wHelper.sh -- Installs or updates 8x8 Work
#
# SYNOPSIS
#       sudo 8x8Install.sh
#
####################################################################################################
#
#       Version: 2.7
#
#       - Andres Sanchez, 12.1.2021
#       
#
####################################################################################################
# Script to download and install/update 8x8 Work while letting the user know
#

title="SAE Institute"
heading="Your 8x8 applications requires an update"
description="8x8 will need to close to install the update, this will take a few moments to complete"
button1="Update"
button2="Cancel"

workPID=$(pgrep '8x8')
logfile="/Library/Logs/8x8InstallScript.log"
url=`/usr/bin/curl -s -A "$userAgent" https://support.8x8.com/cloud-phone-service/voice/work-desktop/download-8x8-work-for-desktop | grep '.dmg' | awk -F'https://' '{print $2}' | awk -F'href' 'NR==1 {print $1}' | sed 's/"//'`
imgfile=`echo ${url} | cut -d '/' -f3`

latestver=`expr "$imgfile" : '.*\(v[0-9].*[0-9]\)'`
latestver=${latestver/v/}
latestver=${latestver/-/.}

downloadAndInstall () {
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
    /bin/sleep 5

    ## Detach and remove image
    echo "`date` : Detaching $installvol and cleaning up" >> ${logfile}
    /usr/bin/hdiutil detach /Volumes/"${installvol}" -force
    /bin/rm /tmp/${imgfile}
    echo "`date` : 8x8 is ready" >> ${logfile}
} 

verifyInstall () {
    verify=`ls /Applications/ | grep "8x8"`
    if [ "${verify}" ]; then
        return 0
    else
        echo "`date` : An issue was encountered, please trying again" >> %{logfile}
        downloadAndInstall
    fi
}

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
        buttonClicked=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$title" -heading "$heading"  -description "$description"  -button1 "$button1"  -button2 "$button2" -defaultButton 1 -cancelButton 2`
        if [ $buttonClicked == 0 ]; then
            # Close 8x8 if runnig
            if [ "${workPID}" != "" ]; then
                    kill ${workPID}
                    echo "`date` : closing 8x8 " >> ${logfile}
            fi
            # unmounting all other images
            images=$(ls /Volumes/ | grep "8x8")
            if [ "$images" ]; then
                echo "Ejecting old 8x8 images" >> ${logfile}
                echo "$images" | while read line ; do
                hdiutil detach /Volumes/"$line" -force
                done
            else
                echo "No other 8x8 images mounted" >> ${logfile}
            fi
            downloadAndInstall
            verifyInstall
            buttonComplete=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$title" -heading "Update Complete"  -description "8x8 is ready!"  -button1 "OK" -button2 "Exit" -defaultButton 1 -cancelButton 2`
            if [ $buttonComplete == 0 ]; then
                exit 0
            elif [ $buttonComplete == 1]; then
                exit 0
            fi
        elif [ $buttonClicked == 1 ]; then
            exit 0
        fi
    fi
else
    echo "8x8 not installed"
    echo "8x8 not installed" >> ${logfile}
    downloadAndInstall
fi
