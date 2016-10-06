//
//  facebookAPI.swift
//  SmartTourist
//
//  Created by weerapons suwanchatree on 10/5/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import Foundation
import Alamofire
//import MapKit
import CoreLocation
class facebookAPI {
    let apiURL = "https://graph.facebook.com"
    let fbObj = facebookObj()
    let limit = 20
    let access_token = "EAAX0NmD7gWABAFFx51sZCReS3iOvFtZA9xFHyZBSXZCI2mHYRJrjFofwOAeOE7Y61uxiuXnnkZAdVS9PPjsikZCusaFYUsnQclTIY6zgzXFIhRdtgfNgDZBxOZCVTauUDKmMNT9tQIu2kzUFG5vyPC7AKiD8CIlbd0QZD"
    
    
    func gatPlace(curLat:String,curLong:String,type:String,page:Int,completionHandler:@escaping ([String:AnyObject])->()) {

        let offset = page*limit
        
        let parameters: Parameters = ["q":type,
                                      "type": "place",
                                      "center":"\(curLat),\(curLong)",
                                      "access_token":access_token,
                                      "fields": "name,fan_count,talking_about_count,checkins,location,category,category_list,picture.height(500)",
                                      "distance":"10000",
                                      "limit":limit,
                                      "offset":offset
                                      ]
        
        // All three of these calls are equivalent
        Alamofire.request("\(apiURL)/search", parameters: parameters).responseJSON{
            response in
            //debugPrint(response)
            if response.result.isSuccess{
                if let JSON = response.result.value{
                    let data = JSON as! NSDictionary
                    for item in data["data"] as! NSArray{
                        for (key,value) in (item as! NSDictionary)
                        {
                            print("Key : \(key) Value : \(value)")
//                            if let ID = item["id"] as! String{
//                                
//                            }
//                            fbObj.ID = item["id"] as! String
                            
                            
                        }
//                        for aKey in (item as! NSDictionary).allKeys{
//                            
//                            print("KEYYYY: \(aKey)")
//                            
//                        }
                        
                    }

                    completionHandler(JSON as! [String : AnyObject])
                }
            }else
            {
                let error = response.result.error
                completionHandler(error as! [String : AnyObject])
            }
        }

    }
    func getTagedData(ID:String,completionHandler:@escaping ([String:AnyObject])->()){
        let parameters: Parameters = ["access_token":access_token,
                                      "fields"      : "message,created_time,id,name,picture"
                                     ]
        
        // All three of these calls are equivalent
        Alamofire.request("\(apiURL)/\(ID)/tagged", parameters: parameters).responseJSON{
            response in
            //debugPrint(response)
            if response.result.isSuccess{
                if let JSON = response.result.value {
                    completionHandler(JSON as! [String : AnyObject])
                    
                }
            }else
            {
                let error = response.result.error
                completionHandler(error as! [String : AnyObject])
            }
            
            
        }
    }
    func getDataByID(ID:String,completionHandler:@escaping ([String:AnyObject])->()) {
        let parameters: Parameters = ["access_token":access_token,
                                      "fields"      : "name,id,picture.height(500),about,category_list"
                                     ]
        // All three of these calls are equivalent
        Alamofire.request("\(apiURL)/\(ID)", parameters: parameters).responseJSON{
            response in
            //debugPrint(response)
            if response.result.isSuccess{
                if let JSON = response.result.value {
                    completionHandler(JSON as! [String : AnyObject])
                    
                }
            }else
            {
                let error = response.result.error
                completionHandler(error as! [String : AnyObject])
            }
            
        }
    }
//    func getDistance(curLat:Double,curLong:Double,destLat:Double,destLong:Double) -> Double {
    func getDistance(curLocation:CLLocation,destLocation:CLLocation) -> Double {
//        let curLat = 13.752468
//        let curLong = 100.566107
//        let destLat = 13.7037469
//        let destLong = 100.4495952
//        let curLocation:CLLocation = CLLocation(latitude: curLat, longitude: curLong)
//        let destLocation:CLLocation = CLLocation(latitude: destLat, longitude: destLong)
        
        let distance = destLocation.distance(from: curLocation)/1000
        
        
        return Double(distance)
    }
}
