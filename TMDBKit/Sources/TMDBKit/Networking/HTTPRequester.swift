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

    enum Error: Swift.Error {
        case emptyResultBody
        case unknownServerError
        case serverError(statusCode: Int, details: String?)
    }
}

protocol HTTPRequester {
    var baseAddress: URL { get }
    var session: URLSession { get }

    func url(forEndpoint endpoint: Endpoint) -> URL

    async func get(_ url: URL) -> Data
    async func post(_ url: URL, withBody: Data) -> Data
    async func patch(_ url: URL, withBody: Data) -> Data
}

protocol AuthenticatedHTTPRequester: HTTPRequester {
    var token: Token { get }
}

extension HTTPRequester {
    func url(forEndpoint endpoint: Endpoint) -> URL {
        return baseAddress.forEndpoint(endpoint)
    }

    func get(_ url: URL) -> Promise<Data> {
        return request(url, requestType: .GET)
    }

    func patch(_ url: URL, withBody body: Data) -> Promise<Data> {
        return request(url, requestType: .PATCH, body: body)
    }

    func post(_ url: URL, withBody body: Data) -> Promise<Data> {
        return request(url, requestType: .POST, body: body)
    }

    private func request(_ url: URL, requestType: HTTP.RequestType, body: Data? = nil) -> Promise<Data> {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        if let bodyData = body {
            request.httpBody = bodyData
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        return fetch(request).then(inspectTaskResponse)
    }

    private typealias DataTaskResponse = (Data?, URLResponse?)
    private func fetch(_ request: URLRequest) -> Promise<DataTaskResponse> {
        return wrap { self.session.dataTask(with: request, completionHandler: $0).resume() }
    }

    private func inspectTaskResponse(_ task: DataTaskResponse) -> Promise<Data> {
        return Promise<Data> { fullfill, reject in
            guard let response = task.1 as? HTTPURLResponse else { reject(HTTP.Error.unknownServerError); return }
            guard let responseData = task.0 else { reject(HTTP.Error.emptyResultBody); return }

            switch response.statusCode {
            case 200...299:
                fullfill(responseData)
            default:
                reject(HTTP.Error.serverError(statusCode: response.statusCode,
                                              details: self.parseError(body: responseData)))
            }
        }
    }

    private func parseError(body: Data) -> String? {
        // TODO: rcedwards Parse details out of error body
        return String(bytes: body, encoding: .utf8)
    }
}

extension HTTPRequester {
    func urlForEndpoint(_ endpoint: Endpoint) -> URL {
        return baseAddress.forEndpoint(endpoint)
    }
}
