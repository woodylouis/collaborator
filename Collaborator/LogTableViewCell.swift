//
//  LogTableViewCell.swift
//  Collaborator
//
//  Created by WENJIN LI on 16/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

protocol LogTextFiledTableViewCellDelegate: class {
    func LocateLogField(_ logTextFiledTableViewCell: LogTableViewCell)
}

class LogTableViewCell: UITableViewCell, UITextFieldDelegate {
    var logRow = Int()
    var logSection = Int()
    @IBOutlet weak var logDetailCell: UITextField!
    weak var delegate: LogTextFiledTableViewCellDelegate?
    @IBAction func selectLogField(_ sender: Any) {
        delegate?.LocateLogField(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
