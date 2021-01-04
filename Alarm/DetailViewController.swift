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
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = memo{
            contentLabel.text = memo.content
            dateLabel.text = memo.getDate()
            timeLabel.text = memo.getTime()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
