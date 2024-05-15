//
//  OrganizationFiles.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 11/10/23.
//

import Foundation
struct OrganizationFiles: Identifiable, Codable, Hashable {
    var id: String
    var organizationId: String
    var name: String
    var content: String  // Base64 string
    var size: Int
    var type: String
    var createdAt: Date
}
