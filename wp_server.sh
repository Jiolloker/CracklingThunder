#! /bin/bash
pass=012KdzG&Eg#S
#Instalar Apache2 webserver
sudo apt install apache2 -y
#Habilitar trafico en el puerto 80
sudo ufw allow in "Apache"
#Habilitar el firewall
sudo ufw enable

#Instalar MySQL, base de datos del server
sudo apt install mysql-server
#Correr script de instalación segura
echo "y $pass $pass y y y y" |sudo ./usr/bin/mysql_secure_installation

