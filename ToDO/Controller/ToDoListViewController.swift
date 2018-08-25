//
//  ToDoListViewController.swift
//  ToDO
//
//  Created by Daljeet Singh Chhabra on 09/06/18.
//  Copyright © 2018 Daljeet Singh Chhabra. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loadData()
        
    }
    

    
    ///////////////////////////////////////////////
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
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
    
//////////////////////////////////////////////////////////////
    
    //MARK: - TableView Datasource Methods here
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
////////////////////////////////////////////////////////////////
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

////////////////////////////////////////////////////////////////
    
    //MARK: -  Data Model Manipulation
    
    func saveData() {
        
        do{
            try context.save()
            
        }catch {
            
            print("Error saving context... \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching request... \(error) ")
        }
        
        tableView.reloadData()

    }

}

    //MARK: - SEARCH METHODS HERE..

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        loadData(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() 
            }
        }
        
    }
    
}
