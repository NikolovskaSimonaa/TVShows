import Foundation

struct UserResponse: Codable {
    let user: User
}

struct User: Codable {
    let email: String
    let imageUrl: URL?
    let id: String

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}
