//
//  ChatMessageViewController.swift
//  Collaborator
//
//  Created by WENJIN LI on 24/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//


import UIKit

// Two sections on the chat view
let chatSectionHeader = ["Chat", "History"]
enum chatSections: Int {
    case chatSection = 0
    case historySection = 1
}

class ChatMessageViewController: UITableViewController, UITextFieldDelegate {
    // var objects = chatSectionHeader.map {(_: String) -> [Task] in return [Task]() }
    var detailItem: Task? {
        didSet {
            
        }
    }
    
    func updateLogInChat (chatTaskFieldIndex: IndexPath){
        let theData = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let currentDate = formatter.string(from: theData)
        let chitChatArea = tableView.cellForRow(at: chatTaskFieldIndex) as! ChatTypingTableViewCell
        detailItem?.logDetail.append("\(currentDate) \(chitChatArea.typingField.text!)")
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let i = IndexPath(row: 0, section: 0)
        updateLogInChat(chatTaskFieldIndex: i)
        tableView.reloadData()
        return true
    }
    
    
    
    //tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        guard let chatSection = chatSections(rawValue: indexPath.section) else {
            fatalError("Unexpectedly got \(indexPath.section)")
        }
        switch chatSection {
        case .chatSection:
            identifier = "chat"
        case .historySection:
            identifier = "chatHistory"
        }
        
        if identifier == "chat" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chat", for: indexPath) as! ChatTypingTableViewCell
            // let textFiled: UITextField = cell.typingField
            // textFiled.text = "hey"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatHistory", for: indexPath)
            cell.textLabel?.text = detailItem?.logDetail[0]
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatSectionHeader.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return detailItem?.logDetail.count ?? 1
        }else{
            return 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
