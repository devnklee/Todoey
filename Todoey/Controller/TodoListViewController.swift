//
//  ViewController.swift
//  Todoey
//
//  Created by kibeom lee on 2018. 1. 20..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeCellController{
    
    let realm = try! Realm()
    var itemContainer : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colour = selectedCategory?.colour {
            
            title = selectedCategory?.name
            
            guard let nav = navigationController?.navigationBar else {
                fatalError("error getting nav bar")
            }
            nav.barTintColor = UIColor(hexString: colour)
            searchBar.barTintColor = UIColor(hexString: colour)
        }
        
    }
    
    //MARK: - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemContainer!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemContainer![indexPath.row].title
        
        let percentage : CGFloat = CGFloat(indexPath.row) / CGFloat((itemContainer?.count)!)
        if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: percentage){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        
        
        if itemContainer![indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    override func deleteCell(at indexPath: IndexPath) {
        if let cellForDelete = self.itemContainer?[indexPath.row]{
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
    
    
    //MARK: - TableView delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* Delete Item from database
         context.delete(itemArray[indexPath.row])
         itemArray.remove(at: indexPath.row)
         */
        do{
            try realm.write {
                itemContainer![indexPath.row].done = !itemContainer![indexPath.row].done
                
            }
        }catch {
            
        }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happend when user click Add Item button
            if textField.text != "" {
                
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        self.selectedCategory?.items.append(newItem)
                    }
                    
                }catch {
                    
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
    
    //MARK: - encode and decode Data with CoreData
    
    func loadData() {
        itemContainer = selectedCategory?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
    
}


//MARK: - SEARCH BAR

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemContainer = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}

