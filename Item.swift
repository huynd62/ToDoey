//
//  Item.swift
//  ToDoey
//
//  Created by Nguyễn Đức Huy on 8/20/20.
//  Copyright © 2020 nguyenduchuy. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object{
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property:"items")
}
