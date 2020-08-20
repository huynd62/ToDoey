//
//  ViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/11/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    
    let realm = try! Realm()
    
    var items:Results<Item>?
    
    var selectedCategory:Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 1
        longPress.delegate = self
        self.tableView.addGestureRecognizer(longPress)
        tableView.reloadData()
    }
    
    //MARK:- longPressAction
    @objc func longPressAction(longPressGesture:UIGestureRecognizer){
        let loc = longPressGesture.location(in: self.tableView)
        var titleTextField = UITextField()
        if let indexPath = self.tableView.indexPathForRow(at: loc){
            let alert = UIAlertController(title: "Change title", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Change Title"
                titleTextField = textField
            }
            
            let action = UIAlertAction(title: "Change title of row this items", style: .default) { (action) in
                do{
                try self.realm.write{
                    self.items?[indexPath.item].title = titleTextField.text!
                    }
                }catch(let error){
                    print(error)
                }
                self.tableView.reloadData()
            }
            
            alert.addAction(action)
            present(alert, animated: true ,completion: nil)
            
        }else{
            print("This is not a row")
        }
    }
    
    //MARK:- loadItems
    func loadItems(with item:String? = nil){
        if item == nil{
            items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        }else{
            items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true).filter("title contains[cd] %@", item!)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK:- TableView DataSource's methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item  = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType =  item.done == true ?  .checkmark:.none
        }else{
            cell.textLabel?.text = "No item added"
        }
        return cell
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try realm.write{
                let item = items?[indexPath.item]
                item!.done = !item!.done
            }
            
        }catch(let error){
            print(error)
        }
        DispatchQueue.main.async {
            //uncheck
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }else{
                //check
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }
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
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.done = false
                    newItem.dateCreated = Date()
                    self.save(item: newItem)
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
    
    //MARK:- save
    func save(item:Object){
        do{
            try realm.write{
                realm.add(item)
                selectedCategory!.items.append(item as! Item)
            }
            tableView.reloadData()
        }catch(let error){
            print(error.localizedDescription)
        }
    }
    
}
//MARK:- UISearchBarDelegate
extension ViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchWord = searchBar.text
        loadItems(with:searchWord)
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




