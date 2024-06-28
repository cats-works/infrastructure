# knar-server-pxe

This is the cat's ansible role for deploying a PXE software server.  **This does not deploy DHCP services** and assumes that
you have DHCP provided by another source (router, dhcpd server, etc).

This playbook has been tested against Debian Jessie.  It should work on Ubuntu.  YMMV on other distributions not based on dpkg.

By deploying this playbook you will get a server capable of serving multiple linux distributions and utilities.  As most of the configurations are PXE booting are dependent on the ISO contents, the ISO files are retained on-disk and mounted as a loop iso9660
filesystem.  This means that you can use this server for both downloading ISO files direct as well as accessing their contents over HTTP
without disk space duplication.

## Details 
This role will deploy nginx and tftpd-hpa.  It configures all data at /srv/ with the following two folders:
 * /srv/iso <-- ISO file storage
 * /srv/tftp <-- tftp/httpd service root
 * /srv/tftp/iso <-- symbolic link back to /srv/iso

Both BIOS and EFI64 are supported.  Since it's heavily unused I have not written any support for 32 bit x86 EFI.  I may eventually patch in AARCH64 support if I have any devices in the future.

The PXELINUX menus are a maze of include statements that I hope I have commented well enough.  The reason for the maze is to have a mostly unified menu system, while still retaining the ability to add options for arch-specific utilities/distributions (IE: EFI Firmware, etc).

