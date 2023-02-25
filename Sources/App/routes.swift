//
//  routes.swift
//
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req -> String in
      return "Hello, Vapor!"
    }
    
    try app.register(collection: AcronymsController())
    
    try app.register(collection: UsersController())
    
    try app.register(collection: CategoriesController())
}
