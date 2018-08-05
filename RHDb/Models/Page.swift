//
//  Page.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

struct Page<T: Decodable>: Decodable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [T]?
}
