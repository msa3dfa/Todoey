//
//  ViewController.swift
//  Todoey
//
//  Created by Musaed alameel on 28/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var itemArray = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(tableView.cellForRow(at: indexPath)!.textLabel!.text!)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIAlert
            
            if alertTextField.text != "" {
                
                self.itemArray.append(alertTextField.text!)
                
                self.tableView.reloadData()
                
            } else {
               
            }
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            
            alertTextField = textField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

