//
//  BaseViewController.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/9.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {

    let fireBase = FireBaseManager.shared
    var actionButton: ActionButton! //右下角浮動按鈕
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseViewPageInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func baseViewPageInit(){
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulseSync
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 50, height: 50)
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Loading..."
        fireBase.initFirebase()
    }
    
    func initActoinButton()
    {
        let creatorIcon = UIImage(named: "personalInfo")!
        let addStoryIcon = UIImage(named: "addStory")!
        let addStoryPage = ActionButtonItem(title: "新增回憶", image: addStoryIcon)
        addStoryPage.action = {
            item in print("Google Plus...")
            //顯示新增回憶頁面
            self.actionButton.toggleMenu()
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
            controller.isEditStory = false
            self.present(controller, animated: true, completion: nil)
        }
        
        let creatorInfoPage = ActionButtonItem(title: "作者介紹", image: creatorIcon)
        creatorInfoPage.action = { item in print("Twitter...")
            //顯示介紹
            self.actionButton.toggleMenu()
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "MyInfoViewController") as! MyInfoViewController
            self.present(controller, animated: true, completion: nil)
            
        }
        
        actionButton = ActionButton(attachedToView: self.view, items: [creatorInfoPage, addStoryPage])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: .normal)
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:0.8)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }


}
