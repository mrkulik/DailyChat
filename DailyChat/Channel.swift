//
//  File.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/27/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

internal class Channel {
    internal let id: String
    internal let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
