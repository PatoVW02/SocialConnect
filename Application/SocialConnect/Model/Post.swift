//
//  Post.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 25/09/23.
//

import Foundation
import SwiftyJSON

struct Post: Identifiable, Codable, Hashable {
    var id: String
    let organization: Organization
    let title: String
    let postType: String
    let content: String
    let videoUrl: String
    let createdAt: Date
}

extension Post {
    init?(json: JSON) {
        guard let id = json["_id"].string else {
            print("Failed to parse _id")
            return nil
        }
        
        guard let organizationData = Organization(json: json["organization"]) else {
            print("Failed to parse organization")
            return nil
        }
        
        guard let title = json["title"].string else {
            print("Failed to parse title")
            return nil
        }
        
        guard let postType = json["postType"].string else {
            print("Failed to parse postType")
            return nil
        }
        
        guard let content = json["content"].string else {
            print("Failed to parse content")
            return nil
        }
        
        guard let videoUrl = json["videoUrl"].string else {
            print("Failed to parse videoUrl")
            return nil
        }
        
        guard let createdAtString = json["createdAt"].string,
              let createdAtDate = DateFormatter.mongoDB.date(from: createdAtString) else {
            print("Failed to parse createdAt date")
            return nil
        }
                
        self.id = id
        self.organization = organizationData
        self.title = title
        self.postType = postType
        self.content = content
        self.videoUrl = videoUrl
        self.createdAt = createdAtDate
    }
}
