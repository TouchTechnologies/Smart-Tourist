//
//  extensions.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/4/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat(M_PI)
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
    
}
