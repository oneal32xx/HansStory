//
//  addFoodViewController.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/16.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

protocol AddFoodDelegate {
    func addFoodComplete()
}

class AddFoodViewController: BaseViewController , UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodTypeTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    var pickOption = [FoodType.other, FoodType.Taiwan, FoodType.FastFood, FoodType.Japan, FoodType.Italy, FoodType.Thai, FoodType.Ｂreakfast]
    var isEditFood = false
    var foodInEdit: Foods!
    var addfoodDelegate: AddFoodDelegate?
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        var key = self.fireBase.refFood.childByAutoId().key
        if(self.isEditFood)
        {
            key = self.foodInEdit.id!
        }

        //creating story with the given values
        let food = ["id":key,
                     "FoodName": foodNameTextField.text! as String  ,
                     "FoodType": foodTypeTextField.text! as String,
                     "RestaurantName": shopNameTextField.text! as String,
                     "Address": addressTextField.text! as String,
                     ]
        
        //adding the story inside the generated unique key
        self.fireBase.refFood.child(key).setValue(food) { (error, ref) in
            if error != nil{
                print(error!)
            }else{
                print("update OK!")
                self.addfoodDelegate?.addFoodComplete()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPicker()
        fireBase.initFirebase()
        
        if(foodInEdit != nil)//初始化頁面資料
        {
            foodNameTextField.text = foodInEdit.FoodName
            foodTypeTextField.text = foodInEdit.FoodType
            shopNameTextField.text = foodInEdit.RestaurantName
            addressTextField.text = foodInEdit.Address
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        foodTypeTextField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        let defaultButton = UIBarButtonItem(title: "預設", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.tappedToolBarBtn))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "請選一個食物種類"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        foodTypeTextField.inputAccessoryView = toolBar
    }
    
    

    @objc func donePressed(sender: UIBarButtonItem) {
        foodTypeTextField.resignFirstResponder()
    }
    
    @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
        foodTypeTextField.text = FoodType.other.foodTypeDes
        foodTypeTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        foodTypeTextField.text = pickOption[row].foodTypeDes
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row].foodTypeDes
    }
}
