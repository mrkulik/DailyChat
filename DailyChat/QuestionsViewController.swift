//
//  QuestionsViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 10/21/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase

class QuestionsViewController: UITableViewController {

    // MARK: Properties
    var senderDisplayName : String?
    var senderGroupNumber : String?
    var userID: String?
    private var questionRefHandle: DatabaseHandle?
    private var profileHandle: DatabaseHandle?
    private var questions: [Channel] = []
    private var questionNames: [String] = []
    static let studentGroupsURL = URL(string: "https://www.bsuir.by/schedule/rest/studentGroup")!
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    private lazy var questionRef: DatabaseReference = Database.database().reference().child("questions")
    var profileRef: DatabaseReference = Database.database().reference().child("settings").child("profile")
    
    var groupsToID = [String:String]()
    var subjectsNames = Set<String>()
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        self.userID = AuthProvider.Instance.userID()
        profileHandle = profileRef.child(userID!).observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            self.senderGroupNumber = data["groupID"] as? String
            self.senderDisplayName = data["name"] as? String
        })
        
        observeChannels()
        
        super.viewDidLoad()
        
        title = "Questions"
    }
    
    // MARK: Firebase related methods
    
    private func observeChannels() {
        questionRefHandle = questionRef.observe(.childAdded, with: { (snapshot) -> Void in
            let questionData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let get_subj_name = questionData["subject_name"] as! String!
            let get_user = questionData["user"] as! String!
            let get_solved = questionData["solved"] as! Bool!
            let get_lab_name = questionData["lab_name"] as! String!
            let get_group = questionData["group"] as! String!
            if get_group == self.senderGroupNumber {
                self.questions.append(Channel(id: id, name: get_lab_name!, group: get_group!))
                self.tableView.reloadData()
            }
            else {
                print("Incorrect group!")
            }
        })
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let navVc = segue.destination as! UINavigationController
            let chatVc = navVc.viewControllers.first as! QuestionViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.questionRef = questionRef.child(channel.id)
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = questions[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = questions[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "ShowQuestion", sender: channel)
    }

}
