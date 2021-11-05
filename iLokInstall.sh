#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       iLokInstall.sh -- Installs or updates Zoom
#
# SYNOPSIS
#       sudo iLokInstall.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1.0
#
#       - Andres Sanchez, 15.5.2020
#
#
####################################################################################################
# Script to download and install/update iLok License Manager.
#
#

#set urls and logging info
url="http://installers.ilok.com/iloklicensemanager/LicenseSupportInstallerMac.zip"
logfile="/Library/Logs/iLokInstallScript.log"
pkgfile="LicenseSupportInstallerMac.zip"

#Download New iLok
/bin/echo "`date`: Downloading file" >> ${logfile}
/usr/bin/curl -L -o /tmp/${pkgfile} ${url}

#Expand the Zip File
/bin/echo "`date`: Expanding Zip File" >> ${logfile}
/usr/bin/unzip /tmp/${pkgfile} -d /tmp/ilokinstall/
image=$(ls /tmp/ilokinstall/ | grep .dmg)
/bin/echo "`date`: Found image: ${image}" >> ${logfile}

#Mount Volumen
/bin/echo "`date`: Mounting Volumen" >> ${logfile}
/usr/bin/hdiutil attach /tmp/ilokinstall/${image}
/bin/echo "`date`: Mounting Image"
installvol=$(ls /Volumes/ | grep License)
echo "Install Vol name: ${installvol}"
installpkg=$(ls /Volumes/"${installvol}" | grep .pkg)
echo "Install pkg name: ${installpkg}"
/bin/echo "`date`: Installing the new iLok Manager"

#Install iLok package
/bin/echo "`date`: Runnign Installer target /" >> ${logfile}
/usr/sbin/installer -allowUntrusted -pkg /Volumes/"${installvol}"/"${installpkg}" -target /

#unmount Volume and clean up
/bin/echo "`date`: Cleaning up" >> ${logfile}
/usr/bin/hdiutil detach /Volumes/"${installvol}"
/bin/rm /tmp/${pkgfile}
/bin/rm -r /tmp/ilokinstall
/bin/echo "Install Complete"
/bin/echo "`date`: Install Complete" >> ${logfile}

exit 0