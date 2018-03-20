//
//  Foods.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/14.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum FoodType: EnumCollection {
    case Taiwan
    case Japan
    case Thai
    case FastFood
    case Italy
    case other
    case Ｂreakfast
    
    var foodTypeDes: String{
        switch self {
        case .Ｂreakfast: return "早餐"
        case .Taiwan: return "台式料理"
        case .Japan: return "日式料理"
        case .Thai: return "泰式料理"
        case .FastFood: return "速食"
        case .Italy: return "義式料理"
        case .other: return "其他"
        }
    }
}




class Foods {
    var id: String?
    var FoodName: String?
    var FoodType: String?
    var RestaurantName: String?
    var Address: String?
    
    
    
    init(FoodName: String, FoodType: String, RestaurantName: String, Address: String){
        self.FoodName = FoodName
        self.FoodType = FoodType
        self.RestaurantName = RestaurantName
        self.Address = Address
    }
    
    init(snapshot: DataSnapshot){
        let foodObject = snapshot.value as? [String: AnyObject]
        self.id = foodObject?["id"] as? String
        self.FoodName  = foodObject?["FoodName"] as? String
        self.FoodType  = foodObject?["FoodType"] as? String
        self.RestaurantName = foodObject?["RestaurantName"] as? String
        self.Address = foodObject?["Address"] as? String
    }

    func toAnyObject() -> Any {
        return [
            "id": self.id!,
            "FoodName": self.FoodName!,
            "FoodType": self.FoodType!,
            "RestaurantName": self.RestaurantName!,
            "Address": self.Address!,
        ]
    }
    
}


public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}

