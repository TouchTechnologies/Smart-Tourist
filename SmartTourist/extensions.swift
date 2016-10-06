//
//  extensions.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/4/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import Foundation

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
//extension UIImage {
//    func withColor(color: UIColor) -> UIImage? {
//        
//        let maskImage = self.cgImage
//        let width = self.size.width
//        let height = self.size.height
//        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo

//        bitmapContext!.clipToMask(bounds, mask: maskImage!)
//        bitmapContext!.setFillColor(color.cgColor)
//        bitmapContext!.fill(bounds)
//        
//        //is it nil?
//        if let cImage = bitmapContext!.makeImage() {
//            let coloredImage = UIImage(cgImage: cImage)
//            return coloredImage
//            
//        } else {
//            return nil
//        } 
//    }
//}

//extension UIImage {
//    func withColor(tintColor: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        
//        let context = UIGraphicsGetCurrentContext() as CGContextRef
//        CGContextTranslateCTM(context, 0, self.size.height)
//        CGContextScaleCTM(context, 1.0, -1.0);
//        CGContextSetBlendMode(context, kCGBlendModeNormal)
//        
//        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
//        CGContextClipToMask(context, rect, self.CGImage)
//        tintColor.setFill()
//        CGContextFillRect(context, rect)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
//}


//extension UIImage {
//    
//    class func withColor(color:UIColor)->UIImage {
//        
//        UIGraphicsBeginImageContext(self.size)
//        let context = UIGraphicsGetCurrentContext()
//        
//        // flip the image
//        context!.scaleBy(x: 1.0, y: -1.0)
//        context!.translateBy(x: 0.0, y: -self.size.height)
//        
//        // multiply blend mode
//        context!.setBlendMode(.multiply)
//        
//        let rect = CGRect(x:0, y:0, width: self.size.width, height: self.size.height)
//        context!.clip(to: rect, mask: self.cgImage!)
//        color.setFill()
//        context!.fill(rect)
//        
//        // create uiimage
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage!
//        
//    }
//    
//}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x:0, y:0, width:1, height:1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:1, height:1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}











