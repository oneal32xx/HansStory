//
//  TimeLineTableViewCell.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/2/27.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak var TimeLineDate: UILabel!
    @IBOutlet weak var TimeLineString: UILabel!
    @IBOutlet weak var TimeLineImage: UIImageView!
    @IBOutlet weak var StarIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}