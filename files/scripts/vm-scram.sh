#!/bin/bash
# This script is managed by ansible
# Do not make any manual edits they will be lost.

NASVM="nas-lgb"
MOUNTPOINT="/nasvms"
SCRIPT=$(readlink -f $0)
export SHELL=/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

logger -s "scram: shutting down vms"
virsh shutdown db-lgb
virsh shutdown mx-lgb
virsh shutdown svc-lgb
virsh shutdown pxe-lgb

umount $MOUNTPOINT
if [ $? -eq 0 ]; then
	logger -s "scram: powering off"
	virsh shutdown nas-lgb
	/sbin/poweroff
else
	logger -s "scram: can't unmount $MOUNTPOINT re-running script 1 minute later via at"
	sleep 30
	/usr/sbin/scram
fi