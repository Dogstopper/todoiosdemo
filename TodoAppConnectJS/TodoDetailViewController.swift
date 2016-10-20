//
//  TodoDetailViewController.swift
//  TodoAppConnectJS
//
//  Created by Stephen Schwahn on 10/20/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class TodoDetailViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var todo: TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableView Controller overrides
    
    // The text view does not fill the whole space, and we don't want to confuse users that 
    // accidentally tap on the row instead of the textview in the row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveTodoItem" {
            todo = TodoModel(json: [:])
            todo!.dueDate = dueDatePicker.date
            todo!.todoItem = nameTextField.text ?? ""
        }
    }
}
