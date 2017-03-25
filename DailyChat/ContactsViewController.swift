//
//  ContactsViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/9/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController {

    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func global(_ sender: Any) {
        self.performSegue(withIdentifier: Const.GLOBAL_SEGUE, sender: nil)
    }
}
