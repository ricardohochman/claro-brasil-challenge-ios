//
//  MovieAPI.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Alamofire
import UIKit

class MovieAPI {
    
    let requestManager: RequestManager
    
    init(requestManager: RequestManager = RequestManager()) {
        self.requestManager = requestManager
    }
    
    func getMovie(title: String, completion: @escaping (Result<Page<Movie>>) -> Void) {
        requestManager.request(url: MovieEndpoint.searchMovie.url, method: HTTPMethod.get, parameters: ["query": title], headers: [:], completion: completion)
    }
    
    func getTrailer(id: Int, completion: @escaping (Result<Page<Trailer>>) -> Void) {
        requestManager.request(url: MovieEndpoint.trailer(id: id).url, method: HTTPMethod.get, parameters: [:], headers: [:], completion: completion)
    }
    
    func getImage(url: URL, completion: @escaping (UIImage) -> Void) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }

}
