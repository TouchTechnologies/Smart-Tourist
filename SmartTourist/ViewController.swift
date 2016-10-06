//
//  ViewController.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/3/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SVPullToRefresh
import SVProgressHUD
import SwiftyJSON
import Nuke
import SystemConfiguration.CaptiveNetwork
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
    
    var fn = Functions()
    var api = facebookAPI()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var locationManager:CLLocationManager!
    var latitude:Double = 13.8906948
    var longitude:Double = 100.5690317
    
    // bgView Set
    @IBOutlet weak var bgView_Detail: UIView!
    @IBOutlet weak var bgView_Menu: UIView!
    
    // View Detail Set
    @IBOutlet weak var _viewForList: UIView!
    @IBOutlet weak var _viewForMap: UIView!

    // View Menu Set
    @IBOutlet weak var _viewMenu: UIView!
    @IBOutlet weak var _viewArrowMenu: UIView!
    @IBOutlet weak var _viewOverlayMenu: UIView!
    
    // Display Data
    var _tbDataList = UITableView()
    
    var _vH = CGFloat()
    var _vW = CGFloat()
    var _vH_min = CGFloat()
    
    var btnItemBarRight = UIBarButtonItem()
    
    // Data Source
    var strToken = String()
    var geoLat = Float32()
    var geoLng = Float32()
    var limit = Int()
    var page = Int()
    
    var searchType = ""
    
    var dataLists = JSON([:])
//    var dataLists:NSMutableArray = []
    
    
    
    
    
    
    // MARK: - -------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = getInterfaces()
        strToken = "EAAX0NmD7gWABAFFx51sZCReS3iOvFtZA9xFHyZBSXZCI2mHYRJrjFofwOAeOE7Y61uxiuXnnkZAdVS9PPjsikZCusaFYUsnQclTIY6zgzXFIhRdtgfNgDZBxOZCVTauUDKmMNT9tQIu2kzUFG5vyPC7AKiD8CIlbd0QZD"
        
        
        limit = 10
        page = 0
        
        // Do any additional setup after loading the view, typically from a nib.
        _vW = self.view.frame.width
        _vH = self.view.frame.height
        _vH_min = self.view.frame.height - 64
        
        designNav()
        designMenu()
        initTableview()
        initMapview()
                //view.bringSubview(toFront: _viewArrowMenu)
        determineMyCurrentLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnTopLeftClick(sender:AnyObject) {
        
        if menuIsShow == false { // Show Menu
            menuIsShow = true
            btnItemBarRight.isEnabled = false
            self.bgView_Menu.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                
                self._viewOverlayMenu.alpha = 0.5
                self.bgView_Menu.alpha = 1
                self.bgView_Menu.frame = CGRect(x: 0, y: 0, width: self._vW, height: self._vH_min - 8)
                
                }, completion: { c in
                    
                    
            })
            
        }else{ // Hide Menu
            
            menuIsShow = false
            btnItemBarRight.isEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                self._viewOverlayMenu.alpha = 0
                self.bgView_Menu.alpha = 0
                self.bgView_Menu.frame = CGRect(x: 0, y: -self._vH_min, width: self._vW, height: self._vH_min - 8)
                
                
                }, completion: { c in
                    
                    self.bgView_Menu.isHidden = true
                    
            })
            
        }
        
        
    }
    
    func btnTopRightClick(sender:AnyObject) {
        
        //UIApplication.shared.openURL(NSURL(string:"prefs:root=General")! as URL)
        //UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
        
        
        imgRight = UIImage.fontAwesomeIconWithName(currentShow == "lists" ? .ListAlt : .Map, textColor: UIColor.gray, size: CGSize(width:30, height:30))
        let imgRight_0 = UIImage.fontAwesomeIconWithName(currentShow == "lists" ? .ListAlt : .Map, textColor: UIColor.clear, size: CGSize(width:30, height:30))
        let btnItemRight = UIButton()
        btnItemRight.frame = CGRect(x:0, y:0, width:30, height:30)
        btnItemRight.setBackgroundImage(imgRight, for: .normal)
        btnItemRight.setBackgroundImage(imgRight_0, for: .disabled)
        btnItemRight.addTarget(self, action: #selector(self.btnTopRightClick(sender:)), for: UIControlEvents.touchUpInside)
        btnItemBarRight = UIBarButtonItem(customView: btnItemRight)
        
        navigationItem.rightBarButtonItem = btnItemBarRight
        
        
        if currentShow == "lists" { // Show Map
            
            self._viewForMap.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self._viewForMap.alpha = 1
                self._viewForList.alpha = 0
                
                }, completion: { c in
            
                    self._viewForList.isHidden = true
                    self.currentShow = "map"
            })
            
        } else if currentShow == "map" { // Show Lists
            
            self._viewForList.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self._viewForMap.alpha = 0
                self._viewForList.alpha = 1
                
                }, completion: { c in
                    
                    self._viewForMap.isHidden = true
                    self.currentShow = "lists"
            })
            
        }
        
    }
    
    // MARK: - MAP ZONE
    
    @IBOutlet weak var mapView: GMSMapView!
    var markerList = [GMSMarker]()
    //var mapView = GMSMapView()
    func initMapview() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        //let mapView = GMSMapView.map(withFrame: self._viewForMap.frame, camera: camera)
        
        mapView.camera = camera
        
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.animate(toLocation: CLLocationCoordinate2D.init(latitude: 13.7027041734701, longitude: 101.662359125912))
        mapView.animate(toZoom: 5.3)
        mapView.isMyLocationEnabled = true
   
        //self._viewForMap.addSubview(mapView)
        
        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 13.7027041734701, longitude: 101.662359125912)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
    
    func refreshMapView(){
        
        var bounds = GMSCoordinateBounds()
        
        for marker in self.markerList {
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
        
        //let downwards = GMSCameraUpdate.scrollByX(0, y: 20)
        //_mapView.animateWithCameraUpdate(downwards)
        
        if self.markerList.count < 2 {
            self.mapView.animate(toZoom: 12)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let _markerData = marker.userData as! NSDictionary
        let view = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as! CustomInfoWindow
        view.setData(data: _markerData as! [String : AnyObject])
        
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        print("xxx")
    }
    
    
    // MARK: - TABLEVIEW ZONE
    func initTableview() {
        
        _tbDataList.frame = _viewForList.frame
        _tbDataList.dataSource = self
        _tbDataList.delegate = self
        _tbDataList.autoresizesSubviews = true
        _tbDataList.register(UINib(nibName: "tbViewCell_Lists", bundle:nil), forCellReuseIdentifier: "cell")
        _tbDataList.rowHeight = 80
        _tbDataList.separatorStyle = .none
        //_tbDataList.backgroundColor = UIColor.green
        
        _viewForList.addSubview(_tbDataList)
        
        
        SVProgressHUD.setDefaultStyle(.dark)
        //SVProgressHUD.show()
        
        //self.title = "Loading..." // fn.randomString(len: 10) as String
        
        self.refreshData()
        
        weak var _weakSelf = self
        self._tbDataList.addPullToRefresh(actionHandler: {
            //print("add Top")
            
            self.page = 0
            _weakSelf!.refreshData()
            
        })
        
        
        self._tbDataList.addInfiniteScrolling(actionHandler: {
            
            if(self.dataLists.count > 0){
                
                self.page = self.page + 1
                _weakSelf!.loadMoreData()
                
            }else{
                print("Notfound Data")
                
                self._tbDataList.infiniteScrollingView.stopAnimating()
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tbViewCell_Lists
        
//        print("Cell4Row")
//        print(JSON(self.dataLists[indexPath.row]))
        
        cell.setData(data: self.dataLists[indexPath.row])
        
//        Nuke.loadImage(with: URL(string: urlLogoImage)!, into: cell.imgLogo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    // MARK: - DESIGN ZONE
    var imgLeft = UIImage()
    var imgRight = UIImage()
    var currentShow = "lists"
    func designNav() {
        
        
        imgLeft = UIImage.fontAwesomeIconWithName(.Filter, textColor: UIColor.gray, size: CGSize(width:30, height:30))
        imgRight = UIImage.fontAwesomeIconWithName(.Map, textColor: UIColor.gray, size: CGSize(width:30, height:30))
        let imgRight_0 = UIImage.fontAwesomeIconWithName(.Map, textColor: UIColor.clear, size: CGSize(width:30, height:30))
        
        let btnItemLeft = UIButton()
        btnItemLeft.frame = CGRect(x:0, y:0, width:30, height:30)
        //btnItemLeft.imageView?.image = imgLeft
        btnItemLeft.setBackgroundImage(imgLeft, for: .normal)
        btnItemLeft.addTarget(self, action: #selector(self.btnTopLeftClick(sender:)), for: UIControlEvents.touchUpInside)
        let btnItemBarLeft = UIBarButtonItem(customView: btnItemLeft)
        
        
        let btnItemRight = UIButton()
        btnItemRight.frame = CGRect(x:0, y:0, width:30, height:30)
        //btnItemRight.imageView?.image = imgRight
        btnItemRight.setBackgroundImage(imgRight, for: .normal)
        btnItemRight.setBackgroundImage(imgRight_0, for: .disabled)
        btnItemRight.addTarget(self, action: #selector(self.btnTopRightClick(sender:)), for: UIControlEvents.touchUpInside)
        btnItemBarRight = UIBarButtonItem(customView: btnItemRight)
        
        
        let vTitleLogo = UIView()
        vTitleLogo.frame = CGRect(x:0, y:0, width:150, height:32)
        //vTitleLogo.backgroundColor = UIColor.whiteColor()
        
//        let _imgLogo = UIImageView()
//        _imgLogo.image = UIImage(named: "iconTopLogo")
//        _imgLogo.frame = vTitleLogo.frame
//        _imgLogo.contentMode = UIViewContentMode.scaleAspectFit
//        vTitleLogo.addSubview(_imgLogo)
        
        
        navigationItem.leftBarButtonItem = btnItemBarLeft
        navigationItem.rightBarButtonItem = btnItemBarRight
        
        //navigationItem.titleView?.tintColor = UIColor.whiteColor()
        //navigationItem.titleView = vTitleLogo
    }
    
    var menuIsShow = false
    func designMenu() {
        
        self._viewForMap.alpha = 0
        self._viewForList.alpha = 1
        self._viewForList.isHidden = false
        self._viewForMap.isHidden = true
    
    
        _viewOverlayMenu.frame = CGRect(x: 0, y: 0, width: _vW, height: _vH)
        _viewOverlayMenu.alpha = 0
        _viewOverlayMenu.backgroundColor = UIColor.black
    
        // let frmBgMenu = _viewOverlayMenu.frame
        // bgView_Menu.frame = CGRect(x: 0, y: -frmBgMenu.height , width: frmBgMenu.width, height: frmBgMenu.height)
        
        bgView_Menu.frame = CGRect(x: 0, y: -_vH_min, width: self._vW, height: _vH_min)
        bgView_Menu.isHidden = true
        bgView_Menu.alpha = 0
        
        _viewMenu.frame = CGRect(x: 8, y: 10, width: _vW - 16, height: _vH_min - 8)
        _viewMenu.backgroundColor = UIColor.white
        
        _viewArrowMenu.frame = CGRect(x: 21, y: 5, width: 20, height: 20)
        _viewArrowMenu.rotate(angle: 45)
        _viewArrowMenu.backgroundColor = UIColor.white
        
        bgView_Detail.frame = CGRect(x: 0, y: 0, width: self._vW, height: _vH_min)
        mapView.frame = CGRect(x: 0, y: 0, width: self._vW, height: _vH)
        
    }
    
    
    // MARK: - LOAD DATA
    func refreshData() {
        
        if self.dataLists.count < 1 {
            SVProgressHUD.show()
        }
        
        DispatchQueue.main.async {
            self.markerList = [GMSMarker]()
            self.mapView.clear()
        }
        
        
        let hds:HTTPHeaders = [:]
        
        let strGeo:String = "\(self.latitude),\(self.longitude)"
        let strLimit:String = "\(String(limit))"
        let strOffset:String = "\(page * limit)"
        
        let params:Parameters =  [
            "type":"place",
            "center":strGeo,
            "distance":"100000",
            "access_token":strToken,
            "q":searchType,
            "fields":"name,fan_count,talking_about_count,checkins,category,category_list,picture.height(200),location",
            "limit":strLimit,
            "offset":strOffset,
            ]
        
        print(self.latitude)
        print(self.longitude)
        
        print("params refreshData()")
        //print("params[limit] = \(params["limit"] as! String)")
        print(params)
//        print("params[offset] = \(params["offset"] as! String)")
        print("------")
        
        //Alamofire.request("https://parseapi.back4app.com/classes/member", method: .get, parameters: params, encoding: URLEncoding.default, headers: hds)
        Alamofire.request("https://graph.facebook.com/search", method: .get, parameters: params, encoding: URLEncoding.default, headers: hds)
            //.validate()
            .responseJSON(completionHandler: {response in
                
                if response.result.isSuccess {
                    
                    //print("is isSuccess")
                    
                    if let res = response.result.value {
                        
                        let _json = JSON(res)
                        
                        let _lists = _json["data"]
                        
//print("_lists")
//print(_lists)
//print("------")
                        self.dataLists = []
                        
                        if _lists.count > 0 {
                            self.dataLists = _lists
                            
                            for jsonItem in self.dataLists.arrayValue {
                                //let jsonItem = JSON(item)
                                //let jsonItem = item
//                                print("jsonItem ---- > > >")
//                                print(jsonItem)
                                
                                guard let urlLogoImage:String = String(jsonItem["picture"]["data"]["url"].stringValue) else {
                                    return
                                }
                                guard let itemName:String = String(jsonItem["name"].stringValue) else {
                                    return
                                }
                                guard let itemSubtitle:String = String(jsonItem["category"].stringValue) else {
                                    return
                                }
                                guard let strFanCount:String = String(jsonItem["fan_count"].stringValue) else {
                                    return
                                }
                                guard let strCheckins:String = String(jsonItem["checkins"].stringValue) else {
                                    return
                                }
                                let itemFanCount = Int(strFanCount)?.asFomatter()
                                let itemCheckins = Int(strCheckins)?.asFomatter()
                                

                                //print(urlLogoImage)
                                
                                let lat:CLLocationDegrees = jsonItem["location"]["latitude"].doubleValue
                                let lng:CLLocationDegrees = jsonItem["location"]["longitude"].doubleValue
                                
//                                print("lat,lng ---- > > >")
//                                print("lat:\(lat) / lng:\(lng)")
                                let myGeo:CLLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
                                let endGeo:CLLocation = CLLocation(latitude: lat, longitude: lng)
                                let floatDistance = self.api.getDistance(curLocation: myGeo, destLocation: endGeo)
                                let strDistance = String(format: "%.02f", floatDistance)
                                
                                let position: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (lat), longitude: lng)
                                let marker = GMSMarker(position: position)
                                marker.title = jsonItem["name"].stringValue
                                //marker.snippet = listsIn.objectForKey("position")?.stringValue
                                marker.map = self.mapView
                                marker.icon = Toucan(image: UIImage(named: "pin-marker-waiting.png")!).resizeByScaling(CGSize(width:50, height:57)).image
                                
                                
                                var dictsForMap:[String: AnyObject] = [
                                    "itemName": itemName as AnyObject,
                                    "itemSubtitle": itemSubtitle as AnyObject,
                                    "itemFanCount": itemFanCount as AnyObject,
                                    "itemCheckins": itemCheckins as AnyObject,
                                    "itemDistant": "\(strDistance) km." as AnyObject,
                                    "itemLogo": UIImage(),
                                    ]

                                let url = NSURL(string: urlLogoImage)
                                
                                DispatchQueue.global(qos: .background).async {
                                    let data = NSData(contentsOf: url! as URL)
                                    DispatchQueue.main.async {
                                        if let _imgMarker = data as NSData?{
                                            dictsForMap["itemLogo"] = UIImage(data: _imgMarker as Data)!
                                            marker.userData = dictsForMap
                                            marker.icon = self.fn.getImageMarker(image: UIImage(data: _imgMarker as Data)!)
                                        }
                                    }
                                }
                                
                                self.markerList.append(marker)
                                
                                
                            }
                            
                            self.refreshMapView()
                            
                            if _lists.count < self.limit {
                                self._tbDataList.showsInfiniteScrolling = false
                            }

                        }else{
                            self.dataLists = JSON([:])
                        }
                        
                        print("dataLists.count")
                        print(self.dataLists.count)
                        print("==================================")

                        
                        self._tbDataList.reloadData()
                        
                    }
                    
                    self._tbDataList.setContentOffset(CGPoint.zero, animated:true)
                    
                    self._tbDataList.pullToRefreshView.stopAnimating()
                    self._tbDataList.infiniteScrollingView.stopAnimating()
                    SVProgressHUD.dismiss()
                }else{
                    
                    print("is not Success")
                    SVProgressHUD.dismiss()
                }
                
            })
        
    }
    
    func loadMoreData() {
        
        let hds:HTTPHeaders = [:]
        
        let strGeo:String = "\(self.latitude),\(self.longitude)"
        let strLimit:String = "\(String(limit))"
        let strOffset:String = "\(page * limit)"
        
        
//        DispatchQueue.main.async {
//            self.markerList = [GMSMarker]()
//            self.mapView.clear()
//        }
        

        
        let params:Parameters =  [
            "type":"place",
            "center":strGeo,
            "distance":"100000",
            "access_token":strToken,
            "q":searchType,
            "fields":"name,fan_count,talking_about_count,checkins,category,category_list,picture.height(200),location",
            "limit":strLimit,
            "offset":strOffset,
            ]
        
        print("params loadMoreData()")
        //print("params[limit] = \(params["limit"] as! String)")
        print(params)
//        print("params[offset] = \(params["offset"] as! String)")
        print("------")
        
        Alamofire.request("https://graph.facebook.com/search", method: .get, parameters: params, encoding: URLEncoding.default, headers: hds)
            //.validate()
            .responseJSON(completionHandler: {response in
                
                if response.result.isSuccess {
                    
                    //print("is isSuccess")
                    
                    if let res = response.result.value {
                        
                        let _json = JSON(res)
                        
                        let _lists = _json["data"]
                        
                        //                        print("_lists")
                        //                        print(_lists)
                        //                        print("------")
                        
                        if _lists.count > 0 {
                            
                            print("_lists.count")
                            print(_lists.count)
                            
                            
                            self.dataLists = JSON(self.dataLists.arrayValue + _lists.arrayValue)
                            
                            if _lists.count < self.limit {
                                self._tbDataList.showsInfiniteScrolling = false
                            }
                            
                            for jsonItem in self.dataLists.arrayValue {
                                //let jsonItem = JSON(item)
                                //let jsonItem = item
                                //                                print("jsonItem ---- > > >")
                                //                                print(jsonItem)
                                
                                guard let urlLogoImage:String = String(jsonItem["picture"]["data"]["url"].stringValue) else {
                                    return
                                }
                                guard let itemName:String = String(jsonItem["name"].stringValue) else {
                                    return
                                }
                                
                                guard let itemSubtitle:String = String(jsonItem["category"].stringValue) else {
                                    return
                                }
                                guard let strFanCount:String = String(jsonItem["fan_count"].stringValue) else {
                                    return
                                }
                                guard let strCheckins:String = String(jsonItem["checkins"].stringValue) else {
                                    return
                                }
                                let itemFanCount = Int(strFanCount)?.asFomatter()
                                let itemCheckins = Int(strCheckins)?.asFomatter()
                                
                                
                                //print(urlLogoImage)
                                
                                let lat:CLLocationDegrees = jsonItem["location"]["latitude"].doubleValue
                                let lng:CLLocationDegrees = jsonItem["location"]["longitude"].doubleValue
                                
                                //                                    print("lat,lng ---- > > >")
                                //                                    print("lat:\(lat) / lng:\(lng)")
                                
                                let myGeo:CLLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
                                let endGeo:CLLocation = CLLocation(latitude: lat, longitude: lng)
                                let floatDistance = self.api.getDistance(curLocation: myGeo, destLocation: endGeo)
                                let strDistance = String(format: "%.02f", floatDistance)
                                
                                let position: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (lat), longitude: lng)
                                let marker = GMSMarker(position: position)
                                marker.title = jsonItem["name"].stringValue
                                //marker.snippet = listsIn.objectForKey("position")?.stringValue
                                marker.map = self.mapView
                                marker.icon = Toucan(image: UIImage(named: "pin-marker-waiting.png")!).resizeByScaling(CGSize(width:50, height:57)).image
                                
                                
                                var dictsForMap:[String: AnyObject] = [
                                    "itemName": itemName as AnyObject,
                                    "itemSubtitle": itemSubtitle as AnyObject,
                                    "itemFanCount": itemFanCount as AnyObject,
                                    "itemCheckins": itemCheckins as AnyObject,
                                    "itemDistant": "\(strDistance) km." as AnyObject,
                                    "itemLogo": UIImage(),
                                    ]
                                
                                let url = NSURL(string: urlLogoImage)
                                
                                
                                DispatchQueue.global(qos: .background).async {
                                    let data = NSData(contentsOf: url! as URL)
                                    
                                    DispatchQueue.main.async {
                                        if let _imgMarker = data as NSData?{
                                            dictsForMap["itemLogo"] = UIImage(data: _imgMarker as Data)!
                                            marker.userData = dictsForMap
                                            marker.icon = self.fn.getImageMarker(image: UIImage(data: _imgMarker as Data)!)
                                        }
                                        
                                    }
                                }
                            
                                self.markerList.append(marker)
                                
                                
                            }
                            
                            self.refreshMapView()
                            
                            
                        }else{
                            
                            self._tbDataList.showsInfiniteScrolling = false
                        }
                        
                        print("dataLists.count")
                        print(self.dataLists.count)
                        print("==================================")

                        
                        
                        self._tbDataList.reloadData()
                        
                    }
                    
                    
                    self._tbDataList.pullToRefreshView.stopAnimating()
                    self._tbDataList.infiniteScrollingView.stopAnimating()
                    SVProgressHUD.dismiss()
                }else{
                    
                    print("is not Success")
                    SVProgressHUD.dismiss()
                }
                
            })
        
    }
    
    func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
                
 ///////////////// เชคว่า ถ้า ไม่ใช่ Phuget smart wifi ให้ show /////////////////
                
                if (SSIDDict[d]!).isEqual("TOUCH") {
                    //show introview
                    print(":::: show introview ::::")
                    let VC1 : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "introviewvc")
                    
                    self.present(VC1, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
    
    // MARK: - --------- Button Action ---------
    
    @IBAction func btnTypeAll_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = ""
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    @IBAction func btnTypeHotel_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = "hotel"
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    @IBAction func btnTypeRestaurant_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = "restaurant"
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    @IBAction func btnTypeShopping_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = "shopping"
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    @IBAction func btnTypeNightLife_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = "nightlife"
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    @IBAction func btnTypeBank_Click(_ sender: AnyObject) {
        
        page = 0
        _tbDataList.showsInfiniteScrolling = true
        SVProgressHUD.show()
        searchType = "ธนาคาร"
        refreshData()
        btnTopLeftClick(sender: UIButton())
        
    }
    
    
    
    
    
    func determineMyCurrentLocation() {
        print("determineMyCurrentLocation")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        latitude = (userLocation.coordinate.latitude)
        longitude = (userLocation.coordinate.longitude)
        
        app.latitude = latitude
        app.longitude = longitude
        
        print("user latitude = \(latitude)")
        print("user longitude = \(longitude)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    
    
    
}

