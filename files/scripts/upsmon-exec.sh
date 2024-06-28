#!/bin/bash
# This script is managed by ansible
# Do not make any manual edits they will be lost.

FROM_ADMIN="noreply@kittytel.net"
TO_ALERT="server-alerts@kittytel.net"
TIME_NOW=`date`

case $NOTIFYTYPE in
        ONBATT)
                logger -t upsmon "Edison power down at Long Beach." "Running on battery"
		SUBJECT="[ALERT] Edison power lost at Long Beach"
		cat -v << EOF | /usr/sbin/sendmail -t -i
From: Bender <$FROM_ADMIN>
To: Server Alert Distribution List <$TO_ALERT>
Subject: Edison Power Lost at Long Beach

The UPS has lost mains power from Edison at LGB.  In 10 minutes services will degrade
to avoid data loss on LIL NAS X.

Up yours,
Bender

EOF
		touch /etc/degraded.services
		at now+10 minutes -f /usr/libexec/degrade-services
                ;;
        ONLINE)
                logger -t upsmon "Edison power restored" "Restoring all services"
		rm /etc/degraded.services
		/usr/libexec/restore-services
		SUBJECT="[ALERT] Edison power restored at Long Beach"
                cat -v << EOF | /usr/sbin/sendmail -t -i
From: Bender <$FROM_ADMIN>
To: Server Alert Distribution List <$TO_ALERT>
Subject: Edison Power restored at Long Beach

Edison power is back at Long Beach.  Services are being restored.

Bender
EOF
                ;;
        *)
                logger -t upsmon "Unrecognized command: $1"
                ;;
esac