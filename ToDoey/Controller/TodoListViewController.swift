//
//  ViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/11/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    var items:[Item] = []
    
    var selectedCategory:Category? {
        didSet{
                loadItems()
            }
        }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 1
        longPress.delegate = self
        self.tableView.addGestureRecognizer(longPress)
    }
    
    //MARK:- longPressAction
    @objc func longPressAction(longPressGesture:UIGestureRecognizer){
        let loc = longPressGesture.location(in: self.tableView)
        var titleTextField = UITextField()
        if let indexPath = self.tableView.indexPathForRow(at: loc){
            print(self.items[indexPath.item].title!)
            
            let alert = UIAlertController(title: "Change title", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Change Title"
                titleTextField = textField
            }
            
            let action = UIAlertAction(title: "Change Title of row \(indexPath.row)", style: .default) { (action) in
                self.items[indexPath.item].title = titleTextField.text!
                self.saveData()
                print("change completed")
                
            }
            
            alert.addAction(action)
            present(alert, animated: true ,completion: nil)
            
        }else{
            print("This is not a row")
        }
    }
    
    //MARK:- loadItems
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),addPredicate:NSPredicate? = nil){
        do{
            request.fetchLimit = 100
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            let defaultPredicate = NSPredicate(format: "parentCategory.name matches[cd] %@", selectedCategory!.name!)
            if let additionPredicate = addPredicate {
                let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate,additionPredicate])
                request.predicate = combinedPredicate
            }else{
                request.predicate = defaultPredicate
            }
            items = try context.fetch(request)
            tableView.reloadData()
        }catch(let error){
            print(error)
        }
        
    }
    
    //MARK:- TableView DataSource's methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item  = items[indexPath.item]
        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done == true ?  .checkmark:.none
        return cell
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        item.done = !item.done
        //uncheck
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            //check
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK:- Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New ToDoey", message: "", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler:{
            (alertTextField) in
            alertTextField.placeholder = "Create new ToDoey"
        })
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safetextFields = alert.textFields{
                for textField in safetextFields {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let newItem = Item(context: context)
                    newItem.title = textField.text
                    newItem.done = false
                    newItem.parentCategory = self.selectedCategory
                    self.items.append(newItem)
                }
            }
            self.saveData()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
    //MARK:- save
    func saveData(){
        do{
            try context.save()
            tableView.reloadData()
        }catch(let error){
            print(error.localizedDescription)
        }
    }
    
}
//MARK:- UISearchBarDelegate
extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("fuck")
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let searchWord = searchBar.text!
        let addPredicate = NSPredicate(format: "title contains[cd] %@", searchWord)
        self.loadItems(with: request,addPredicate: addPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        }
    }
}




