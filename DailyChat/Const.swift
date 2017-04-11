//
//  Const.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/20/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation

class Const {
    
    //AuthProvider
    static let INVALID_EMAIL = "Invalid Email.";
    static let WRONG_PASSWORD = "Wrong Password.";
    static let USER_NOT_FOUND = "User not found. Please, Register"
    static let WEAK_PASSWORD = "Weak Password. Password should be at least 6 characters long."
    static let EMAIL_ALREADY_IN_USE = "Invalid Email. This email already in use."
    static let CONNECTING_PROBLEMS = "Problems with connecting."
    
    //LogViewController
    static let CONTACTS_SEGUE = "ContactsSegue"
    static let OK = "OK"
    static let AUTH_ERROR = "Problem with Authentification"
    static let LOGGED_IN = "Logged in"
    static let EMAIL_PASSWORD_REQUIRE = "Email and Password required."
    static let REQUIRE_MESSAGE = "Please enter Email and Password"
    static let PROBLEM_WITH_CREATE = "Problem with creating a new user"
    static let CREATED = "New user created"
    
    //DBProvider
    static let CONSTACTS = "Contacts"
    static let MESSAGES = "Messages"
    static let MEDIA_MESSAGES = "Media_Messages"
    static let IMAGE_STORAGE = "Image_Storage"
    static let VIDEO_STORAGE = "Video_Storage"
    
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let DATA = "data"
    
    static let TEXT = "Text"
    static let SENDER_ID = "sender_id"
    static let SENDER_NAME = "sender_name"
    static let URL = "url"
    
    static let STORAGE_URL = "gs://dailychat-448df.appspot.com"
    
    //ContactsViewController
    static let GLOBAL_SEGUE = "GlobalSegue"
    static let CELL_ID = "Cell"
    
}
