#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1 #give other than 0 upto 127
else
    echo "you are running with root access"
fi

#Validate function takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
then
    echo "Installing mysql $2 is ... sucsess"
else
    echo "Installing mysql $2 is ... failure"
    exit 1
fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "mysql is not installed..going to install it"
    dnf install mysql -y
    VALIDATE $? "mysql"
else
    echo "mysql is already installed..nothing to do"
fi

dnf list installed python3
if [ $? -ne 0 ]
then
    echo "python3 is not installed..going to install it"
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo "python3 is already installed..nothing to do"
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
    echo "nginx is not installed..going to install it"
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed..nothing to do"
fi