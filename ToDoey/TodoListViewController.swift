//
//  ViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/11/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    
    var items = ["Học IOS","Học Tiếng Anh","Tập Cardio","Ngủ Sớm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- TableView DataSource's methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.item]
        
        
        return cell
        
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.item])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
                    self.items.append(textField.text!)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    
}




