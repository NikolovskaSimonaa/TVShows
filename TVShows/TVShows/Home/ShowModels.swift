struct Show: Decodable {
    let id: String
    let title: String?
    let description: String?
    let imageUrl: String?
    let noOfReviews: Int?
    let averageRating: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case noOfReviews = "no_of_reviews"
        case averageRating = "average_rating"
    }
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}
