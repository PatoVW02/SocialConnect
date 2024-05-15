import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var replies = [PostReply]()
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }

}
