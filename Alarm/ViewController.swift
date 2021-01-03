//
//  ViewController.swift
//  Alarm
//
//  Created by gtk on 2020/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
            if granted {
                self.doAdd()
            }else{
                self.cannotAdd()
            }
        }
        
    }
    
    func addNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.requestPermission()
            }else if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                self.doAdd()
            } else{
                self.cannotAdd()
            }
        }
    }
    
    func doAdd(){
        let content = UNMutableNotificationContent()
        content.title = "this is title"
        content.body = "this is body"
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        
        // fixme the hour or min maybe wrong...
        let now = Date().addingTimeInterval(60)
        let hour = calendar.component(.hour, from: now)
        let min = calendar.component(.minute, from: now)
        
        dateComponents.hour = hour
        dateComponents.minute = min
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
        print("add successfully at \(hour):\(min)")
    }
    
    func cannotAdd(){
        // todo, alert or jump to settings page. question is how to jump to settings page
        print("not granted, pls reRequest")
    }
    
    @IBAction func sendClick(_ sender: UIButton) {
        requestPermission()
    }
}
