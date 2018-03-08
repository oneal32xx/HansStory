//
//  Story.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/3/6.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

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
    
    
    
}
