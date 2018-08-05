//
//  UIImageView+Extensions.swift
//  RHDb
//
//  Created by Ricardo Hochman on 02/08/2018.
//  Copyright © 2018 Ricardo Hochman. All rights reserved.
//

import AlamofireImage
import UIKit

extension UIImageView {
    
    func setImageWithPlaceholder(with URL: URL) {
        self.af_setImage(withURL: URL, placeholderImage: #imageLiteral(resourceName: "moviePlaceholder"), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false)
    }
    
    func setImage(with URL: URL) {
        self.af_setImage(withURL: URL, imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: false)
    }

}
