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
        content.userInfo = [memo_id:memo.id, memo_content:memo.content, memo_year:memo.year, memo_month:memo.month, memo_day:memo.day, memo_hour:memo.hour, memo_minute:memo.minute]
        
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

func getMemoFromContent(notificationContent:UNNotificationContent) -> Memo{
    let userInfo = notificationContent.userInfo
    let id = userInfo[memo_id] as! Int
    let content = userInfo[memo_content] as! String
    let year = userInfo[memo_year] as! Int
    let month = userInfo[memo_month] as! Int
    let day = userInfo[memo_day] as! Int
    let hour = userInfo[memo_hour] as! Int
    let minute = userInfo[memo_minute] as! Int
    
    return Memo(id: id, content: content, year: year, month: month, day: day, hour: hour, minute: minute)
}

func updateNotification(memo:Memo){
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [String(memo.id)])
    addNotification(memo: memo)
}
