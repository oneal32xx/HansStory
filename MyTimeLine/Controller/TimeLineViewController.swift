//
//  ViewController.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/2/26.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class TimeLineViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, AddStoryDelegate {
   
    func addStoryComplete() {
        updateTableView()
        self.stopAnimating()
    }

    @IBOutlet weak var TimeLineTableView: UITableView!
    var refStory: DatabaseReference!
    
    var story = [Story]()
    var storyImage = [UIImage]()
    var actionButton: ActionButton! // 首先右下角悬浮按钮声明
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.baseViewPageInit()
       
        //getting a reference to the node story
        refStory = Database.database().reference().child("story");
        updateTableView()
        // Do any additional setup after loading the view, typically from a nib.
        TimeLineTableView.delegate = self
        TimeLineTableView.dataSource = self
        
        //tableView 背景圖片
        let backgroundImage = UIImage(named: "backbground")
        let imageView = UIImageView(image: backgroundImage)
        self.TimeLineTableView.backgroundView = imageView
        self.TimeLineTableView.backgroundView?.contentMode = .scaleAspectFit
        self.TimeLineTableView.backgroundView?.alpha = 0.5
        
        //Cell 自動高度
        self.TimeLineTableView.estimatedRowHeight = 10
        self.TimeLineTableView.rowHeight = UITableViewAutomaticDimension
        initActoinButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTableView()
    {
        self.startAnimating()
        //observing the data changes
        refStory.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.story.removeAll()
                self.storyImage.removeAll()
                //iterating through all the values
                for story in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let storyObject = story.value as? [String: AnyObject]
                    let storyUploadUser  = storyObject?["UploadUser"]
                    let storyId  = storyObject?["id"]
                    let storyContent = storyObject?["Story"]
                    let ImageURL = storyObject?["ImageURL"]
                    let StoryDate = storyObject?["StoryDate"]
                    let storyImage: UIImage?
                    
                    let url = URL(string: ImageURL as! String)
//                    if let data = try? Data(contentsOf: url!)
//                    {
//                        let image: UIImage = UIImage(data: data)!
//                        storyImage = image
//                    }else{
//                        storyImage = UIImage()
//                    }
                    
                    //creating artist object with model and fetched values
                    let storyItem = Story(id: storyId as! String?,
                                               UploadUser: storyUploadUser as! String?,
                                               Story: storyContent as! String?,
                                               ImageURL: ImageURL as! String?,
                                               StoryDate: StoryDate as! String?,
                                               StoryImage: UIImage())
                    
                    //appending it to list
                    self.story.append(storyItem)
                }
                
                self.story.sort(by: { $0.StoryDate! > $1.StoryDate! })
                //reloading the tableview
                self.TimeLineTableView.reloadData()
                self.stopAnimating()
            }
        })
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
       return story.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell", for: indexPath) as! TimeLineTableViewCell
        cell.TimeLineDate.text = story[indexPath.row].StoryDate
        cell.TimeLineString.text = story[indexPath.row].Story
        cell.TimeLineImage.loadImageUsingCache(withUrl: story[indexPath.row].ImageURL!)
        cell.TimeLineImage.zoomImage()
        return cell
    }
    
    //cell被選擇的狀況
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //將目前狀態相反後存回去
       let cell = tableView.cellForRow(at: indexPath as IndexPath) as? TimeLineTableViewCell;
        if(cell != nil){
            //不要讓cell有選擇起來的反黑的效果,用這這個語法可以取消選擇
            TimeLineTableView.deselectRow(at: indexPath as IndexPath, animated: false);
        }
    }

    func DeleteStory(id:String){
        
        //updating the artist using the key of the artist
        refStory.child(id).setValue(nil)
        //displaying message
        print("story delete!")
        updateTableView()
      
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            self.DeleteStory(id: self.story[indexPath.row].id!)
            success(true)
        })
        modifyAction.title = "要跟我說掰掰嗎><"
        modifyAction.image = UIImage(named: "delete-1")

        return UISwipeActionsConfiguration(actions: [modifyAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            
            //顯示編輯頁面
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
            controller.EditStory = self.story[indexPath.row]
            controller.isEditStory = true
            self.present(controller, animated: true, completion: nil)
            success(true)
        })
        closeAction.title = "想加點什麼?!"
        closeAction.image = UIImage(named: "pen")
        

        return UISwipeActionsConfiguration(actions: [closeAction])

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
    
    func initActoinButton()
    {
        let twitterImage = UIImage(named: "personalInfo")!
        let plusImage = UIImage(named: "addStory")!

        let google = ActionButtonItem(title: "新增回憶", image: plusImage)
        google.action = {
            item in print("Google Plus...")

            //顯示編輯頁面
            self.actionButton.toggleMenu()
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
            controller.isEditStory = false
            self.present(controller, animated: true, completion: nil)
        
           
        }
        
        let twitter = ActionButtonItem(title: "作者介紹", image: twitterImage)
        twitter.action = { item in print("Twitter...")
            
     
            //顯示編輯頁面
            self.actionButton.toggleMenu()
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "MyInfoViewController") as! MyInfoViewController
            self.present(controller, animated: true, completion: nil)
        
            
            
        }
        
        actionButton = ActionButton(attachedToView: self.view, items: [twitter, google])
        actionButton.action = { button in button.toggleMenu() }
        // 在这里设置按钮的相关属性，其实就是把刚刚那两个文件中的原始属性给覆盖了一遍，这里仅覆盖了2个旧属性
        actionButton.setTitle("+", forState: .normal)
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:0.8)

    }

}



extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! as NSData }
}

