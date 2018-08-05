//
//  ShapeRounded.swift
//  OnlineShopping
//
//  Created by SKY on 07/03/17.
//  Copyright © 2017 sky. All rights reserved.
//

import UIKit

@IBDesignable
class ShapeRounded: UIView {

    @IBInspectable var shapeCornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = shapeCornerRadius
        }
    }

    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 1.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }

}
