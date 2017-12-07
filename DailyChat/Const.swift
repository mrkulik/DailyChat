//
//  Const.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/20/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import UIKit

class Const {
    
    /*
        AuthProvider
     */
    static let INVALID_EMAIL = "Invalid Email.";
    static let WRONG_PASSWORD = "Wrong Password.";
    static let USER_NOT_FOUND = "User not found. Please, Register"
    static let WEAK_PASSWORD = "Weak Password. Password should be at least 6 characters long."
    static let EMAIL_ALREADY_IN_USE = "Invalid Email. This email already in use."
    static let CONNECTING_PROBLEMS = "Problems with connecting."
    
    /*
        LogViewController
     */
    static let CONTACTS_SEGUE = "ContactsSegue"
    static let OK = "OK"
    static let AUTH_ERROR = "Problem with Authentification"
    static let LOGGED_IN = "Logged in"
    static let EMAIL_PASSWORD_REQUIRE = "Email and Password required."
    static let REQUIRE_MESSAGE = "Please enter Email and Password"
    static let PROBLEM_WITH_CREATE = "Problem with creating a new user"
    static let CREATED = "New user created"
    
    /*
        DBProvider
     */
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
    
    /*
        ContactsViewController
     */
    static let GLOBAL_SEGUE = "GlobalSegue"
    static let CELL_ID = "Cell"
    static let CHAT_SEGUE = "ChatSegue"
    
    /*
        ChatViewController
     */
    static let PROFILE_IMG = "ProfileImg"
    static let MEDIA_SELECT = "Please select a media"
    static let CANCEL = "Cancel"
    
    /*
        ChannelListVC
     */
    static let CHANNEL_LIST_SEGUE = "ChannelListSegue"
    static let GROUP_SEGUE = "groupLoginSegue"
    
    /*
        TabBarVC
     */
    static let TAB_SEGUE = "TabBarSegue"
    static let SET_SEGUE = "settingsSegue"
    static let SET_TO_TAB = "setToTab"
    
    /*
        SettingsVC
     */
    static let GROUP_API_URL = "https://students.bsuir.by/api/v1/studentGroup/schedule?studentGroup="
    
    struct Colors {
        static let cyan = UIColor(red: 30 / 255.0,
                                  green: 180 / 255.0,
                                  blue: 226 / 255.0,
                                  alpha: 1)
        
    }
}
