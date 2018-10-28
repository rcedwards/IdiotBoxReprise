import XCTest
@testable import TVDBKit

class TVDBKitTests: XCTestCase {
    func testAuthentication() {
        let callbackExpectation = expectation(description: "Async")
        let baseAddress = URL(string: "https://api.thetvdb.com")!
        let httpClient = HTTPClient(baseAddress: baseAddress)
        let authAPI = AuthenticationAPIService(httpClient: httpClient)
        let login = Login()

        authAPI.aquireToken(withLogin: login)
            .then { _ in
                callbackExpectation.fulfill()
            }
            .catch {
                XCTFail(String(describing: $0))
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
