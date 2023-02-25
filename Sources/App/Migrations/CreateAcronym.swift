//
//  CreateAcronym.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent

struct CreateAcronym: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(Acronym.schema)
            .id()
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userId", .uuid, .required, .references(User.schema, "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(Acronym.schema).delete()
    }
}
