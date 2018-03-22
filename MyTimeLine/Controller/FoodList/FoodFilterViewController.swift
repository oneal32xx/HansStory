//
//  FoodFilterViewController.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/16.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

protocol FoodFilterDelegate {
    func FoodFilterComplete()
}

class FoodFilterViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate{

   
    @IBOutlet weak var foodsTypeTableView: UITableView!
    
    @IBAction func backPressed(_ sender: Any) {
        foodFilterDelegate?.FoodFilterComplete()
        self.dismiss(animated: true, completion: nil)
    }
    
    var foodFilterDelegate:FoodFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodsTypeTableView.dataSource = self
        foodsTypeTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(fireBase.foodTypeArray.count)
        return fireBase.foodTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodFilterTableViewCell", for: indexPath) as! FoodFilterTableViewCell
        cell.foodType.text = fireBase.foodTypeArray[indexPath.row]
        
        if(fireBase.foodSelect[indexPath.row])
        {
            cell.foodSelect.isSelected = true
        }else{
            cell.foodSelect.isSelected = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectStatus = fireBase.foodSelect[indexPath.row]

        if(selectStatus)
        {
            fireBase.foodSelect[indexPath.row] = false
        }else{
            
            fireBase.foodSelect[indexPath.row] = true
        }

        //將目前狀態相反後存回去
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as? FoodFilterTableViewCell;
        if(cell != nil){
            //不要讓cell有選擇起來的反黑的效果,用這這個語法可以取消選擇
            tableView.deselectRow(at: indexPath as IndexPath, animated: false);
            
        }
        foodsTypeTableView.reloadData()
    }
    
}
