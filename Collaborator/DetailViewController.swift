//
//  DetailViewController.swift
//  Collaborator
//
//  Created by Wenjin Li on 26/4/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func detailViewControllerDidUpdate(_ detailViewController: DetailViewController)
}

let subsectionHeaders = ["TASK", "COLLABORATORS", "LOG"]
enum subSections: Int {
    case taskSection = 0
    case collaboratorSection = 1
    case logSection = 2
}

class DetailViewController: UITableViewController, UITextFieldDelegate, TextFiledTableViewCellDelegate, LogTextFiledTableViewCellDelegate {
    var objects = subsectionHeaders.map { (_: String) -> [Task] in return [Task]() } //.map
    var delegate: DetailViewControllerDelegate?
    var testFiledTableViewCell: TextFiledTableViewCell? = nil
    var logTableViewCell: LogTableViewCell? = nil
    var indexPath: IndexPath?
    var textRowCell = Int()
    var textSectionCell = Int()
    var peerName = [AnyObject]()
    var theHostOwner = ""
 
    // to get row and section for the text filed
    func LocateTextFiled(_ textFiledTableViewCell: TextFiledTableViewCell) {
        textRowCell = textFiledTableViewCell.taskRow
        textSectionCell = textFiledTableViewCell.taskSection
    }
    
    // to get row and section for the log's
    func LocateLogField(_ logTextFiledTableViewCell: LogTableViewCell) {
        textRowCell = logTextFiledTableViewCell.logRow
        textSectionCell = logTextFiledTableViewCell.logSection
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        let taskIndexPath = IndexPath(row: textRowCell, section: textSectionCell)
        // return detail for in log Section
        if textSectionCell == 0 {
            StoreHistory(taskIndexPath: taskIndexPath)
        } else if textSectionCell == 2 {
            StoreAHistory(taskIndexPath: taskIndexPath)
        }
        delegate?.detailViewControllerDidUpdate(self)
        tableView.reloadData()
        return true
    }
    
    // For store history's date
    func StoreHistory(taskIndexPath: IndexPath){
        let theDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH:mm:ss"  //Australian Date format
        //formatter.dateStyle = .short
        let currentDate = formatter.string(from: theDate)
        let defaultChange = "\(currentDate) Wenjin Li changed topic to"
        
        let taskCell = tableView.cellForRow(at: taskIndexPath) as! TextFiledTableViewCell
        detailItem?.taskName = taskCell.taskDetailCell.text ?? ""
        detailItem?.logDetail.append("\(defaultChange) \"\(taskCell.taskDetailCell.text!)\"")
    }
    
    // the function use for store log data
    func StoreAHistory(taskIndexPath: IndexPath){
        let logCell = tableView.cellForRow(at: taskIndexPath) as! LogTableViewCell
        detailItem?.logDetail[taskIndexPath.row] = logCell.logDetailCell.text ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.detailViewControllerDidUpdate(self)
        
    }
    
    var detailItem: Task? {
        didSet {
            // Update the view.
            //configureView()
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
        print("get name in detail \(peerName)")
        print("count peers \(peerName.count)")
        configureView()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatMessageViewController{
            let controller = segue.destination as? ChatMessageViewController
            controller?.detailItem = detailItem
        }
    }
    
    // MARK: - table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subsectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return peerName.count
        } else if section == 2 {
            return detailItem?.logDetail.count ?? 1
        } else {
            return 1
        }
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
        // let the program identify the cell and edit its text cell
        if identifier == "task" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath) as! TextFiledTableViewCell
            let textFiled: UITextField = cell.taskDetailCell
            textFiled.text = detailItem?.description
            cell.taskRow = indexPath.row
            cell.taskSection = indexPath.section
            cell.delegate = self
            return cell
        } else if identifier == "collaborator" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collaborator", for: indexPath) as! CollaboratorTableViewCell
            cell.textLabel?.text = String(describing: peerName[indexPath.row].displayName ?? "")
            cell.detailTextLabel?.text = theHostOwner
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "log", for: indexPath) as! LogTableViewCell
            let logTextField: UITextField = cell.logDetailCell
            logTextField.text = detailItem?.logDetail[indexPath.row]
            cell.delegate = self
            cell.logRow = indexPath.row
            cell.logSection = indexPath.section
            return cell
        }
    }
    
    // MARK: - to show sub header i.e. TASK, COLLABORATORS, LOG
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subsectionHeaders[section]
    }
}

