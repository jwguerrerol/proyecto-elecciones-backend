# ELECCIONES FULL PROJECT

## Backend

### 1. Create database in PostgreSQL

Use script in /db/tesis.sql

### 2. Create .env on file:

Begin by creating a file name '.env' in the root directory of your project.

### 3. Define database connection variables:

Inside the .env file, specify the variables required for connecting to your PostgreSQL database.

- PORT : The number port used for express server. Recommended the port number 4000
- DB_USER : The username used to authenticate with PostgreSQL server
- DB_USER_PASSWORD : The password associated with the specified username
- DB_DATABASE = The name of the PostgreSQL database you want connect to.
- DB_HOST = The hostname of IP address of the PostgreSQL server(default 'localhost')
- DB_PORT = The port number on which PostgreSQL is running(default is 5432)
- TEST_PORT = The number port used for express server. Recommended the port number 4000.
- TEST_DB_USER = The username used to authenticate with PostgreSQL server
- TEST_DB_USER_PASSWORD = The password associated with the specified username
- TEST_DB_DATABASE = The name of the PostgreSQL test database you want connect to.
- TEST_DB_HOST = The hostname of IP address of the PostgreSQL server(default 'localhost')
- TEST_DB_PORT =5432
- SECRET = The password encryption phrase(default 'colombia_mi_patria). Change for security. 

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

### 4. Include .env in .gitignore

To prevent sensitive information from being exposed, add the .env file to your .gitignore file.

```bash
# .gitignore
.env
```

## RECOMMENDED: Additional steps if your change the encryption passphrase(SECRET) in the .env file:

### 1. Get 
Using postman make a request to the url: http://localhost:4000/login. Use POST method.

Data for create new user:

```JSON
{
    "id_usuario": 4,
    "nom_usuario": "yourName",
    "correo_usuario": "yourEmail@example.com",
    "clave_usuario": "yourPasswordEncrypted",
    "id_role": 1,
    "id_puesto_votacion": 1,
    "url_imagen": "https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png"
}

```

Response Postman example:

```JSON
{
    "id_usuario": 4,
    "nom_usuario": "yourName",
    "correo_usuario": "yourEmail@example.com",
    "clave_usuario": "passwordEncrypted",
    "id_role": 1,
    "id_puesto_votacion": 1,
    "url_imagen": "https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png"
}

```

Copy from Postman's response the value of clave_usuario encrypted


### 2. Update PostgreSQL database 

Using the terminal or pgAdmin update the password of the admin user(admin@gmail.com). Use the clave_usuario copied in the previus step

```SQL
UPDATE usuarios SET clave_usuario = 'yourPasswordEncrypted' WHERE id_usuario=1;
```

## Run project

### Backend

Using the terminal, go to the project root folder and execute:

```bash
npm run dev
```

Default url: http://localhost:4000

### Frontend

Using the terminal, go to the project root folder and execute:

```bash
cd frontend # Localized in frontend directory
npm start   # Up frontend
```

Default url: http://localhost:3000

## Login

### If you use default "SECRET" value on .env file: 

Using usename and password by default for login:

**Username**: admin@gmail.com
**Password**: 320350

## If you are using custom "SECRET" value on .env file

Login with your credentials

**Username**: admin@gmail.com
**Pasword**: yourPasswordEncrypted

**JOIN**