//
//  TodoModel.swift
//  TodoAppConnectJS
//
//  Created by Stephen Schwahn on 10/20/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

class TodoModel : JsonSerializable, Equatable {
    
    var id: String = ""
    var todoItem: String = ""
    var dueDate: Date = Date(timeIntervalSinceNow: 0.0)
    var dueDateString: String {
        return formatter.string(from: dueDate)
    }
    
    private let formatter = ISO8601DateFormatter()
    
    required init(json: [String : AnyObject]) {
        self.deserialize(json: json)
    }
    
    func serialize() -> [String : AnyObject] {
        var jsonDic: [ String : AnyObject ] = [:]
        
        jsonDic["_id"] = id as AnyObject?
        jsonDic["todo"] = todoItem as AnyObject?
        jsonDic["date"] = formatter.string(from: dueDate) as AnyObject?
        
        return jsonDic
    }
    
    func deserialize(json: [String : AnyObject]) {
        self.id = json["_id"] as? String ?? ""
        self.todoItem = json["todo"] as? String ?? ""
        if let due = json["date"] as? String {
            self.dueDate = formatter.date(from: due)!
        }
    }
}

func ==(lhs: TodoModel, rhs: TodoModel) -> Bool {
    return lhs.id == rhs.id && lhs.todoItem == rhs.todoItem && lhs.dueDate == rhs.dueDate
}
