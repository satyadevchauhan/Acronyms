//
//  CategoriesController.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor
import Fluent

struct CategoriesController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "categories")
        
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.get(":categoryId", use: getHandler)
        acronymsRoutes.get(":categoryId", "acronyms", use: getAcronymsHandler)
    }
    
    // http://localhost:8080/api/categories
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    // http://localhost:8080/api/categories
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    // http://localhost:8080/api/categories/<categoryId>
    func getHandler(_ req: Request) -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // http://localhost:8080/api/categories/<categoryId>/acronyms
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { category in
                category.$acronyms.get(on: req.db)
            }
    }
    
}
