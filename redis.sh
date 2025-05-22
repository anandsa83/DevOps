dnf module disable redis -y
dnf module enable redis:7 -y

dnf install redis -y 

sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis/redis.conf
sed -i '/protected-mode/ s/yes/no/' /etc/redis/redis.conf

systemctl enable redis 
systemctl restart redis 