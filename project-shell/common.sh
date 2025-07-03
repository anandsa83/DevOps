LOG_FILE=/tmp/devops.log
rm -f $LOG_FILE
code_dir=$(pwd)

PRINT () {
    echo &>> $LOG_FILE
    echo &>> $LOG_FILE
    echo "############################ $* ###########################" &>> $LOG_FILE
    echo $*
}

STAT () {
    if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCESS\e[0m"
    else
    echo -e "\e[31mFAILURE\e[0m"
    echo
    echo "Refer the log file for more information: $LOG_FILE"
    exit $1
    fi
}


APP_PREREQ ()   {
    PRINT Adding Application User
    id roboshop &>> $LOG_FILE
    if [ $? -ne 0 ]; then
    useradd roboshop &>> $LOG_FILE
    fi
    STAT $?

    PRINT Remove Old Content
    rm -fr ${app_path} &>> $LOG_FILE
    STAT $?

    PRINT Create App Directory
    mkdir ${app_path} &>> $LOG_FILE
    STAT $?

    PRINT Download Application Content
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>> $LOG_FILE
    STAT $?

    PRINT Extract Application Content
    cd ${app_path}
    unzip /tmp/${component}.zip &>> $LOG_FILE
    STAT $?
}


SYSTEMD_SETUP ()    {
    PRINT Copy Service File
    cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>> $LOG_FILE
    STAT $?

    PRINT Start the Servcie
    systemctl daemon-reload &>> $LOG_FILE
    systemctl enable ${component} &>> $LOG_FILE
    systemctl start ${component} &>> $LOG_FILE
    STAT $?
}

NODEJS ()   {
    PRINT Disable NodeJS Default Version
    dnf module disable nodejs -y &>> $LOG_FILE
    STAT $?

    PRINT Enable NodeJS 20 Module
    dnf module enable nodejs:20 -y &>> $LOG_FILE
    STAT $?

    PRINT Install NodeJS
    dnf install nodejs -y &>> $LOG_FILE
    STAT $?

    APP_PREREQ

    PRINT Download NodeJS Dependencies
    npm install &>> $LOG_FILE
    STAT $?

    SCHEMA_SETUP
    SYSTEMD_SETUP
}


JAVA () {
    PRINT Install Java and Maven
    dnf install maven -y &>> $LOG_FILE
    STAT $?

    APP_PREREQ

    PRINT Download Dependencies
    mvn clean package &>> $LOG_FILE
    mv target/shipping-1.0.jar shipping.jar &>> $LOG_FILE
    STAT $?

    SCHEMA_SETUP
    SYSTEMD_SETUP
}

SCHEMA_SETUP () {
    if [ "$schema_setup" == "mongo" ]; then
    PRINT Copy MongDB Repo File
    cp /root/DevOps/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
    STAT $?

    PRINT Install MongoDB Client
    dnf install mongodb-mongosh -y &>> $LOG_FILE
    STAT $?

    PRINT Load Master Data
    mongosh --host mongodb.dev.adevops.click </app/db/master-data.js &>> $LOG_FILE
    STAT $?
    fi

    if [ "$schema_setup" == "mysql" ]; then
    PRINT Install MySQL Client
    dnf install mysql -y &>> $LOG_FILE
    STAT $?

    for file in schema master-data app-user; do
      PRINT Load file - $file.sql
      mysql -h mysql.dev.adevops.click -uroot -pRoboShop@1 < /app/db/$file.sql &>> $LOG_FILE
      STAT $?
    done
  fi
}