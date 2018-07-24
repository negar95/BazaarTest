//
//  MovieHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SwiftyJSON

///This protocol is to connect to the class that use this class
///Two functions are declared here, get movies successfully or not
@objc protocol MovieDelegate: NSObjectProtocol{
    @objc optional func getMovieSuccessfuly(lstMovies: [Movie], page : Int)
    @objc optional func failedToGetMovie(error : String)
}

/**
 This class is for request the query search, get the answer and parse it to create a movie model.
 */
class MovieHelper: NSObject{

    var delegate: MovieDelegate!

    func getMovies(page : Int, query : String){
        var lstParams = [String : AnyObject]()
        lstParams["api_key"] = "2696829a81b1b5827d515ff121700838" as AnyObject
        lstParams["query"] = query as AnyObject
        lstParams["page"] = page as AnyObject

        ApiHelper.sharedApi.jsonGetRequest(urlString: Values.SEARCH_URL, lstParams: lstParams){
            response, status in
            if status {
                var lstMovies = [Movie]()
                let page = JSON(response["total_pages"]).intValue
                //build movie list with json result.
                lstMovies = (Movie.buildList(jsonData: JSON(response["results"] )))

                //protocol function for success responds with the list of movies and the page
                if self.delegate.responds(to: #selector(MovieDelegate.getMovieSuccessfuly(lstMovies: page:))) {
                    self.delegate.getMovieSuccessfuly!(lstMovies: lstMovies, page: page)
                }
            } else {
                //protocol function for fail responds with error
                if self.delegate.responds(to: #selector(MovieDelegate.failedToGetMovie(error:))) {
                    self.delegate.failedToGetMovie!(error: String(describing: response["error"]) )
                }
            }
        }
    }
}
