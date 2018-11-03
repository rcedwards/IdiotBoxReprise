import Foundation
import Promises

enum HTTP {
    enum RequestType: String {
        case POST
        case PUT
        case PATCH
        case GET
        case DELETE
        case HEAD
    }

    enum Error: Swift.Error {
        case unknownServerError
    }
}

protocol HTTPRequester {
    var baseAddress: URL { get }
    var session: URLSession { get }

    func url(forEndpoint endpoint: Endpoint) -> URL

    func get(_ url: URL) -> Promise<Data>
    func post(_ url: URL, withBody: Data) -> Promise<Data>
    func patch(_ url: URL, withBody: Data) -> Promise<Data>
}

protocol AuthenticatedHTTPRequester {
    var token: Token { get }
}

extension HTTPRequester {
    func url(forEndpoint endpoint: Endpoint) -> URL {
        return baseAddress.forEndpoint(endpoint)
    }

    func get(_ url: URL) -> Promise<Data> {
        return sendRequest(url, requestType: .GET)
    }

    func patch(_ url: URL, withBody body: Data) -> Promise<Data> {
        return sendRequest(url, requestType: .PATCH, body: body)
    }

    func post(_ url: URL, withBody body: Data) -> Promise<Data> {
        return sendRequest(url, requestType: .POST, body: body)
    }

    private func sendRequest(_ url: URL, requestType: HTTP.RequestType, body: Data? = nil) -> Promise<Data> {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        if let bodyData = body {
            request.httpBody = bodyData
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        return Promise<Data> { fullfill, reject in
            let task = self.session.dataTask(with: request) { (maybeData, maybeResponse, maybeError) in
                switch (maybeData, maybeError) {
                case (let responseData?, _):
                    fullfill(responseData)
                case (_, let error?):
                    reject(error)
                default:
                    reject(HTTP.Error.unknownServerError)
                }
            }
            task.resume()
        }
    }
}

extension HTTPRequester {
    func urlForEndpoint(_ endpoint: Endpoint) -> URL {
        return baseAddress.forEndpoint(endpoint)
    }
}
