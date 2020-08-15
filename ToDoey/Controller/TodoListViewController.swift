//
//  ViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/11/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,UIGestureRecognizerDelegate {
    
    
    var items:[Item] = []
    
    let dataFilePath = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent("Items.plist")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 1
        longPress.delegate = self
        self.tableView.addGestureRecognizer(longPress)
        
    }
    
    
    //MARK:- longPressAction
    @objc func longPressAction(longPressGesture:UIGestureRecognizer){
        let loc = longPressGesture.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: loc){
            print(self.items[indexPath.item].title)
        }else{
            print("This is not a row")
        }
    }
    
    //MARK:- loadItems
    func loadItems(){
        if let data  = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                self.items = try decoder.decode([Item].self, from: data)
            }catch(let error){
                print(error)
            }
        }else{
            print("There was an error when loading data")
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
                    self.items.append(Item(textField.text!,false))
                }
            }
            self.saveData()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //MARK:- save
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.items)
            try data.write(to:self.dataFilePath!)
            tableView.reloadData()
        }catch(let error){
            print(error.localizedDescription)
        }
    }
    
}




