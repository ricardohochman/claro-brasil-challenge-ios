//
//  JSONDecoder+Extensions.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromDict dict: [AnyHashable: Any]) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return try self.decode(type, from: data)
    }
}
