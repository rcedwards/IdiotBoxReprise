struct EpisodesCollection: Codable {
    let episodes: [Episode]
    let pagesInfo: PaginationInformation

    enum CodingKeys: String, CodingKey {
        case episodes = "data"
        case pagesInfo = "links"
    }
}

struct PaginationInformation: Codable {
    let first: Int
    let last: Int
    let next: Int?
    let previous: Int?
}
