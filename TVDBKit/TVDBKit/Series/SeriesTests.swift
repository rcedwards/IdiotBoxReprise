import XCTest
@testable import TVDBKit

class SeriesTests: XCTestCase {

    var seriesService: SeriesAPIService!
    var authService: AuthenticationAPIService!
    let baseAddress = Configuration.apiBaseURL
    let login = Login()

    override func setUp() {
        super.setUp()

        let httpClient = HTTPClient(baseAddress: baseAddress)
        authService = AuthenticationAPIService(httpClient: httpClient)
    }

    func testSeriesSearch() throws {
        let searchQuery = "Lost"
        let expectedName = "Lost"
        let expectedIdentifier = 73739
        let expectedNetwork = "ABC (US)"

        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login).then {
            let authenticatedClient = AuthenticatedHTTPClient(baseAddress: self.baseAddress, token: $0)
            self.seriesService = SeriesAPIService(authenticatedHTTPClient: authenticatedClient)
            self.seriesService.searchSeries(query: searchQuery).then() {
                XCTAssert($0.count > 0)
                guard let theRealLost = $0.first else { XCTFail(); return }
                XCTAssertEqual(theRealLost.name, expectedName)
                XCTAssertEqual(theRealLost.network, expectedNetwork)
                XCTAssertEqual(theRealLost.identifier, expectedIdentifier)
                callbackExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
