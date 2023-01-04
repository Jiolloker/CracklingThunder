#! /bin/bash

#Instalador de ELK-stack
#Actualizar sistema
echo "Actualizar sistema"
sleep 1
sudo apt -y update
#Installar paquetes requeridos
echo "Instalando paquetes"
sleep 1
sudo apt install wget curl gnupg2 -y
#Para correr Elasticsearch se necesita java. Instalar Java
sudo apt install openjdk-11-jdk -y
#kibana utiliza Nginx como proxy reverso. Instalar nginx webserver
sudo apt install nginx -y

#Instalar y configurar Elasticsearch
#Instalar paquetes requeridos
echo "Instalación de paquetes y utiles para ElastisSearch"
sleep 1
sudo apt install apt-transport-https -y
#Importar llave de loggeo de Elasticsearch PGP
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#Añadir el repositorio APT de Elasticsearch
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
#Actualizar sistema
echo "Se actualiza el sistema"
sleep 1
sudo apt update -y
#Instalar Elasticsearch
echo "Instalando ElasticSearch"
sleep 1
sudo apt install elasticsearch -y
#Editar Elasticsearch archivo de configuracion
sudo sed -i "/network.host/s/^#//g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/http.port/s/^#//g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/192.168.0.1/localhost/g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "71 i discovery.type: single-node" /etc/elasticsearch/elasticsearch.yml

echo "Puede cambiar el directorio donde se guardara la base de datos de ElasticSearch"
sleep 2
read -r -p "Desea hacerlo? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
        read -r -p "Especifique el nuevo directorio con el path completo. ie. /mnt/elk/log" path
        sudo mkdir -p $path
        sudo sed -i "33 s+var/lib/elasticsearch+$path+" /etc/elasticsearch/elasticsearch.yml
	sudo chown -R elasticsearch:elasticsearch $path
        read -r -p "Desea mover el contenido de /var/lib/elasticsearch al nuevo directorio? [y/N]" answer
        if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]
                sudo mv -vf /var/lib/elasticsearch $path
                echo "Se movio el contenido de /var/lib/elasticsearch a $path"
        else
                echo "No se realizaran cambios" 
        fi
        echo "Continua la instalación de ElasticSearch"
        sleep 3
else
        echo "En el archivo de configuración de ElasticSearch puede modificar esto cuando deseé"
        echo "Se encuentra en /etc/elasticsearch/elasticsearch.yml, lo puede encontrar ne la linea 33"
        echo "Continua la instalación de ElasticSearch"
        sleep 7
fi

#Recargar el daemon
sudo systemctl daemon-reload
#Iniciar el servicio de ElasticSearch
sudo systemctl start elasticsearch
#Habilitar el servicio de ElasticSearch al inicio del sistema.
sudo systemctl enable elasticsearch
echo "Se termino la instalacion de ElasticSearch"
sleep 1

#Instalar Logstash
echo "Iniciando instalación de Logstash"
sleep 2
sudo apt install logstash -y
#Iniciar el servicio Logstash
sudo systemctl start logstash
#Habilitar el servicio de Logstash al inicio del sistema.
sudo systemctl enable logstash
echo "Se termino la instalación de Logstash"

#Instalar Kibana
echo "Instalando Kibana"
echo sleep 2
sudo apt install kibana -y
#Editar archivo de configuracion de kibana
sudo sed -i "/server.port/s/^#//" /etc/kibana/kibana.yml
sudo sed -i "/server.host/s/^#//" /etc/kibana/kibana.yml
sudo sed -i "/elasticsearch.hosts/s/^#//" /etc/kibana/kibana.yml
sudo sed -i "7 s/localhost/0.0.0.0/" /etc/kibana/kibana.yml
#Iniciar servicio de kibana
sudo systemctl start kibana
#Habilitar el servicio de kibana al inicio del sistema.
sudo systemctl enable kibana
#Habilitar trafico para el puerto 5601
sudo ufw allow 5601/tcp
echo "Se termino la instalación de Kibana"
sleep 1

#Instalar y configurar Filebeat
echo "Instalando Filebeat"
sleep 1
sudo apt install filebeat -y
sudo sed -i "135 s/^/#/" /etc/filebeat/filebeat.yml
sudo sed -i "137 s/^/#/" /etc/filebeat/filebeat.yml
sudo sed -i "148 s/^#//" /etc/filebeat/filebeat.yml
sudo sed -i "150 s/^  #//" /etc/filebeat/filebeat.yml
#Habilitar modulo de Filebeat system
sudo filebeat modules enable system
#Cargar Index Template
sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
#Iniciar servicio Filebeat
sudo systemctl start filebeat
#Habilitar al servicio de Filebeat iniciarse al inicio de sistema
sudo systemctl enable filebeat
#Imprimir mensaje de finalizacion de instalacion de ELK-stack
echo "Termino la instalación de Filebeat"
sleep 1
echo "Se termino la instalación de ELK-STACK"
echo "Puede comprobar su funcionamiento entrando en la siguiente URL: http://localhost:5601" 
sleep 2

