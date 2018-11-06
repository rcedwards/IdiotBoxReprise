import Foundation

enum Configuration {
    static let defaultAPIKey = Bundle.defaultAPIKey
    static let apiBaseURL = Bundle.apiBaseURL
}

fileprivate extension Bundle {
    static var defaultAPIKey: String {
        guard let key = tvdbKitBundle.infoDictionary?["TVDB_API_KEY"] as? String,
            !key.isEmpty else {
                preconditionFailure("Missing value from secrets.xcconfig")
        }
        return key
    }

    static var apiBaseURL: URL {
        guard let baseString = tvdbKitBundle.infoDictionary?["API_BASE"] as? String,
            !baseString.isEmpty,
            let url = URL(string: baseString) else {
                preconditionFailure("Invalid base url in info.plist")
        }
        return url
    }
}
