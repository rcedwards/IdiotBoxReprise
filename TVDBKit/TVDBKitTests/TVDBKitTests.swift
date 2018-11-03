import XCTest
@testable import TVDBKit

class TVDBKitTests: XCTestCase {

    var authService: AuthenticationAPIService!
    let baseAddress = URL(string: "https://api.thetvdb.com")!
    let login = Login()

    override func setUp() {
        super.setUp()

        let httpClient = HTTPClient(baseAddress: baseAddress)
        authService = AuthenticationAPIService(httpClient: httpClient)
    }

    func testAuthentication() {
        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login)
            .then { _ in
                callbackExpectation.fulfill()
            }
            .catch {
                XCTFail(String(describing: $0))
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefresh() {
        let callbackExpectation = expectation(description: "Async")
        authService.aquireToken(withLogin: login).then {
            let authenticatedClient = AuthenticatedHTTPClient(baseAddress: self.baseAddress, token: $0)
            self.authService.authenticatedHTTPClient = authenticatedClient
            self.authService.refreshToken().then { _ in callbackExpectation.fulfill() }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
