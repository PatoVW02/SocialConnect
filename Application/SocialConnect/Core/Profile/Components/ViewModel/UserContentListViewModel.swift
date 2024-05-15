import Foundation

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var replies = [PostReply]()
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
}
