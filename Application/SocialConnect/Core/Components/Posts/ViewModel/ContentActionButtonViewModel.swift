import Foundation

@MainActor
class ContentActionButtonViewModel: ObservableObject {
    @Published var post: Post?
    @Published var reply: PostReply?
    
    init(post: Post? = nil, reply: PostReply? = nil) {
        self.post = post
        self.reply = reply
    }
}
