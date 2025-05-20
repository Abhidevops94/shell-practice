#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 |cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started excuting at: $(date)" &>>$LOG_FILE


if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" &>>$LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "you are running with root access" &>>$LOG_FILE
fi

#Validate function takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
then
    echo -e "Installing mysql $2 is ... $G sucsess $N" &>>$LOG_FILE
else
    echo -e "Installing mysql $2 is ... $R failure $N" &>>$LOG_FILE
    exit 1
fi
}

dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "mysql is not installed..going to install it" &>>$LOG_FILE
    dnf install mysql -y &>>$LOG_FILE
    VALIDATE $? "mysql"
else
    echo -e "$Y mysql is already installed..nothing to do $N" &>>$LOG_FILE
fi

dnf list installed python3 &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "python3 is not installed..going to install it" &>>$LOG_FILE
    dnf install python3 -y &>>$LOG_FILE
    VALIDATE $? "python3"
else
    echo -e "$Y python3 is already installed..nothing to do $N" &>>$LOG_FILE
fi

dnf list installed nginx &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "nginx is not installed..going to install it" &>>$LOG_FILE
    dnf install nginx -y &>>$LOG_FILE
    VALIDATE $? "nginx"
else
    echo -e "$Y nginx is already installed..nothing to do $N" &>>$LOG_FILE
fi
