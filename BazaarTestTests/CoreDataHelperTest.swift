//
//  CoreDataHelperTest.swift
//  BazaarTestTests
//
//  Created by negar on 97/Mordad/01 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import XCTest
@testable import BazaarTest

class CoreDataHelperTest: XCTestCase {

    let coreDataHelper = CoreDataHelper()
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

    func testFetchFromCoreData() {
        
    }

    func testSaveToCoreData(){
        XCTAssertTrue(coreDataHelper.saveToCoreData(search: search))
    }

    func testDeleteSingleFromCoreData() {
        var test = false
        if coreDataHelper.saveToCoreData(search: search){
            coreDataHelper.deleteSingleFromCoreData(search: search)
            if let searches = coreDataHelper.fetchFromCoreData(){
                for s in searches{
                    if search == s {
                        test = true
                    }
                }
            }
        }
        XCTAssertFalse(test)
    }

    func testDeleteAllFromCoreData(){
        coreDataHelper.deleteAllFromCoreData()
        XCTAssertNil(coreDataHelper.fetchFromCoreData())
    }

    func testPushToCoreDataStack(){
        XCTAssertTrue(coreDataHelper.pushToCoreDataStack(search: search))
    }

}
