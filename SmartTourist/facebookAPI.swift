//
//  facebookAPI.swift
//  SmartTourist
//
//  Created by weerapons suwanchatree on 10/5/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import Foundation
import Alamofire

class facebookAPI {
    let apiURL = "https://graph.facebook.com"
    let access_token = "EAAX0NmD7gWABAFFx51sZCReS3iOvFtZA9xFHyZBSXZCI2mHYRJrjFofwOAeOE7Y61uxiuXnnkZAdVS9PPjsikZCusaFYUsnQclTIY6zgzXFIhRdtgfNgDZBxOZCVTauUDKmMNT9tQIu2kzUFG5vyPC7AKiD8CIlbd0QZD"
    
    
    func gatPlace(type:String,completionHandler:@escaping ([String:AnyObject])->()) {

        
        let parameters: Parameters = ["q":type,
                                      "type": "place",
                                      "center":"13.752468,100.566107",
                                      "access_token":access_token,
                                      "fields": "name,fan_count,talking_about_count,checkins,category,category_list,picture.height(500)",
                                      "distance":"10000",
                                      "limit":"100"
                                      ]
        
        // All three of these calls are equivalent
        Alamofire.request("\(apiURL)/search", parameters: parameters).responseJSON{
            response in
            //debugPrint(response)
            if let JSON = response.result.value {
                completionHandler(JSON as! [String : AnyObject])
                
            }


        }

    }
}
