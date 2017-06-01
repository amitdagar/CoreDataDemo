//
//  APIservice.swift
//  CoreDataTutorialPart1Final
//
//  Created by James Rochabrun on 3/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
   
    lazy var baseurl: String = {
        return "http://citeall.com/devapp21/orderapi/index.php"
    }()

    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = baseurl
        let jsonObject: [String: Any] = ["action":"assignmentlist",
                                         "info":["student_id":"2"]]
        guard let url = URL(string: urlString) else {
            return completion(.Error("Invalid URL, we can't update your feed"))
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            return completion(.Error("Invalid URL, we can't update your feed"))
        }
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
         guard error == nil else{
            return completion(.Error(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["list"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





