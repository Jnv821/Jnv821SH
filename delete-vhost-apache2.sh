#!/bin/bash
# ---------------------------------------------------------------------------------
#                  INFORMACIÓN CLAVE DEL ARCHIVO SHELL SCRIPT
# ---------------------------------------------------------------------------------
#   Autor: Jose Rubicco Ferro
#   Ciclo: 2SMR
#   Asignatura: Servicios en Red
#   Actividad: 108
#   ===============================================================================
#   Descripción: 
#  
#   Este Script Bash automatizara la destrucción de ciertos archivos y directorios 
#   asi como la recuperación desde archivos previamente creados.
#

#============SCRIPT PARA LA ELIMINACIÓN DE LOS ARCHIVOS Y VOLVER A BASE==============
read -p "Nombre del servidor que será borrado " ServerName

#----- Remueve todas las paginas web -----
echo "Removiendo las carpetas de contenido de los host virtuales"
sudo rm  /var/www/$ServerName/*
sudo rm  /var/www/$ServeName-ssl/*
sudo rm -d /var/www/$ServeName-ssl
sudo rm -d /var/www/$ServeName
#sudo rm -dR /var/www/html
#sudo rm -dR /var/www/wordpress

#----- Remueve los archivos del certificado y la llave ------
# Obtención de la llave y certificado
KeyName=$ServeName.key
CertName=$ServeName.pem

echo "Removiendo archivos Archivos de llave y certificados"
sudo rm /etc/ssl/private/$KeyName.key
sudo rm /etc/ssl/certs/$CertName.pem

#----- Remueve los archivos de host virtuales ---------

echo "Removiendo archivos de Hosts Virtuales" 
sudo rm /etc/apache2/sites-available/000-default.conf
sudo rm /etc/apache2/sites-available/$ServeName.conf
sudo rm /etc/apache2/sites-available/$ServeName-ssl.conf

#========== RESTAURAR LOS ARCHIVOS ANTERIORES ===========

echo "Restaurando Archivos"
sudo mv /etc/apache2/sites-available/000-default-conf.bak /etc/apache2/sites-available/000-default.conf
sudo mkdir /var/www/html
