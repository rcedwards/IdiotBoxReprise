import Foundation

struct Series: Codable {

    enum Error: Swift.Error {
        case malformedKeyedDecodingContainer
    }

    enum Status: String {
        case ended = "Ended"
        case ongoing = "Continuing"
        case unknown
    }

    let identifier: Int
    let network: String?
    let overview: String?
    let name: String
    let slug: String
    let status: Status
    let beganDate: Date?
    let bannerPath: String?
    var banner: URL? {
        let base = Configuration.apiBaseURL
        return bannerPath.flatMap(base.appendingPathComponent)
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case beganDate = "firstAired"
        case name = "seriesName"
        case bannerPath = "banner"
        case network
        case overview
        case slug
        case status
    }

    init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            throw Error.malformedKeyedDecodingContainer
        }

        let rawStatus = try container.decode(String.self, forKey: .status)
        status = Status(rawValue: rawStatus) ?? .unknown

        if let dateString = try container.decodeIfPresent(String.self, forKey: .beganDate),
            !dateString.isEmpty {
            beganDate = try container.decode(Date.self, forKey: .beganDate)
        } else {
            beganDate = nil
        }

        identifier = try container.decode(Int.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        network = try container.decodeIfPresent(String.self, forKey: .network)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        slug = try container.decode(String.self, forKey: .slug)
        bannerPath = try container.decodeIfPresent(String.self, forKey: .bannerPath)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(network, forKey: .network)
        try container.encode(overview, forKey: .overview)
        try container.encode(slug, forKey: .slug)

        try container.encodeIfPresent(beganDate, forKey: .beganDate)
        try container.encodeIfPresent(bannerPath, forKey: .bannerPath)
    }
}
