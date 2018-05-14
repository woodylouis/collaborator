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
enum subSections: Int {
    case taskSection = 0
    case collaboratorSection = 1
    case logSection = 2
}

class DetailViewController: UITableViewController, UITextFieldDelegate {

    var objects = subsectionHeaders.map { (_: String) -> [Task] in return [Task]() } //.map
    var delegate: DetailViewControllerDelegate?
    var indexPath: IndexPath?
    //@IBOutlet weak var detailDescriptionField: UITextField!
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        detailItem?.taskName = textField.text ?? ""
        delegate?.detailViewControllerDidUpdate(self)
        return true
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
        //detailItem?.taskName = detailDescriptionField.text ?? ""
        configureView()
        delegate?.detailViewControllerDidUpdate(self)
        
    }
    
    var detailItem: Task? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "task") as! TextFiledTableViewCell
        if let detail = detailItem {
            if let field = taskCell.taskDetailCell {
                field.text = detail.taskName
            }
        }
    }
    
    // MARK: - table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subsectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 1
        return objects[section].count
    }
    
    // Switch section by identifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        guard let subSection = subSections(rawValue: indexPath.section) else {
            fatalError("Unexpectedly got \(indexPath.section)")
        }
        switch subSection {
        case .taskSection:
            identifier = "task"
        case .collaboratorSection:
            identifier = "collaborator"
        case .logSection:
            identifier = "log"
            //        default:
            //            fatalError("Unexpectedly got \(indexPath.section)")
        }
        
        //       let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TextFiledTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TextFiledTableViewCell
        let textFiled: UITextField = cell.taskDetailCell
        textFiled.text = detailItem?.taskName
        textFiled.delegate = self
        return cell
    }
    
    // MARK: - to show sub header i.e. TASK, COLLABORATORS, LOG
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subsectionHeaders[section]
    }
    
    
    
}

