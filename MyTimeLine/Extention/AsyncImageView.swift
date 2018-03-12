//
//  AsyncImageView.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/12.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {

    private var currentUrl: String? //Get a hold of the latest request url
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    public func imageFromServerURL(url: String){
        currentUrl = url
        if(imageCache.object(forKey: url as AnyObject) != nil){
            self.image = imageCache.object(forKey: url as AnyObject) as? UIImage
        }else{
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let downloadedImage = UIImage(data: data!) {
                            if (url == self.currentUrl) {//Only cache and set the image view when the downloaded image is the one from last request
                                self.imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                                self.image = downloadedImage
                            }
                            
                        }
                    })
                    
                }
                else {
                    print(error)
                }
            })
            task.resume()
        }
        
        
    }
}
