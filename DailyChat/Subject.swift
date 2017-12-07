//
//  Subject.swift
//  DailyChat
//
//  Created by Gleb Kulik on 6/14/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import RealmSwift

/*
 for test Realm only
 */

class Subject: Object {
    
    dynamic var name = ""
    dynamic var notes = ""
    let labs = List<Lab>()
    
}
