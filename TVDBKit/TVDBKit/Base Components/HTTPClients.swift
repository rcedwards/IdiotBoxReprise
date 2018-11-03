import Foundation

class HTTPClient: HTTPRequester {
    let baseAddress: URL

    var sessionConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json; charset=utf-8"
        ]
        return config
    }

    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfig)
    }()

    init(baseAddress: URL) {
        self.baseAddress = baseAddress
    }
}

class AuthenticatedHTTPClient: HTTPClient, AuthenticatedHTTPRequester {
    let token: Token

    override var sessionConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json; charset=utf-8",
            "Authorization": "Bearer \(token.value)"
        ]
        return config
    }

    init(baseAddress: URL, token: Token) {
        self.token = token
        super.init(baseAddress: baseAddress)
    }
}
