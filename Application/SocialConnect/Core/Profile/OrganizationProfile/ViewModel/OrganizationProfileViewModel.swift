//
//  OrganizationProfileViewModel.swift
//  SocialConnect
//
//  Created by Patricio Villarreal Welsh on 26/09/23.
//

import SwiftUI
import Alamofire
import SwiftyJSON

@MainActor
class OrganizationProfileViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @Published var organization: Organization
    @Published var starClicked: Bool = false
    @Published var favorites = [Favorite]()
    @Published var possibleFavorite: Favorite?
    @Published var posts = [Post]()
    
    init(organization: Organization) {
        self.organization = organization
        Task { await checkOrganizationFollow() }
        Task { await fetchOrganizationPosts() }
    }
    
    func checkOrganizationFollow() async {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        AF.request("\(mongoBaseUrl)/favorites", method: .get, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try! JSON(data: data)
                let fetchedFavorites = json.arrayValue.compactMap { Favorite(json: $0) }
                
                self.favorites = fetchedFavorites
                        
                let organizationId = self.organization.id
                self.starClicked = self.favorites.contains(where: { $0.organizationId == organizationId })
                
                if self.starClicked {
                    self.possibleFavorite = self.favorites.first(where: { $0.organizationId == organizationId })
                }
            case .failure(let err):
                print(err)
                self.starClicked = false
            }
        }
    }
    
    func fetchOrganizationPosts() async {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        AF.request("\(mongoBaseUrl)/posts/organization/\(self.organization.id)", method: .get, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try! JSON(data: data)
                let fetchedPosts = json.arrayValue.compactMap { Post(json: $0) }
                
                self.posts = fetchedPosts
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func markAsFavorite(organizationId: String) {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        let parameters: Parameters = [
            "organizationId": self.organization.id
        ]
        
        AF.request("\(mongoBaseUrl)/favorites", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try! JSON(data: data)
                self.possibleFavorite = Favorite(
                    id: json["_id"].string ?? "",
                    organizationId: json["organizationId"].string ?? "",
                    userId: json["userId"].string ?? "",
                    name: self.organization.name,
                    rfc: self.organization.rfc,
                    schedule: self.organization.schedule,
                    userName: self.organization.userName,
                    address: Favorite.Address(
                        street1: self.organization.address.street1,
                        street2: self.organization.address.street2,
                        city: self.organization.address.city,
                        state: self.organization.address.state,
                        zipCode: self.organization.address.zipCode,
                        country: self.organization.address.country
                    ),
                    contact: Favorite.Contact(
                        phoneNumber: self.organization.contact.phoneNumber,
                        email: self.organization.contact.email
                    ),
                    description: self.organization.description,
                    socialNetworks: self.organization.socialNetworks.map { orgSocialNetwork in
                        Favorite.SocialNetwork(name: orgSocialNetwork.name, url: orgSocialNetwork.url)
                    },
                    logoUrl: self.organization.logoUrl,
                    videoUrl: self.organization.videoUrl,
                    bannerUrl: self.organization.bannerUrl,
                    tags: self.organization.tags,
                    createdAt: self.organization.createdAt,
                    updatedAt: self.organization.updatedAt
                )
                self.starClicked = true
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func unmarkAsFavorite() {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        if let favoriteId = possibleFavorite?.id {
            let url = "\(mongoBaseUrl)/favorites/\(favoriteId)"
            
            AF.request(url, method: .delete, headers: HTTPHeaders(newHeaders)).responseData { response in
                switch response.result {
                case .success(_):
                    self.starClicked = false
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
