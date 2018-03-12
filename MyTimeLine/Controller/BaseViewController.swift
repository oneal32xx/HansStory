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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func baseViewPageInit(){
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulseSync
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 50, height: 50)
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Loading..."
    }
    

}
