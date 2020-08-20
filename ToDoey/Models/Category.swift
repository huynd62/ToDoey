//
//  Category.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/20/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name:String = ""
    var items = List<Item>()
}

