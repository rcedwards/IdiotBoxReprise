import Foundation

class HTTPClient: HTTPRequester {
    let baseAddress: URL
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json; charset=utf-8"
        ]
        return URLSession(configuration: config)
    }()

    init(baseAddress: URL) {
        self.baseAddress = baseAddress
    }
}

class AuthenticatedHTTPClient: HTTPClient, AuthenticatedHTTPRequester {
    let token: Token

    init(baseAddress: URL, token: Token) {
        self.token = token
        super.init(baseAddress: baseAddress)
    }
}
