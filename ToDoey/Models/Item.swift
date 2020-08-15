//
//  Item.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/12/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import UIKit

class Item:Codable{
    
    var title:String = ""
    var done:Bool = false
    
    init(_ title:String,_ done:Bool) {
        self.title = title
        self.done = done
    }
}
