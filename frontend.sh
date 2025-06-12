source common.sh
component=frontend
app_path=/usr/share/nginx/html

PRINT Disable Nginx Default module
dnf module disable nginx -y &>> $LOG_FILE
STAT $?

PRINT Enable Nginx 1.24 module
dnf module enable nginx:1.24 -y &>> $LOG_FILE
STAT $?

PRINT Install Nginx
dnf install nginx -y &>> $LOG_FILE
STAT $?

APP_PREREQ

PRINT Remove Old Nginx Config File
rm /etc/nginx/nginx.conf &>> $LOG_FILE
STAT $?

PRINT Copy New Nginx Config FIle
cp nginx.conf /etc/nginx/nginx.conf &>> $LOG_FILE
STAT $?

PRINT Start Nginx Service
systemctl daemon-reload &>> $LOG_FILE
systemctl enable nginx  &>> $LOG_FILE
systemctl restart nginx  &>> $LOG_FILE
STAT $?