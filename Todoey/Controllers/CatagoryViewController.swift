//
//  CatagoryTableViewController.swift
//  Todoey
//
//  Created by Musaed alameel on 29/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    var catagoryArray: [Catagory] = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatagorys()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    //MARK: - tableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        
        return cell
        
    }
    
    
    //MARK: - tableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagoryArray[indexPath.row]
            
        }
        
    }
    
    //MARK: - addButton method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "add new catagory", message: "", preferredStyle: .alert)
        
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "add catagory", style: .default) { (action) in
            
            if alertTextField.text != nil {
                
                let newCatagory = Catagory(context: self.context)
                
                newCatagory.name = alertTextField.text!
            
                self.catagoryArray.append(newCatagory)
                
                self.saveCatagorys()
            
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "new Catagory"
            
            alertTextField = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - save and load methods
    
    func saveCatagorys() {
        
        do {
          try self.context.save()
        } catch {
            print("Error saving catagorys: \(error)")
        }
        
    }
    
    func loadCatagorys() {
        
        let request : NSFetchRequest<Catagory> = Catagory.fetchRequest()
        
        do {
           catagoryArray = try context.fetch(request)
            
        } catch {
            print("Error loading catagorys: \(error)")
        }
        
        
    }
    
}
