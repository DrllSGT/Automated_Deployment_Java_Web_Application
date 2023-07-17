#! /bin/bash

# adding repository and installing nginx
apt update
apt install nginx -y
cat <<EOT > jvapp
upstream jvapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://jvapp;

}

}

EOT

mv jvapp /etc/nginx/sites-available/jvapp
rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/jvapp /etc/nginx/sites-enabled/jvapp

#starting nginx service and firewall
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
