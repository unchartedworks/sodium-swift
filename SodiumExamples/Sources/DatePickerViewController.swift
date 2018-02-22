//
//  DatePickerViewController.swift
//  SodiumExamples
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class DatePickerViewController: UIViewController{
    @IBOutlet weak var datePicker: SDatePicker!
    @IBOutlet weak var dateLabel: SLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.cText = cellDate(datePicker)
    }
    
    func cellDate(_ datePicker: SDatePicker) -> Cell<String> {
        func date2String(_ date: Date) -> String {
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
            return dateFormatter.string(from: date)
        }
        return datePicker.csDate.map(date2String)
    }

}
