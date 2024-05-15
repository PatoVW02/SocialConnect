import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

class CreatePostViewModel: ObservableObject {
    @AppStorage("token") var token = ""
    @Published var title = ""
    @Published var content = ""
    @Published var fileUrl = ""
    
    func createPost() async throws {
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"
        
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "videoUrl": fileUrl
        ]
        
        AF.request("\(mongoBaseUrl)/posts", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(newHeaders)).response { response in
            switch response.result {
            case .success:
                return
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
