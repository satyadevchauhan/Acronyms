//
//  CreateAcronymCategoryPivot.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Fluent

struct CreateAcronymCategoryPivot: Migration {
    
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(AcronymCategoryPivot.schema)
            .id()
            .field("acronymId", .uuid, .required, .references(Acronym.schema, "id", onDelete: .cascade))
            .field("categoryId", .uuid, .required, .references(Category.schema, "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema(AcronymCategoryPivot.schema).delete()
    }
}
