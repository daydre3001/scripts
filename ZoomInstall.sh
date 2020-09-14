#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       ZoomInstall.sh -- Installs or updates Zoom
#
# SYNOPSIS
#       sudo ZoomInstall.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1.2
#
#       - Andres Sanchez, 15.5.2020
#       (Adapted from the FirefoxInstall.sh script by Joe Farage, 18.03.2015)
#
####################################################################################################
# Script to download and install/update Zoom.
#
#

# Set preferences - set to anything besides "true" to disable
hdvideo="true"
ssodefault="false"


# choose language (en-US, fr, de)
lang="en-US"
pkgfile="ZoomInstallerIT.pkg"
plistfile="us.zoom.config.plist"
logfile="/Library/Logs/ZoomInstallScript.log"
zoomPID=$(pgrep 'zoom')
zoomopen=true

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
        ## Get OS version and adjust for use with the URL string
        OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

        ## Set the User Agent string for use with curl
        userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

        # Get the latest version of Reader available from Zoom page.
        latestver=`/usr/bin/curl -s -A "$userAgent" https://zoom.us/download | grep 'ZoomInstallerIT.pkg' | awk -F'/' '{print $3}'`
        echo "Latest Version is: $latestver"

        # Get the version number of the currently-installed Zoom, if any.
        if [ -e "/Applications/zoom.us.app" ]; then
                currentinstalledver=`/usr/bin/defaults read /Applications/zoom.us.app/Contents/Info CFBundleVersion`
          		currentinstalledver=${currentinstalledver//(*)/}
            	echo "Current installed version is: $currentinstalledver"
                if [ ${latestver} = ${currentinstalledver} ]; then
                        echo "Zoom is current. Exiting"
                        /bin/echo "`date`: Zoom is current. Exiting" >> ${logfile}
                        exit 0
                fi
        else
                echo "Zoom is not installed"
        fi

        # Check if Zoom is running
        if [ "${zoomPID}" != "" ]; then
                        zoomopen=true
                        kill ${zoomPID}
                        echo "Zoom will re-open once the Install is complete" >> ${logfile}
                else
                        zoomopen=false
                        echo "Zoom is not running, continuing with the install" >> ${logfile}
        fi

        url="https://zoom.us/client/${latestver}/ZoomInstallerIT.pkg"

        echo "Latest version of the URL is: $url"
        echo "`date`: Download URL: $url" >> ${logfile}

        # Compare the two versions, if they are different or Zoom is not present then download and install the new version.
        if [ "${currentinstalledver}" != "${latestver}" ]; then
                
                # Construct the plist file for preferences
                echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
                 <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
                 <plist version=\"1.0\">
                 <dict>
                        <key>ZDisableVideo</key>
                        <true/>
                        <key>ZAutoJoinVoip</key>
                        <true/>
                        <key>ZDualMonitorOn</key>
                        <false/>" >> /tmp/${plistfile}

                echo "<key>ZAutoFullScreenWhenViewShare</key>
                        <false/>
                        <key>ZAutoFitWhenViewShare</key>
                        <false/>" >> /tmp/${plistfile}

                if [ "${hdvideo}" == "true" ]; then
                        echo "<key>ZUse720PByDefault</key>
                        <true/>" >> /tmp/${plistfile}
                else
                        echo "<key>ZUse720PByDefault</key>
                        <false/>" >> /tmp/${plistfile}
                fi

                echo "<key>ZRemoteControlAllApp</key>
                        <true/>
                </dict>
                </plist>" >> /tmp/${plistfile}

                # Download and install new version
                /bin/echo "`date`: Current Zoom version: ${currentinstalledver}" >> ${logfile}
                /bin/echo "`date`: Available Zoom version: ${latestver}" >> ${logfile}
                /bin/echo "`date`: Downloading newer version." >> ${logfile}
                /usr/bin/curl -L -o /tmp/${pkgfile} ${url}
                /bin/echo "`date`: Installing PKG..." >> ${logfile}
                /usr/sbin/installer -allowUntrusted -pkg /tmp/${pkgfile} -target /

                /bin/sleep 10
                /bin/echo "`date`: Deleting downloaded PKG." >> ${logfile}
                /bin/rm /tmp/${pkgfile}
                /bin/echo "`date`: Installing Zoom Audio Device." >> ${logfile}
		/bin/cp -R /Applications/zoom.us.app/Contents/PlugIns/ZoomAudioDevice.driver /Library/Audio/Plug-Ins/HAL/
                /bin/echo "Installed Zoom Audio Driver"
        # If Zoom is up to date already, just log it and exit.
        else
                /bin/echo "`date`: Zoom is already up to date, running ${currentinstalledver}." >> ${logfile}
                /bin/echo "--" >> ${logfile}
        fi

else
        /bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
fi

if [ "$zoomopen" = true ]; then
	/bin/echo "`date`: Relaunching Zoom."
	/usr/bin/open /Applications/zoom.us.app/
else
	echo "Zoom is ready"
        /bin/echo "`date`: Zoom is ready" >> ${logfile}
fi

exit 0
