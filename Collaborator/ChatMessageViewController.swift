//
//  ChatMessageViewController.swift
//  Collaborator
//
//  Created by WENJIN LI on 24/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//


import UIKit

let chatSectionHeader = ["Chat", "History"]
enum chatSections: Int {
    case chatSection = 0
    case historySection = 1
}

class ChatMessageViewController: UITableViewController {
    
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
            let textFiled: UITextField = cell.typingField
                textFiled.text = "hey"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatHistory", for: indexPath)
            cell.textLabel?.text = "world"
            return cell
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatSectionHeader.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
