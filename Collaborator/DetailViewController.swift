//
//  DetailViewController.swift
//  Collaborator
//
//  Created by Wenjin Li on 26/4/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate {
    func detailViewControllerDidUpdate(_ detailViewController: DetailViewController)
    //func detailViewControllerDidCancel(_ detailViewController: DetailViewController)
}

let subsectionHeaders = ["TASK", "COLLABORATORS", "LOG"]

class DetailViewController: UITableViewController, UITextFieldDelegate {

    var delegate: DetailViewControllerDelegate?
    @IBOutlet weak var detailDescriptionField: UITextField!
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        detailItem?.taskName = textField.text ?? ""
        delegate?.detailViewControllerDidUpdate(self)
        return true
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let field = detailDescriptionField{
                field.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        detailItem?.taskName = detailDescriptionField.text ?? ""
        delegate?.detailViewControllerDidUpdate(self)
    }
    
    var detailItem: Task? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    // MARK: - to show sub header i.e. TASK, COLLABORATORS, LOG
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subsectionHeaders[section]
    }
    
}

