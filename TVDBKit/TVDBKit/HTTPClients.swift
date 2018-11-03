import Foundation

class HTTPClient: HTTPRequester {
    let baseAddress: URL
    lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration())
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
