//
//  ToDoListViewController.swift
//  ToDO
//
//  Created by Daljeet Singh Chhabra on 09/06/18.
//  Copyright © 2018 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [ItemModel]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        print(dataFilePath!)

        loadData()
        
    }
    

    
    ///////////////////////////////////////////////
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //
            
            let newItem = ItemModel()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new ToDo"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
        
        
    }
    
    //MARK -  Data Model Manipulation
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            print(data)
            try data.write(to: dataFilePath!)
            
        }catch {
            print("Error encoding items, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData() {
        
      
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([ItemModel].self , from: data )
            }catch {
                print("Error decoding the data : \(error)")
            }
        }
        
    }
    
    
    
    //MARK: - TableView Datasource Methods here
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isDone == true ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
