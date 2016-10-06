//
//  Functions.swift
//  JOBBKK
//
//  Created by Thirawat Phannet on 11/26/2558 BE.
//  Copyright © 2558 Thirawat Phannet. All rights reserved.
//

import Foundation
import UIKit

class Functions: NSObject {
    
    func resizeImage(image: UIImage, maxSize: CGFloat) -> UIImage {
        
        var scale = CGFloat()
        if(image.size.height > image.size.width){
            scale = maxSize / image.size.height
        }else{
            scale = maxSize / image.size.width
        }
        
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:maxSize, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:maxSize, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
//    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
//        
//        let newRect = CGRect(x:0,y:0, width:newSize.width, height:newSize.height).integral
//        let imageRef = image.cgImage
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        
//        // Set the quality level to use when rescaling
//        context!.interpolationQuality = .high
//        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
//
//        context!.concatenate(flipVertical)
//        // Draw into the context; this scales the image
//        
//        CGContextDrawImage(context, newRect, imageRef)
//        
//        
//        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
//        let newImage = UIImage(CGImage: newImageRef)
//        
//        // Get the resized image from the context and a UIImage
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
    
    func getImageMarker(image: UIImage) -> UIImage {
        
        var newImage = self.resizeImage(image: image, newWidth: 44)
        
        let bgImage = UIImage(named: "pin-marker.png")!
        let topImage = Toucan(image: image).resizeByCropping(CGSize(width:42, height:42)).image
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:50, height:57), false, 0.0)
        bgImage.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width:50, height:57)))
        topImage.draw(in: CGRect(origin: CGPoint(x:4, y:4), size: CGSize(width:42, height:42)))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
