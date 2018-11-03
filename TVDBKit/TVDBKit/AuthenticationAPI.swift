import Foundation
import Promises

protocol AuthenticationAPI {
    var httpClient: HTTPRequester { get }
    func aquireToken(withLogin loginInfo: Login) -> Promise<Token>
}

extension AuthenticationAPI {
    func aquireToken(withLogin loginInfo: Login) -> Promise<Token> {
        let endpointURL = httpClient.baseAddress.withEndpoint(AuthenticationEndpoint.login)
        do {
            let data = try JSONEncoder().encode(loginInfo)
            return httpClient.post(endpointURL, withBody: data).then { data in
                print("Data \(data)")
                return Promise(Token(value: "test"))
            }
        } catch {
            return Promise<Token>(error)
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
