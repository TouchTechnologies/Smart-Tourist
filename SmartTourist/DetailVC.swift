//
//  DetailVC.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/7/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SVPullToRefresh
import SVProgressHUD
import SwiftyJSON
import Nuke

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var api = facebookAPI()
    var dataLists = JSON([:])
    
    @IBOutlet weak var _tbReviewList: UITableView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var viewDetail: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblCheckin: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblKM: UILabel!
    @IBOutlet weak var iconPin: UIImageView!
    @IBOutlet weak var iconLike: UIImageView!
    
    
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnCloseClick(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    var itemData = [String:AnyObject]()
    var dataID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("itemData")
        print(itemData)
        print("--------")
        
        self._tbReviewList.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        guard let urlLogoImage:String = itemData["picture"] as! String? else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            let data = NSData(contentsOf: URL(string: urlLogoImage)! as URL)
            DispatchQueue.main.async {
                if let _img = data as NSData?{
                    self.imgCover.image = UIImage(data: _img as Data)!
                }
            }
        }
        
        self.lblTitle.text = itemData["name"] as! String?
        self.lblSubtitle.text = itemData["category"] as! String?
//        self.lblLike.text = Int(itemData["fan_count"] as! Int).asFomatter()
//        self.lblCheckin.text = Int(itemData["checkins"] as! Int).asFomatter()
        self.lblLike.text = itemData["fan_count"] as! String?
        self.lblCheckin.text = String(itemData["checkins"] as! Int)
        self.lblKM.text = "\(itemData["distance"]!) km."
        
        
        
        guard let _id:String = itemData["id"] as! String else {
            return
        }
        dataID = _id
        
        initTableview()
        
        
        self.btnClose.backgroundColor = UIColor.clear
        self.btnClose.setImage(UIImage.fontAwesomeIconWithName(.Close, textColor: UIColor.white, size: CGSize(width: 30, height: 30)),for:.normal)
        self.btnClose.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - TABLEVIEW ZONE
    func initTableview() {
        
        //_tbDataList.frame = _viewForList.frame
        _tbReviewList.dataSource = self
        _tbReviewList.delegate = self
        _tbReviewList.autoresizesSubviews = true
        _tbReviewList.register(UINib(nibName: "tbViewCell_Review", bundle:nil), forCellReuseIdentifier: "cell")
        _tbReviewList.rowHeight = 80
        _tbReviewList.separatorStyle = .none
        //_tbDataList.backgroundColor = UIColor.green
        
        
        SVProgressHUD.setDefaultStyle(.dark)
        //SVProgressHUD.show()
        
        //self.title = "Loading..." // fn.randomString(len: 10) as String
        
        self.refreshData()
//        
//        weak var _weakSelf = self
//        self._tbDataList.addPullToRefresh(actionHandler: {
//            //print("add Top")
//            
//            self.page = 0
//            _weakSelf!.refreshData()
//            
//        })
//        
//        
//        self._tbDataList.addInfiniteScrolling(actionHandler: {
//            
//            if(self.dataLists.count > 0){
//                
//                self.page = self.page + 1
//                _weakSelf!.loadMoreData()
//                
//            }else{
//                print("Notfound Data")
//                
//                self._tbDataList.infiniteScrollingView.stopAnimating()
//            }
//            
//        })
        
    }
    
    
    func setDataToTable(data: JSON) {
        //getData
        
        print("====================================================")
        print("setDataToTable")
        print(data)
        print("====================================================")
        
        if(data.count > 0){
            
            dataLists = data
            
        }else{
        
            dataLists = JSON([:])
            
        }
        
        _tbReviewList.reloadData()
        
    }
    
    func refreshData() {
        
        self.api.getTagedData(ID: dataID, completionHandler: {data in
            
            let getData = JSON(data)
            
            self.setDataToTable(data: getData["data"])
            
            print("dataTagedData")
            print(getData)
            print("=============")
           

            
            
//            self.api.getDataByID(ID: _id, completionHandler: {data in
//                
//                let dataByID = JSON(data)
//                print("getDataByID")
//                print(dataByID)
//                print("=============")
//                
//                guard let urlLogoImagexxx:String = String(dataByID["picture"]["data"]["url"].stringValue) else {
//                    return
//                }
//                
////                let urlLogoImage:String = dataByID["picture"]["data"]["url"].stringValue
////                
////                print("urlLogoImage")
////                print(urlLogoImage)
////                
////                DispatchQueue.global(qos: .background).async {
////                    let data = NSData(contentsOf: URL(string: urlLogoImage)! as URL)
////                    DispatchQueue.main.async {
////                        if let _img = data as NSData?{
////                            self.imgLogo.image = UIImage(data: _img as Data)!
////                        }
////                    }
////                }
//                
//                
//            })
            
        })
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tbViewCell_Review
        
        cell.setData(data: self.dataLists[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
