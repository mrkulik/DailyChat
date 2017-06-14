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

class SettingsViewController: UIViewController {

    var senderDisplayName: String?
    var settingsRef: DatabaseReference = Database.database().reference().child("settings")
    
    @IBOutlet weak var groupTextField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        if groupTextField.text != nil {
            let userID = AuthProvider.Instance.userID()
            let newSettingsRef = settingsRef.child("profile").child(userID)
            let settingsItem = [
                "name": 
                "surname":
                "groupID": groupTextField.text
            ]
            newSettingsRef.setValue(settingsItem)
        }
        performSegue(withIdentifier: Const.SET_TO_TAB, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
