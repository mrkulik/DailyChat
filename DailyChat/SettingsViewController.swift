//
//  GroupViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/30/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import RealmSwift
import SWXMLHash

class SettingsViewController: UIViewController, UITextFieldDelegate {

    private var channelRefHandle: DatabaseHandle?
    private var subjectsRefHandle: DatabaseHandle?
    var senderDisplayName: String?
    var groupsToID = [String:String]()
    var senderGroupNumber: String?
    var senderLastName: String?
    var subjectsNames = Set<String>()
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    private var channels: [Channel] = []
    private var channelNames: [String] = []
    static var studentGroupsURL =  "https://students.bsuir.by/api/v1/studentGroup/schedule?studentGroup="
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    var channelRef: DatabaseReference = Database.database().reference().child("channels")
    var settingsRef: DatabaseReference = Database.database().reference().child("settings")
    var subjectsRef: DatabaseReference = Database.database().reference().child("subjects")
    var subjects : Results<Subject>!
    var subjectS = [SubjectS]()
    
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        senderDisplayName = nameTextField.text
        senderLastName = lastName.text
        senderGroupNumber = groupTextField.text
        if senderGroupNumber != nil {
            let userID = AuthProvider.Instance.userID()
            let newSettingsRef = settingsRef.child("profile").child(userID)
            let settingsItem = [
                "name": nameTextField.text,
                "lastName": lastName.text,
                "groupID": groupTextField.text
            ]
            newSettingsRef.setValue(settingsItem)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(cancelDownload),
                                                   name: downloadCanceledNotification,
                                                   object: nil)
            // For Tests only!
            try! dlRealm.write {
                dlRealm.deleteAll()
            }
            
            observeChannels()
            
            startDownload()
            
            performSegue(withIdentifier: Const.SET_TO_TAB, sender: nil)
        }
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
        if let srefHandle = subjectsRefHandle {
            subjectsRef.removeObserver(withHandle: srefHandle)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func startDownload() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Splash") {
            present(vc, animated: false)
            XMLFetcher.fetch(from: URL(string: SettingsViewController.studentGroupsURL + groupTextField.text!)! ) { xml in
                self.subjectsNames = BSUIRXMLParser.parseSubjects(xml)
                NotificationCenter.default.post(Notification(name: self.downloadCanceledNotification))
            }
        }
    }
    
    func cancelDownload() {
        DispatchQueue.main.sync {
            
            for name in subjectsNames {
                if channels.contains( where: {$0.name == name && $0.group == groupTextField.text} ) {
                    continue
                } else {
                    let newChannelRef = channelRef.childByAutoId()
                    let channelItem = [
                        "name": name,
                        "group": senderGroupNumber
                    ]
                    newChannelRef.setValue(channelItem)
                }
            }

            for name in subjectsNames {
                let userID = AuthProvider.Instance.userID()
                let newSubjectsRef = subjectsRef.child(userID).child(name)
                if subjectS.contains( where: {$0.name == name} ) {
                    continue
                } else {
                    let subjectItem = [
                        "name": name,
                    ]
                    newSubjectsRef.setValue(subjectItem)
                }
            }
            
            try? dlRealm.write {
                for name in subjectsNames {
                    subjects = dlRealm.objects(Subject.self)
                    let item = Subject()
                    item.name = name
                    if subjects.contains( where: {$0.name == item.name} ) {
                        continue
                    } else {
                        let subj = Subject()
                        subj.name = name
                        dlRealm.add(subj)
                    }
                }
                subjects = dlRealm.objects(Subject.self)
            }
            
            subjects = dlRealm.objects(Subject.self)
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let name = channelData["name"] as! String!
            var group = channelData["group"] as! String!
            if (name?.characters.count)! > 0 && (group?.characters.count)! > 0{
                if group == self.groupTextField.text {
                    self.channels.append(Channel(id: id, name: name!, group: group!))
                }
            } else {
                print("Error! Could not decode channel data")
            }
        })
        
        let userID = AuthProvider.Instance.userID()
        subjectsRefHandle = subjectsRef.child(userID).observe(.childAdded, with: { (snapshot) -> Void in
            let subjectsData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let name = subjectsData["name"] as! String!
            if (name?.characters.count)! > 0{
                self.subjectS.append(SubjectS(id: id, name: name!, notes: "", labs: []))
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.lastName.delegate = self
        self.groupTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
}
