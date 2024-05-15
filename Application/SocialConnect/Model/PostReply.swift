//
//  PostReply.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 12/10/23.
//

import Foundation
struct PostReply: Identifiable, Hashable, Codable {
    var id: String
    var replyUser: String
    var user: User
}
