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
    public var refFood: DatabaseReference!
    
    public var foodSelect:[Bool] = []
    public var foodTypeArray:[String] = []
    
    func initFirebase()
    {
        refStory = Database.database().reference().child("story");
        refFood = Database.database().reference().child("food");
    }

    public func defaultFoodTypeArray(){
        for food in FoodType.cases() {
            foodTypeArray.append(food.foodTypeDes)
            foodSelect.append(true)
        }
        
        print(foodTypeArray)
    }
    
}



extension DatabaseReference {
    func fetch<T: Codable, S>(_ type: T.Type, forChild child: FirebaseChild<S>, completionHandler: @escaping (T?) -> Void) {
        self.child(child.path).observeSingleEvent(of: .value) { snapshot in
            var result: T? = nil
            
            if let data = snapshot.value as? S,
                let json = try? JSONEncoder().encode(data) {
                result = try? JSONDecoder().decode(type, from: json)
            }
            completionHandler(result)
        }
    }
}



struct FirebaseChild<S: Codable> {
    let path: String
}
