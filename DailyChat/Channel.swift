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
