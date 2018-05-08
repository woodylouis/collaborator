//
//  MasterViewController.swift
//  Collaborator
//
//  Created by Wenjin Li on 26/4/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit

// Section Title
let sectionHeaders = ["Ongoing", "Done"]
enum Sections: Int {
    case ongoingSection = 0
    case doneSection = 1
}

//let sectionMappings: [ Int : Sections] = [
//    Sections.ongoingSection.rawValue: .ongoingSection,
//    Sections.doneSection.rawValue: .doneSection ]

///using func - traditional way 1
//func initialiseObjects(n: Int) -> [[Any]] {
//    var array = [[Any]]()
//    for _ in 0..<n {
//        array.append([Any]())
//    }
//    return array
//}

//using func - traditional way 2
//func initialiseObjects(_ a: [String]) -> [[Any]] {
//    let n = a.count
//    var array = [[Any]]()
//    for _ in 0..<n {
//        array.append([Any]())
//    }
//    return array
//}

//.map
//func f(_ s: String) -> [Any] {
//    return [Any]()
//}

//func initialiseObjects(_ a: [String]) -> [[Any]] {
//    return a.map { (_: String) -> [Any] in return [Any]() }
//}


class MasterViewController: UITableViewController, DetailViewControllerDelegate {
    
    //var toDoList:[Task] = []
    var indexPath: IndexPath?
    var detailViewController: DetailViewController? = nil
//    var objects = [[Any](), [Any]()]
//    var objects = initialiseObjects(n: sectionHeaders.count)
    var objects = sectionHeaders.map { (_: String) -> [Task] in return [Task]() } //.map

    func detailViewControllerDidUpdate(_ detailViewController: DetailViewController) {
//        let indexPath = objects[0].count - 1
//        if objects[0][indexPath].taskName == "" {
//            objects[0].remove(at: (indexPath))//        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Insert new object
    @objc
    func insertNewObject(_ sender: Any) {
        //objects[0].insert("Hello", at: 0)
        //var indexPaths = [IndexPath]()
        //for section in 0..<sectionHeaders.count }
        let indexPath = IndexPath(row: objects[0].count, section: 0)
        objects[0].append(Task(taskName: "To do item \(objects[0].count + 1)"))  //default item
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.indexPath = indexPath
        tableView.reloadData()
        performSegue(withIdentifier: "showDetail", sender: indexPath)
        
        //let indexPath1 = IndexPath(row: 0, section: 1)
        //}        
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        performSegue(withIdentifier: "showDetail", sender: indexPath)
//    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.section][indexPath.row] as! Task  //two dimensions
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
        if segue.identifier == "showDetail" {
            let indexPath : IndexPath
            if let indexPaths = tableView.indexPathForSelectedRow {
                indexPath = indexPaths
            }else{
                guard let indexPaths = sender as? IndexPath else{
                    fatalError()
                }
                indexPath = indexPaths
            }
            self.indexPath = indexPath
            let object = objects[indexPath.section][indexPath.row]
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
            controller.delegate = self
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }

    // Switch section by identifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Unexpectedly got \(indexPath.section)")
        }
        switch section {
        case .ongoingSection:
            identifier = "ongoing"
        case .doneSection:
            identifier = "done"
//        default:
//            fatalError("Unexpectedly got \(indexPath.section)")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        //let object = objects[indexPath.section][indexPath.row] as! NSDate //two dimensions
        let object = objects[indexPath.section][indexPath.row] //two dimensions
        //cell.textLabel!.text = object.description
        cell.textLabel!.text = object.taskName
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // Drag and drop in Edit mode
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        objects[destinationIndexPath.section].insert(objects[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
        objects[sourceIndexPath.section].remove(at: sourceIndexPath.row)
    }

}

