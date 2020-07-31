#!/bin/bash
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       VersionInfo.sh -- Gives the version of installed apps
#
# SYNOPSIS
#       sudo VersionInfo.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1.0
#
#       - Andres Sanchez, 22.6.2020
#
#
####################################################################################################
# Script that looks for the version info of every app in the /Applications folder and generates
# an HTML file in the folder /Applications/VersionCheck.
#
#

outfile=/Applications/versionChecker/Versions.html
DIR=/Applications

if [ ! -d "/Applications/versionCheck/" ]; then
  mkdir -p "/Applications/versionChecker"
fi

if [ -f "${outfile}" ]; then
  rm ${outfile}
fi

echo "<!DOCTYPE html>" >> ${outfile}
echo "<html>" >> ${outfile}
echo "<body>" >> ${outfile}
echo "<h1>`hostname`</h1>" >> ${outfile}
echo "<h2>Date: `date`</h2>" >> ${outfile}

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
check="app"
for name in $(ls "$DIR");
do
  if [[ "$name" == *"$check"* ]]; then
    echo "<p>$name: `/usr/bin/defaults read /Applications/"$name"/Contents/Info CFBundleShortVersionString`</p>" >> ${outfile}
    echo "" >> ${outfile}
  else
    continue
  fi
done

echo "</body>" >> ${outfile}
echo "</html>" >> ${outfile}

IFS=$SAVEIFS
exit 0