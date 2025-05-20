#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 |cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python3" "nginx" "httpd")

mkdir -p $LOGS_FOLDER
echo "script started excuting at: $(date)" | tee -a $LOG_FILE


if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "you are running with root access" | tee -a $LOG_FILE
fi

#Validate function takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
then
    echo -e "Installing mysql $2 is ... $G sucsess $N" | tee -a $LOG_FILE
else
    echo -e "Installing mysql $2 is ... $R failure $N" | tee -a $LOG_FILE
    exit 1
fi
}

#for package in ${PACKAGES[@]}
for package in $@
do
    dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]
then
    echo "$package is not installed..going to install it" | tee -a $LOG_FILE
    dnf install $package -y &>>$LOG_FILE
    VALIDATE $? "$package"
else
    echo -e "$Y $package is already installed..nothing to do $N" | tee -a $LOG_FILE
fi
done