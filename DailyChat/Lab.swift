//
//  Lab.swift
//  DailyChat
//
//  Created by Gleb Kulik on 6/14/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import RealmSwift

class Lab: Object {
    
    dynamic var name = ""
    dynamic var notes = ""
    dynamic var isCompleted = false
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
