//
//  MainViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UITableViewController{
    let CELL_IDENTIFIER = "MemoCell"
    
    var allMemos = [NSManagedObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        let memo = allMemos[indexPath.row]
        
        let information = getInformation(memo: memo)
        let content = information.0
        let ddl = information.1
        
        cell.textLabel?.text = content
        cell.detailTextLabel?.text = ddl
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memo = allMemos[indexPath.row]
//        testDelete(memo: memo)
        testUpdate(memo: memo)
    }
    
    func testDelete(memo:NSManagedObject)  {
        let id = memo.value(forKey: memo_id) as! Int
        
        let alert = UIAlertController(title: "delete it?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
            deleteMemo(id: id)
            self.refresh()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func testUpdate(memo:NSManagedObject){
        let id = memo.value(forKey: memo_id) as! Int
        let content = memo.value(forKey: memo_content) as! String
        let year = memo.value(forKey: memo_year) as! Int
        let month = memo.value(forKey: memo_month) as! Int
        let day = memo.value(forKey: memo_day) as! Int
        let hour = memo.value(forKey: memo_hour) as! Int
        let minute = memo.value(forKey: memo_minute) as! Int
        
        let alert = UIAlertController(title: "update it?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
            updateMemo(id: id, content: content+content, year: year, month: month, day: day, hour: hour, minute: minute)
            self.refresh()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func refresh()  {
        getAllMemos(handler: { (result) in
            allMemos = result
        })
        tableView.reloadData()
    }
}
