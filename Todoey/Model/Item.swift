//
//  Item.swift
//  Todoey
//
//  Created by kibeom lee on 2018. 1. 24..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
