import Foundation

enum HTTP {
    enum RequestType: String {
        case POST
        case PUT
        case PATCH
        case GET
        case DELETE
        case HEAD
    }
}

protocol HTTPRequester {
    var baseAddress: URL { get }
    var session: URLSession { get set }

    func get(_ url: URL) -> Data?
    func post(_ url: URL, withBody: Data) -> Data?
    func patch(_ url: URL, withBody: Data) -> Data?
}

protocol AuthenticatedHTTPRequester {
    var token: Token { get }
}

extension HTTPRequester {
    func get(_ url: URL) -> Data? {
        return sendRequest(url, requestType: .GET)
    }

    func patch(_ url: URL, withBody body: Data) -> Data? {
        return sendRequest(url, requestType: .PATCH, body: body)
    }

    func post(_ url: URL, withBody body: Data) -> Data? {
        return sendRequest(url, requestType: .POST, body: body)
    }

    private func sendRequest(_ url: URL, requestType: HTTP.RequestType, body: Data? = nil) -> Data? {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.httpBody = body
        let task = session.dataTask(with: request) { (maybeData, maybeResponse, maybeError) in
            print(maybeData)
            print(maybeResponse)
            print(maybeError)
        }
        task.resume()
        return nil
    }
}

extension HTTPRequester {
    func urlForEndpoint(_ endpoint: Endpoint) -> URL {
        return baseAddress.withEndpoint(endpoint)
    }
}
