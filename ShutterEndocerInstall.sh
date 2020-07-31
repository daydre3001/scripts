#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       ShutterEncoderInstall.sh -- Installs/Update Shutter Encoder
#
# SYNOPSIS
#       sudo ShutterEncoderInstall.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1.0
#
#       - Andres Sanchez, 25.6.2020
#
#
####################################################################################################
# Script to download and install/update Shutter Encoder.
#
#

logfile="/Library/Logs/ShutterEncoder.log"

echo "`date` :Checking Version" >> ${logfile}
if [ -e "/Applications/Shutter Encoder.app" ]; then
  currentinstalledver=`/usr/bin/defaults read /Applications/Shutter\ Encoder.app/Contents/Info CFBundleShortVersionString`
  userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"
  latestver=`/usr/bin/curl -s -A "$userAgent" https://www.shutterencoder.com/en/ | grep 'MAC Version' | cut -d'/' -f 2 | cut -d'"' -f 1 | cut -c29-33`
  if [ ${latestver} = ${currentinstalledver} ];then
    echo "Already up to date" >> ${logfile}
    exit 0
  else
    echo 'Updating Shutter Encoder'
    /bin/rm /Applications/Shutter\ Encoder.app
  fi
  echo "`date` :Downloading and Installing ShutterEncoder" >> ${logfile}
else
  toinstall=`/usr/bin/curl -s -A "$userAgent" https://www.shutterencoder.com/en/ | grep 'MAC Version' | cut -d'/' -f 2 | cut -d'"' -f 1`
  pkgfile='ShutterEncoder.zip'
  url="http://www.shutterencoder.com/${toinstall}"
  url=${url// /%20}
  /usr/bin/curl -L -o /tmp/${pkgfile} ${url}
  /usr/bin/unzip /tmp/${pkgfile} -d /Applications
  echo "`date` :leaning up" >> ${logfile}
  /bin/rm /tmp/${pkgfile}
  /bin/rm -f -R /Applications/__MACOSX/
fi
exit 0
