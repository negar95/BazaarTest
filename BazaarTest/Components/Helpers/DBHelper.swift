//
//  DBHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SQLite

/**
 This class is for connecting to database. The connection is alive which
 means we don't need to open it every time we want to work with database
 which cause big load on CPU.
 */
class DBHelper: NSObject {
    ///Connect to database
    var database: Connection!

    ///This is what make our connection alive, singleton impelementation.
    static let sharedDatabase: DBHelper = {

        let instance = DBHelper()
        let docsurl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = docsurl.appendingPathComponent(Values.DATABASE_NAME + ".sqlite")
        instance.database = try! Connection(url.path)
        return instance
    }()


}
