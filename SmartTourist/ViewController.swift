//
//  ViewController.swift
//  SmartTourist
//
//  Created by Thirawat Phannet on 10/3/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    var _vH = CGFloat()
    var _vW = CGFloat()
    var _vH_min = CGFloat()
    
    var btnItemBarRight = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _vW = self.view.frame.width
        _vH = self.view.frame.height
        _vH_min = self.view.frame.height - 64
        
        designNav()
        designMenu()
        
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
        
        
        
       
        
    }

}

