//
//  EditViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit

class EditViewController: UIViewController{
    @IBOutlet weak var contentInput: UITextField!
    
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var timeInput: UIDatePicker!
    
    enum InputType{
        case add
        case modify
    }
    
    var inputType = InputType.add
    var inputMemo:Memo?
    
    override func viewDidLoad() {
        if inputType == .modify{
            let memo = inputMemo!
            let calendar = Calendar.current
            var dateComponent = DateComponents()
            dateComponent.year = memo.year
            dateComponent.month = memo.month
            dateComponent.day = memo.day
            dateComponent.hour = memo.hour
            dateComponent.minute = memo.minute
            
            let date = calendar.date(from: dateComponent)
            
            contentInput.text = memo.content
            dateInput.date = date!
            timeInput.date = date!
        }
    }
    
    @IBAction func onDoneClick(_ sender: UIBarButtonItem) {
        let content = contentInput.text
        if content == nil || content!.isEmpty {
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
            
            switch inputType {
            case .add:
                let memo = Memo(content: content!, year: year, month: month, day: day, hour: hour, minute: minute)
                addMemo(memo: memo)
                break
            case .modify:
                updateMemo(id: inputMemo!.id, content: content!, year: year, month: month, day: day, hour: hour, minute: minute)
                break
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
