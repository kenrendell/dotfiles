#!/bin/sh
# Restore Home Files from Backup Repository

[ -d "${1}" ] || { printf 'Usage: restore.sh <repo>\n' 1>&2; exit 1; }

# Get the password for the repository.
RESTIC_PASSWORD="$(keepassxc-cli show --attributes Password "${HOME}/.secrets/passwords.kdbx" 'Backup/Personal')" || exit 1

export RESTIC_REPOSITORY="${1}" RESTIC_PASSWORD

# Check if a repository is already initialized.
restic cat config >/dev/null 2>&1 || { printf 'Backup repository is not initialized!\n' 1>&2; exit 1; }

# Restore home files from backup repository.
restic restore --verify --target="${HOME}/" 'latest'
