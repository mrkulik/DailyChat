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
    
    //for test Realm only
    dynamic var name = ""
    dynamic var notes = ""
    let labs = List<Lab>()
    
}
