import Foundation
import Combine
import SwiftUI
import PhotosUI
import Alamofire
import SwiftyJSON

@MainActor
class CurrentUserProfileViewModel: ObservableObject {
    @AppStorage("token") var token = ""
    @Published var currentUser: User?
    @Published var posts = [Post]()
    @Published var tags = [Tag]()
    @Published var currentUserTags = [Tag]()
    @AppStorage("userId") var userId: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("userFirstName") var userFirstName: String = ""
    @AppStorage("userLastName") var userLastName: String = ""
    @AppStorage("userPhoneNumber") var userPhoneNumber: String = ""
    @AppStorage("userRole") var userRole: String = ""
    @AppStorage("userImageUrl") var userImageUrl: String = ""
    @AppStorage("isOrganization") var isOrganization: Bool = false
    
    init() {
        Task {
            do {
                try fetchTags()
                try fetchCurrentUserTags()
            } catch {
            }
        }
    }
    
    func fetchTags() throws {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        AF.request("\(mongoBaseUrl)/tags", method: .get, headers: HTTPHeaders(newHeaders)).responseData { data in
            let json = try! JSON(data: data.data!)
            for tag in json {
                let newTag = Tag(
                    id: tag.1["_id"].stringValue,
                    name: tag.1["name"].stringValue,
                    description: tag.1["description"].stringValue,
                    createdAt: Date(),
                    updatedAt: Date(),
                    updatedBy: tag.1["updatedBy"].stringValue
                )

                self.tags.append(newTag)
            }
        }
    }
    
    func fetchCurrentUserTags() throws {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        AF.request("\(mongoBaseUrl)/users/get/tags", method: .get, headers: HTTPHeaders(newHeaders)).responseData { [weak self] data in
            guard let self = self else { return }
            let json = try! JSON(data: data.data!)
            var tags: [Tag] = []
            for tag in json {
                let newTag = Tag(
                    id: tag.1["_id"].stringValue,
                    name: tag.1["name"].stringValue,
                    description: "",
                    createdAt: Date(),
                    updatedAt: Date(),
                    updatedBy: ""
                )
                tags.append(newTag)
            }

            DispatchQueue.main.async {
                self.currentUserTags = tags
            }
        }
    }
    
    func updateUserProfile(newTags: [Tag]) {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        let tagIDs = newTags.map { $0.id }
        let parameters: [String: Any] = [
            "tags": tagIDs
        ]

        print("Parameters: \(parameters)")
        print("Headers: \(newHeaders)")
            
        AF.request("\(mongoBaseUrl)/users/update/tags", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(newHeaders)).responseData { [weak self] response in
                switch response.result {
                case .success(_):
                    self?.currentUserTags = newTags

                case .failure(_):
                    if let data = response.data {
                        print("Server error: \(String(decoding: data, as: UTF8.self))")
                    }
                }
            }

    }
}
