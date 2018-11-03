import Foundation

struct Token: Codable {
    let value: String

    enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}
