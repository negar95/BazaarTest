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

class Connection {

    static let connection: Connection = {
        let instance = Connection()

        return instance
    }()

    /**
     - parameters:
        - urlString: The request url
        - onCompletion: 
     */
    func jsonGetRequest(urlString: String, onCompletion: @escaping (JSON, Bool) -> Void) {
        Alamofire.request(urlString).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.checkValidity(json: JSON(value), onCompletion: onCompletion)
            case .failure(let error):
                onCompletion(["error": JSON(error)], false)
            }
        }
    }

    /**
     - parameters:
         - json:
         - onCompletion:
     */
    func checkValidity(json: JSON, onCompletion: (JSON, Bool) -> Void) {

        if let totalResults = json["total_results"].int {
            if totalResults > 0 {
                onCompletion(json["results"], true)
            } else {
                onCompletion(["error": "bad request"], false)
            }
        } else if !(json["success"].bool!) {
            onCompletion(["error": json["status_message"].string ?? "error"], false)
        }else{
            onCompletion(["error": ["error"]], false)
        }
    }

    func xmlGetRequest(urlString: String, onCompletion: @escaping ([String:Any], Bool) -> Void) {
        Alamofire.request(urlString).responseData { response in
            switch response.result {
            case .success(let value):
                let xml = XML.parse(value)
                if let totalResults = xml["total_results"].int{

                    if totalResults > 0 {
                        var files: [[String: String]] = [[String: String]]()
                        for item in xml["results"]{
                            var res: [String: String] = [String: String]()
                            res["id"] = item.element?.attributes["id"]!
                            res["title"] = item.element?.attributes["title"]!
                            res["release_date"] = item.element?.attributes["release_date"]!
                            res["overview"] = item.element?.attributes["overview"]!
                            res["poster_path"] = item.element?.attributes["poster_path"]!
                            files.append(res)
                        }
                         Movie.initItems(items: files)
                        onCompletion(["success":"true"], true)
                    } else {
                        onCompletion(["error":"bad request"],false)
                    }
                }else{
                    onCompletion(["error": xml["status_message"].description],false)
                }
            case .failure(let error):
                onCompletion(["error": error as! String], false)
            }

        }
    }
}
