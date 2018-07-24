//
//  Connection.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/28 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyXMLParser
import Alamofire

/**
 This class is for handling all requests in our app, and the answers
 are pass according to the type of request function we call.
 */
class ApiHelper {

    ///singleton implementation
    static let sharedApi: ApiHelper = {
        let instance = ApiHelper()

        return instance
    }()

    /**
     - parameters:
         - urlString: The request url
         - lstParams: The paramets that should be sent with request
         - onCompletion: Completion handler consists of result JSON and status
     */
    func jsonGetRequest(urlString: String, lstParams:
            [String: AnyObject], onCompletion: @escaping (JSON, Bool) -> Void) {
        Alamofire.request(urlString, method: .get, parameters: lstParams).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                //if the request is successful, the validity of the result should be tested.
                self.checkValidity(json: JSON(value), onCompletion: onCompletion)
            case .failure(let error):
                //it checks the internet connection
                if !NetworkReachabilityManager()!.isReachable{
                    onCompletion(["error": "check your connection"], false)
                }else {
                    onCompletion(["error": JSON(error)], false)
                }
            }
        }
    }

    /**
     This function checks the result of json request. If total_results key
     is available and has a value our result is valid
     - parameters:
        - json: Result of the request
        - onCompletion: Completion handler consists of result JSON and status
     */
    func checkValidity(json: JSON, onCompletion: (JSON, Bool) -> Void) {

        if let totalResults = json["total_results"].int {
            if totalResults > 0 {
                onCompletion(json, true)
            } else if totalResults == 0 {
                //if search on the query has no result
                onCompletion(["error": "Nothing found"], false)
            } else {
                onCompletion(["error": "Bad request"], false)
            }
        } else if let success = json["success"].bool {
            if !success{
                onCompletion(["error": json["status_message"].string ?? "error"], false)
            }
        } else {
            onCompletion(["error": ["Error"]], false)
        }
    }

    /**
     - parameters:
         - urlString: The request url
         - lstParams: The paramets that should be sent with request
         - onCompletion: Completion handler consists of result dictionary and status
     */
    func XMLGetRequest(urlString: String, lstParams:
            [String: AnyObject], onCompletion: @escaping ([String: Any], Bool) -> Void) {
        Alamofire.request(urlString, method: .get, parameters: lstParams).responseData { response in
            switch response.result {
            case .success(let value):
                let xml = XML.parse(value)
                //if the request is successful, the validity of the result should be tested.
                //A valid answer has total_results key and its value
                if let totalResults = xml["total_results"].int {

                    if totalResults > 0 {
                        var files = [[String: Any]]()
                        for item in xml["results"] {
                            var res = [String: Any]()
                            res["id"] = item.element?.attributes["id"]!
                            res["title"] = item.element?.attributes["title"]!
                            res["release_date"] = item.element?.attributes["release_date"]!
                            res["overview"] = item.element?.attributes["overview"]!
                            res["poster_path"] = item.element?.attributes["poster_path"]!
                            files.append(res)
                        }
                        Movie.initItems(items: files)
                        onCompletion(["success": "true"], true)
                    } else {
                        onCompletion(["error": "bad request"], false)
                    }
                } else {
                    onCompletion(["error": xml["status_message"].description], false)
                }
            case .failure(let error):
                onCompletion(["error": error as! String], false)
            }

        }
    }
}
