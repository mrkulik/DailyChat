//
//  File.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/27/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class Channel {
    
    private var _name = ""
    private var _id = ""
    private var _group = ""
    
    init(id: String, name: String, group: String) {
        _id = id
        _name = name
        _group = group
    }
    
    var name : String {
        get {
            return _name
        }
    }
    
    var id: String {
        return _id
    }
    
    var group: String {
        return _group
    }
    
}
