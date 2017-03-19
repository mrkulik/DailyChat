//
//  DBProvider.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/19/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    private init() {}
    
    static var Instance: DBProvider {
        return _instance
    }
    
}
