#! /bin/bash
#Instalar dependencias
echo "Instalando dependencias"
sleep 2
sudo apt-get install mariadb-client apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y



#Instalar Docker

#Descargar llave GPG
echo "Descarga de llave GPG"
sleep 2
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Añadir repositorio de docker
echo "Añadir repositorio de docker"
sleep 2
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_releas while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post e -cs) stable"

echo "\n\r"

#Docker
echo "Instalar docker"
sleep 2
sudo apt-get install docker-ce docker-ce-cli containerd.io  -y



#Crear contenedor de MariaDB
echo "Crear contenedor de MariaDB"
sleep 2
sudo docker pull mariadb

mkdir -p ~/wordpress/database

mkdir -p ~/wordpress/html

#Configurar MariaDB
echo "Configurar MariaDB"
sleep 2
read -r -p "Escribir Mysql root password para configurar la base de datos: " MYSQL_ROOT_pass

read -r -p "Escribir Mysql nombre de usuario: " MYSQL_user

read -r -p "Escribir contraseña para mysql: " MYSQL_PASS
echo "Se guardaran credenciales de mysql en mysqlcred.txt"
sleep 3
echo $MYSQL_ROOT_pass $MYSQL_user $MYSQL_PASS mysqlcred.txt

sudo docker run -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_pass -e MYSQL_USER=$MYSQL_user -e MYSQL_PASSWORD=$MYSQL_PASS -e MYSQL_DATABASE=wpdb -v /root/wordpress/database:/var/lib/mysql --name wordpressdb -d mariadb



#Puede verificar ip del contenedor de MariDB

#sudo docker inspect -f '{{ .NetworkSettings.IPAddress }}' wordpressdb

#con el ip que obtiene puede hacer lo siguiente

#sudo mysql -u username -h my.ip.obtenido.anteriormente -p

#ingreso password

#y con el siguiente comando veo si se creo la base de datos

#show databases;     incluir punto y coma

#exit;



#Crear contenedor de Wordpress
echo "Creación de contenedor de Wordpress"
sleep 2
sudo docker pull wordpress:latest

#Crear nuevo nombre de contenedor
echo "Configuración de Wordpress"
sleep 2
read -r -p "Escribir nombre de usuario de Wordpress: " WP_DB_USER

read -r -p "Escribir password de usuario de Wordpress: " WP_DB_PASS
echo "Se guardaron las credenciales de Wordpress en wpdata.txt"
sleep 3
echo $WP_DB_USER $WP_DB_PASS wpdata.txt

sudo docker run -e WORDPRESS_DB_USER=$WP_DB_USER -e WORDPRESS_DB_PASSWORD=$WP_DB_PASS -e WORDPRESS_DB_NAME=wpdb -p 8081:80 -v /root/wordpress/html:/var/www/html --link wordpressdb:mysql --name wpcontainer -d wordpress



#Instalar Nginx
echo "Instalar Nginx como Proxy reverso"
sleep 2
sudo apt-get install nginx -y

#Configurar Nginx
echo "Configurar Nginx"
sleep 2
sudo echo "server {

  listen 80;

  server_name wp.example.com;

  location / {

    proxy_pass http://localhost:8081;

    proxy_set_header Host \$host;

    proxy_set_header X-Real-IP \$remote_addr;

    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

  }

}" | sudo tee /etc/nginx/sites-available/wordpress > /dev/null

#Activar virtual host
echo "Activar host virtual"
sleep 2
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

#Re-Iniciar el servicio de Nginx
echo "Reiniciar Nginx"
sleep 2
sudo systemctl restart nginx

echo "Instalacion de Wordpress terminada, puede probar entrar a la web con Su.ip.de.trabajo:8081"
