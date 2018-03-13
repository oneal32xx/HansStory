//
//  FireBaseManager.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/12.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class FireBaseManager: NSObject {
    public static let shared: FireBaseManager = FireBaseManager()
    public var refStory: DatabaseReference!
    
    func initFirebase()
    {
        refStory = Database.database().reference().child("story");
        
        
    }

    
}
