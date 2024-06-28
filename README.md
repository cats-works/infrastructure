This is a collection of Ansible playbooks for managing the Kitty Telecom infrastructure.  This contains plays for services including but not limited to:

* nginx/php-fpm
* NextCloud
* LibreNMS
* Postfix/Dovecot GSSAPI MTA
* nut (network UPS tools)
* chronyd (with GPS reciever)
* MariaDB
* PXE server (PXELINUX soon to be replaced with iPXE)

This also includes personal things including

* Deploying libvirt VM's from PXE (full autoinstall via ansbile)
* Deployment of SSH keys
* Joining Active Directory (WinBind & SSSD)
* Provisioning my NAS server (Samba SMB, NFS4)
* Provisioning a 2nd SMB server for Legacy devices on my NAS server
* Some helper scripts to bootstrap NAS reliant VM's (my NAS runs in a VM itself)
* Provisioning my dog's website
* Handling ACME SSL (Lets Encrypt)

I am publishing this in the hopes anybody learning Ansible may find this useful.