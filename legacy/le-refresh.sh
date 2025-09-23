#!/bin/bash
set -e

PLAYBOOKS=/etc/ansible
ansible-playbook $PLAYBOOKS/wf-lgb.yml
ansible-playbook $PLAYBOOKS/svc-lgb.yml
ansible-playbook $PLAYBOOKS/mx-lgb.yml
