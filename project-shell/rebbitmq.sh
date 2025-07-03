source common.sh
component=rabbitmq

PRINT Copy Rebbitmq Repo File
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LOG_FILE
STAT $?

PRINT Install RebiitMQ Server
dnf install rabbitmq-server -y &>> $LOG_FILE
STAT $?

PRINT Start RebbitMQ Service
systemctl enable rabbitmq-server &>> $LOG_FILE
systemctl restart rabbitmq-server &>> $LOG_FILE
STAT $?

PRINT Add User in RabbitMQ
rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
STAT $?