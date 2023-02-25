//
//  File.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor
import Fluent

final class AcronymCategoryPivot: Model {
    
    static let schema: String = "acronym-category-pivot"
    
    @ID
    var id: UUID?
    
    @Parent(key: "acronymId")
    var acronym: Acronym
    
    @Parent(key: "categoryId")
    var category: Category
    
    init() {}
    
    init(id: UUID? = nil, acronym: Acronym, category: Category) throws {
        self.id = id
        self.$acronym.id = try acronym.requireID()
        self.$category.id = try category.requireID()
    }
}
