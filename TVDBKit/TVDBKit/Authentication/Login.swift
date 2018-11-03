import Foundation

struct Login: Codable {
    fileprivate static let defaultAPIKey = Bundle.defaultAPIKey

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

fileprivate extension Bundle {
    static var defaultAPIKey: String {
        guard let key = tvdbKitBundle.infoDictionary?["TVDB_API_KEY"] as? String,
            !key.isEmpty else {
                preconditionFailure("Missing value from secrets.xcconfig")
        }
        return key
    }
}
