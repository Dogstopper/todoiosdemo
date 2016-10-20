//
//  ViewController.swift
//  TodoAppConnectJS
//
//  Created by Stephen Schwahn on 10/6/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    private var todos: [TodoModel] = []
    
    // MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoAPI.get(callback: { todos in
            self.todos = todos
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let dateString = DateFormatter.localizedString(from: todos[indexPath.row].dueDate, dateStyle: .medium, timeStyle: .medium)
        
        cell.textLabel?.text = "\(todos[indexPath.row].todoItem)"
        cell.detailTextLabel?.text = "\(dateString)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos.remove(at: indexPath.row)
            TodoAPI.delete(todo: todo.id, callback: { success in
                if success {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else {
                    self.todos.insert(todo, at: indexPath.row)
                    Helpers.displayAlertWithTitle("Removing item failed", viewController: self)
                }
            })
        }
    }

    // MARK: - Unwind Handlers
    
    @IBAction func cancelToTodoViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveTodoItem(segue:UIStoryboardSegue) {
        if let todoDetailsViewController = segue.source as? TodoDetailViewController {
            
            //add the new player to the players array
            if let todo = todoDetailsViewController.todo {
                TodoAPI.create(todo: todo.todoItem, date: todo.dueDateString, callback: { todoModel, success in
                    if success {
                        self.todos.append(todoModel) // Save with the updated id
                        
                        //update the tableView
                        let indexPath = IndexPath(row: self.todos.count - 1, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                    else {
                        Helpers.displayAlertWithTitle("Adding item failed", viewController: self)
                    }
                })
            }
        }
    }
}

