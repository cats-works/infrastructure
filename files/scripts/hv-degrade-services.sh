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

if [ ! -f /etc/degraded.services ]; then
    logger -s "degrade-services: called while /etc/degraded.services is not touched. exiting"
    exit 0
fi


logger -s "degrade-services: shutting down vms"
virsh shutdown pxe-lgb
virsh shutdown mx-lgb
virsh shutdown svc-lgb
virsh shutdown db-lgb

umount $MOUNTPOINT
if [ $? -eq 0 ]; then
	logger -s "degrade-services: powering off vms"
	virsh shutdown nas-lgb
	virsh shutdown yy-kms
	virsh shutdown unifi-lgb
else
	logger -s "degrade-services: can't unmount $MOUNTPOINT re-running script 30 seconds"
	sleep 30
	/usr/libexec/degrade-services
fi