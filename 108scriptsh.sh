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
#   Este Script Bash automatizara la creación de ciertas tareas. 
#   Desplegará un par de host virtuales y wordpress.
#
# ==============================================================================
#                   ESTRUCTURA DE FICHEROS QUE SE CREARA
# ==============================================================================
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

# Estuve teniendo porblemas para que echo -e ...\n... hiciese un salto de linea.
# por eso echo " " estara presente.
echo "Bienvenido a la herramienta de creacion de VirtualHost e implantacion de Wordpress Automatica."
echo "Los hots virtuales creados con esta herramienta utilizan el nombre"
echo "El nombre se añadira a 'ubuntuserver.local' y en caso de ser https se añadira '-ssl'"
echo
echo "Primero necesitamos unos datos para los hosts virtuales:"
echo 
#------------WHILE DE CONFIRMACION DE ENTRADA DE DATOS.------------------------
while true; do
read -p "Nombre para los Hosts virtuales: " ServerName
echo
read -p "Confirma que el nombre es correcto (Y/N)" isnameok
    case $isnameok in
        [yYeEsS]) 
                    echo "El nombre ha sido confirmado"
                    break
                    ;;
        [nNoO])
                    >&2
                    ;;
        *^[yYeEsSnN])
                    echo "Introduzca un caracter valido" >&2
                    echo
    esac 
done
echo
#------------WHILE DE CONFIRMACION DE CORREO ELECTRONICO------------------------
echo "Es necesario que introduzca un correo electronico para la administracion del servidor"
while true; do
read -p "Email de Administración: " Email
echo
read -p "Confirma que el email es correcto (Y/N)" isemailok
    case $isemailok in
        [yYeEsS]) 
                    echo "El nombre ha sido confirmado"
                    break
                    ;;
        [nNoO])
                    >&2
                    ;;
        *^[yYeEsSnN])
                    echo "Introduzca un caracter valido" >&2
                    echo
    esac 
done
echo
#------------WHILE DE CONFIRMACION DE LA LLAVE Y CERTIFICADO SSL------------------------
echo "Es necesario elegir el nombre del archivo de la llave para el uso de HTTPS"
while true; do
read -p "Nombre para el archivo de la llave: " KeyName
echo
read -p "Confirma que el nombre es correcto (Y/N)" iskeynameok
    case $iskeynameok in
        [yYeEsS]) 
                    echo "El nombre ha sido confirmado"
                    break
                    ;;
        [nNoO])
                    >&2
                    ;;
        *^[yYeEsSnN])
                    echo "Introduzca un caracter valido" >&2
                    echo
    esac 
done
echo
echo "Es necesario elegir el nombre del archivo de certificado de la llave para el uso de HTTPS"
#-----------------------------------CERTIFICADO------------------------------------------------
while true; do
read -p "Nombre para el archivo de la llave: " CertName
echo
read -p "Confirma que el nombre es correcto (Y/N)" iscertnameok
    case $iscertnameok in
        [yYeEsS]) 
                    echo "El nombre ha sido confirmado"
                    break
                    ;;
        [nNoO])
                    >&2
                    ;;
        *^[yYeEsSnN])
                    echo "Introduzca un caracter valido" >&2
                    echo
    esac 
done
echo


#======================= GENERACION DE LA CLAVE Y CERTIFICADO PRE CREACION DE HOST VIRTUAL HTTPS============
echo "Generando la clave y certificado para HTTPS, debera introducir unos datos a posterior"
sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/private/$KeyName.key -out /etc/ssl/certs/$CertName.pem -days 365

echo 

echo "Se ha terminado de recopliar los datos, se pasara al proceso de creacion"

#=========================== FIN DE LA RECOPILACION DE DATOS ===================================

#========================== GENERANDO LOS DIRECTORIOS Y FICHEROS ===============================

# Genera la estructura de ficheros basada en las variables.

echo "Generando directorios para guardar hosting108, hosting108-ssl y todo su contenido"

sudo mkdir -p "/var/www/$ServerName"/ErrorDocs
sudo mkdir -p "/var/www/$ServerName"-ssl/ErrorDocs

echo "Se han generado los directorios correctamente."

echo "Generando el archivo de configuracion para $ServerName"

# Genera el archivo de Virtual Host con todo el contenido necesario
sudo cat > /etc/apache2/sites-available/$ServerName.conf << EOF
<VirtualHost *:80>

    ServerName $ServerName.ubuntuserver.local
    ServerAlias www.$ServerName.ubuntuserver.local
    ServerAdmin $email
    DocumentRoot /var/www/$ServerName

    # Apartado de Redirecciones

    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteRule ^(.*)$ https://$ServerName.ubuntuserver.local$1 [L,R=302]
    </IfModule>

    # Apartado de los documentos de errores

    ErrorDocument 403 /ErrorDocs/403.html
    ErrorDocument 404 /ErrorDocs/404.html
    ErrorDocument 500 /ErrorDocs/500.html

    # Fin de la configuracion

</VirtualHost>
EOF

echo "Se ha generado el archivo de configuración para $ServerName"

# Genera TODO el contenido para la estructura de ficheros de hosting 108.

echo "Se generará el contenido para $ServerName Este proceso podria tardar un rato." 

#============== GENERANDO CONTENIDO PARA EL PRIMER VIRTUAL HOST ==================

#=========== DESCARGANDO IMAGEN DE FORMA OCULTA PARA UN PROCESO MAS FLUIDO =======

sudo wget -q https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Gnu-bash-logo.svg/1920px-Gnu-bash-logo.svg.png --output-file /var/www/$ServerName/GNUBASHLOGO.PNG

#========== Generando Index.html ==================================================
echo "Genrando index.html..."
sudo touch /var/www/$ServerName/index.html << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="Author" content="Jose Rubicco Ferro">
    <title>Shell Script Site</title>
    <link rel="stylesheet" href="Main.css">
</head>
<body>
    
    <img src="GNUBASHLOGO.png" alt="BASH LOGO">
    
    <div class="div1">
        <h1>La creación de los Virtual Host fue existosa.</h1>
    </div>
       
    
    <ul>
        <li>
            <p>Ficheros para http y https creados correctamente</p>
        </li>
        <li>
            <p>Redirección http --> https</p>
        </li>
        <li>
            <p>Para confirmar la parte relacionada con Wordpress acceda a <a href="https://ubuntuserver.local">ubuntuserver.local</a></p>
        </li>
    </ul>
</body>
</html>
EOF
#============================ GENERANDO ARCHIVO CSS ===================================================
echo "Genrando Archivo CSS..."
sudo touch > /var/www/$ServerName/Main.css << EOF
body{
    background-color: rgb(235, 235, 235);
}

img{
    width: 50%;
    height: auto;
    margin-left: 25%;
    overflow: hidden;
    position: relative;
}
h1{
    font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
    text-align: center;
}
.div1{
    margin-left: 25%;
    width:50%;
    background-color: rgb(181, 181, 181);
    border-radius: 10px;
    display: flex;
    justify-content: center;
}

ul{
    width: 50%;
 margin-left: 25%;
}

li{
    font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
    font-size: 24px;
}

a{
    font-family:  'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
    color: black;
}
a:visited{
    color: gray
}
a:hover{
    color: green;
}
a:active{
    color: white
}
.errorp{
        width: 50%;
        margin-left: 25%;
        font-family: 'Franklin Gothic Medium', 'Arial Narrow', Arial, sans-serif;
        font-size: 24px;
}
EOF
#============================ GENERANDO ARCHIVOS DE ERROR =============================================

#------------------------------------ERROR 403----------------------------------------------------------
echo "Genrando Archivo de Error 403..."
sudo touch > /var/www/$ServerName/403.html << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="Author" content="Jose Rubicco Ferro">
    <title>403</title>
    <link rel="stylesheet" href="../Main.css">
</head>
<body>
    
    <img src="../GNUBASHLOGO.png" alt="BASH LOGO">
    
    <div class="div1">
        <h1>Error 403: SIN AUTORIZACIÓN</h1>
    </div>
    
    <p class="errorp">Porfavor contacte con el administrador para solucionar este problema y obtener permisos.</p>
</body>
</html>
EOF

#------------------------------------ERROR 404----------------------------------------------------------
echo "Genrando Archivo de Error 404..."
sudo touch > /var/www/$ServerName/404.html << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="Author" content="Jose Rubicco Ferro">
    <title>403</title>
    <link rel="stylesheet" href="../Main.css">
</head>
<body>
    
    <img src="../GNUBASHLOGO.png" alt="BASH LOGO">
    
    <div class="div1">
        <h1>Error 404: NO ENCONTRADO</h1>
    </div>
    
    <p class="errorp">No se ha encontrado la página solicitada, revise el URL o contacte al administrador para solucionar este problema.</p>
</body>
</html>
EOF

#------------------------------------ERROR 500----------------------------------------------------------
echo "Generando Archivo de Error 500..."
sudo touch > /var/www/$ServerName/500.html << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="Author" content="Jose Rubicco Ferro">
    <title>403</title>
    <link rel="stylesheet" href="../Main.css">
</head>
<body>
    
    <img src="../GNUBASHLOGO.png" alt="BASH LOGO">
    
    <div class="div1">
        <h1>Error 500: ERROR INTERNO DEL SERVIDOR</h1>
    </div>
    
    <p class="errorp">Hay un error en la configuración del servidor porfavor contacte con el administrador.</p>
</body>
</html>
EOF

#===================================FIN DE LA GENERACION DE CONTENIDO PARA HTTP ===============================

#=================================== INICIO DE LA GENERACIÓN DE HOST VIRTUAL PARA HTTPS =======================
echo "Generando archivo de configuracion para $ServerName-ssl"

sudo touch > "/etc/apache2/sites-available/$ServerName"-ssl.conf << EOF
<IfModule mod_ssl.c>
    <VirtualHost *:80>

        ServerName "$ServerName"-ssl.ubuntuserver.local
        ServerAlias www."$ServerName"-ssl.ubuntuserver.local
        ServerAdmin $email
        DocumentRoot "/var/www/$ServerName"-ssl/

        # Apartado SSL

        SSLengine On
        SSLCertificateKeyFile /etc/ssl/private/$KeyName.key
        SSLCertificateFile    /etc/ssl/certs/$CertName.pem

        # Apartado de los documentos de errores

        ErrorDocument 403 /ErrorDocs/403.html
        ErrorDocument 404 /ErrorDocs/404.html
        ErrorDocument 500 /ErrorDocs/500.html

        # Fin de la configuracion

    </VirtualHost>
<IfModule>
EOF

#===================== COPIA DEL CONTENIDO DE HTTP A HTTPS =========================================================
# Directorio Base:
#==========================
echo "Generando contenido para $ServeName-ssl"
# Copia la página principal
sudo cp /var/www/$ServerName/index.html "/var/www/$ServerName"-ssl/index.html
# Copia el Archivo Css
sudo cp /var/www/$ServerName/Main.css "/var/www/$ServerName"-ssl/Main.css
# Copia la imagen
sudo cp /var/www/$ServerName/GNUBASHLOGO.png "/var/www/$ServerName"-ssl/GNUBASHLOGO.png
#==========================
# Directorio de los documentos de error
#==========================
# Copia la página 403
sudo cp /var/www/$ServerName/403.html "/var/www/$ServerName"-ssl/403.html
# Copia la página 404
sudo cp /var/www/$ServerName/404.html "/var/www/$ServerName"-ssl/404.html
# Copia la página 500
sudo cp /var/www/$ServerName/500.html "/var/www/$ServerName"-ssl/500.html
#=========================
# Fin de la copia
#=========================

#================================= ACTIVACION DE LOS VIRTUALHOST ======================================================
echo "Activando los virtualhosts"

sudo a2ensite $ServerName
sudo a2ensite $ServerName-ssl

echo "Reiniciando Apache..."
echo "Debera introducir la clave del certificado"

sudo systemctl restart apache2

#============================ FINALIZACIÓN DE LOS VIRTUALHOSTS ========================================================
