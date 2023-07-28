#!/bin/sh
# Backup Home Files

[ -d "${1}" ] || { printf 'Usage: backup.sh <repo>\n' 1>&2; exit 1; }

# Get the password for the repository.
RESTIC_PASSWORD="$(keepassxc-cli show --attributes Password "${HOME}/.secrets/passwords.kdbx" 'Backup/Personal')" || exit 1

export RESTIC_REPOSITORY="${1}" RESTIC_PASSWORD

# Check if a repository is already initialized.
if ! restic cat config >/dev/null 2>&1; then
	printf 'Initialize the repository (y/N)? '; read -r ans
	[ -n "${ans}" ] && { [ -z "${ans#y}" ] || [ -z "${ans#Y}" ]; } && restic init
	exit 1
fi

# Create a backup of home files.
restic backup --files-from-verbatim="${HOME}/.backup"
restic check # Check the repository for errors.
