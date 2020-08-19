//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/18/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category:[Category] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.reloadData()
    }
    //MARK:- loadData
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            let context = self.context
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            category = try context.fetch(request)
            tableView.reloadData()
        }catch(let error){
            print(error)
        }
    }
    
    // MARK: - Table view data source
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 2
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category.count
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
            let newCategory = Category(context: self.context)
            newCategory.name = categoryTextField.text
            self.category.append(newCategory)
            self.saveData()
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category[indexPath.item].name
        cell.accessoryType = category[indexPath.item].done == true ? .checkmark:.none
        return cell
    }
    
    //MARK:- SaveData
    func saveData(){
        do {
            try context.save()
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
                    ItemVC.selectedCategory = category[indexPath.item]
                }
            }
        }
    }
}
//MARK:- SearchBar methods
extension CategoryViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name contains[cd] %@", searchBar.text!)
        loadData(with: request)
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
