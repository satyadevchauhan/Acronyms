//
//  Category.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor
import Fluent

final class Category: Model, Content {
    
    static let schema: String = "categories"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: AcronymCategoryPivot.self, from: \.$category, to: \.$acronym)
    var acronyms: [Acronym]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.name = name
    }
}
