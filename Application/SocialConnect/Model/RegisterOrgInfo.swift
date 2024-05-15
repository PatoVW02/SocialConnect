//
//  RegisterOrgInfo.swift
//  SocialConnect
//
//  Created by David Faudoa on 11/10/23.
//

import Foundation

struct RegisterOrgInfo: Codable {
    
    var name: String
    var userName: String
    var rfc: String
    var schedule: String
    var phoneNumber: String
    var email: String
    var desc: String
    var logourl: String
    var street: String
    var number: String
    var city: String
    var state: String
    var zipcode: String
    var country: String
    var Tags: [String]
    var password: String
    var facebook: String
    var instagram: String
    var twitter: String
}
