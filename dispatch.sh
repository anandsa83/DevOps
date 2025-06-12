component=dispatch
source common.sh
app_path=/app


APP_PREREQ

dnf install golang -y
cd /app 
go mod init dispatch
go get 
go build

SYSTEMD_SETUP