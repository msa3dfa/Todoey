//
//  Item.swift
//  Todoey
//
//  Created by Musaed alameel on 29/04/2018.
//  Copyright © 2018 Musaed alameel. All rights reserved.
//

import Foundation

class Item: Codable{
    
    var itemText : String
    var isChecked : Bool = false
    
    init (text: String) {
        
        itemText = text
        
    }
    
}
