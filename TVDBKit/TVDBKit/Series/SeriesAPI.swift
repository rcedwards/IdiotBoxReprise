import Foundation
import Promises

// MARK: - API Contract

protocol SeriesAPI {
    var authenticatedHTTPClient: AuthenticatedHTTPRequester { get set }

    func searchSeries(query: String) -> Promise<[Series]>
}

extension SeriesAPI {
    func searchSeries(query: String) -> Promise<[Series]> {
        let endpoint = authenticatedHTTPClient.url(forEndpoint: SeriesEndpoint.search(query: query))
        return authenticatedHTTPClient.get(endpoint).then { data in
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            let json = try decoder.decode([String: [Series]].self, from: data)
            guard let series = json["data"] else { throw SeriesError.parserError }
            return Promise(series)
        }
    }
}

// MARK: - Errors

enum SeriesError: Swift.Error {
    case parserError
}

// MARK: - Endpoints

public enum SeriesEndpoint: Endpoint {
    case search(query: String)

    var path: String {
        switch self {
        case .search(_):
            return "/search/series"
        }
    }

    var query: String? {
        switch self {
        case .search(let query):
            return "name=\(query)"
        }
    }
}

// MARK: - Concrete Service

class SeriesAPIService: SeriesAPI {
    var authenticatedHTTPClient: AuthenticatedHTTPRequester

    init(authenticatedHTTPClient: AuthenticatedHTTPRequester) {
        self.authenticatedHTTPClient = authenticatedHTTPClient
    }
}
