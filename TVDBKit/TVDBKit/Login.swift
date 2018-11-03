import Foundation

struct Login: Codable {
    let username: String
    let password: String
    let apiKey: String

    enum CodingKeys: String, CodingKey {
        case username
        case password = "userkey"
        case apiKey
    }

    init(username: String, password: String, apiKey: String = "") {
        self.username = username
        self.password = password
        self.apiKey = apiKey
    }
}
