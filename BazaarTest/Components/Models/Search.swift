//
//  Search.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SQLite

class Search : NSObject, NSCoding {

    static let TABLE_NAME = "Search"
    static let NAME = Expression<String>("name")

    var title = ""

    func encode(with aCoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String

    }

    required init?(coder aDecoder: NSCoder) {
        aDecoder.encode(self.title, forKey: "title")

    }





}
