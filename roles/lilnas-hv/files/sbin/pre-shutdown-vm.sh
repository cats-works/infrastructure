#!/bin/bash
VM_NAME="$1"

is_vm_running() {
    virsh domstate "$VM_NAME" 2>/dev/null | grep -q "running"
}

logger "Shutting down VM: $VM_NAME..."
virsh shutdown "$VM_NAME"

TIMEOUT=180
WAITED=0
SLEEP_INTERVAL=2

while is_vm_running; do
    if [ "$WAITED" -ge "$TIMEOUT" ]; then
        logger "VM did not shut down in time, forcing power off..."
        virsh destroy "$VM_NAME"
        break
    fi
    sleep $SLEEP_INTERVAL
    WAITED=$((WAITED + SLEEP_INTERVAL))
done