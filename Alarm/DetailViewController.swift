//
//  DetailViewController.swift
//  Alarm
//
//  Created by gtk on 2021/1/3.
//

import UIKit

let detail_id = "DetailViewController"
class DetailViewController: UIViewController {
    var memo:Memo?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = memo{
            contentLabel.text = memo.content
            dateLabel.text = memo.getDate()
            timeLabel.text = memo.getTime()
        }
    }
}
