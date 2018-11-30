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

    func testFetchingSubsequentPage() throws {
        let showIdentifier = 73739
        let page = 2
        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login).then {
            let authenticatedClient = AuthenticatedHTTPClient(baseAddress: self.baseAddress, token: $0)
            self.episodesService = EpisodeAPIService(authenticatedHTTPClient: authenticatedClient)
            self.episodesService.fetchEpisodes(forShow: showIdentifier, page: page).then {
                XCTAssert($0.episodes.count > 0)
                callbackExpectation.fulfill()
                }.catch {
                    XCTFail("\($0)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchingMissingPage() throws {
        let showIdentifier = 73739
        let page = 20
        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login).then {
            let authenticatedClient = AuthenticatedHTTPClient(baseAddress: self.baseAddress, token: $0)
            self.episodesService = EpisodeAPIService(authenticatedHTTPClient: authenticatedClient)
            self.episodesService.fetchEpisodes(forShow: showIdentifier, page: page).catch { error in
                guard let error = error as? HTTP.Error else { XCTFail("Incorrect error type"); return }
                switch error {
                case let .serverError(code, details):
                    XCTAssertEqual(code, 404)
                    print(String(describing: details))
                default:
                    XCTFail("Incorrect error type")
                }
                callbackExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
