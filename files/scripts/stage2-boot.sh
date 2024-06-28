#!/bin/bash
# This script is managed by ansible
# Do not make any manual edits they will be lost.

NASVM="nas-lgb"
MOUNTPOINT="/nasvms"
SCRIPT=$(readlink -f $0)

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "`virsh domstate $NASVM | grep running`" ]; then
	logger -s "stage2-boot: nas-lgb not yet running using at to rerun 1 minute later"
	sleep 30
	/usr/local/sbin/stage2-boot
	exit 0
fi

if [ -n "`mount | grep $MOUNTPOINT`" ]; then
	logger -s "stage2-boot: $MOUNTPOINT Already mounted - starting vms"
        virsh start db-lgb
        virsh start mx-lgb
        virsh start svc-lgb
        virsh start pxe-lgb
	exit 0
fi

mount /var/lib/libvirt/images/iso-images
mount $MOUNTPOINT

if [ $? -eq 0 ]; then
	logger -s "stage2-boot: $MOUNTPOINT mounted by script - starting vms"
	virsh start db-ldb
	virsh start svc-lgb
    virsh start mx-lgb
    virsh start pxe-lgb
	rm /etc/degraded.services
else
	logger -s "stage2-boot: $MOUNTPOINT is not ready to mount - restarting again 1 min later via at"
	sleep 30
        /usr/local/sbin/stage2-boot
fi