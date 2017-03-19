//
//  ViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 2/23/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogViewController: UIViewController {

    private let CONTACTS_SEGUE = "ContactsSegue"
    private let OK = "OK"
    private let AUTH_ERROR = "Problem with Authentification"
    private let LOGGED_IN = "Logged in"
    private let EMAIL_PASSWORD_REQUIRE = "Email and Password required."
    private let REQUIRE_MESSAGE = "Please enter Email and Password"
    private let PROBLEM_WITH_CREATE = "Problem with creating a new user"
    private let CREATED = "New user created"
    
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
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.logIn(withEmail: emailTextField.text! , password: passwordTextField.text! , loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: self.AUTH_ERROR, message: message!)
                } else {
                    print(self.LOGGED_IN)
                }
                
            })
            
        } else {
            alertTheUser(title: EMAIL_PASSWORD_REQUIRE, message: REQUIRE_MESSAGE)
        }
        
        //self.performSegue(withIdentifier: CONTACTS_SEGUE, sender: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: self.PROBLEM_WITH_CREATE, message: message!)
                } else
                {
                    print(self.CREATED)
                }
            })
            
        } else {
            alertTheUser(title: EMAIL_PASSWORD_REQUIRE, message: REQUIRE_MESSAGE)
        }
        
    }
    
    private func alertTheUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: OK, style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
}

