source common.sh
component=redis

PRINT Disable Redis Default Module
dnf module disable redis -y &>> $LOG_FILE
STAT $?

PRINT Enable Redis 7 Module
dnf module enable redis:7 -y &>> $LOG_FILE
STAT $?

PRINT Install Redis
dnf install redis -y  &>> $LOG_FILE
STAT $?

PRINT Edit Redis Confiuration
sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ s/yes/no/' /etc/redis/redis.conf &>> $LOG_FILE
STAT $?

PRINT Start Redis Service
systemctl enable redis &>> $LOG_FILE
systemctl restart redis &>> $LOG_FILE
STAT $?