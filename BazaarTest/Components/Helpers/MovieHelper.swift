//
//  MovieHelper.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/29 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol MovieDelegate: NSObjectProtocol{
    @objc optional func getMovieSuccessfuly(lstMovies: [Movie], page : Int)
    @objc optional func failedToGetMovie(error : String)
}
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
                lstMovies = (Movie.buildList(jsonData: JSON(response["results"] )))

                if self.delegate.responds(to: #selector(MovieDelegate.getMovieSuccessfuly(lstMovies: page:))) {
                    self.delegate.getMovieSuccessfuly!(lstMovies: lstMovies, page: page)
                }
            } else {
                if self.delegate.responds(to: #selector(MovieDelegate.failedToGetMovie(error:))) {
                    self.delegate.failedToGetMovie!(error: String(describing: response["error"]) )
                }
            }
        }
    }
}
