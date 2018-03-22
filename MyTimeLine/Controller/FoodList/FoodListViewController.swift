//
//  EditFoodViewController.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/15.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import Crashlytics
import FirebaseStorage
import FirebaseDatabase

class FoodListViewController: BaseViewController  ,UITableViewDataSource, UITableViewDelegate, AddFoodDelegate{
    
    func addFoodComplete() {
        loadFoodList()
    }
    var food = [Foods]()
    
    @IBOutlet weak var foodTableView: UITableView!
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        loadFoodList()
    }
    
    
    func loadFoodList(){
        fireBase.refFood.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.food.removeAll()
                
                //iterating through all the values
                for foodList in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let foodItem = Foods(snapshot: foodList)
                    
                    self.food.append(foodItem)
                    self.food.sort(by: { $0.FoodType! > $1.FoodType! })
                }
                //self.foodTableView.reloadData()
            }
             self.foodTableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodListTableViewCell", for: indexPath) as! FoodListTableViewCell
        cell.foodName.text = food[indexPath.row].FoodName
        cell.foodType.text = food[indexPath.row].FoodType
        cell.shopName.text = food[indexPath.row].RestaurantName
        cell.address.text = food[indexPath.row].Address
        return cell
    }
    
    //MARK UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "黑名單", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("delete action pressed")
            self.DeleteooFood(id: self.food[indexPath.row].id!)
            success(true)
        })
        deleteAction.image = UIImage(named: "delete-1")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "要改一下?!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("edit action pressed")
            //顯示編輯頁面
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var controller = mainStoryboard.instantiateViewController(withIdentifier: "AddFoodViewController") as! AddFoodViewController
            controller.foodInEdit = self.food[indexPath.row]
            controller.isEditFood = true
            self.present(controller, animated: true, completion: nil)
            success(true)
        })
        editAction.image = UIImage(named: "pen")
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    func DeleteooFood(id:String){
        //updating the story using the key of the story
        fireBase.refFood.child(id).setValue(nil)
        //displaying message
        print("food delete!")
    }
    
    

}
