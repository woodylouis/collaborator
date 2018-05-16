//
//  Task.swift
//  Collaborator
//
//  Created by WENJIN LI on 1/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

class Task {
    var taskName: String = ""
    var collaboratorDetail: String = ""
    var logDetail: Array<String> = []
    
    init(taskName: String, collaboratorDetail: String, logDetail: Array<String>) {
        self.taskName = taskName
        self.collaboratorDetail = collaboratorDetail
        self.logDetail = logDetail
    }
}
    
extension Task: CustomStringConvertible {
        var description: String{
            return taskName
        }
}

