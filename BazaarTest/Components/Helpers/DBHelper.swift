//
//  DBHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SQLite


class DatabaseHelper: NSObject {
    var database: Connection!


    static let sharedDatabase: DatabaseHelper = {

        let instance = DatabaseHelper()
        let docsurl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = docsurl.appendingPathComponent(Values.DATABASE_NAME + ".sqlite")
        instance.database = try! Connection(url.path)
        return instance
    }()


}
