# Acronyms
Acronyms is rest API build upon [Vapor](https://vapor.codes/) framework.

## Vapor
Vapor 4 requires Swift 5.2, both in Xcode and from the command line. Xcode 11.4 and 11.5 both provide Swift 5.2.

## Installing on macOS
```
$ brew install vapor
```

## Uninstalling from macOS
```
$ brew uninstall vapor
```

## Creating Vapor Porject
```
$ vapor new <project_name>
```
e.g.
```
$ vapor new HelloVapor
```

## To build and start your app, run:
```
$ cd <project_name>
$ swift run
```

The template has a predefined route, so open your browser and visit http://localhost:8080/ and see the response!

Use CTRL+C to terminate running instance of server

Finding running application instance (server) with PID
```
$ lsof -i :8080
```

Kill running application instance with PID
```
$ kill PID
```

Open project in Xcode
```
$ open Package.swift
```

## Docker
Install the [Docker](https://www.docker.com/) desktop client.
We will use docker to install database and run test-cases.

To check that your database is running in docker
```
$ docker ps
```

## Database


- ### PostgreSQL

To use PostgreSQL, add the SPM library as dependency
```
.package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
```

and to the target app.
```
.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
```

Import the package in configre.swift file.
```
import FluentPostgresDriver
```

Add the below code to use postgres database 
```
app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? databaseName
), as: .psql)
```
    
Running PostgresSQL in docker
```
$ docker run --name postgres -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres
```

Stop PostgreSQL database
```
$ docker stop postgres
```

Remove PostgreSQL database
```
$ docker rm postgres  
```

- ### MySQL

To use MySQL, import the SPM library as dependency
```
.package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0")
```

and to the target app.
```
.product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
```

Import the package in configre.swift file.
```
import FluentMySQLDriver
```

Add the below code to use mysql database 
```
var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
app.databases.use(.mysql(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? "vapor_database",
    tlsConfiguration: tls//.forClient(certificateVerification: .none)
), as: .mysql)
```

Running MySQL in docker
```
$ docker run --name mysql \
  -e MYSQL_USER=vapor_username \
  -e MYSQL_PASSWORD=vapor_password \
  -e MYSQL_DATABASE=vapor_database \
  -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
  -p 3306:3306 -d mysql
```

- ### Mongo

To use MySQL, import the SPM library
```
.package(url: "https://github.com/vapor/fluent-mongo-driver.git", from: "1.0.0")
```

and to the target app.
```
.product(name: "FluentMongoDriver", package: "fluent-mongo-driver"),
```

Import the package in configre.swift file.
```
import FluentMongoDriver
```

Add the below code to use mongo database 
```
try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/vapor"), as: .mongo)
```

Running Mongo in docker
```
$ docker run --name mongo \
  -e MONGO_INITDB_DATABASE=vapor \
  -p 27017:27017 -d mongo
```

- ### SQLite

To use MySQL, add the SPM library
```
.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0")
```

and to the target app.
```
.product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
```

Import the package in configre.swift file.
```
import FluentSQLiteDriver
```

Add the below code to use sqlite database in memory 
```
app.databases.use(.sqlite(.memory), as: .sqlite)
```

or sqlite file name
```
app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)   
```
    
### TESTING

Build testing docker
```
$ docker-compose -f docker-compose-testing.yml build
```

Run testing in docker
```
$ docker-compose -f docker-compose-testing.yml up \
  --abort-on-container-exit  
```
