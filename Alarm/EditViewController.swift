//
//  EditViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit

class EditViewController: UIViewController{
    @IBOutlet weak var stuffInput: UITextField!
    
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var timeInput: UIDatePicker!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func onDoneClick(_ sender: UIBarButtonItem) {
        let stuff = stuffInput.text
        if stuff == nil || stuff!.isEmpty {
            //toast
            return
        }else{
            let date = dateInput.date
            let time = timeInput.date
           
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let hour = calendar.component(.hour, from: time)
            let minute = calendar.component(.minute, from: time)
            
//            print("date = \(date), time = \(time)")
//            print("year = \(year), month = \(month), day = \(day), hour = \(hour), minute = \(minute)")
            let memo = Memo(content: stuff!, year: year, month: month, day: day, hour: hour, minute: minute)
            
            addMemo(memo: memo)
            navigationController?.popViewController(animated: true)
        }
    }
}
