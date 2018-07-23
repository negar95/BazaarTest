//
//  ApiHelperTest.swift
//  BazaarTestTests
//
//  Created by negar on 97/Mordad/01 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import BazaarTest

class ApiHelperTest: XCTestCase{

    let apiHelper = ApiHelper()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testJsonGetRequest(){
        let ex = expectation(description: "Expecting a JSON data not nil")
        var lstParams = [String : AnyObject]()
        lstParams["api_key"] = "2696829a81b1b5827d515ff121700838" as AnyObject
        lstParams["query"] = "Batman" as AnyObject
        lstParams["page"] = "1" as AnyObject

        ApiHelper.sharedApi.jsonGetRequest(urlString: Values.SEARCH_URL, lstParams: lstParams) {
            result, status in

            XCTAssertNotNil(result)
            XCTAssertNotNil(status)
            ex.fulfill()

        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }

    func testXMLGetRequest(){
        let ex = expectation(description: "Expecting a JSON data not nil")
        var lstParams = [String : AnyObject]()
        lstParams["api_key"] = "2696829a81b1b5827d515ff121700838" as AnyObject
        lstParams["query"] = "Batman" as AnyObject
        lstParams["page"] = "1" as AnyObject

        ApiHelper.sharedApi.XMLGetRequest(urlString: Values.SEARCH_URL, lstParams: lstParams) {
            result, status in

            XCTAssertNotNil(result)
            XCTAssertNotNil(status)
            ex.fulfill()

        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }

    func testCheckValidity(){
        let
    }
    
}
