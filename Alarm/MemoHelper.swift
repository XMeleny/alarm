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
    
    func save()  {
        let managedObjectContext = getManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: entity_name_memo, in: managedObjectContext)!
        let memo = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        memo.setValue(id, forKey: memo_id)
        memo.setValue(content, forKey: memo_content)
        memo.setValue(year, forKey: memo_year)
        memo.setValue(month, forKey: memo_month)
        memo.setValue(day, forKey: memo_day)
        memo.setValue(hour, forKey: memo_hour)
        memo.setValue(minute, forKey: memo_minute)
        
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("save entity memo error")
        }
    }
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


