#!/bin/sh
# Backup Home Files

[ -d "${1}" ] || { printf 'Usage: backup.sh <repo>\n' 1>&2; exit 1; }

# Get the password for the repository.
printf 'Password: '
RESTIC_PASSWORD="$(stty -echo; head -n 1; stty echo)"
printf '\n'

export RESTIC_REPOSITORY="${1}" RESTIC_PASSWORD

# Check if a repository is already initialized or the password is correct.
restic cat config >/dev/null 2>&1 || { printf 'Invalid repository or password!\n' 1>&2; exit 1; }

# Create a backup of home files.
restic backup --files-from-verbatim="${HOME}/.backup"
restic check # Check the repository for errors.
