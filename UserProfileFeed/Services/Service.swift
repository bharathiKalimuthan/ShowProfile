//
//  Service.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 31/03/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service()
    
    
    
   // func getResults(description: String, location: String, completed: @escaping (Result<[Profile], ErrorMessage>) -> Void) {
    func getResults(url: String, completed: @escaping (Result <Data, ErrorMessage>) -> Void) {
        //   let urlString = "https://jobs.github.com/positions.json?description=\(description.replacingOccurrences(of: " ", with: "+"))&location=\(location.replacingOccurrences(of: " ", with: "+"))"
        
      //  let  urlString = "https://api.github.com/users"
        
        let  urlString = url
           guard let url = URL(string: urlString) else {return}
           
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               
               if let _ = error {
                   completed(.failure(.invalidData))
                   return
               }
               
               guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                   completed(.failure(.invalidResponse))
                   return
               }
               
               guard let data = data else {
                   completed(.failure(.invalidData))
                   return
               }
               
               do {
                   let deconder = JSONDecoder()
                   deconder.keyDecodingStrategy = .convertFromSnakeCase
                 //  let results = try deconder.decode([Profile].self, from: data)
                  // completed(.success(results))
                  completed(.success(data))
                 
                
                
                   
               } catch {
                   completed(.failure(.invalidData))
               }
               
               
           }
           task.resume()
           
           
           
       }
}
