//
//  UsersController.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        
        usersRoutes.post(use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.group(":userId") { user in
            user.get(use: getHandler)
            user.get("acronyms", use: getAcronymsHandler)
        }
    }
    
    // http://localhost:8080/api/users
    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
    // http://localhost:8080/api/users
    func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    // http://localhost:8080/api/users/<userId>
    func getHandler(_ req: Request) -> EventLoopFuture<User> {
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // http://localhost:8080/api/users/<userId>/acronyms
    func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$acronyms.get(on: req.db)
            }
    }
}
