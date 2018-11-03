import Foundation

protocol Endpoint {
    var path: String { get }
    var query: String? { get }
}

extension URL {
    func withEndpoint(_ endpoint: Endpoint) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            preconditionFailure("Base URL is invalid: \(self)")
        }
        guard endpoint.path.first == "/" else {
            preconditionFailure("Endpoint paths should begin with a '/'")
        }

        components.query = endpoint.query
        if path != "/" {
            components.path = path + endpoint.path
        } else {
            components.path = endpoint.path
        }

        guard let url = components.url else {
            preconditionFailure("Failed to formulate endpoint url with components: \(components)")
        }
        return url
    }
}

