#!/bin/bash
DATABASE_PASS='admin123'
sudo yum update -y
sudo yum install epel-release -y
sudo yum install git zip unzip -y
sudo yum install mariadb-server -y


# Start & Enable Mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation <<EOF

y
admin123
admin123
y
y
y
y
EOF

# Create 'accounts' database and grant privileges to 'admin' account
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE accounts;"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES;"

# Reset privileges and exit
sudo mysql -u root -p"$DATABASE_PASS" -e "RESET PRIVILEGES;"
sudo mysql -u root -p"$DATABASE_PASS" -e "EXIT;"

# Restart MariaDB service
sudo systemctl restart mariadb


#starting the firewall and allowing the mariadb to access from port no. 3306
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb
