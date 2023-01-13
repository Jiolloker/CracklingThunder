#! /bin/bash
echo "Actualizar sistema"
sleep 2
sudo apt update
echo "Instalando apache2"
sleep 2
sudo apt install apache2 curl
sudo ufw allow in "Apache"
echo "Instalacion y config de mysql"
sleep 2
sudo apt install mysql-server
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by '21zKxUk9t*G';" > altmysql.txt
sudo mysql < altmysql.txt
echo "Root password de mysql 21zKxUk9t*G" 
sleep 4
echo "Responder a las siguientes preguntas con los siguientes"
echo "21zKxUk9t*G n n y y y y"
sleep 4
sudo mysql_secure_installation
echo "Instalar php"
sleep 2
sudo apt install php libapache2-mod-php php-mysql
echo "Preparando Directorio de la web"
sleep 2
sudo mkdir /var/www/wpsample
sudo chown -R $USER:$USER /var/www/wpsample
echo "<VirtualHost *:80>

    ServerName wpsample

    ServerAlias www.wpsample

    ServerAdmin webmaster@localhost

    DocumentRoot /var/www/wpsample

    ErrorLog \${APACHE_LOG_DIR}/error.log

    CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" > wpsample.conf
sudo mv wpsample.conf /etc/apache2/sites-available/.
echo "Configuracion de web"
sudo a2ensite wpsample
sudo a2dissite 000-default
sudo apache2ctl configtest
sleep 4
sudo systemctl reload apache2
echo "PWD 21zKxUk9t*G de mysql"
sleep 4
echo "Usando las siguientes lineas copiar y pegar cuando inicie mysql"
echo "CREATE DATABASE wpsample DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
echo "CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY '21zKxUk9t*G';"
echo "GRANT ALL ON wpsample.* TO 'wordpressuser'@'%';"
echo "FLUSH PRIVILEGES;"
echo "EXIT;"
sleep 10
sudo mysql -u root -p
echo "Actualizar sistema"
sleep 2
sudo apt update
echo "Mas paquetes php"
sleep 2
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
sleep 3
sudo systemctl restart apache2
echo "Descarga e instalacion de wordpress"
sleep 2
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /home/ubuntu/CracklingThunder/wordpress/.htaccess
cp ./wordpress/wp-config-sample.php ./wordpress/wp-config.php
mkdir ./wordpress/wp-content/upgrade
#salt
cd /home/ubuntu/CracklingThunder/wordpress/
SALT=/home/ubuntu/CracklingThunder/salt.txt
bash $SALT
#config wp-config
sudo sed -i "82 s/false/true/" /home/ubuntu/CracklingThunder/wordpress/wp-config.php
sudo sed -i "23 s/database_name_here/wpsample/" /home/ubuntu/CracklingThunder/wordpress/wp-config.php
sudo sed -i "26 s/username_here/wordpressuser/" /home/ubuntu/CracklingThunder/wordpress/wp-config.php
sudo sed -i "29 s/password_here/21zKxUk9t*G/" /home/ubuntu/CracklingThunder/wordpress/wp-config.php
sudo sed -i "82 s/false/true/" /home/ubuntu/CracklingThunder/wordpress/wp-config.php
sudo sed -i "85 i define( 'WP_DEBUG_LOG', true );" /home/ubuntu/CracklingThunder/wordpress/wp-config.php


sudo cp -a /home/ubuntu/CracklingThunder/wordpress/. /var/www/wpsample
sudo chown -R www-data:www-data /var/www/wpsample
sudo find /var/www/wpsample/ -type d -exec chmod 750 {} \;
sudo find /var/www/wpsample/ -type f -exec chmod 640 {} \;
echo "Se completo la instalacion de wordpress puede ingresar por localhost o su ip en un navegador web"

