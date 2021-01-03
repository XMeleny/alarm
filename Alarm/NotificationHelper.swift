import Foundation
import UIKit

func addNotification(grantHandler: @escaping ()->Void,  deniedHandler: @escaping ()->Void){
    let center = UNUserNotificationCenter.current()
    
    center.getNotificationSettings { (settings) in
        switch (settings.authorizationStatus) {
        case .notDetermined:
            center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if granted {
                    grantHandler()
                }else{
                    deniedHandler()
                }
            }
        case .authorized, .provisional:
            grantHandler()
        default:
            deniedHandler()
        }
    }
}

func addTestNotification()  {
    addNotification {
        let content = UNMutableNotificationContent()
        content.title = "this is title"
        content.body = "this is body"
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        
        // 1 min later
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
    } deniedHandler: {
        print("permission denied")
    }

}
