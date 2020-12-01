import XCTest
@testable import TVDBKit

class SeriesTests: XCTestCase {

    var seriesService: SeriesAPIService!
    var authService: AuthenticationAPIService!
    let baseAddress = Configuration.apiBaseURL
    let login = Login()
    
    enum Error: Swift.Error {
        case missingSampleFile
    }

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
    
    func testStubbedSeriesSearch() throws {
        guard let sampleDataURL = Bundle.testBundle.url(forResource: "SampleSearchResults", withExtension: "json")
              else { throw Error.missingSampleFile }
        let rawData = try Data(contentsOf: sampleDataURL)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let json = try decoder.decode([String: [Series]].self, from: rawData)
        guard let series = json["data"] else { throw SeriesError.parserError }
        XCTAssertEqual(series.count, 100)
    }
}
