//
//  customeTableViewCell.swift
//  CoreDataDemo
//
//  Created by Abhishek Gupta on 27/04/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit

class customeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
