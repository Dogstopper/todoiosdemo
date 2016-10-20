//
//  TodoAPIController.swift
//  TodoAppConnectJS
//
//  Created by Stephen Schwahn on 10/20/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

class TodoAPI {
    open static func get(callback: @escaping ([TodoModel]) -> Void) {
        API.request(.getAllTodos(User.currentUser.accessToken), asArray: { todosArray, err in
            var allTodos: [TodoModel] = []
            
            if err == .NO_ERROR {
                allTodos += todosArray.map({TodoModel(json: $0)})
            }
            return callback(allTodos)
        })
    }
    
    open static func get(todo: String, callback: @escaping (TodoModel) -> Void) {
        API.request(.getTodo(User.currentUser.accessToken, todo), completionHandler: { json, err in
            if err == .NO_ERROR {
                return callback(TodoModel(json: json))
            }
            return callback(TodoModel(json: [:]))
        })
    }
    
    open static func create(todo: String, date: String, callback: @escaping (TodoModel, Bool) -> Void) {
        API.request(.createTodo(User.currentUser.accessToken, todo, date), completionHandler: { json, err in
            if err == .NO_ERROR {
                return callback(TodoModel(json: json), true)
            }
            return callback(TodoModel(json: [:]), false)
        })
    }
    
    open static func delete(todo: String, callback: @escaping (Bool) -> Void) {
        API.request(.deleteTodo(User.currentUser.accessToken, todo), completionHandler: { json, err in
            if err == .NO_ERROR {
                return callback(true)
            }
            return callback(false)
        })
    }
}
