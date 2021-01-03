//
//  MemoHelper.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit
import CoreData

let entity_name_memo = "Memo"
let memo_id = "id"
let memo_content = "content"
let memo_year = "year"
let memo_month = "month"
let memo_day = "day"
let memo_hour = "hour"
let memo_minute = "minute"

class Memo{
    let id:Int
    let content:String
    let year:Int
    let month:Int
    let day:Int
    let hour:Int
    let minute:Int
    
    init(content:String, year:Int, month:Int, day:Int, hour:Int, minute:Int) {
        self.id = Memo.getId()
        self.content = content
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
    }
    
    static func getId() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
}

func addMemo(memo:Memo){
    let managedObjectContext = getManagedObjectContext()
    let entity = NSEntityDescription.entity(forEntityName: entity_name_memo, in: managedObjectContext)!
    let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
    
    managedObject.setValue(memo.id, forKey: memo_id)
    managedObject.setValue(memo.content, forKey: memo_content)
    managedObject.setValue(memo.year, forKey: memo_year)
    managedObject.setValue(memo.month, forKey: memo_month)
    managedObject.setValue(memo.day, forKey: memo_day)
    managedObject.setValue(memo.hour, forKey: memo_hour)
    managedObject.setValue(memo.minute, forKey: memo_minute)
    
    do{
        try managedObjectContext.save()
    }catch{
        fatalError("save entity memo error")
    }
}

func getInformation(memo:NSManagedObject) -> (String, String){
    let content = memo.value(forKey: memo_content) as! String
    
    let year = memo.value(forKey: memo_year) as! Int
    let month = memo.value(forKey: memo_month) as! Int
    let day = memo.value(forKey: memo_day) as! Int
    let hour = memo.value(forKey: memo_hour) as! Int
    let minute = memo.value(forKey: memo_minute) as! Int
    
    let ddl = "\(year).\(month).\(day) \(hour):\(minute)"
    
    return (content,ddl)
}

func getAllMemos(handler: ([NSManagedObject])->Void)  {
    let managedObjectContext = getManagedObjectContext()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name_memo)
    do {
        let fetchedResults = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        if let result = fetchedResults {
            handler(result)
        }
    } catch  {
        fatalError("获取失败")
    }
}
