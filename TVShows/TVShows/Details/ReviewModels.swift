struct ReviewResponse: Codable {
    let review: Review
}

struct Review: Codable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}

