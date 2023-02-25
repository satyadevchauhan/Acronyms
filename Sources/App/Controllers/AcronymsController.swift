//
//  AcronymsController.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms")
        
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.get(":acronymId", use: getHandler)
        acronymsRoutes.put(":acronymId", use: updateHandler)
        acronymsRoutes.delete(":acronymId", use: deleteHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: getSortedHandler)
        
        // user
        acronymsRoutes.get(":acronymId", "user", use: getUserHandler)
        
        // category
        acronymsRoutes.post(":acronymId", "categories", ":categoryId", use: addCategoryHandler)
        acronymsRoutes.get(":acronymId", "categories", use: getCategoriesHandler)
        acronymsRoutes.delete(":acronymId", "categories", use: deleteCategoryHandler)
    }
    
    // http://localhost:8080/api/acronyms
    func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let data = try req.content.decode(CreateAcronymData.self)
        let acronym = Acronym(short: data.short, long: data.long, userId: data.userId)
        return acronym.save(on: req.db).map { acronym }
    }
    
    // http://localhost:8080/api/acronyms
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // http://localhost:8080/api/acronyms/<acronymId>
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let updateData = try req.content.decode(CreateAcronymData.self)
        return Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.short = updateData.short
                acronym.long = updateData.long
                acronym.$user.id = updateData.userId
                return acronym.save(on: req.db).map { acronym }
            }
    }
    
    // http://localhost:8080/api/acronyms/<acronymId>
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    // http://localhost:8080/api/acronyms/search?term=<search_string>
    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        return Acronym
            .query(on: req.db).group(.or) { or in
                or.filter(\.$short == searchTerm)
                or.filter(\.$long == searchTerm)
            }.all()
    }
    
    // http://localhost:8080/api/acronyms/first
    func getFirstHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        return Acronym
            .query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    // http://localhost:8080/api/acronyms/sorted
    func getSortedHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        return Acronym
            .query(on: req.db)
            .sort(\.$short, .ascending)
            .all()
    }
    
}

// MARK: - Acronyms User

extension AcronymsController {
    // http://localhost:8080/api/acronyms/<acronymId>/user
    func getUserHandler(_ req: Request) throws -> EventLoopFuture<User> {
        Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.$user.get(on: req.db)
            }
    }
}

// MARK: - Acronyms Category

extension AcronymsController {
    
    // http://localhost:8080/api/acronyms/<acronymId>/categories/<categoryId>
    func addCategoryHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        let acronymQuery = Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        let categoryQuery = Category
            .find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return acronymQuery.and(categoryQuery)
            .flatMap { acronym, category in
                acronym
                    .$categories
                    .attach(category, on: req.db)
                    .transform(to: .created)
            }
    }
    
    // http://localhost:8080/api/acronyms/<acronymId>/categories
    func getCategoriesHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.$categories.query(on: req.db).all()
            }
    }
    
    // http://localhost:8080/api/acronyms/<acronymId>/categories/<categoryId>
    func deleteCategoryHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        let acronymQuery = Acronym
            .find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        let categoryQuery = Category
            .find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return acronymQuery.and(categoryQuery)
            .flatMap { acronym, category in
                acronym
                    .$categories
                    .detach(category, on: req.db)
                    .transform(to: .noContent)
            }
    }
}
