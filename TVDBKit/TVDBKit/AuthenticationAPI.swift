import Foundation
import Promises

protocol AuthenticationAPI {
    var httpClient: HTTPRequester { get }
    func aquireToken(withLogin loginInfo: Login) -> Token?
}

extension AuthenticationAPI {
    func aquireToken(withLogin loginInfo: Login) -> Token? {
        let endpointURL = httpClient.baseAddress.withEndpoint(AuthenticationEndpoint.login)
        do {
            let data = try JSONEncoder().encode(loginInfo)
            let result = httpClient.post(endpointURL, withBody: data)
            return nil
        } catch {
            return nil
        }
    }
}

public enum AuthenticationEndpoint: Endpoint {
    case login

    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }

    var query: String? {
        switch self {
        case .login:
            return nil
        }
    }
}

struct AuthenticationAPIService: AuthenticationAPI {
    let httpClient: HTTPRequester
}
