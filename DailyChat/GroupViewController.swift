//
//  GroupViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 4/30/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    var senderDisplayName: String?
    
    @IBOutlet weak var groupTextField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        performSegue(withIdentifier: Const.CHANNEL_LIST_SEGUE, sender: nil)
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
        let navVc = segue.destination as! UINavigationController
        let channelListVc = navVc.viewControllers.first as! ChannelListViewController
        
        channelListVc.senderGroupNumber = groupTextField?.text
        channelListVc.senderDisplayName = senderDisplayName
    }
}
