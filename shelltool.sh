#!/usr/bin/env bash

SN=$(basename "$0")

case "$SN" in
    edit-vault)
	ansible-vault edit /etc/ansible/group_vars/all/vault
        ;;
    pxe-boot)
	ansible-playbook /etc/ansible/tool-pxe-boot.yaml --limit $1
        ;;
    deploy-vm)
	ansible-playbook /etc/ansible/tool-deploy-vm.yaml --limit $1
        ;;
    install-galaxy)
	ansible-galaxy install -r /etc/ansible/requirements.yaml
        ;;
    *)
        echo "Unknown tool: $SN"
        exit 1
        ;;
esac
