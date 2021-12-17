//
//  UIView+Extension.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
