import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON

@MainActor
class PostDetailsViewModel: ObservableObject {
    @AppStorage("token") var token = ""
    @Published var post: Post
    @Published var replies = [PostReply]()
    @Published var favorites = [Favorite]()
    @Published var starClicked = false
    @Published var possibleFavorite: Favorite?
    
    init(post: Post, replies: [PostReply] = [PostReply]()) {
        self.post = post
        self.replies = replies
        Task { await checkOrganizationFollow() }
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
                        
                let organizationId = self.post.organization.id
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
    
    func followOrganization() {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
                
        let parameters: Parameters = [
            "organizationId": self.post.organization.id
        ]
        
        AF.request("\(mongoBaseUrl)/favorites", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try! JSON(data: data)
                self.possibleFavorite = Favorite(
                    id: json["_id"].string ?? "",
                    organizationId: json["organizationId"].string ?? "",
                    userId: json["userId"].string ?? "",
                    name: self.post.organization.name,
                    rfc: self.post.organization.rfc,
                    schedule: self.post.organization.schedule,
                    userName: self.post.organization.userName,
                    address: Favorite.Address(
                        street1: self.post.organization.address.street1,
                        street2: self.post.organization.address.street2,
                        city: self.post.organization.address.city,
                        state: self.post.organization.address.state,
                        zipCode: self.post.organization.address.zipCode,
                        country: self.post.organization.address.country
                    ),
                    contact: Favorite.Contact(
                        phoneNumber: self.post.organization.contact.phoneNumber,
                        email: self.post.organization.contact.email
                    ),
                    description: self.post.organization.description,
                    socialNetworks: self.post.organization.socialNetworks.map { orgSocialNetwork in
                        Favorite.SocialNetwork(name: orgSocialNetwork.name, url: orgSocialNetwork.url)
                    },
                    logoUrl: self.post.organization.logoUrl,
                    videoUrl: self.post.organization.videoUrl,
                    bannerUrl: self.post.organization.bannerUrl,
                    tags: self.post.organization.tags,
                    createdAt: self.post.organization.createdAt,
                    updatedAt: self.post.organization.updatedAt
                )
                self.starClicked = true
            case .failure(let err):
                print(err)
            }
        }        
    }
    
    func unfollowOrganization() {
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
