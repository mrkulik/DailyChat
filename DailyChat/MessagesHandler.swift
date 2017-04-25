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
    
    func sendMessage (senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = [Const.SENDER_ID: senderID, Const.SENDER_NAME: senderName, Const.TEXT: text]
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data)
    }
    
}
