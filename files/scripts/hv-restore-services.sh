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


logger -s "restore-services: starting vms"

virsh start nas-lgb
virsh start yy-kms
virsh start unifi-lgb

rm /etc/degraded.services
/usr/local/sbin/stage2-boot