//
//  TVDBKitTests.swift
//  TVDBKitTests
//
//  Created by Robert Edwards on 10/12/18.
//  Copyright © 2018 Robert Edwards. All rights reserved.
//

import XCTest
@testable import TVDBKit

class TVDBKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let callbackExpectation = expectation(description: "Async")
        let baseAddress = URL(string: "https://api.thetvdb.com")!
        let httpClient = HTTPClient(baseAddress: baseAddress)
        let authAPI = AuthenticationAPIService(httpClient: httpClient)
        let login = Login()

        authAPI.aquireToken(withLogin: login).then {
            print($0)
            callbackExpectation.fulfill()
        }

        waitForExpectations(timeout: 200, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
