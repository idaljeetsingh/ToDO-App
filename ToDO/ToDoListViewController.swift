//
//  ToDoListViewController.swift
//  ToDO
//
//  Created by Daljeet Singh Chhabra on 09/06/18.
//  Copyright © 2018 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
            
        }
    }
    
    var itemArray = ["List 1", "List 2", "List 3"]
    
    let defaults = UserDefaults.standard
    
    ///////////////////////////////////////////////
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
            
            
        }
        self.tableView.reloadData()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new ToDo"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
        
        
    }
    
    
    
    //MARK: - TableView Datasource Methods here
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
       return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(indexPath.row)
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {

            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
}

