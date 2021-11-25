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
#   Este Script Bash automatizara la creación de ciertas tareas sin la posiblidiad
#   de personalización. Desplegará un par de host virtuales y wordpress de forma 
#   predefinida y no servirá en una instalación limpia de apache.
#
#   NOTA: Se puede hacer pero dispongo de poco tiempo para completar esta actividad.
#   ===============================================================================
#   Valores Predefinidos:
#       
#   Host virtuales: 
#           Conexión Http:
#                   Nombre del archivo VH: hosting108.conf
#
#                   ServerName: hosting108.ubuntuserver.local
#                   ServerAlias: www.hosting108.local
#                   ServerAdmin: a20joserf@iessanclemente.net
#                   DocumentRoot: /var/www/hosting108
#                   Redirección a: https://hosting108.ubuntuserver.local
#                   Paginas de Error: Mensaje de Error sencillo
#
#           
#                   Landing Page: Página personalizada.
#
#          Conexión Https:
#                   Nombre del archivo VH: hosting108-ssl.conf
#
#                   ServerName: hosting108.ubuntuserver.local
#                   ServerAlias: www.hosting108ssl.local
#                   ServerAdmin: a20joserf@iessanclemente.net
#                   DocumentRoot: /var/www/hosting108-ssl
#                   Llave SSL: hosting108.key
#                   Certificado SSL: hosting108.pem
#                   Paginas de Error: Mensaje de Error sencillo
#
# =============================================================================
#         IMPORTANTE LEER, DUDAS SOBRE LA REALIZACION DE LA ACTIVIDAD 
#                                Y WORDPRESS.
# =============================================================================
#
#   Tengo una confusión con el enunciado y no me queda muy claro.
#   No estoy seguro de si tengo que añadir las paginas de los virtual host a Wordpress
#   o no, por eso Instalaré wordpress de la misma forma que se hizo en la actividad
#   107, exceptuando por aquellos pasos que se piden no automatizar.
# ==============================================================================
#                   ESTRUCTURA DE FICHEROS QUE SE CREARA
# ==============================================================================
#   Por ende el script generará algo parecido a esta estructura de ficheros:
#   
#   /var/www/
#           |
#           |
#            `- html/... (Wordpress)
#           |
#           |
#            ` hosting108/
#           |           |
#           |            `index.html 
#           |           |
#           |            `Main.css
#           |           |
#           |            `BASHLOGO.PNG
#           |           |
#           |            `ErrorDocs/
#           |                     |
#           |                      `403.html
#           |                     |
#           |                      `404.html
#           |                     |
#           |                      `500.html
#           |
#            ` hosting108/
#           |           |
#           |            `index.html 
#           |           |
#           |            `Main.css
#           |           |
#           |            `BASHLOGO.PNG
#           |           |
#           |            `ErrorDocs/
#           |                     |
#           |                      `403.html
#           |                     |
#           |                      `404.html
#           |                     |
#           |                      `500.html
#           |
#            `... 
# ===========================================================================
#           FIN DE LA EXPLICACIÓN / DOCUMENTACIÓN BÁSICA
# ===========================================================================
#
# ===========================================================================
#                       COMIENZO DEL SCRIPT BASH
# ===========================================================================


echo Este Script generara 2 Virtual Hosts predefinidods e Instalara Wordpress.
Es probable que necesite autentificarse como Super usuario en diferent ocasiones.

# Genera el directorio para almacenar hosting 108

echo Generando directorio para guardar hosting108 y hosting108-ssl

sudo mkdir /var/www/hosting108
sudo mkdir /var/www/hosting108-ssl

echo Se han generado los directorios correctamente.

echo Generando el archivo de configuracion para hosting108

 Genera el archivo de Virtual Host con todo el contenido necesario y limpia la terminal.
cat > /etc/apache2/sites-available/hosting108.conf << EOF
<VirtualHost *:80>

    ServerName hosting108.ubuntuserver.local
    ServerAlias www.hosting108.ubuntuserver.local
    ServerAdmin a20joseRF@iessanclemente.net
    DocumentRoot /var/www/hosting108

    # Apartado de Redirecciones

    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteRule ^(.*)$ https://hosting108.ubuntuserver.local$1 [L,R=302]
    </IfModule>

    # Apartado de los documentos de errores

    ErrorDocument 403 /ErrorDocs/403.html
    ErrorDocument 404 /ErrorDocs/404.html
    ErrorDocument 500 /ErrorDocs/500.html

    # Fin de la configuracion

</VirtualHost>
EOF

echo Se ha generado el archivo de configuración para hosting108
