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
    var senderDisplayName: String?
    var groupsToID = [String:String]()
    var senderGroupNumber = "453503"
    var subjectsNames = Set<String>()
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    private var channels: [Channel] = []
    private var channelNames: [String] = []
    static let studentGroupsURL = URL(string: "https://www.bsuir.by/schedule/rest/studentGroup")!
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    var channelRef: DatabaseReference = Database.database().reference().child("channels")
    var settingsRef: DatabaseReference = Database.database().reference().child("settings")
    var subjects : Results<Subject>!
    
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        if groupTextField.text != nil {
            let userID = AuthProvider.Instance.userID()
            let newSettingsRef = settingsRef.child("profile").child(userID)
            let settingsItem = [
                "name": nameTextField.text,
                "groupID": groupTextField.text
            ]
            newSettingsRef.setValue(settingsItem)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelDownload),
                                               name: downloadCanceledNotification,
                                               object: nil)
        
        observeChannels()
        
        startDownload()
        
        performSegue(withIdentifier: Const.SET_TO_TAB, sender: nil)
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func startDownload() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Splash") {
            present(vc, animated: false)
            XMLFetcher.fetch(from: ChannelListViewController.studentGroupsURL) { xml in
                self.groupsToID = BSUIRXMLParser.parseGroupsID(xml)
                XMLFetcher.fetch(from: ChannelListViewController.scheduleURL.appendingPathComponent(self.groupsToID[self.senderGroupNumber] ?? "")) { xml in
                    self.subjectsNames = BSUIRXMLParser.parseSubjects(xml)
                    NotificationCenter.default.post(Notification(name: self.downloadCanceledNotification))
                }
            }
        }
    }
    
    func cancelDownload() {
        DispatchQueue.main.sync {
            
            for name in subjectsNames {
                let item = Channel(id: "0", name: name)
                if channels.contains( where: {$0.name == item.name} ) {
                    continue
                } else {
                    let newChannelRef = channelRef.childByAutoId()
                    let channelItem = [
                        "name": name
                    ]
                    newChannelRef.setValue(channelItem)
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
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
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
