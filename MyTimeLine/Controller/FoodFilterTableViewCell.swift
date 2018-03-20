//
//  FoodFilterTableViewCell.swift
//  MyTimeLine
//
//  Created by HansJiang on 2018/3/16.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

class FoodFilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var foodType: UILabel!
    @IBOutlet weak var foodSelect: UIButton!
    @IBAction func foodSelect(_ sender: Any) {
   
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
