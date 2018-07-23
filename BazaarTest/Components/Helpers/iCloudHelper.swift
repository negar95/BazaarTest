//
//  iCloudHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation

class iCloudHelper {
    var keyStore = NSUbiquitousKeyValueStore()

    func saveToiCloud(search: Search) {
        keyStore.set(search.title, forKey: "title")
        keyStore.synchronize()
    }
    
    func fetchFromiCloud() -> Search{
        let storedSearch = keyStore.string(forKey: "title")
        let instance = Search()
        instance.title = storedSearch!
        return instance
    }
}
