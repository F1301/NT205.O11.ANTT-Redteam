#!/bin/bash

# Target file path
TARGET_FILE="/var/www/html/public/deploy.sh"

# Writing the script to the target file
cat << 'EOF' > "$TARGET_FILE"
#!/bin/bash

# Variables
HOST="172.16.0.10"
USERNAME="vmtien"
PASSWORD="minhtien"
LOCAL_PATH="*"  # All files in the current directory
REMOTE_PATH="/var/www/html/public/"

# Install sshpass if not already installed (Ubuntu/Debian)
if ! command -v sshpass &> /dev/null; then
    echo "sshpass could not be found, installing..."
    sudo apt-get update
    sudo apt-get install -y sshpass
fi

# Using sshpass to automate password entry for scp
sshpass -p "$PASSWORD" scp $LOCAL_PATH "${USERNAME}@${HOST}:${REMOTE_PATH}"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "File transfer successful."
else
    echo "File transfer failed."
fi
EOF

# Giving execute permissions to the script
chmod +x "$TARGET_FILE"

echo "Script written to $TARGET_FILE and made executable."
