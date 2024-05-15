//
//  Role.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 13/10/23.
//

import Foundation
struct Role: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var description: String
    var permissions: [String]
}
