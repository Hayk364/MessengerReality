//
//  User.swift
//  MessengeReality
//
//  Created by АА on 01.10.24.
//

import Foundation

struct User:Codable{
    let id:String?
    let name:String?
    let password:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case password
    }
}
