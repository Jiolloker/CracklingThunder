#! /bin/bash

sudo apt update
sudo apt install apache2
sudo ufw allow in "Apache"
sudo apt install mysql-server
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by '21zKxUk9t*G';" > altmysql.txt
sudo mysql < altmysql.txt
echo "21zKxUk9t*G  mysql root pwd" 
sleep 4
echo "21zKxUk9t*G n n y y y y"
sleep 4
sudo apt install php libapache2-mod-php php-mysql
sudo mkdir /var/www/wpsample
sudo chown -R $USER:$USER /var/www/wpsample
echo "<VirtualHost *:80>

    ServerName wpsample

    ServerAlias www.wpsample

    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/wpsample

    ErrorLog \${APACHE_LOG_DIR}/error.log

    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/wpsample/>

        AllowOverride All

    </Directory>

</VirtualHost>" /$HOME/CracklingThunder/wpsample.conf
sudo mv wpsample.conf /etc/apache2/sites-available/
sudo a2ensite wpsample
sudo a2dissite 000-default
sudo apache2ctl configtest
sleep 4
sudo systemctl reload apache2

