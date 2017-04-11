//
//  ContactsViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/9/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData {

    @IBOutlet weak var contactsTable: UITableView!
    
    private var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DBProvider.Instance.delegate = self
        
        DBProvider.Instance.getContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        
        contactsTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.CELL_ID, for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].name
        
        return cell
        
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func global(_ sender: Any) {
        self.performSegue(withIdentifier: Const.GLOBAL_SEGUE, sender: nil)
    }
}
