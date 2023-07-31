#!/bin/sh
# Restore Home Files from Backup Repository

[ -d "${1}" ] || { printf 'Usage: restore.sh <repo> [snapshot-ID]\n' 1>&2; exit 1; }

# Get the password for the repository.
printf 'Password: '
RESTIC_PASSWORD="$(stty -echo; head -n 1; stty echo)"
printf '\n'

export RESTIC_REPOSITORY="${1}" RESTIC_PASSWORD

# Check if a repository is already initialized or the password is correct.
restic cat config >/dev/null 2>&1 || { printf 'Invalid repository or password!\n' 1>&2; exit 1; }

# Restore home files from backup repository.
restic restore --verify --target="${HOME}/" "${2:-latest}"
