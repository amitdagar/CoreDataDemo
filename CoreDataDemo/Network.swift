//
//  Network.swift
//  CoreDataDemo
//
//  Created by Abhishek Gupta on 27/04/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit

class Network: NSObject {

    class var sharedInstance:Network{
        
        struct Singlton{
            
            static let instance = Network()
        }
        return Singlton.instance
    }
    

    public func fetchAllAssignment(completion: @escaping (JSON) -> Void) {
        let url = URL(string: "http://citeall.com/devapp21/orderapi/index.php")!
        let jsonObject: [String: Any] = ["action":"assignmentlist",
                                            "info":["student_id":"2"]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task =   URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) -> Void in
            guard error == nil else {
                print("Error while fetching remote rooms: \(String(describing: error))")
                //completion(nil)
                return
            }
            
           
              let json:JSON = JSON(data: data!)
           
            completion(json)
        }
        
        task.resume()
    }
}
