#!/bin/bash

# Variables
WINDOWS_HOST="10.10.10.102"
USERNAME="tqkhang"
PASSWORD="anhmajyeuem"
FILE_PATH="C:\Users\tqkhang\Desktop"
BACKUP_PATH="/var/backups/tqkhang"

scp "${USERNAME}@${WINDOWS_HOST}:${FILE_PATH}" "${BACKUP_PATH}"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "Backup successful."
else
    echo "Backup failed."
fi
