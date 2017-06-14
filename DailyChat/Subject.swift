//
//  Subject.swift
//  DailyChat
//
//  Created by Gleb Kulik on 6/14/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object {
    
    dynamic var name = ""
    dynamic var notes = ""
    let labs = List<Lab>()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
}

class SubjectJSON {
    var name = ""
    var notes = ""
    let labs = List<Lab>()
}
