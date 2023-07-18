#!/bin/bash

set -e # Exit script if any command fails
set -u # Prevent unset variables

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"
TOMDIR=""

# Install Java, Git, Maven, and Wget
sudo yum install -y java-1.8.0-openjdk git maven wget

# Download and extract Tomcat
cd /tmp/
wget "$TOMURL" -O tomcatbin.tar.gz
TOMDIR=$(tar tzvf tomcatbin.tar.gz | head -1 | awk -F/ '{print $1}')
tar xzvf tomcatbin.tar.gz
rm -f tomcatbin.tar.gz

# Create Tomcat user and set ownership
sudo useradd --system --shell /sbin/nologin tomcat
rsync -avzh "/tmp/$TOMDIR/" /usr/local/tomcat8/
sudo chown -R tomcat:tomcat /usr/local/tomcat8

# Configure systemd service for Tomcat
cat <<EOT > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat8
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINA_BASE=/usr/local/tomcat8
ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd configuration and start Tomcat service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat
