    import XCTest
    @testable import TMDBKit

    final class TMDBKitTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(TMDBKit().text, "Hello, World!")
        }
    }