//
//  CollaboratorTableViewCell.swift
//  Collaborator
//
//  Created by WENJIN LI on 16/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

protocol CollaCellTableViewCellDelegate: class {
    func collaCellPosition(_ collaCellTableViewCell: CollaboratorTableViewCell)
}

class CollaboratorTableViewCell: UITableViewCell {

//    @IBOutlet weak var collaboratorDetailCell: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
