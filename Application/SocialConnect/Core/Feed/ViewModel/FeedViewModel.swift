import SwiftUI
import Alamofire
import SwiftyJSON

@MainActor
class FeedViewModel: ObservableObject {
    @AppStorage("token") var token: String = ""
    @Published var posts = [Post]()
    @Published var isLoading = false

    init() {
        Task { await fetchPosts() }
    }

    func fetchPosts() async {
        isLoading = true
        var newHeaders = mongoHeaders
        newHeaders["Authorization"] = "Bearer \(token)"

        AF.request("\(mongoBaseUrl)/posts", method: .get, headers: HTTPHeaders(newHeaders)).responseData { response in
            switch response.result {
            case .success(let value):
                let json = try! JSON(data: value)
                print(json)
                let fetchedPosts = json.arrayValue.map { postJson -> Post? in
                    if let post = Post(json: postJson) {
                        return post
                    } else {
                        return nil
                    }
                }.compactMap { $0 }
                
                self.posts = fetchedPosts
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
}
