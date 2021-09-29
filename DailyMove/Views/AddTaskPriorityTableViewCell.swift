//
//  AddTaskPriorityTableViewCell.swift
//  DailyMove
//
//  Created by Seydoux on 2021/09/29.
//

import UIKit

class AddTaskPriorityTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
