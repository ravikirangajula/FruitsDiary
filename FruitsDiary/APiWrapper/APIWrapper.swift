//
//  APIWrapper.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import Foundation
import UIKit

enum httpMethodType:String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

class APIWrapper {
    typealias JSONParseCompletionHandler = (Decodable?, Error?) -> Void

    static func getRequest<T: Decodable>(with url: String, decodingType: T.Type, completionHandler completion: @escaping JSONParseCompletionHandler) -> ()  {
        guard let url = URL(string: url) else { return }
        let urlSessionObject = URLSession.shared
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        let task = urlSessionObject.dataTask(with: request) { data, res, error in
            guard let resObj = data else {return}
            do {
                let genericModel = try JSONDecoder().decode(decodingType, from: resObj)
                completion(genericModel,nil)
            } catch {
                print("Error == \(error)")
                completion(nil,error)
            }
        }
        task.resume()
    }
    
    static func postRequest<T: Decodable>(with url: String, parms:[String:Any] = [:], decodingType: T.Type, completionHandler completion: @escaping JSONParseCompletionHandler) -> ()  {
        guard let url = URL(string: String(url)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodType.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !parms.isEmpty {
            let bodyData = try? JSONSerialization.data(
                withJSONObject: parms,
                options: []
            )
            request.httpBody = bodyData
        }
        let session = URLSession.shared
        let _ = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil,error)
            } else if let data = data {
                do {
                    let genericModel = try JSONDecoder().decode(decodingType, from: data)
                    completion(genericModel, nil)
                } catch {
                    completion(nil,error)
                }
            } else {
                // Handle unexpected error
            }
        }.resume()
    }

    

    static func deleteRequest(url:URL, completion: @escaping(_ list:SuccessResponse?) -> ()) {
        let urlSessionObject = URLSession.shared
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = httpMethodType.DELETE.rawValue
        let task = urlSessionObject.dataTask(with: request) { data, res, error in
            guard let resObj = data else {return}
            do {
                let parserObj = try JSONDecoder().decode(SuccessResponse.self, from: resObj)
                print("Deleted SuccessFully : \(parserObj)")
                completion(parserObj)
            } catch {
                print("Error == \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

