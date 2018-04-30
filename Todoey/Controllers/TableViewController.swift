//
//  ViewController.swift
//  Todoey
//
//  Created by Musaed alameel on 28/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController, UISearchBarDelegate {

    var itemArray : Results<Item>?
    let defaults = UserDefaults.standard
    var selectedCatagory : Catagory? {
        didSet{
            loadItems()
        }
    }
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
//         Do any additional setup after loading the view, typically from a nib.
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.itemText
            cell.accessoryType = item.isChecked ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.isChecked = !item.isChecked
                }
            } catch {
                print("Error updating data: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            
            if alertTextField.text != "" {
                
                
                
                if let currentCategory = self.selectedCatagory {
                  
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.itemText = alertTextField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving Items: \(error)")
                    }
                }

                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            
            alertTextField = textField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - save and load data
    
 

    func loadItems() {

        itemArray = selectedCatagory?.items.sorted(byKeyPath: "itemText", ascending: true)

    }

    //MARK: - search bar protocols and methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("itemText CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemText", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {

        loadItems()
            
        itemArray = itemArray?.filter("itemText CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemText", ascending: true)
            
        tableView.reloadData()
        }

    }
    
    


}

