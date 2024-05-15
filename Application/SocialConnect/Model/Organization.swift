//
//  Organization.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import Foundation
import SwiftyJSON

struct Organization: Identifiable, Codable, Hashable {
    struct Address: Hashable, Codable {
        let street1: String
        let street2: String
        let city: String
        let state: String
        let zipCode: String
        let country: String
    }
    
    struct Contact: Hashable, Codable {
        let phoneNumber: String
        let email: String
    }
    
    struct SocialNetwork: Hashable, Codable {
        let name: String
        let url: String
    }
    
    let id: String
    let userId: String
    let name: String
    let userName: String?
    let rfc: String?
    let schedule: String?
    let address: Address
    let contact: Contact
    let description: String?
    let socialNetworks: [SocialNetwork]
    let logoUrl: String?
    let videoUrl: String?
    let bannerUrl: String
    let tags: [String]
    let createdAt: Date
    let updatedAt: Date
}

extension Organization {
    init?(json: JSON) {
        guard
            let id = json["_id"].string,
            let userId = json["userId"].string,
            let name = json["name"].string,
            let addressJSON = json["address"].dictionary,
            let contactJSON = json["contact"].dictionary,
            let socialNetworksJSON = json["socialNetworks"].array,
            let bannerUrl = json["bannerUrl"].string,
            let tags = json["tags"].arrayObject as? [String]
        else {
            print("Failed to parse basic organization fields")
            return nil
        }
        
        // Extract Address, Contact, and SocialNetworks
        guard let address = Address(json: addressJSON) else { return nil }
        guard let contact = Contact(json: contactJSON) else { return nil }
        let socialNetworks = socialNetworksJSON.compactMap { SocialNetwork(json: $0) }

        self.id = id
        self.userId = userId
        self.name = name
        self.userName = json["userName"].string
        self.rfc = json["rfc"].string
        self.schedule = json["schedule"].string
        self.address = address
        self.contact = contact
        self.description = json["description"].string
        self.socialNetworks = socialNetworks
        self.logoUrl = json["logoUrl"].string
        self.videoUrl = json["videoUrl"].string
        self.bannerUrl = bannerUrl
        self.tags = tags
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        if let createdAtString = json["createdAt"].string, let createdAtDate = dateFormatter.date(from: createdAtString) {
            self.createdAt = createdAtDate
        } else {
            print("Failed to parse createdAt")
            return nil
        }

        if let updatedAtString = json["updatedAt"].string, let updatedAtDate = dateFormatter.date(from: updatedAtString) {
            self.updatedAt = updatedAtDate
        } else {
            print("Failed to parse updatedAt")
            return nil
        }
    }
}

extension Organization.Address {
    init?(json: [String: JSON]) {
        guard
            let street1 = json["street1"]?.string,
            let city = json["city"]?.string,
            let state = json["state"]?.string,
            let zipCode = json["zipCode"]?.string,
            let country = json["country"]?.string
        else {
            print("Failed to parse basic organization address fields")
            return nil
        }

        self.street1 = street1
        self.street2 = json["street2"]?.string ?? ""
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
}

extension Organization.Contact {
    init?(json: [String: JSON]) {
        guard
            let phoneNumber = json["phoneNumber"]?.string,
            let email = json["email"]?.string
        else {
            print("Failed to parse basic organization contact fields")
            return nil
        }

        self.phoneNumber = phoneNumber
        self.email = email
    }
}

extension Organization.SocialNetwork {
    init?(json: JSON) {
        guard
            let name = json["name"].string,
            let url = json["url"].string
        else {
            print("Failed to parse basic organization social network fields")
            return nil
        }

        self.name = name
        self.url = url
    }
}
