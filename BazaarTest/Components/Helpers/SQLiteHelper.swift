//
//  SQLiteHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SQLite

class SQLiteHelper : NSObject{

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
