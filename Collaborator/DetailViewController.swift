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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
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
        
        
//        guard let taggedView = cell.viewWithTag(1), let textField = taggedView as? UITextField else {
//            return cell
//        }
        if identifier == "taskField" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TextFiledTableViewCell
            let textFiled: UITextField = cell.taskDetailCell
            textFiled.text = detailItem?.description
            cell.row = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            return cell
        } else if identifier == "collaborator"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "collaborator", for: indexPath) as! CollaboratorTableViewCell
            let textFiled: UITextField = cell.collaboratorDetailCell
            textFiled.text = detailItem?.taskName
            textFiled.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogTableViewCell
            let logTextField: UITextField = cell.logDetailCell
            logTextField.text = detailItem?.logDetail[indexPath.row]
            cell.delegate = self
            cell.row = indexPath.row
            cell.section = indexPath.section
            return cell
        }
//        textField.text = detailItem?.taskName
//        textField.delegate = self
//        return cell
        
    }
    
    // MARK: - to show sub header i.e. TASK, COLLABORATORS, LOG
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subsectionHeaders[section]
    }
    
    
    
}

