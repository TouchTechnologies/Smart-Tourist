//
//  tbViewCell_Lists.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/5/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import SwiftyJSON
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        let bgViewActive = UIView(frame: self.frame)
        bgViewActive.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)

        
        
        self.backgroundView = bgView
        self.selectedBackgroundView = bgViewActive
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: JSON) {
        
        let objData = data
        
        print("objData")
        print(objData)
        print("-------")
        
        self.lblTitle.text = data["name"].stringValue
        self.lblSubtitle.text = data["category"].stringValue
        
        let urlLogoImage = data["picture"]["data"]["url"].stringValue
        
//        print("___urlLogoImage___")
//        print(data["picture"]["data"]["url"])
//        print("-------")
//        
//        var urlRequest = URLRequest(url: URL(string: urlLogoImage)!)
//        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
//        urlRequest.timeoutInterval = 30
//        
//        var request = Request(urlRequest: urlRequest)
//        
//        // You can add arbitrary number of transformations to the request
//        //request.process(with: GaussianBlur())
//        
//        // Disable memory caching
//        request.memoryCacheOptions.writeAllowed = false
//        
//        // Load an image
//        Nuke.loadImage(with: request, into: self.imgLogo)
////
//////        loader.startAnimating()
//////        Nuke.loadImage(with: request, into: self.imgLogo) { [weak v] in
//////            v?.handle(response: $0, isFromMemoryCache: $1)
//////            self.loader.stopAnimating()
//////        }
        
        Nuke.loadImage(with: URL(string: urlLogoImage)!, into: self.imgLogo)
        
    }
    
}
