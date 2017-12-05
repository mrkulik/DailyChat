//
//  LabsViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 6/14/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseStorage

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class LabsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var senderDisplayName : String?
    var senderGroupNumber : String?
    
    var userID: String?
    
    var selectedSubject : Subject!
    var todoLabs : Results<Lab>!
    var completedLabs : Results<Lab>!
    var currentCreateAction:UIAlertAction!
    var subjectsRef: DatabaseReference = Database.database().reference().child("subjects")
    var questionRef: DatabaseReference = Database.database().reference().child("questions")
    var profileRef: DatabaseReference = Database.database().reference().child("settings").child("profile")
    private var profileHandle: DatabaseHandle?
    var isEditingMode = false
    
    @IBOutlet weak var labsTableView: UITableView!
    override func viewDidLoad() {
        self.userID = AuthProvider.Instance.userID()
        self.profileHandle = self.profileRef.child(userID!).observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            self.senderGroupNumber = data["groupID"] as? String
            self.senderDisplayName = data["name"] as? String
        })
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton;
        
        super.viewDidLoad()
        self.title = selectedSubject.name
        readLabsAndUpateUI()
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClickOnAddLab(_ sender: UIBarButtonItem) {
        self.displayAlertToAddLab(nil)
    }
    
    func readLabsAndUpateUI(){
        
        completedLabs = self.selectedSubject.labs.filter("isCompleted = true")
        todoLabs = self.selectedSubject.labs.filter("isCompleted = false")
        
        self.labsTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return todoLabs.count
        }
        return completedLabs.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "TODO LABS"
        }
        return "COMPLETED LABS"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var task: Lab!
        if indexPath.section == 0{
            task = todoLabs[indexPath.row]
        }
        else{
            task = completedLabs[indexPath.row]
        }
        
        cell?.textLabel?.text = task.name
        return cell!
    }
    
    func displayAlertToAddLab(_ updatedLab:Lab!){
        
        let userID = AuthProvider.Instance.userID()
        
        var title = "New Lab"
        var doneTitle = "Create"
        if updatedLab != nil{
            title = "Update Lab"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name and description of your lab.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let labName = alertController.textFields?[0].text
            let labNotes = alertController.textFields?[1].text
            
            if updatedLab != nil{
                try! dlRealm.write{
                    updatedLab.name = labName!
                    updatedLab.notes = labNotes!
                    self.readLabsAndUpateUI()
                }
            }
            else{
                
                let newLab = Lab()
                newLab.name = labName!
                newLab.notes = labNotes!
                
                try! dlRealm.write{
                    
                    self.selectedSubject.labs.append(newLab)
                    self.readLabsAndUpateUI()
                }
            }
            
            let newLabsRef = self.subjectsRef.child(userID).child(self.selectedSubject.name).child(labName!)
            let labItem = [
                "name": labName,
                "note": labNotes
                ]
            newLabsRef.setValue(labItem)
            print(labName ?? "")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Lab Name"
            textField.addTarget(self, action: #selector(LabsViewController.labNameFieldDidChange(_:)) , for: UIControlEvents.editingChanged)
            if updatedLab != nil{
                textField.text = updatedLab.name
            }
        }
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Lab description"
            textField.addTarget(self, action: #selector(LabsViewController.labNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedLab != nil{
                textField.text = updatedLab.notes
            }
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

    func labNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = textField.text?.characters.count > 0
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{1F5D1}") { (deleteAction, indexPath) -> Void in
            
            var labToBeDeleted: Lab!
            if indexPath.section == 0{
                labToBeDeleted = self.todoLabs[indexPath.row]
            }
            else{
                labToBeDeleted = self.completedLabs[indexPath.row]
            }
            
            try! dlRealm.write{
                dlRealm.delete(labToBeDeleted)
                self.readLabsAndUpateUI()
            }
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{2026}") { (editAction, indexPath) -> Void in
            
            self.isEditingMode = !self.isEditingMode
            self.labsTableView.setEditing(self.isEditingMode, animated: true)
            var labToBeUpdated: Lab!
            if indexPath.section == 0{
                labToBeUpdated = self.todoLabs[indexPath.row]
            }
            else{
                labToBeUpdated = self.completedLabs[indexPath.row]
            }
            
            self.displayAlertToAddLab(labToBeUpdated)
            
        }
        
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{2713}") { (doneAction, indexPath) -> Void in
            
            var labToBeUpdated: Lab!
            if indexPath.section == 0{
                labToBeUpdated = self.todoLabs[indexPath.row]
                try! dlRealm.write{
                    labToBeUpdated.isCompleted = true
                    self.readLabsAndUpateUI()
                }
            }
            else{
                labToBeUpdated = self.completedLabs[indexPath.row]
                try! dlRealm.write{
                    labToBeUpdated.isCompleted = false
                    self.readLabsAndUpateUI()
                }
            }
            
        }
        
        let questionAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "\u{2754}") { (questionAction, indexPath) -> Void in
            let newQuestionRef = self.questionRef.childByAutoId()
            let questionItem = [
                "subject_name": self.selectedSubject.name,
                "user": self.userID!,
                "solved": false,
                "lab_name": self.todoLabs[indexPath.row].name,
                "group": self.senderGroupNumber!,
                ] as [String : Any]
            newQuestionRef.setValue(questionItem)
        }
        return [deleteAction, editAction, doneAction, questionAction]
    }
    
}
