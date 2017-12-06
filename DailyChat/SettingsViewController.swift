//
//  SettingsViewController.swift
//  DailyChat
//
//  Created by Mikhail Lyapich on 12/6/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import RealmSwift
import SWXMLHash

struct Person {
    var lastName: String
    var name: String
    var group: String
}

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    private var person: Person?
    private var profileRef: DatabaseReference = Database.database().reference().child("settings").child("profile")
    private var profileHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        let userID = AuthProvider.Instance.userID()
        profileHandle = profileRef.child(userID).observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            let group = (data["groupID"] as? String) ?? ""
            let name = (data["name"] as? String) ?? ""
            let lastName = (data["lastName"] as? String) ?? ""
            self.nameLabel.text = "\(name) \(lastName)"
            self.groupLabel.text = "Group \(group)"
            self.person = Person(lastName: lastName, name: name, group: group)
        })
        super.viewDidLoad()
    }
}
