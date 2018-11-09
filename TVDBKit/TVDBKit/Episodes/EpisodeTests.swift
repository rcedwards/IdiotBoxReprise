import XCTest
@testable import TVDBKit

class EpisodeTests: XCTestCase {

    var episodesService: EpisodeAPIService!
    var authService: AuthenticationAPIService!
    let baseAddress = Configuration.apiBaseURL
    let login = Login()

    override func setUp() {
        super.setUp()

        let httpClient = HTTPClient(baseAddress: baseAddress)
        authService = AuthenticationAPIService(httpClient: httpClient)
    }

    func testFetchingFirstPageOfEpisodes() throws {
        let showIdentifier = 73739

        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login).then {
            let authenticatedClient = AuthenticatedHTTPClient(baseAddress: self.baseAddress, token: $0)
            self.episodesService = EpisodeAPIService(authenticatedHTTPClient: authenticatedClient)
            self.episodesService.fetchEpisodes(forShow: showIdentifier).then {
                XCTAssert($0.episodes.count > 0)
                callbackExpectation.fulfill()
            }.catch {
                XCTFail("\($0)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
