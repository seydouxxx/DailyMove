//
//  AddTaskTextTableViewCell.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/30.
//

import UIKit

class AddTaskTextTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UITextField!
    @IBOutlet weak var memoLabel: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

