import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let role: String
    let imageUrl: String
    let isFollowed: Bool
}
