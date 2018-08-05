//
//  Locale+Extensions.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import Foundation

extension Locale {
    static var languageAndRegion: String {
        guard let language = self.preferredLanguages.first else {
            return "en-US"
        }
        
        return language
    }
}
