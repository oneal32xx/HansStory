//
//  EatWhatViewController.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/14.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EatWhatViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource , FoodFilterDelegate{
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var foodPicker: UIPickerView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dochiButton: UIButton!
    @IBOutlet weak var foodFilterButton: UIButton!
    
    var food = [Foods]()
    var foodFilter = [Foods]()
    var foodtype = [String]()
    var noFoodToShow = ["沒有食物.."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodPicker.showsSelectionIndicator = false
        fireBase.defaultFoodTypeArray()
        loadFoodLis()
        foodPicker.delegate = self
    }

    func FoodFilterComplete() {
        filterdata()
        foodFilterResult()
        self.radomEat()
    }
    
    func loadFoodLis(){
        self.fireBase.refFood.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.food.removeAll()
                //iterating through all the values
                for foodList in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let foodItem = Foods(snapshot: foodList)
                    self.food.append(foodItem)

                }
            }
            self.foodPicker.delegate = self
            self.filterdata()
            self.foodFilterResult()
            self.radomEat()
        })
   
        
        
    }
    
    func filterdata(){
        foodtype.removeAll()
        var i = 0
        for foodType in fireBase.foodTypeArray {
            if(fireBase.foodSelect[i])
            {
                foodtype.append(foodType)
            }
            i = i+1
        }
    }
    
    func foodFilterResult(){
        foodFilter.removeAll()
        for foodItem in food {
            if(foodtype.contains(foodItem.FoodType!))
            {
                foodFilter.append(foodItem)
            }
        }
        foodPicker.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func dochiButtonPressed(_ sender: Any) {
        radomEat()
    }
    
    @IBAction func foodFilterPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "FoodFilterViewController") as! FoodFilterViewController
        controller.foodFilterDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func radomEat(){
        if(foodFilter.count > 0)
        {
            let selectRowIndex = Int(arc4random())%foodFilter.count + 0
            foodPicker.selectRow(selectRowIndex, inComponent: 0, animated: true)
            foodNameLabel.text = foodFilter[selectRowIndex].FoodName
            foodTypeLabel.text = foodFilter[selectRowIndex].FoodType
            restNameLabel.text = foodFilter[selectRowIndex].RestaurantName
            addressLabel.text = foodFilter[selectRowIndex].Address
        }else{
            foodNameLabel.text = ""
            foodTypeLabel.text = ""
            restNameLabel.text = ""
            addressLabel.text = ""
        }
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        radomEat()
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    //picker有幾個元件
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //picker有幾個資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(foodFilter.count == 0)
        {
            return noFoodToShow.count
        }else{
            return foodFilter.count
        }
    }
    
    //設定pickerView 資料
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        if(foodFilter.count == 0)
        {
            pickerLabel.text = noFoodToShow[row]
        }else{
            pickerLabel.text = foodFilter[row].FoodName
        }
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
}
