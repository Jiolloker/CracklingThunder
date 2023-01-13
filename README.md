Instalación
bash elk_stack.sh
Instalara progresivamente hasta elasticsearch, luego pregunta si quiere cambiar el path en donde se guardara la base de datos
Puede contestar yes, luego preguntara por el path completo en donde meter la base de datos. Sea /mnt/elk_db, luego pregunta si quiere mover todo el contenido de la carpeta estandar de elasticsearch a el nuevo directorio, puede dejarlo asi si quiere.
Y luego procedera a instalar lo demas.
Una vez finalizado puede comprobar el funcionamiento de kibana en http://localhost:5601

bash wp_lamp.sh
Lo mas complicado de este instalador es la parte interactiva que tiene mysql al momento de configurarlo y crear la base de datos y los usuarios.

Cuando se llega a esto, te cambia la contraseña de root en mysql. Se intento hacer todo de forma no interactiva pero no se logro.
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'mynewpassword'; #pwd  21zKxUk9t*G    
sudo mysql < text.txt confirmed this works check sudo mysql -u root -p

La forma de completar la configuracion de mysql_secure_installation.
Contestar de la siguiente manera. rootpwd n n y y y y
sudo mysql_secure_installation
Enter password for user root: pwd
Test password strenght? ((Press y|Y for Yes, any other key for No) : n
Change the password for root ? ((Press y|Y for Yes, any other key for No) : n
Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
Success!

Luego llegara a la creacion de base de datos y usuario
Seguir siguientes pasos
# Puede cambiar wpsample por cualquier otro nombre para la base de datos
mysql> CREATE DATABASE wpsample DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

# Puede cambiar wordpressuser y mysql_native_password
mysql> CREATE USER 'wordpressuser'@'%' IDENTIFIED WITH mysql_native_password BY '21zKxUk9t*G';

# Cambiar wpsample al nuevo db y wordpressuser al nuevo usuario
mysql> GRANT ALL ON wpsample.* TO 'wordpressuser'@'%';

# Confirmar cambios
mysql> FLUSH PRIVILEGES;

# Salir
mysql> exit;

Y automaticamente prosigue con la instalacion hasta finalizar. Y luego puede entrar en localhost o su ip en el navegador para ingresar al portal de wordpress.




Biografia utilzada
https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-22-04-with-a-lamp-stack
https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04
https://stackoverflow.com/questions/23024473/how-can-i-run-both-nginx-and-apache-together-on-ubuntu


Se utilizo este material para el desafio de paso de datos pero no funciona
https://kifarunix.com/visualize-wordpress-user-activity-logs-on-elk-stack/
https://www.sitepoint.com/monitoring-wordpress-apps-with-the-elk-stack/ 

