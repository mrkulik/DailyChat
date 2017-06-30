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

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class ChannelListViewController: UITableViewController {
    
    // MARK: Properties
    var senderDisplayName = "Gleb"
    var senderGroupNumber = "453503"
    var newChannelTextField: UITextField?
    
    private var channelRefHandle: DatabaseHandle?
    private var channels: [Channel] = []
    private var channelNames: [String] = []
    static let studentGroupsURL = URL(string: "https://www.bsuir.by/schedule/rest/studentGroup")!
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    
    var groupsToID = [String:String]()
    var subjectsNames = Set<String>()
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cancelDownload),
                                               name: downloadCanceledNotification,
                                               object: nil)
        //startDownload()
        
        observeChannels()
        
        super.viewDidLoad()
        
        
      /*  let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)*/
        
        title = "Channels"
    }
    
  /*  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                self.performSegue(withIdentifier: "privateSegue", sender: self)
            
            default:
                break
            }
        }
    }*/
    
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
                let item = Channel(id: "0", name: name, group: senderGroupNumber)
                if channels.contains( where: {$0.name == item.name && $0.group == item.group} ) {
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK :Actions
    
    @IBAction func createChannel(_ sender: AnyObject) {
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name,
                "group": senderGroupNumber
            ]
            newChannelRef.setValue(channelItem)
        }
    }
    
    // MARK: Firebase related methods
    
    private func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name, group: self.senderGroupNumber))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    // MARK: Navigation
    
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
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
    }
    
    @IBAction func joinPrivateChat(_ sender: Any) {
        self.performSegue(withIdentifier: "privateSegue", sender: self)
    }
    
}

