//
//  tbViewCell_Review.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/7/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import SwiftyJSON
import Nuke

class tbViewCell_Review: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var imgLineBottom: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let grayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        let bgViewActive = UIView(frame: self.frame)
        bgViewActive.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        
        self.backgroundView = bgView
        self.selectedBackgroundView = bgViewActive
        
        self.imgLogo.contentMode = .scaleAspectFill
        self.imgLogo.clipsToBounds = true
        self.imgLogo.backgroundColor = grayColor
        
        lblDate.isHidden = true
        
        //self.imgLineBottom.image = UIImage.imageWithColor(color: UIColor.gray)
        self.imgLineBottom.image = UIImage.imageWithColor(color: grayColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: JSON) {
        
        
        print("setData tb")
        print(data)
        print("-------")
        
        lblTitle.text = data["name"].stringValue
        lblDetail.text = data["message"].stringValue
//        lblDate.text = data["name"].stringValue
        
        let picture:String = data["picture"].stringValue
        Nuke.loadImage(with: URL(string: picture)!, into: self.imgLogo)
        self.loader.stopAnimating()
        
//        DispatchQueue.global(qos: .background).async {
//            let data = NSData(contentsOf: URL(string: urlLogoImage)! as URL)
//            DispatchQueue.main.async {
//                if let _img = data as NSData?{
//                    self.imgLogo.image = UIImage(data: _img as Data)!
//                }
//            }
//        }
        
        
        
    }
}
