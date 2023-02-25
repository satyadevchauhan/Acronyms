//
//  CreateCategory.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent

struct CreateCategory: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(Category.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(Category.schema).delete()
    }
}
