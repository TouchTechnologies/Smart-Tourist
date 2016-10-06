//
//  CustomInfoWindow.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/6/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import Nuke

class CustomInfoWindow: UIView {

    @IBOutlet weak var viewArrowBack: UIView!
    @IBOutlet weak var viewArrowFront: UIView!
    @IBOutlet weak var viewMainBG: UIView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var scrollerTitle: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblDistant: UILabel!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        let grayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        self.viewArrowBack.rotate(angle: 45)
        self.viewArrowFront.rotate(angle: 45)
        self.viewMainBG.layer.borderWidth = 1
        self.viewMainBG.layer.borderColor = grayColor.cgColor
        
        self.viewArrowBack.layer.borderWidth = 1
        self.viewArrowBack.layer.borderColor = grayColor.cgColor
        
        
        
    }
    
    func setData(data:[String:AnyObject]) {
        let itemName = data["itemName"] as! String?
        let itemType = data["itemType"] as! String?
        let itemLogo:UIImage = data["itemLogo"] as! UIImage
        
        self.lblTitle.text = itemName
        self.lblTitle.sizeToFit()
        //self.scrollerTitle.contentSize = CGSize(width: self.lblTitle.frame.width + 6, height: self.scrollerTitle.frame.height)
        self.scrollerTitle.contentSize = CGSize(width: 506, height: self.scrollerTitle.frame.height)
        
        self.imgLogo.image = itemLogo
        self.imgLogo.contentMode = .scaleAspectFill
        self.imgLogo.clipsToBounds = true
        
        //Nuke.loadImage(with: URL(string: urlLogoImage)!, into: self.imgLogo)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
