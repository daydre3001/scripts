#!/bin/bash

# looks like they changed they name again
# https://groups.google.com/forum/#!topic/munki-dev/w38roCmEgH0
# I have 11.2.1.203 and it is now just 'shoe'
# Changed once again, 12.0.0.456 and it is 'shoetoolv120'

# Copy the com.avid.bsd.shoe Helper Tool
PHT_SHOE="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

/bin/cp "/Applications/Pro Tools.app/Contents/Library/LaunchServices/com.avid.bsd.shoetoolv120" $PHT_SHOE
/usr/sbin/chown root:wheel $PHT_SHOE
/bin/chmod 544 $PHT_SHOE

# Create the Launch Deamon Plist for com.avid.bsd.shoe
PLIST="/Library/LaunchDaemons/com.avid.bsd.shoetoolv120.plist"
FULL_PATH="/Library/PrivilegedHelperTools/com.avid.bsd.shoetoolv120"

rm -f $PLIST # Make sure we are idempotent

/usr/libexec/PlistBuddy -c "Add Label string" $PLIST
/usr/libexec/PlistBuddy -c "Set Label com.avid.bsd.shoetoolv120" $PLIST

/usr/libexec/PlistBuddy -c "Add MachServices dict" $PLIST
/usr/libexec/PlistBuddy -c "Add MachServices:com.avid.bsd.shoetoolv120 bool" $PLIST
/usr/libexec/PlistBuddy -c "Set MachServices:com.avid.bsd.shoetoolv120 true" $PLIST

/usr/libexec/PlistBuddy -c "Add Program string" $PLIST
/usr/libexec/PlistBuddy -c "Set Program $FULL_PATH" $PLIST

/usr/libexec/PlistBuddy -c "Add ProgramArguments array" $PLIST
/usr/libexec/PlistBuddy -c "Add ProgramArguments:0 string" $PLIST
/usr/libexec/PlistBuddy -c "Set ProgramArguments:0 $FULL_PATH" $PLIST

/bin/launchctl load $PLIST

chown -R root:wheel /Users/Shared/*
chmod -R a+rw "/Users/Shared/Pro Tools"
chmod -R a+rw "/Users/Shared/AvidVideoEngine"