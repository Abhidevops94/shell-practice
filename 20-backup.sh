#!/bin/bash

START_TIME=$(date +%s)
USERID=$(id -u)
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # Default to 14 days if not provided

# Colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

# Ensure logs folder exists before logging
mkdir -p "$LOGS_FOLDER"

echo "Script started executing at: $(date)" | tee -a "$LOG_FILE"

check_root() {
    if [ "$USERID" -ne 0 ]; then
        echo -e "${R}ERROR:: Please run this script with root access${N}" | tee -a "$LOG_FILE"
        exit 1
    else
        echo "You are running with root access" | tee -a "$LOG_FILE"
    fi
}

validate() {
    if [ "$1" -eq 0 ]; then
        echo -e "$2 ... ${G}SUCCESS${N}" | tee -a "$LOG_FILE"
    else
        echo -e "$2 ... ${R}FAILURE${N}" | tee -a "$LOG_FILE"
        exit 1
    fi
}

usage() {
    echo -e "${Y}USAGE:${N} sudo bash $0 <source-dir> <destination-dir> [days]" | tee -a "$LOG_FILE"
}

# Input validation
if [ $# -lt 2 ]; then
    usage
    exit 1
fi

check_root

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${R}Source directory $SOURCE_DIR doesn't exist. Please check.${N}" | tee -a "$LOG_FILE"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo -e "${R}Destination directory $DEST_DIR doesn't exist. Please check.${N}" | tee -a "$LOG_FILE"
    exit 1
fi

# Find matching files
FILES=$(find "$SOURCE_DIR" -name "*.log" -mtime +"$DAYS")

if [ -n "$FILES" ]; then
    echo "Files to zip:" | tee -a "$LOG_FILE"
    echo "$FILES" | tee -a "$LOG_FILE"

    TIME_STAMP=$(date +%F-%H-%M-%S)
    ZIP_FILE="$DEST_DIR/app-logs-$TIME_STAMP.zip"

    echo "$FILES" | zip -@ "$ZIP_FILE"
    validate $? "Zipping log files"

    if [ -f "$ZIP_FILE" ]; then
        while IFS= read -r filepath; do
            echo "Deleting file: $filepath" | tee -a "$LOG_FILE"
            rm -f "$filepath"
        done <<< "$FILES"

        echo -e "Log files older than $DAYS days from source directory removed ... ${G}SUCCESS${N}" | tee -a "$LOG_FILE"
    else
        echo -e "Zip file creation ... ${R}FAILURE${N}" | tee -a "$LOG_FILE"
        exit 1
    fi
else
    echo -e "No files found older than $DAYS days ... ${Y}SKIPPING${N}" | tee -a "$LOG_FILE"
fi
