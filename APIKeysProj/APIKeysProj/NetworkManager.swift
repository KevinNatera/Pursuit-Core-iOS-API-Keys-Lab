//
//  NetworkManager.swift
//  APIKeysProj
//
//  Created by Kevin Natera on 9/9/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation
import UIKit

enum ErrorHandling: Error {
    case badURL
    case decodingError
    case noData
}

class NetworkManager {
    private init () {}
    
    static let shared = NetworkManager()
    
    
    func getData(urlString: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(ErrorHandling.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(ErrorHandling.noData))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(ErrorHandling.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(ErrorHandling.badURL))
                return
            }
            
            switch response.statusCode {
            case 404:
                completionHandler(.failure(ErrorHandling.noData))
            case 401,403:
                completionHandler(.failure(ErrorHandling.badURL))
            case 200...299:
                completionHandler(.success(data))
            default:
                completionHandler(.failure(ErrorHandling.decodingError))
            }
            }.resume()
    }
}
