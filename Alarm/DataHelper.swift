//
//  DataHelper.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit
import CoreData

func getManagedObjectContext()->NSManagedObjectContext{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}
