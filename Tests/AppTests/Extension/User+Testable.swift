//
//  User+Testable.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

@testable import App
import Fluent

extension User {
    static func create( name: String = "Luke", username: String = "lukes", on database: Database) throws -> User {
        let user = User(name: name, username: username)
        try user.save(on: database).wait()
        return user
    }
}

