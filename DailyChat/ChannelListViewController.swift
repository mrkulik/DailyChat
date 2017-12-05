//
//  GlobalViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/23/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase
import SWXMLHash

class ChannelListViewController: UITableViewController {
    
    var senderDisplayName : String?
    var senderGroupNumber : String?
    
    private var channelRefHandle: DatabaseHandle?
    private var profileHandle: DatabaseHandle?
    private var channels: [Channel] = []
    private var channelNames: [String] = []
    static let studentGroupsURL = URL(string: "https://www.bsuir.by/schedule/rest/studentGroup")!
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    var profileRef: DatabaseReference = Database.database().reference().child("settings").child("profile")
    
    var groupsToID = [String:String]()
    var subjectsNames = Set<String>()
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    
    override func viewDidLoad() {

        observeChannels()
        
        super.viewDidLoad()

        title = "Channels"
    }

    private func observeChannels() {
        let userID = AuthProvider.Instance.userID()
        profileHandle = profileRef.child(userID).observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            self.senderGroupNumber = data["groupID"] as? String
            self.senderDisplayName = data["name"] as? String
        })
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let name = channelData["name"] as! String!
            var group = channelData["group"] as! String!
            if (name?.characters.count)! > 0 && (group?.characters.count)! > 0{
                if group == self.senderGroupNumber {
                    self.channels.append(Channel(id: id, name: name!, group: group!))
                    self.tableView.reloadData()
                }
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let channel = sender as? Channel {
            let navVc = segue.destination as! UINavigationController
            let chatVc = navVc.viewControllers.first as! ChannelViewController

            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }
    
}

