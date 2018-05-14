//
//  Task.swift
//  Collaborator
//
//  Created by WENJIN LI on 1/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

class Task {
    var taskName: String = ""
    
    init(taskName: String) {
        self.taskName = taskName
    }
}
    
extension Task: CustomStringConvertible {
        var description: String{
            return taskName
        }
}

