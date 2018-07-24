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


///This class is definition of the movie model, and build single movie and list of movies.
class Movie : NSObject{
    static var items = [[String: Any]]()
    var id = 0
    var name = ""
    var date = ""
    var poster = ""
    var info = ""

    /**
     This function is for parsing json data and create a movie instance with that.
     - parameters:
        - jsonData: The json data to build a movie with.
     */
    class func buildSingle(jsonData: JSON) -> Movie {
        let movie = Movie()

        movie.id = jsonData["id"].intValue
        movie.name = jsonData["title"].stringValue
        movie.date = jsonData["release_date"].stringValue
        movie.poster = jsonData["poster_path"].stringValue
        movie.info = jsonData["overview"].stringValue

        return movie

    }

    /**
     This function is for parsing json array and create a list of movie instances with that.
     - parameters:
        - jsonData: The json array to build the movie list with.
     */
    class func buildList(jsonData: JSON) -> [Movie] {
        var movies = [Movie]()
        for index in 0..<jsonData.count {
            movies.append(Movie.buildSingle(jsonData: jsonData[index]))
        }
        return movies
    }

    /**
     This function is for initializing the items variable
     which is use to create list from xml data.
     - parameters:
        - items: A [[String: Any]] dictionary array.
     */
    class func initItems(items : [[String: Any]]){
        self.items = items
    }

    /**
     This function is for parsing xml data and create a movie
     instance with that.
     - parameters:
        - xmlData: A [String: Any] dictionary made of xml data
        to build a movie instance with.
     */
    class func buildSingle(xmlData: [String: Any]) -> Movie {
        let movie = Movie()

        movie.id = xmlData["id"] as! Int
        movie.name = xmlData["title"] as! String
        movie.date = xmlData["release_date"] as! String
        movie.poster = xmlData["poster_path"] as! String
        movie.info = xmlData["overview"] as! String

        return movie

    }

    ///This function is for creating an array of Movie type.
    class func buildList() -> [Movie] {
        var movies = [Movie]()
        for movie in self.items {
            movies.append(Movie.buildSingle(xmlData: movie))
        }
        return movies
    }

}

