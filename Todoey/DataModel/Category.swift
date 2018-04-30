//
//  Catagory.swift
//  Todoey
//
//  Created by Musaed alameel on 30/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
