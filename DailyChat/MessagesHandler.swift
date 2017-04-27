//
//  MessagesHandler.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/24/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageRecievedDelegate: class {
    
    func messageRecieved(senderID: String, senderName: String, text: String)
    
}

class MessagesHandler {
    
    private static let _instance = MessagesHandler()
    private init() {}
    
    weak var delegate: MessageRecievedDelegate?
    
    static var Instance: MessagesHandler {
        return _instance
    }
    
    func sendMessage (senderID: String, senderName: String, text: String) {
        
        let data: Dictionary<String, Any> = [Const.SENDER_ID: senderID, Const.SENDER_NAME: senderName, Const.TEXT: text]
        
        DBProvider.Instance.messagesRef.childByAutoId().setValue(data)
    }
    
    func observeMessages() {
        DBProvider.Instance.messagesRef.observe(FIRDataEventType.childAdded) {
            (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                if let senderID = data[Const.SENDER_ID] as? String {
                    
                    if let senderName = data[Const.SENDER_NAME] as? String {
                        
                        if let text = data[Const.TEXT] as? String {
                            self.delegate?.messageRecieved(senderID: senderID, senderName: senderName, text: text)
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}
