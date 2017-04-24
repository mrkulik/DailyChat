//
//  MessagesHandler.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/24/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class MessagesHandler {
    
    private static let _instance = MessagesHandler()
    private init() {}
    
    static var Instance: MessagesHandler {
        return _instance
    }
    
}
