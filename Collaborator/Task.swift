//
//  Task.swift
//  Collaborator
//
//  Created by WENJIN LI on 1/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//
import MultipeerConnectivity

class Task: Codable {
    var taskName: String
    var collaboratorDetail: String
    var logDetail: Array<String>
    var test = "transfer data test"
    init(taskName: String, collaboratorDetail: String, logDetail: Array<String>) {
        self.taskName = taskName
        self.collaboratorDetail = collaboratorDetail
        self.logDetail = logDetail
    }
}
    
extension Task: CustomStringConvertible {
    var description: String {
            return taskName
        }
    var log: Array<String> {
            return logDetail
    }
}

extension Task {
    var json:Data {
        get {return try! JSONEncoder().encode(test)}
        set {test = try! JSONDecoder().decode(String.self,  from: newValue)}
        
    }
}

