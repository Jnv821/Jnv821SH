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

#----- Remueve todas las paginas web y archivo descargado de wordpress-----
echo "Removiendo las carpetas de contenido de los host virtuales"
sudo rm -d -R /var/www/$ServerName/*
sudo rm -d -R /var/www/$ServerName-ssl/*
sudo rm -dR /var/www/html
sudo rm /var/www/wordpres*

#----- Remueve los archivos del certificado y la llave ------
# Obtención de la llave y certificado
KeyName=$ServerName.key
CertName=$ServerName.pem

echo "Removiendo archivos Archivos de llave y certificados"
sudo rm /etc/ssl/private/$KeyName
sudo rm /etc/ssl/certs/$CertName

#----- Remueve los archivos de host virtuales ---------

echo "Removiendo archivos de Hosts Virtuales" 
sudo rm /etc/apache2/sites-available/000-default.conf
sudo rm /etc/apache2/sites-available/$ServerName.conf
sudo rm /etc/apache2/sites-available/$ServerName-ssl.conf

#========== RESTAURAR LOS ARCHIVOS ANTERIORES ===========

echo "Restaurando Archivos"
sudo mv /etc/apache2/sites-available/000-default.conf.bak /etc/apache2/sites-available/000-default.conf
sudo mkdir /var/www/html
