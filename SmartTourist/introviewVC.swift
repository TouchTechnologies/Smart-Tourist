//
//  introviewVC.swift
//  SmartTourist
//
//  Created by Touch Developer on 10/5/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import EAIntroView

class introviewVC: UIViewController,EAIntroDelegate {
    @IBOutlet var beseView: UIView!
    var buttonView : UIView!
    var intro = EAIntroView()
    var rootView = UIView()
    var page1 = EAIntroPage()
    var page2 = EAIntroPage()
    var page3 = EAIntroPage()
    var page4 = EAIntroPage()
    var page5 = EAIntroPage()
    var page6 = EAIntroPage()
    var page7 = EAIntroPage()
    
    var CancelBtn = UIButton()
    
    var settingBtn = UIButton()
    
    var width = CGFloat()
    var height = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
    
        
        width = UIScreen.main.bounds.size.width
        height = UIScreen.main.bounds.size.height
        beseView.frame = CGRect(x: 0, y: 20, width: width, height: height)
        
        page1.bgImage = UIImage(named:"intro01.jpg")
        page2.bgImage = UIImage(named:"intro02.jpg")
        page3.bgImage = UIImage(named:"intro03.jpg")
        page4.bgImage = UIImage(named:"intro04.jpg")
        page5.bgImage = UIImage(named:"intro05.jpg")
        page6.bgImage = UIImage(named:"intro06.jpg")
        page7.bgImage = UIImage(named:"intro07.jpg")
        
        
        intro = EAIntroView(frame: UIScreen.main.bounds, andPages: [page1 , page2 ,page3 ,page4,page5 , page6 , page7])
        intro.delegate = self
        intro.show(in: beseView, animateDuration: 0.3)
        intro.swipeToExit = false

        self.intro.skipButton.setTitle("Skip", for: .normal)
        self.intro.skipButtonY = self.intro.pageControlY - 20
        self.intro.skipButtonSideMargin = self.width - self.width/1.1
        self.intro.skipButton.addTarget(self, action: #selector(self.cancelIntroview), for: UIControlEvents.touchUpInside)
      
        print("%d \( self.intro.skipButton.bounds)")
  
        self.page7.onPageDidDisappear = {() -> Void in
          
            self.intro.skipButton.setTitle("Skip", for: .normal)
            self.intro.skipButtonY =  self.intro.pageControlY + 10
            self.intro.skipButtonSideMargin = self.width - self.width/1.1
            self.intro.pageControl.isHidden = false
            self.intro.skipButton.isHidden = false
            self.settingBtn.isHidden = true
         
         
        }
        
        page7.onPageDidAppear = {() -> Void in
            
            self.intro.skipButton.setTitle("Cancel", for: .normal)
            self.intro.skipButtonY = self.view.bounds.size.height/2.0 - 60
            self.intro.skipButtonSideMargin = self.view.bounds.size.width/2 - 25
            self.intro.pageControl.isHidden = true
            self.intro.swipeToExit = false
            
      
            self.settingBtn.frame = CGRect(origin: CGPoint(x:self.view.bounds.size.width/2 - 75 , y: self.view.bounds.size.height/2.0), size: CGSize(width: 150 , height :50))
            self.settingBtn.addTarget(self, action: #selector(self.loadDeviceSetting), for: UIControlEvents.touchUpInside)
            self.settingBtn.setTitle("Open Setting", for: .normal)
            self.settingBtn.backgroundColor = UIColor.red
            self.settingBtn.layer.cornerRadius = 5
            self.settingBtn.clipsToBounds = true
            self.settingBtn.isHidden = false;
            self.intro.addSubview(self.settingBtn)
        

        }

        
    }
    func loadDeviceSetting()
    {
        print("ddddd")
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
        
        
    }
    func cancelIntroview(){
        print("CANCEL")
        //self.intro.hideOffscreenPages = true
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showIntro()
    {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
