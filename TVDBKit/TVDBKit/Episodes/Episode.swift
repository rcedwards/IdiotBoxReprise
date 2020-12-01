struct Episode: Codable {
    let identifier: Int
    let name: String
    let overview: String
    let episodeNumber: Int
    let seasonNumber: Int
    let seasonIdentifier: Int
    let seriesIdentifier: Int
    let director: String?
    let thumbnailRelativePath: String?
    let lastUpdated: Date
    let writers: [String]

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case episodeNumber = "airedEpisodeNumber"
        case seasonNumber = "airedSeason"
        case seasonIdentifier = "airedSeasonID"
        case director
        case name = "episodeName"
        case thumbnailRelativePath = "filename"
        case lastUpdated
        case overview
        case seriesIdentifier = "seriesId"
        case writers
    }
}
