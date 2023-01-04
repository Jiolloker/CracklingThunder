#! /bin/bash

#Instalador de ELK-stack
#Actualizar sistema
sudo apt -y update
#Installar paquetes requeridos
sudo apt install wget curl gnupg2 -y
#Para correr Elasticsearch se necesita java. Instalar Java
sudo apt install openjdk-11-jdk -y
#kibana utiliza Nginx como proxy reverso. Instalar nginx webserver
sudo apt install nginx -y

#Instalar y configurar Elasticsearch
#Instalar paquetes requeridos
sudo apt install apt-transport-https -y
#Importar llave de loggeo de Elasticsearch PGP
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
#Añadir el repositorio APT de Elasticsearch
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
#Actualizar sistema
sudo apt update -y
#Instalar Elasticsearch
sudo apt install elasticsearch -y
#Editar Elasticsearch archivo de configuracion
sudo sed -i "/network.host/s/^#//g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/http.port/s/^#//g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s/192.168.0.1/localhost/g" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "71 i discovery.type: single-node" /etc/elasticsearch/elasticsearch.yml
#Recargar el daemon
sudo systemctl daemon-reload
#Iniciar el servicio de ElasticSearch
sudo systemctl start elasticsearch
#Habilitar el servicio de ElasticSearch al inicio del sistema.
sudo systemctl enable elasticsearch

#Instalar Logstash
sudo apt install logstash -y
#Iniciar el servicio Logstash
sudo systemctl start logstash
#Habilitar el servicio de Logstash al inicio del sistema.
sudo systemctl enable logstash

#Instalar Kibana
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

#Instalar y configurar Filebeat
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
echo "Se termino la instalación de ELK-STACK"


