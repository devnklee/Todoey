//
//  Category.swift
//  Todoey
//
//  Created by kibeom lee on 2018. 1. 24..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    var items = List<Item>()
    
}
