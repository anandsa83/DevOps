source common.sh

PRINT Copy Mongo Repo FIle
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
STAT $?

PRINT Install MongoDB
dnf install mongodb-org -y  &>> $LOG_FILE
STAT $?

PRINT Edit Mongo COnfiguration
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOG_FILE
STAT $?

PRINT Start MongDB Service
systemctl enable mongod &>> $LOG_FILE
systemctl restart mongod &>> $LOG_FILE
STAT $?