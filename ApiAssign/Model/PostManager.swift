//
//  PostManager.swift
//  ApiAssign
//
//  Created by Rukhsar on 19/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation

enum PostError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct PostManager {
    let postUrl = "https://calendarific.com/api/v2/holidays?api_key=7a10e7022622c251e525395c031cd81ef9ecd4cf&country=US&year=2019"
    
    func perfomRequest(completion: @escaping(Result<[holidaysDetails], PostError >)-> Void) {
       
        if let url = URL(string: postUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, reponse, error) in
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(PostData.self, from: safeData)
                        let PostDeatils = decodedData.response.holidays
                        completion(.success(PostDeatils))
                    }catch{
                        completion(.failure(.canNotProcessData))
                    }
                }
            } // closure end
            task.resume()
        } // if end
    }// end request
}
