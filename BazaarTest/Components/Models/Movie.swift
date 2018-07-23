//
//  Movie.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/28 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyXMLParser

class Movie : NSObject{
    static var items = [[String: Any]]()
    var id = 0
    var name = ""
    var date = ""
    var poster = ""
    var info = ""

    class func buildSingle(jsonData: JSON) -> Movie {
        let movie = Movie()

        movie.id = jsonData["id"].intValue
        movie.name = jsonData["title"].stringValue
        movie.date = jsonData["release_date"].stringValue
        movie.poster = jsonData["poster_path"].stringValue
        movie.info = jsonData["overview"].stringValue

        return movie

    }

    class func buildList(jsonData: JSON) -> [Movie] {
        var movies = [Movie]()
        for index in 0..<jsonData.count {
            movies.append(Movie.buildSingle(jsonData: jsonData[index]))
        }
        return movies
    }

    class func initItems(items : [[String: Any]]){
        self.items = items
    }
    
    class func buildSingle(xmlData: [String: Any]) -> Movie {
        let movie = Movie()

        movie.id = xmlData["id"] as! Int
        movie.name = xmlData["title"] as! String
        movie.date = xmlData["release_date"] as! String
        movie.poster = xmlData["poster_path"] as! String
        movie.info = xmlData["overview"] as! String

        return movie

    }

    class func buildList() -> [Movie] {
        var movies = [Movie]()
        for movie in self.items {
            movies.append(Movie.buildSingle(xmlData: movie))
        }
        return movies
    }

}

