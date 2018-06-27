//
//  SubjectsViewController.swift
//  DailyChat
//
//  Created by Gleb Kulik on 6/14/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import UIKit
import RealmSwift
import SWXMLHash

class SubjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataRecieveProtocol {
    
    @IBOutlet weak var subjectsTableView: UITableView!
    
    var subjects : Results<Subject>! {
        didSet {
            self.subjectsTableView.setEditing(false, animated: true)
            self.subjectsTableView.reloadData()
        }
    }
    
    var subjectsNames = Set<String>()
    var isEditingMode = false
    var currentCreateAction:UIAlertAction!
    var groupsToID = [String:String]()
    var selectedSubject : Subject!
    static let studentGroupsURL = URL(string: "https://www.bsuir.by/schedule/rest/studentGroup")!
    static let scheduleURL = URL(string: "https://www.bsuir.by/schedule/rest/schedule")!
    let downloadCanceledNotification = Notification.Name(rawValue: "downloadCanceled")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readSubjectsAndUpdateUI()
    }
    
    func readSubjectsAndUpdateUI(){
        subjects = dlRealm.objects(Subject.self)
        self.subjectsTableView.setEditing(false, animated: true)
        self.subjectsTableView.reloadData()
    }
    
    //NEED TO WRITE OBSERVER FOR FB(NOW ONLY LOCAL OBSERVER)
    
    @IBAction func didClickOnAddButton(_ sender: UIBarButtonItem) {
        
        displayAlertToAddSubject(nil)
    }
    
    func subjectNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func displayAlertToAddSubject(_ updatedSubject:Subject!){
        
        var title = "New subject"
        var doneTitle = "Create"
        if updatedSubject != nil{
            title = "Update subject"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name and description of your subject.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let subjectName = alertController.textFields![0].text
            let subjectNote = alertController.textFields![1].text
            if updatedSubject != nil{
                try! dlRealm.write {
                    updatedSubject.name = subjectName!
                    updatedSubject.notes = subjectNote!
                    self.readSubjectsAndUpdateUI()
                }
            }
            else{
                
                let newSubject = Subject()
                newSubject.name = subjectName!
                newSubject.notes = subjectNote!
                try! dlRealm.write{
                    
                    dlRealm.add(newSubject)
                    self.readSubjectsAndUpdateUI()
                }
            }
            
            print(subjectName ?? "")
            print(subjectNote ?? "")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Subject name"
            textField.addTarget(self, action: #selector(SubjectsViewController.subjectNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedSubject != nil{
                textField.text = updatedSubject.name
            }
        }
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Subject description"
            textField.addTarget(self, action: #selector(SubjectsViewController.subjectNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedSubject != nil{
                textField.text = updatedSubject.notes
            }
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let listsTasks = subjects {
            return listsTasks.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")
        
        let list = subjects[indexPath.row]
        
        cell?.textLabel?.text = list.name
        cell?.detailTextLabel?.text = "\(list.labs.count) Labs "
        return cell!
    }

    //USER PERMISSION TO DELETE AND UPDATE SUBJECTS(DISBANDED)
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            let listToBeDeleted = self.subjects[indexPath.row]
            try! dlRealm.write{
                
                dlRealm.delete(listToBeDeleted)
                self.readSubjectsAndUpdateUI()
            }
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            self.isEditingMode = !self.isEditingMode
            self.subjectsTableView.setEditing(self.isEditingMode, animated: true)
            // Editing will go here
            let listToBeUpdated = self.subjects[indexPath.row]
            self.displayAlertToAddSubject(listToBeUpdated)
            
        }
        //return [deleteAction, editAction]
    }*/
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openLabs", sender: self.subjects[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVc = segue.destination as! UINavigationController
        let labsViewController = navVc.viewControllers.first as! LabsViewController
        labsViewController.selectedSubject = sender as! Subject
        labsViewController.delegate = self
    }
    
    func dataRecieved(data: String) {
        print(data)
    }
    
}
