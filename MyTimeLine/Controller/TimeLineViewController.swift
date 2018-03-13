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
    var story = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
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
        self.initActoinButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateTableView()
    {
        self.startAnimating()
        //observing the data changes
        fireBase.refStory.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.story.removeAll()

                //iterating through all the values
                for story in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let storyObject = story.value as? [String: AnyObject]
                    let storyUploadUser  = storyObject?["UploadUser"]
                    let storyId  = storyObject?["id"]
                    let storyContent = storyObject?["Story"]
                    let ImageURL = storyObject?["ImageURL"]
                    let StoryDate = storyObject?["StoryDate"]
                    
                    //creating story object with model and fetched values
                    let storyItem = Story(id: storyId as! String?,
                                               UploadUser: storyUploadUser as! String?,
                                               Story: storyContent as! String?,
                                               ImageURL: ImageURL as! String?,
                                               StoryDate: StoryDate as! String?,
                                               StoryImage: UIImage())
                    
                    //appending it to list
                    self.story.append(storyItem)
                }
                
                //sort date
                self.story.sort(by: { $0.StoryDate! > $1.StoryDate! })
                //reloading the tableview
                self.TimeLineTableView.reloadData()
                self.stopAnimating()
            }
        })
        
    }

    //MARK UITableViewDataSource
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

    //MARK UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "要跟我說掰掰嗎><", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("delete action pressed")
            self.DeleteStory(id: self.story[indexPath.row].id!)
            success(true)
        })
        deleteAction.image = UIImage(named: "delete-1")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "想加點什麼?!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("edit action pressed")
            //顯示編輯頁面
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
            controller.EditStory = self.story[indexPath.row]
            controller.isEditStory = true
            self.present(controller, animated: true, completion: nil)
            success(true)
        })
        editAction.image = UIImage(named: "pen")
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func DeleteStory(id:String){
        //updating the artist using the key of the artist
        fireBase.refStory.child(id).setValue(nil)
        //displaying message
        print("story delete!")
        updateTableView()
    }
}





