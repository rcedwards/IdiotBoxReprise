import Foundation
import Promises

// MARK: - API Contract

protocol AuthenticationAPI {
    var httpClient: HTTPRequester { get }
    var authenticatedHTTPClient: AuthenticatedHTTPRequester? { get set }

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
            return Promise(AuthenticationError.missingAuthenticatedRequestor)
        }
        let endpoint = authenticatedHTTPClient.url(forEndpoint: AuthenticationEndpoint.refresh)
        return authenticatedHTTPClient.get(endpoint).then { data in
            let decoder = JSONDecoder()
            return Promise(try decoder.decode(Token.self, from: data))
        }
    }
}

// MARK: - Errors

public enum AuthenticationError: Error {
    case missingAuthenticatedRequestor
}

// MARK: - Endpoints

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

// MARK: - Concrete Service

class AuthenticationAPIService: AuthenticationAPI {
    let httpClient: HTTPRequester
    var authenticatedHTTPClient: AuthenticatedHTTPRequester?

    init(httpClient: HTTPRequester, authenticatedHTTPClient: AuthenticatedHTTPRequester? = nil) {
        self.httpClient = httpClient
        self.authenticatedHTTPClient = authenticatedHTTPClient
    }
}
