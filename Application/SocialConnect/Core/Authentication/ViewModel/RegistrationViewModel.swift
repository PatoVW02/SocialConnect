import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

class RegistrationViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @Published var email = ""
    @Published var phonenumber = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    @Published var isAuthenticating = false
    @Published var showAlert: Bool = false
    @Published var tags = [Tag]()
    
    init() {
        Task { try fetchTags() }
    }
    
    func createUser() {
        
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
}
