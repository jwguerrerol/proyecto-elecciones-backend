# ELECCIONES FULL PROJECT

## Backend

### 1. Crear una base de datos con PostgreSQL

Usar el script de la ubicación /db/tesis.sql

### 2. Crear un archivo .env en la raíz del proyecto:

### 3. Definir las variables de entorno:

- PORT : Puerto que usuará Express para iniciar el proyecto en local, en caso de estar ejecutandose en producción, este se ajustará automáticamente según el entorno en producción, a menos que el servidor donde se vaya a alojar indique que se debe especificar, en caso tal se usará no solamente en local, sino también en producción.
- DB_USER : Usuario con permisos para utilizar la base de datos
- DB_USER_PASSWORD : Contraseña de usuario con acceso a la base de datos
- DB_DATABASE = Nombre de la base de datos
- DB_HOST = Hostname o IP de la base de datos. Por defecto es 'localhost'
- DB_PORT = Puerto de postgreSQL. Por defecto 5432
- TEST_PORT = Puerto de postgreSQL para testing. Por defecto 5432
- TEST_DB_USER = Usuario de la base de datos con permisos sobre la base de datos de testing
- TEST_DB_USER_PASSWORD = Contraseña de usuario de la base de datos de testing
- TEST_DB_DATABASE = Nombre de base de datos de testing
- TEST_DB_HOST = Hostname o IP de la base de datos de testing. Por defecto es 'localhost'
- TEST_DB_PORT =5432
- SECRET = Frase de seguridad de su preferencia, para codificar y decodificar el token generado para autenticación. ESTE PASO ES ESENCIAL, PARA PODER GESTIONAR LA SEGURIDAD DE LA AUTENTICACIÓN. Nunca revele este código o lo deje visible ene el código. 

```bash
    PORT =4000
    DB_USER =
    DB_USER_PASSWORD =
    DB_DATABASE =
    DB_HOST ='localhost'
    DB_PORT =5432
    TEST_PORT =
    TEST_DB_USER =
    TEST_DB_USER_PASSWORD = 
    TEST_DB_DATABASE =
    TEST_DB_HOST = 'localhost'
    TEST_DB_PORT =5432
    SECRET = 'colombia_patria_mia'
```

### 4. Incluir el archivo .env en el archivo .gitignore

Para prevenir filtrar información sensible del proyecto como APIS, claves, frases SECRET, tokens, urls de conexión se debe realizar este proceso:

```bash
# .gitignore
.env
```

## Ejecutar proyecto

### Backend

Usando la terminal, ejecutar:

```bash
npm run dev
```

Url por defecto: http://localhost:4000


**JOIN**
