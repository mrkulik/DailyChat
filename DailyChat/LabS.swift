//
//  LabS.swift
//  DailyChat
//
//  Created by Gleb Kulik on 8/11/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class LabS {
    
    private var _name = ""
    private var _notes = ""
    private var _isCompleted = false
    
    init(name: String, notes: String, isCompleted: Bool){
        _name = name
        _notes = notes
        _isCompleted = isCompleted
    }
    
    var name : String {
        get {
            return _name
        }
    }
    
    var notes: String {
        return _notes
    }
    
    var isCompleted: Bool {
        return _isCompleted
    }
}
