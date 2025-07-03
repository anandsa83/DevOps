source common.sh
component=payment
app_path=/app

PRINT Install Python and Its Dependencies
dnf install python3 gcc python3-devel -y &>> $LOG_FILE
STAT $?

APP_PREREQ

PRINT Install Python Requirement
cd /app &>> $LOG_FILE
pip3 install -r requirements.txt &>> $LOG_FILE

SYSTEMD_SETUP