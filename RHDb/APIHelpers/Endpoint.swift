//
//  Endpoint.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import UIKit

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var url: URL { get }
}

extension Endpoint {
    
    var base: String {
        return "https://api.themoviedb.org/3"
    }
    
    var url: URL {
        if var urlBase = URL(string: self.base) {
            urlBase.appendPathComponent(self.path)
            return urlBase
        }
        
        fatalError()
    }
}

enum MovieEndpoint {
    case searchMovie
    case trailer(id: Int)
}

extension MovieEndpoint: Endpoint {
    var path: String {
        switch self {
        case .searchMovie:
            return "/search/movie"
        case .trailer(let id):
            return "movie/\(id)/videos"
        }
    }
}
