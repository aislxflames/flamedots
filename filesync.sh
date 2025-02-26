#!/bin/bash

# Get the user's home directory dynamically
USER_HOME="/home/$(logname)"
SOURCE_CONFIG="./Dotfiles/"

# Log file for sync activity
LOG_FILE="./rsync_log.txt"

# Function to perform rsync
sync_files() {
    echo "$(date): Syncing .config and Wallpapers to $USER_HOME..." >> "$LOG_FILE"
    rsync -avi "${SOURCE_CONFIG%/}/" "$USER_HOME/" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        echo "$(date): Error during sync. Check logs for details." >> "$LOG_FILE"
    else
        echo "$(date): Sync completed successfully." >> "$LOG_FILE"
    fi
}

# Watch the source directory for changes and sync
inotifywait -m -r -e modify,create,delete "$SOURCE_CONFIG" | while read path _ file; do
    echo "$(date): Change detected: $path$file"
    sync_files
done
