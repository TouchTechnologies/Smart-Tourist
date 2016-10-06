//
//  tbViewCell_Lists.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/5/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import Nuke


class tbViewCell_Lists: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var iconLike: UIImageView!
    @IBOutlet weak var iconCheckin: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblCheckin: UILabel!
    @IBOutlet weak var lblKM: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var imgLineBottom: UIImageView!
    
    var api = facebookAPI()
    
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
        
        //self.imgLineBottom.image = UIImage.imageWithColor(color: UIColor.gray)
        self.imgLineBottom.image = UIImage.imageWithColor(color: grayColor)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: JSON) {
        
//        let objData = data
        
//        print("objData")
//        print(objData)
//        print("-------")
      
        
        DispatchQueue.main.async {
           
            
            self.lblTitle.text = data["name"].stringValue
            self.lblSubtitle.text = data["category"].stringValue
            
            self.lblLike.text = Int(data["fan_count"].stringValue)?.asFomatter()
            self.lblCheckin.text = Int(data["checkins"].stringValue)?.asFomatter()
            
            
            let lat:CLLocationDegrees = data["location"]["latitude"].doubleValue
            let lng:CLLocationDegrees = data["location"]["longitude"].doubleValue
            
            //        print("lat,lng ---- > > >")
            //        print("lat:\(lat) / lng:\(lng)")
            let startGeo:CLLocation = CLLocation(latitude: 13.753059, longitude: 100.540683)
            let endGeo:CLLocation = CLLocation(latitude: lat, longitude: lng)
            let floatDistance = self.api.getDistance(curLocation: startGeo, destLocation: endGeo)
            
            let strDistance = String(format: "%.02f", floatDistance)
            self.lblKM.text =  String("\(strDistance) km.")
            
            
            
            self.imgType.isHidden = true
            
            //        "itemName": itemName as AnyObject,
            //        "itemSubtitle": itemSubtitle as AnyObject,
            //        "itemFanCount": itemFanCount as AnyObject,
            //        "itemCheckins": itemCheckins as AnyObject,
            //        "itemDistant": "\(strDistance) km." as AnyObject,
            //        "itemLogo": UIImage(),
            
            //
            
            let urlLogoImage = data["picture"]["data"]["url"].stringValue
            
            Nuke.loadImage(with: URL(string: urlLogoImage)!, into: self.imgLogo)
            self.loader.stopAnimating()
            
        }
        
        
    }
    
}
