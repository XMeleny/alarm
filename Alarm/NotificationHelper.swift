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

func addNotification(memo:Memo){
    addNotification {
        let content = UNMutableNotificationContent()
        content.title = memo.content
        content.body = memo.getDDL()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: memo.getDateComponent(), repeats: false)
        
        let request = UNNotificationRequest(identifier: String(memo.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
        print("add notification successfully, will present at \(memo.getDDL())")
    } deniedHandler: {
        print("add notification error, permission denied")
    }
}

func updateNotification(memo:Memo){
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [String(memo.id)])
    addNotification(memo: memo)
}
