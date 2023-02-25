//
//  configure.swift
//
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent
import FluentPostgresDriver
//import FluentSQLiteDriver
//import FluentMySQLDriver
//import FluentMongoDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // register database
    
    let databaseName: String
    let databasePort: Int
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = "vapor_database"
        databasePort = 5432
    }
    
    // postgres db
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: databasePort, //Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? databaseName
    ), as: .psql)
    
    // sqlite db
    //app.databases.use(.sqlite(.memory), as: .sqlite)  // In Memory
    //app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)   // sqlite file
    
    // mysql db
    /*var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
    app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME")
        ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD")
        ?? "vapor_password",
        database: Environment.get("DATABASE_NAME")
        ?? "vapor_database",
        tlsConfiguration: tls//.forClient(certificateVerification: .none)
    ), as: .mysql)*/
    
    // mongo db
    //try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/vapor"), as: .mongo)
    
    // register database migration
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    
    // enable debugging
    app.logger.logLevel = .debug
    
    // migrate Database
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
