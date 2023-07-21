struct Show: Decodable {
    let id: String
    let title: String
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}
