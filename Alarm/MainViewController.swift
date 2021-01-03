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
        getAllMemos { (result) in
            allMemos = result
            tableView.reloadData()
        }
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
}
