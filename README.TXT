# SISTEMA MATRIZ DE RIESGO

## Descripción

Este proyecto corresponde a un sistema desarrollado en **Django (Python)** para la gestión de una **Matriz de Riesgo**.
Permite administrar registros, auditorías y diferentes operaciones relacionadas con la gestión de riesgos dentro del sistema.

El sistema se ejecuta de forma **local**, utilizando **Python** para el backend y **MySQL** como base de datos.

---

## REQUISITOS

Antes de ejecutar el sistema se debe tener instalado:

* Python 3.10 o superior
* MySQL Server o XAMPP
* Navegador web (Chrome, Edge, Firefox, etc.)
* Instalar la versión mas recient de MariaDB "https://mariadb.org/download/?t=mariadb&p=mariadb&r=12.2.2&os=windows&cpu=x86_64&pkg=msi&mirror=insacom"

---

## INSTALACIÓN DEL PROYECTO

1. Crear la base de datos en MySQL:

matriz_riesgo

2. Crear el usuario de conexión para la base de datos:

Ejecutar el siguiente SQL en MySQL:

CREATE DATABASE matriz_riesgo;

CREATE USER 'python_conectar'@'localhost' IDENTIFIED BY 'riesgos';

GRANT ALL PRIVILEGES ON matriz_riesgo.* TO 'python_conectar'@'localhost';

FLUSH PRIVILEGES;

3. Importar la base de datos del sistema:

Importar el archivo incluido en el proyecto:

matriz_riesgo.sql

Esto creará todas las tablas necesarias para el funcionamiento del sistema.

---

## INSTALACIÓN DE DEPENDENCIAS

Ejecutar el archivo:

instalar.bat

Este archivo realizará automáticamente:

* Creación del entorno virtual de Python
* Instalación de todas las dependencias necesarias

Si el archivo no se ejecuta con doble clic, abrir una terminal dentro de la carpeta del proyecto y ejecutar:

.\instalar.bat

También es posible instalar las dependencias manualmente ejecutando:

pip install -r requirements.txt

Tambien se debe instalar Python 
Luego de tener instalado Python ejecutar el comando "pip install Django" luego "pip install mysqlclient"

---

## EJECUCIÓN DEL SISTEMA

Para iniciar el sistema ejecutar:

ejecutar.bat

Si no funciona con doble clic, ejecutar en la consola:

.\ejecutar.bat

Luego abrir el navegador web en:

http://127.0.0.1:8000

---

Para iniciar el programa maualmente desde Visual Studio ejecute el comando:

python manage.py runserver

Encontrandose lógicamente en la carpeta donde este el archivo manage.py


---

## NOTAS IMPORTANTES

* El sistema utiliza MySQL como base de datos.
* La conexión está configurada en el archivo:

matriz_riesgo/settings.py

con los siguientes datos:

Base de datos: matriz_riesgo
Usuario: python_conectar
Contraseña: riesgos
Host: 127.0.0.1
Puerto: 3306

Si se modifican estos datos en MySQL, también deben actualizarse en el archivo **settings.py**.

---

## ESTRUCTURA GENERAL DEL PROYECTO

core/
Aplicación principal del sistema

matriz_riesgo/
Configuración del proyecto Django

scripts/
Scripts auxiliares de pruebas y utilidades

manage.py
Archivo principal para ejecutar comandos de Django

requirements.txt
Lista de dependencias del proyecto

instalar.bat
Script para instalar dependencias automáticamente

ejecutar.bat
Script para iniciar el servidor del sistema

matriz_riesgo.sql
Base de datos exportada del sistema

---

## ACCESO AL SISTEMA

Una vez iniciado el servidor, acceder desde el navegador a:

http://127.0.0.1:8000