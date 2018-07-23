//
//  MovieTest.swift
//  BazaarTestTests
//
//  Created by negar on 97/Mordad/01 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import BazaarTest

class MovieTest: XCTestCase {

    let movie = Movie()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBuildSingleFromJSON(){
        let jsonData : JSON = [
            "id": 1,
            "title": "test",
            "release_date": "test",
            "poster_path": "test",
            "overview": "test"
        ]
        let movie = Movie.buildSingle(jsonData: jsonData)
        XCTAssertNotNil(movie)
        XCTAssertEqual(jsonData["id"].int, movie.id)
        XCTAssertEqual(jsonData["title"].string, movie.name)
        XCTAssertEqual(jsonData["release_date"].string, movie.date)
        XCTAssertEqual(jsonData["poster_path"].string, movie.poster)
        XCTAssertEqual(jsonData["overview"].string, movie.info)
    }

    func testBuildListFromJSON(){
        let jsonData : JSON = [
            [
                "id": 1,
                "title": "test",
                "release_date": "test",
                "poster_path": "test",
                "overview": "test"
            ],
            [
                "id": 1,
                "title": "test",
                "release_date": "test",
                "poster_path": "test",
                "overview": "test"
            ]
        ]

        let movies = Movie.buildList(jsonData: jsonData)
        XCTAssertGreaterThan(movies.count, 0)
    }

    func testBuildSingleFromXML(){
        let xmlData : [String: Any] = [
            "id": 1,
            "title": "test",
            "release_date": "test",
            "poster_path": "test",
            "overview": "test"
        ]
        let movie = Movie.buildSingle(xmlData: xmlData)
        XCTAssertNotNil(movie)
        XCTAssertEqual(xmlData["id"] as! Int, movie.id)
        XCTAssertEqual(xmlData["title"] as! String, movie.name)
        XCTAssertEqual(xmlData["release_date"] as! String, movie.date)
        XCTAssertEqual(xmlData["poster_path"] as! String, movie.poster)
        XCTAssertEqual(xmlData["overview"] as! String, movie.info)
    }

    func testBuildListFromXML(){
        let xmlData : [[String:Any]] = [
            [
                "id": 1,
                "title": "test",
                "release_date": "test",
                "poster_path": "test",
                "overview": "test"
            ],
            [
                "id": 1,
                "title": "test",
                "release_date": "test",
                "poster_path": "test",
                "overview": "test"
            ]
        ]

        Movie.initItems(items: xmlData)
        let movies = Movie.buildList()
        XCTAssertGreaterThan(movies.count, 0)
    }
}
