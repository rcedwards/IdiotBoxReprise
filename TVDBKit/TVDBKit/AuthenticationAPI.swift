import Foundation
import Promises

protocol AuthenticationAPI {
    var httpClient: HTTPRequester { get }
    var authenticatedHTTPClient: HTTPRequester? { get set }

    func aquireToken(withLogin loginInfo: Login) -> Promise<Token>
    func refreshToken() -> Promise<Token>
}

extension AuthenticationAPI {
    func aquireToken(withLogin loginInfo: Login) -> Promise<Token> {
        let endpoint = httpClient.url(forEndpoint: AuthenticationEndpoint.login)
        do {
            let data = try JSONEncoder().encode(loginInfo)
            return httpClient.post(endpoint, withBody: data).then { data in
                let decoder = JSONDecoder()
                return Promise(try decoder.decode(Token.self, from: data))
            }
        } catch {
            return Promise<Token>(error)
        }
    }

    func refreshToken() -> Promise<Token> {
        guard let authenticatedHTTPClient = authenticatedHTTPClient else {
            return Promise(AuthenticationError.missingToken)
        }
        let endpoint = authenticatedHTTPClient.url(forEndpoint: AuthenticationEndpoint.refresh)
        return authenticatedHTTPClient.get(endpoint).then { data in
            let decoder = JSONDecoder()
            return Promise(try decoder.decode(Token.self, from: data))
        }
    }
}

public enum AuthenticationError: Error {
    case missingToken
}

public enum AuthenticationEndpoint: Endpoint {
    case login
    case refresh

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .refresh:
            return "/refresh_token"
        }
    }

    var query: String? {
        switch self {
        case .login, .refresh:
            return nil
        }
    }
}

class AuthenticationAPIService: AuthenticationAPI {
    let httpClient: HTTPRequester
    var authenticatedHTTPClient: HTTPRequester?

    init(httpClient: HTTPRequester, authenticatedHTTPClient: HTTPRequester? = nil) {
        self.httpClient = httpClient
        self.authenticatedHTTPClient = authenticatedHTTPClient
    }
}
