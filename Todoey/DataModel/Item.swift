//
//  Item.swift
//  Todoey
//
//  Created by Musaed alameel on 30/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var itemText: String = ""
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
    
}
