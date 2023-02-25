//
//  CreateUser.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent

struct CreateUser: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
