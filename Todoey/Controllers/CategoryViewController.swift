//
//  CatagoryTableViewController.swift
//  Todoey
//
//  Created by Musaed alameel on 29/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryViewController: UITableViewController {

    let realm = try! Realm()
    var catagoryArray: Results<Catagory>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCatagorys()
       
        
    }

    //MARK: - tableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        
        cell.textLabel?.text = catagoryArray?[indexPath.row].name ?? "No catagories added yet"
        
        return cell
        
    }
    
    
    //MARK: - tableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if catagoryArray != nil {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagoryArray?[indexPath.row]
            
        }
        
    }
    
    //MARK: - addButton method
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "add new catagory", message: "", preferredStyle: .alert)
        
        var alertTextField = UITextField()
        
        let action = UIAlertAction(title: "add catagory", style: .default) { (action) in
            
            if alertTextField.text != nil {
                
                let newCatagory = Catagory()
                
                newCatagory.name = alertTextField.text!
                
                self.save(catagory: newCatagory)
            
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
    
    func save(catagory: Catagory) {
        
        do {
            try realm.write {
                realm.add(catagory)
            }
        } catch {
            print("Error saving catagorys: \(error)")
        }
        
    }
    
    func loadCatagorys() {
        
        catagoryArray = realm.objects(Catagory.self)
        
    }
    
}
