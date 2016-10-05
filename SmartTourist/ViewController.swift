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


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
    
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
    var offset = Int()
    
    
    var dataLists = JSON([:])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        strToken = "EAAX0NmD7gWABAFFx51sZCReS3iOvFtZA9xFHyZBSXZCI2mHYRJrjFofwOAeOE7Y61uxiuXnnkZAdVS9PPjsikZCusaFYUsnQclTIY6zgzXFIhRdtgfNgDZBxOZCVTauUDKmMNT9tQIu2kzUFG5vyPC7AKiD8CIlbd0QZD"
        geoLat = 13.752468
        geoLng = 100.566107
        limit = 10
        offset = 0
        
        // Do any additional setup after loading the view, typically from a nib.
        _vW = self.view.frame.width
        _vH = self.view.frame.height
        _vH_min = self.view.frame.height - 64
        
        designNav()
        designMenu()
        initTableview()
        initMapview()
                //view.bringSubview(toFront: _viewArrowMenu)
        
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
    func initMapview() {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self._viewForMap.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.animate(toLocation: CLLocationCoordinate2D.init(latitude: 13.7027041734701, longitude: 101.662359125912))
        mapView.animate(toZoom: 5.3)
        mapView.isMyLocationEnabled = true
   
        
        self._viewForMap.addSubview(mapView)
        
        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 13.7027041734701, longitude: 101.662359125912)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
    }
    
    
    
    // MARK: - TABLEVIEW ZONE
    func initTableview() {
        
        _tbDataList.frame = _viewForList.frame
        _tbDataList.dataSource = self
        _tbDataList.delegate = self
        _tbDataList.autoresizesSubviews = true
        _tbDataList.register(UINib(nibName: "tbViewCell_Lists", bundle:nil), forCellReuseIdentifier: "cell")
        _tbDataList.backgroundColor = UIColor.green
        
        _viewForList.addSubview(_tbDataList)
        
        
        SVProgressHUD.setDefaultStyle(.dark)
        //SVProgressHUD.show()
        
        //self.title = "Loading..." // fn.randomString(len: 10) as String
        
        self.refreshData()
        
        weak var _weakSelf = self
        self._tbDataList.addPullToRefresh(actionHandler: {
            //print("add Top")
            
            //            self.currentPage = 1
            //            self.f._filter_set_WithKey("page", andValue: "1")
            _weakSelf!.refreshData()
            
        })
        
        
        self._tbDataList.addInfiniteScrolling(actionHandler: {
            
            if(self.dataLists.count > 0){
                
                //let _searchFilter:NSDictionary = self.f._filter_get()
                
                //let intPage:Int = (_searchFilter.objectForKey("page")?.integerValue)! + 1
                //print("intPage = \(intPage)")
                //let strNextPage = String(intPage)
                //print("strNextPage = \(strNextPage)")
                //self.v._filter_Update("page", _Value: strNextPage)
                //self.f._filter_set_WithKey("page", andValue: strNextPage)
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
        
    }
    
    
    // MARK: - LOAD DATA
    func refreshData() {
        
        if self.dataLists.count < 1 {
            SVProgressHUD.show()
        }
        
        let hds:HTTPHeaders = [:]
        
        let strGeo:String = "\(geoLat),\(geoLng)"
        let strLimit:String = "\(String(limit))"
        let strOffset:String = "\(String(offset))"
        
        let params:Parameters =  [
            "type":"place",
            "center":strGeo,
            "distance":"10000",
            "access_token":strToken,
            "q":"hotel",
            "fields":"name,fan_count,talking_about_count,checkins,category,category_list,picture.height(500)",
            "limit":strLimit,
            "offset":strOffset,
            ]
        
                print("params")
                print(params)
                print("------")
        
        //Alamofire.request("https://parseapi.back4app.com/classes/member", method: .get, parameters: params, encoding: URLEncoding.default, headers: hds)
        Alamofire.request("https://graph.facebook.com/search", method: .get, parameters: params, encoding: URLEncoding.default, headers: hds)
            //.validate()
            .responseJSON(completionHandler: {response in
                
                if response.result.isSuccess {
                    
                    print("is isSuccess")
                    
                    if let res = response.result.value {
                        
                        let _json = JSON(res)
                        
                        let _lists = _json["data"]
                        
                        print("_lists")
                        print(_lists)
                        print("------")
                        
                        if _lists.count > 0 {
                            self.dataLists = _lists
                        }else{
                            self.dataLists = [:]
                        }
                        
//                        print("self.dataLists")
//                        print(self.dataLists)
//                        print("------")
                        
                        //self.title = "Total : \(self.dataLists.count)"
                        
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
    
    func loadMoreData() {
        
        
        
        
    }
    
    
    
}

