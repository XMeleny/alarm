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
    
    init(id:Int, content:String, year:Int, month:Int, day:Int, hour:Int, minute:Int) {
        self.id = id
        self.content = content
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
    }
    
    init(obj:NSManagedObject) {
        id = obj.value(forKey: memo_id) as! Int
        content = obj.value(forKey: memo_content) as! String
        year = obj.value(forKey: memo_year) as! Int
        month = obj.value(forKey: memo_month) as! Int
        day = obj.value(forKey: memo_day) as! Int
        hour = obj.value(forKey: memo_hour) as! Int
        minute = obj.value(forKey: memo_minute) as! Int
    }
    
    static func getId() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    func getDate() -> String {
        return String(format: "%d.%02d.%02d", year,month,day)
    }
    
    func getTime() -> String {
        String(format: "%02d:%02d", hour,minute)
    }
    
    func getDDL() -> String {
        return "\(getDate()) \(getTime())"
    }
    
    func getDateComponent() -> DateComponents{
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        dateComponent.hour = hour
        dateComponent.minute = minute
        return dateComponent
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
        print("successfully saved memo, content =\(memo.content), id = \(memo.id)")
    }catch{
        fatalError("save entity memo error")
    }
}

func deleteMemo(id:Int) {
    let context = getManagedObjectContext()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name_memo)
    fetchRequest.predicate = NSPredicate(format:"\(memo_id) == \(id)", "")
    
    do {
        let fetchedResult = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let result = fetchedResult{
            for obj in result{
                context.delete(obj)
            }
            try context.save()
        }
    }catch {
        fatalError("delete error")
    }
}

func updateMemo(id:Int, content:String, year:Int, month:Int, day:Int, hour:Int, minute:Int){
    let context = getManagedObjectContext()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity_name_memo)
    fetchRequest.predicate = NSPredicate(format:"\(memo_id) == \(id)", "")
    
    do {
        let fetchedResult = try context.fetch(fetchRequest) as? [NSManagedObject]
        
        if let result = fetchedResult{
            for obj in result{
                obj.setValue(content, forKey: memo_content)
                obj.setValue(year, forKey: memo_year)
                obj.setValue(month, forKey: memo_month)
                obj.setValue(day, forKey: memo_day)
                obj.setValue(hour, forKey: memo_hour)
                obj.setValue(minute, forKey: memo_minute)
            }
            try context.save()
        }
    }catch {
        fatalError("update error")
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
        fatalError("get all memos error")
    }
}
