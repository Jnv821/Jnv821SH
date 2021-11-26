 #!/bin/bash
 #============SCRIPT PARA LA ELIMINACIÓN DE LOS ARCHIVOS Y VOLVER A BASE==============
 
 #----- Remueve todas las paginas web -----
 echo "Removiendo las carpetas de contenido de los host virtuales"
 sudo rm  /var/www/$ServerName/*
 sudo rm  /var/www/$ServeName-ssl/*
 sudo rm -d /var/www/$ServeName-ssl
 sudo rm -d /var/www/$ServeName

 #sudo rm -dR /var/www/html
 #sudo rm -dR /var/www/wordpress

 #----- Remueve los archivos del certificado y la llave ------

echo "Removiendo archivos Archivos de llave y certificados"
 sudo rm /etc/ssl/private/$KeyName.key
 sudo rm /etc/ssl/certs/$CertName.pem

#----- Remueve los archivos de host virtuales ---------

#echo "Removiendo archivos de Hosts Virtuales" 
sudo rm /etc/apache2/sites-available/000.default.conf

#----- Remueve archivos descargados ----

sudo rm /var/www/wordpress.tar.gz

#========== RESTAURAR LOS ARCHIVOS ANTERIORES ===========

echo "Restaurando Archivos"
sudo mv /etc/apache2/sites-available/000.default.conf~ /etc/apache2/sites-available/000.default.conf
sudo mkdir -p /var/www/html
