//
//  MainViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import Foundation
import UIKit

class MainViewController: UITableViewController {
    override func viewDidLoad() {
        getAllMemos { (result) in
            //todo
        }
    }
}
