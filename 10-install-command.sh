#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1 #give other than 0 upto 127
else
    echo "you are running with root access"
fi

#check already installed or not. if installed $? is 0, then
# If not installed $? is not 0. expression is true
dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "mysql is not installed..going to install it"
    dnf install mysql -y
    if [ $? -eq 0 ]
then
    echo "Installing mysql is ... sucsess"
else
    echo "Installing mysql is ... failure"
    exit 1
fi
else
    echo "mysql is already installed..nothing to do"
    exit 1
fi

# dnf install mysql -y

# if [ $? -eq 0 ]
# then
#     echo "Installing mysql is ... sucsess"
# else
#     echo "Installing mysql is ... failure"
#     exit 1
# fi

