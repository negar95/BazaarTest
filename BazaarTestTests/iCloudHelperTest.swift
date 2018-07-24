//
//  iCloudHelperTest.swift
//  BazaarTestTests
//
//  Created by negar on 97/Mordad/02 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import XCTest
@testable import BazaarTest

class iCloudHelperTest: XCTestCase {

    let icloud = iCloudHelper()
    let search = Search()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        search.title = "Test Movie"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSaveToiCloud(){
        icloud.saveToiCloud(search: self.search)
        XCTAssertNotNil(icloud.fetchFromiCloud())
    }
    func testFetchFromiCloud() {
        let test = icloud.fetchFromiCloud()
        XCTAssertEqual(self.search.title, test.title)
    }
    
}
