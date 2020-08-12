//
//  Item.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/12/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding{
    
    let title:String?
    var done:Bool?
    
    init(_ title:String,_ done:Bool) {
        self.title = title
        self.done = done
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title,forKey: "title")
        coder.encode(done,forKey: "done")
    }
    
    required convenience init?(coder: NSCoder) {
        let title = coder.decodeObject(forKey: "title") as! String
        let done = coder.decodeBool(forKey: "done")
        self.init(title,done)
     }
}
