//
//  DBProvider.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/19/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider {
    
    private static let _instance = DBProvider()
    
    private init() {}
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var contactsRef: FIRDatabaseReference {
        return dbRef.child(Const.CONSTACTS)
    }
    
    var messagesRef: FIRDatabaseReference {
        return dbRef.child(Const.MESSAGES)
    }
    
    var mediaMessagesRef: FIRDatabaseReference {
        return dbRef.child(Const.MEDIA_MESSAGES)
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: Const.STORAGE_URL)
    }
    
    var imageStorageRef: FIRStorageReference {
        return storageRef.child(Const.IMAGE_STORAGE)
    }
    
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Const.VIDEO_STORAGE)
    }
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Const.EMAIL: email, Const.PASSWORD: password]
        
        contactsRef.child(withID).setValue(data)
    }
    
    func getContacts() -> [Contact] {
        
        var contacts = [Contact]()
        
        contactsRef.observeSingleEvent(of: FIRDataEventType.value) {
            (snapshot: FIRDataSnapshot) in
            
            if let contactsDict = snapshot.value as? NSDictionary {
                for (key, value) in contactsDict {
                    if let contactsData = value as? NSDictionary {
                        if let email = contactsData[Const.EMAIL] as? String {
                            let id = key as! String
                            let newContact = Contact(id: id, name: email)
                            contacts.append(newContact)
                        }
                    }
                }
            }
        }
        return contacts
    }
}
