component=dispatch
source common.sh
app_path=/app


APP_PREREQ

PRINT Install Golang
dnf install golang -y &>> $LOG_FILE
cd /app 
PRINT Configure Golang
go mod init dispatch &>> $LOG_FILE
go get &>> $LOG_FILE
go build &>> $LOG_FILE

SYSTEMD_SETUP