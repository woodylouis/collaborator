//
//  TextFiledTableViewCell.swift
//  Collaborator
//
//  Created by WENJIN LI on 14/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

class TextFiledTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskDetailCell: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
