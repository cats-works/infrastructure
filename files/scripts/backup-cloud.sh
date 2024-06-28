#!/usr/bin/env bash
# This script is managed by ansible
# Do not make any manual edits they will be lost.

set -e
set -u
set -o pipefail

source /etc/nxcbackup.conf

__failback () {
    /usr/local/bin/occsys maintenance:mode --off
    exit 1
}

DATECODE=$(date +%Y-%m-%d)

/usr/local/bin/occsys maintenance:mode --on

echo "Removing SQL backups older than 7 days"
find /nxc-data/sql-backups/ -type f -name '*.enc' -mtime +7 -exec rm -f {} \; || __failback

echo "Creating SQL backup"
mysqldump nextcloud | gpg -z 9 --batch --yes --encrypt --recipient "${GPG_RCPT}" --output \
	"${NXC_DATA_PATH}/sql-backups/nxc-${DATECODE}.sql.enc" || __failback

echo "Backing up encryption keys"

USER_FILE_PATHS=$(find "${NXC_DATA_PATH}"/*/files_encryption/ -maxdepth 0 -type d | tr '\n' ' ')

tar cz $USER_FILE_PATHS \
  "${NXC_DATA_PATH}/files_encryption/" | gpg -z 9 --batch --yes --encrypt \
  --recipient "${GPG_RCPT}" --output \
  "${NXC_DATA_PATH}/sql-backups/keys-${DATECODE}.tar.enc" || __failback

echo "Syncing with B2"
/usr/bin/rclone sync --exclude=*/files_encryption/** --exclude=files_encryption/** \
 --exclude=ownbackup/** --exclude=appdata_ocaczurp5vlc/preview/** --retries 1 /nxc-data/ "b2b:${B2_REPO_ID}" || __failback

/usr/local/bin/occsys maintenance:mode --off