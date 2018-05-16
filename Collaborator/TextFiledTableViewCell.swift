//
//  TextFiledTableViewCell.swift
//  Collaborator
//
//  Created by WENJIN LI on 14/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

protocol TextFiledTableViewCellDelegate: class {
    func LocateTextFiled(_ textFiledTableViewCell: TextFiledTableViewCell)
}

class TextFiledTableViewCell: UITableViewCell, UITextFieldDelegate {
    var taskRow = Int()
    var taskSection = Int()
    @IBOutlet weak var taskDetailCell: UITextField!
    weak var delegate: TextFiledTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func selectTaskField(_ sender: Any) {
        delegate?.LocateTextFiled(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
