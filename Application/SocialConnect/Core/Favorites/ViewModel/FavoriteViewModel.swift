import SwiftUI
import Alamofire
import SwiftyJSON

@MainActor
class FavoriteViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @Published var favorites = [Favorite]()
    @Published var isLoading = false

    init() {
        Task { fetchFavorites() }
    }

    func fetchFavorites() {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"

        AF.request("\(mongoBaseUrl)/favorites", method: .get, headers: HTTPHeaders(newHeaders)).responseData { data in
            let json = try! JSON(data: data.data!)
            self.favorites.removeAll()
            for favorite in json {
                let socialNetworksArray: [Favorite.SocialNetwork] = favorite.1["socialNetworks"].arrayValue.map { socialNetworkObject in
                    let name = socialNetworkObject["name"].stringValue
                    let url = socialNetworkObject["url"].stringValue
                    return Favorite.SocialNetwork(name: name, url: url)
                }

                let tagsArray: [String] = favorite.1["tags"].arrayValue.map { value in
                    return value.stringValue
                }

                let org = Favorite(
                    id: favorite.1["_id"].stringValue,
                    organizationId: favorite.1["organizationId"].stringValue,
                    userId: favorite.1["userId"].stringValue,
                    name: favorite.1["name"].stringValue,
                    rfc: favorite.1["rfc"].stringValue,
                    schedule: favorite.1["schedule"].stringValue,
                    userName: favorite.1["userName"].stringValue,
                    address: Favorite.Address(
                        street1: favorite.1["address"]["street1"].stringValue,
                        street2: favorite.1["address"]["street2"].stringValue,
                        city: favorite.1["address"]["city"].stringValue,
                        state: favorite.1["address"]["state"].stringValue,
                        zipCode: favorite.1["address"]["zipCode"].stringValue,
                        country: favorite.1["address"]["country"].stringValue
                    ),
                    contact: Favorite.Contact(
                        phoneNumber: favorite.1["contact"]["phoneNumber"].stringValue,
                        email: favorite.1["contact"]["email"].stringValue
                    ),
                    description: favorite.1["description"].stringValue,
                    socialNetworks: socialNetworksArray,
                    logoUrl: favorite.1["logoUrl"].stringValue,
                    videoUrl: favorite.1["videoUrl"].stringValue,
                    bannerUrl: favorite.1["bannerUrl"].stringValue,
                    tags: tagsArray,
                    createdAt: Date(),
                    updatedAt: Date()
                )

                self.favorites.append(org)
            }
        }
    }

    func removeFavorite(favoriteId: String) {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        let url = "\(mongoBaseUrl)/favorites/\(favoriteId)"
        
        if let index = favorites.firstIndex(where: { $0.id == favoriteId }) {
            favorites.remove(at: index)
        }
        
        AF.request(url, method: .delete, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(_):
                self.fetchFavorites()
                print("Favorite successfully removed from backend")
            case .failure(let err):
                print(err)
            }
        }
    }
}
