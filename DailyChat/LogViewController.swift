//
//  ViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 2/23/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    private let CONTACTS_SEGUE = "ContactsSegue"
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
    }

}

