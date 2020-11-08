//
//  User.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 30/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

import Foundation
struct User: Codable {
    let id : String
    let username: String
    let email: String
    let password : String
    let role : [String]
}

