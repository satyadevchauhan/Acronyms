//
//  main.swift
//
//
//  Created by Satyadev Chauhan on 25/02/23.
//

import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
