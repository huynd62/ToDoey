//
//  ViewController.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/11/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var items:[Item] = [Item("Học IOS",false),
                        Item("Học Tiếng Anh",false),
                        Item("Tập Cardio",false),
                        Item("Ngủ Sớm",false)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        do{
//            if let decoded = defaults.object(forKey: "ToDoListModel") as? Data {
//                if let Bitems = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [Item.self], from: decoded) as? [Item] {
//                    self.items = Bitems
//                }
//            }
//        }catch(let error){
//            print(error.localizedDescription)
//        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
//        self.saveData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
//        self.saveData()
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
        item.done = !item.done!
        //uncheck
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
        //check
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
                    self.items.append(Item(textField.text!,false))
                }
            }
//            self.saveData()
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true ,completion: nil)
    }
    //MARK:- save
//    func saveData(){
//        do{
//            let itemAsData = try NSKeyedArchiver.archivedData(withRootObject: self.items, requiringSecureCoding: true)
//            self.defaults.set(itemAsData, forKey: "ToDoListModel")
//            self.defaults.synchronize()
//        }catch(let error){
//            print(error.localizedDescription)
//        }
//    }
    
}




