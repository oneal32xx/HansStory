//
//  DatePickerView.swift
//  AgentPlusiPadPlatform
//
//  Created by Darren Hsu on 22/12/2017.
//  Copyright © 2017 D.H. All rights reserved.
//

import UIKit

class DatePickerView: PickerView {

    @IBOutlet var datePicker: UIDatePicker!
    
    var didSelectedDate: ((_ date: Date) -> ())?
    
    @IBAction override func submitPressed(_ sender: UIButton) {
        didSelectedDate?(datePicker.date)
        presentController?.dismiss(animated: true, completion: nil)
    }
    
    class func presentPicker(_ sourceView: UIView, defaultDate: Date? = nil, minimum: Bool? = nil, handleSelected: @escaping (Date)->()) {
        let pickerView: DatePickerView = UINib(nibName: "DatePickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DatePickerView
        pickerView.didSelectedDate = handleSelected
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY/MM/dd"
        
        let string1 = "2216/09/24"
        let lastDate = dateformatter.date(from: string1)
        if let date = lastDate {
            pickerView.datePicker.maximumDate = date
        }
        
        let string2 = "2016/01/01"
        let firstDate = dateformatter.date(from: string2)
        if let date = firstDate {
            pickerView.datePicker.minimumDate = date
        }
        
        if defaultDate != nil {
            pickerView.datePicker.date = defaultDate!
            if let m = minimum {
                if m {
                    pickerView.datePicker.minimumDate = Date()
                }
            }
        }
        
        self.presentSelf(pickerView, sourceView: sourceView)
    }
}
