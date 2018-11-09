import Foundation
import Promises

// MARK: - API Contract

protocol EpisodeAPI {
    var authenticatedHTTPClient: AuthenticatedHTTPRequester { get set }

    func fetchEpisodes(forShow showID: Int, page: Int?) -> Promise<EpisodesCollection>
}

extension EpisodeAPI {
    func fetchEpisodes(forShow showID: Int, page: Int? = nil) -> Promise<EpisodesCollection> {
        let endpoint = EpisodeEndpoint.fetchEpisodes(showID: showID, page: page)
        let url = authenticatedHTTPClient.url(forEndpoint: endpoint)
        return authenticatedHTTPClient.get(url).then {
            let decoder = JSONDecoder()
            return Promise(try decoder.decode(EpisodesCollection.self, from: $0))
        }
    }
}

// MARK: - Concrete Service

class EpisodeAPIService: EpisodeAPI {
    var authenticatedHTTPClient: AuthenticatedHTTPRequester

    init(authenticatedHTTPClient: AuthenticatedHTTPRequester) {
        self.authenticatedHTTPClient = authenticatedHTTPClient
    }

}

// MARK: - Endpoints

public enum EpisodeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchEpisodes(showID: let showID, page: _):
            return "/series/\(showID)/episodes"
        }
    }

    var query: String? {
        switch self {
        case .fetchEpisodes(showID: _, page: let page?):
            return "page=\(page)"
        case .fetchEpisodes(showID: _, page: nil):
            return nil
        }
    }

    case fetchEpisodes(showID: Int, page: Int?)
}
