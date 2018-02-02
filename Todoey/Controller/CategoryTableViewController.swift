//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by kibeom lee on 2018. 1. 23..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeCellController  {
    
    let realm = try! Realm()
    var categoryContainer : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    //*********************************************************
    //MARK: - tableview datasource methods
    //*********************************************************
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryContainer![indexPath.row].name
        if let colour = UIColor(hexString: categoryContainer![indexPath.row].colour) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }

        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryContainer!.count
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let cellForDelete = self.categoryContainer?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(cellForDelete)
                }
            }
            catch {
                print("error \(error)")
            }
        }
        
        //tableView.reloadData()
        
    }
    
    
    //*********************************************************
    //MARK: - tableview delegate methods
    //*********************************************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryContainer?[indexPath.row]
        }
    }
    
    //MARK: = ADD new categories
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happend when user click Add Item button
            if textField.text != "" {
                
                
                do {
                    try self.realm.write {
                        let newItem = Category()
                        newItem.name = textField.text!
                        newItem.colour = RandomFlatColorWithShade(.light).hexValue()
                        self.realm.add(newItem)
                    }
                }catch {
                    print("Error saving data \(error)")
                }
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation methods
    
    func loadData() {
        categoryContainer = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

