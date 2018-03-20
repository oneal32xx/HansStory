//
//  Story.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/3/6.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//
import UIKit
import FirebaseDatabase

class Story {
    
    var id: String?
    var UploadUser: String?
    var Story: String?
    var ImageURL: String?
    var StoryDate: String?
    var StoryImage: UIImage?
    
    init(id: String?, UploadUser: String?, Story: String?, ImageURL: String?, StoryDate: String?, StoryImage: UIImage?){
        self.id = id
        self.UploadUser = UploadUser
        self.Story = Story
        self.ImageURL = ImageURL
        self.StoryDate = StoryDate
        self.StoryImage = StoryImage
    }
    
    init(snapshot: DataSnapshot){
        let storyObject = snapshot.value as? [String: AnyObject]
        self.UploadUser  = storyObject?["UploadUser"] as? String
        self.id  = storyObject?["id"] as? String
        self.Story = storyObject?["Story"] as? String
        self.ImageURL = storyObject?["ImageURL"] as? String
        self.StoryDate = storyObject?["StoryDate"] as? String
        self.StoryImage = UIImage()
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "UploadUser": UploadUser,
            "Story": Story,
            "ImageURL": ImageURL,
            "StoryDate": StoryDate,
        ]
    }
    
}
