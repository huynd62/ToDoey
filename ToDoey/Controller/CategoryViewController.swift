//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/18/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var category:Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    //MARK:- loadData
    func loadData(with categor:String? = nil){
        if categor == nil{
            category = realm.objects(Category.self)
        }else{
            category = realm.objects(Category.self).filter("name contains[cd] %@", categor!)
        }
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.count ?? 1
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Catergory", message: "", preferredStyle: .alert)
        var categoryTextField = UITextField()
        alert.addTextField { (textfield) in
            textfield.placeholder = "Category name"
            categoryTextField = textfield
        }
        let action  = UIAlertAction(title: "add Category", style:
        .default) { (action) in
            let newCategory = Category()
            newCategory.name = categoryTextField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category?[indexPath.item].name ?? "Not Category added yet"
        return cell
    }
    
    //MARK:- SaveData
    func save(category:Object){
        do {
            try realm.write{
                realm.add(category)
            }
            tableView.reloadData()
        } catch (let error) {
            print(error)
        }
    }
    //MARK:- AddCategory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            if let ItemVC = segue.destination as? ViewController{
                if let indexPath = tableView.indexPathForSelectedRow{
                    ItemVC.selectedCategory = category?[indexPath.item]
                }
            }
        }
    }
}
//MARK:- SearchBar methods
extension CategoryViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchWord = searchBar.text
        loadData(with: searchWord)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
