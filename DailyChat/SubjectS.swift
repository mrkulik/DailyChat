//
//  SubjectS.swift
//  DailyChat
//
//  Created by Gleb Kulik on 8/11/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class SubjectS {
    
    private var _id = ""
    private var _name = ""
    private var _notes = ""
    private var _labs = [LabS]()
    
    init(id: String, name: String, notes: String, labs: Array<Any>) {
        _id = id
        _name = name
        _notes = notes
        _labs = labs as! [LabS]
    }
    
    var id: String {
        return _id
    }
    
    var name : String {
        get {
            return _name
        }
    }
    
    var group: String {
        return _notes
    }
    
    var labs: Array<Any> {
        return _labs
    }
}
