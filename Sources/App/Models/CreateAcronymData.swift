//
//  CreateAcronymData.swift
//  
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import Vapor

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userId: UUID
}
