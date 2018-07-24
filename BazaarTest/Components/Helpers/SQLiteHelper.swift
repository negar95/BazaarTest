//
//  SQLiteHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SQLite

/**
 This class is for working with SQLite database.
 */
class SQLiteHelper : NSObject{

    ///This function is for creating a table to save entities.
    func createTables() {
        let search = Table(Search.TABLE_NAME)
        do {
            try DBHelper.sharedDatabase.database.run(search.create {t in
                t.column(Search.TITLE, primaryKey: true)
            })
        } catch  {
            print("Database Save Failed")
        }

    }
}
