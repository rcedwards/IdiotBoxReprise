import Foundation

struct Login: Codable {
    fileprivate static let defaultAPIKey = Configuration.defaultAPIKey

    let username: String?
    let password: String?
    let apiKey: String

    enum CodingKeys: String, CodingKey {
        case username
        case password = "userkey"
        case apiKey
    }

    init(username: String? = nil, password: String? = nil, apiKey: String = defaultAPIKey) {
        self.username = username
        self.password = password
        self.apiKey = apiKey
    }
}
