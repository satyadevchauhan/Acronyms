//
//  Acronym+Testable.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

@testable import App
import Fluent

extension Acronym {
    static func create(short: String = "TIL", long: String = "Today I Learned", user: User? = nil, on database: Database) throws -> Acronym {
        var acronymsUser = user
        
        if acronymsUser == nil {
            acronymsUser = try User.create(on: database)
        }
        
        let acronym = Acronym(short: short, long: long, userId: acronymsUser!.id!)
        try acronym.save(on: database).wait()
        return acronym
    }
}
