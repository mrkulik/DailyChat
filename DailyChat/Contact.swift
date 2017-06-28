//
//  Contact.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/25/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class Contact {
    
    private var _name = ""
    private var _id = ""
    
    init(id: String, name: String) {
        _id = id
        _name = name
    }
    
    var name : String {
        get {
            return _name
        }
    }
    
    var id: String {
        return _id
    }
    
}
