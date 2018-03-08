//
//  BaseViewController.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/3/6.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var editingView: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initContaner() {
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - KeyboardNotification
    @objc func keyboardWillShow(notification: Notification) {
        guard editingView != nil else {
            return
        }
        
        let frame: CGRect = self.view.convert(editingView.frame, from: editingView.superview)
        let eFrame: CGRect = ((UIApplication.shared.delegate!.window?)!.convert(frame, from: self.view))
        let sFrame: CGRect = (appDelegate.window?.convert(self.view.frame, from: self.view.superview))!
        let kbFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        guard eFrame.origin.y + eFrame.size.height >= kbFrame.origin.y else {
            return
        }
        
        let height: CGFloat = CGFloat(-(eFrame.origin.y + eFrame.size.height - kbFrame.origin.y - sFrame.origin.y + 20))
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0.0, y: height, width: self.view.frame.width, height: self.view.frame.height)
            self.editingView = nil
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}

