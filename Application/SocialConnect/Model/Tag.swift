//
//  Tag.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import Foundation
struct Tag: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let createdAt: Date
    let updatedAt: Date
    let updatedBy: String
}

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
