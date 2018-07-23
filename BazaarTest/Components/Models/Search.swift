//
//  Search.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SQLite
import SwiftyJSON

class Search : NSObject, NSCoding {

    static let TABLE_NAME = "Search"
    static let TITLE = Expression<String>("title")

    var title = ""

    override init() {

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
    }

    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
    }

    class func buildDatabaseRow(row: Row) -> Search {
        let search = Search()
        search.title = row[TITLE]
        return search
    }

    class func buildDatabaseList(list: AnySequence<Row>) -> [Search] {
        var lstSearches = [Search]()
        for data in list {
            lstSearches.append(buildDatabaseRow(row: data))
        }
        return lstSearches
    }
}
