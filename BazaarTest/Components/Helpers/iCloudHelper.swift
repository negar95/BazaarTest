//
//  iCloudHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation

/**
 This class is for working with iCloud.
 */
class iCloudHelper {
    var keyStore = NSUbiquitousKeyValueStore()

    /**
     This function is for saving to iCloud
     - parameters:
        - search: The search entity that should be saved.
     */
    func saveToiCloud(search: Search) {
        keyStore.set(search.title, forKey: "title")
        //sync icloud
        keyStore.synchronize()
    }
    ///This function is for fetching from icloud.
    func fetchFromiCloud() -> Search{
        let storedSearch = keyStore.string(forKey: "title")
        ///Create a search instance with saved title
        let instance = Search()
        instance.title = storedSearch!
        return instance
    }
}
