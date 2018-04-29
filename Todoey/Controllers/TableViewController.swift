//
//  ViewController.swift
//  Todoey
//
//  Created by Musaed alameel on 28/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchBarDelegate {

    var itemArray : [Item] = [Item]()
    let defaults = UserDefaults.standard
    var selectedCatagory : Catagory? {
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
//         Do any additional setup after loading the view, typically from a nib.
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].itemText
        
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        saveItems()
        
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
                
                let newItem = Item(context: self.context)
                newItem.itemText = alertTextField.text!
                newItem.isChecked = false
                newItem.parentCatagory = self.selectedCatagory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
          
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
        
        
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCatagory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, catagoryPredicate])
        } else {
            request.predicate = catagoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }

    }
    
    //MARK: - search bar protocols and methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "itemText CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "itemText", ascending: true)]
        
        loadItems(with: request, with: predicate)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            print("Done")
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "itemText CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "itemText", ascending: true)]
        
        loadItems(with: request, with: predicate)
        
        tableView.reloadData()
        }
        
    }
    
    
}

