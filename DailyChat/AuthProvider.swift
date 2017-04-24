//
//  AuthProvider.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/18/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void;

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    
    var userName = ""
    
    func logIn(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: {
            (user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }
            else {
                loginHandler?(nil)
            }
        });
    }//logIn func
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: {
            (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            } else {
                if user?.uid != nil {
                    //store user in database
                    DBProvider.Instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                    
                    //login the user
                    self.logIn(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
            }
        })
        
    }//signUp func
    
    func isLoggedIn() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            return true
        }
        
        return false
        
    }
    
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    }
    
    func userID() -> String {
        return FIRAuth.auth()!.currentUser!.uid
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            switch errCode {
             
            case .errorCodeWrongPassword:
                loginHandler?(Const.WRONG_PASSWORD);
                break;
                
            case .errorCodeUserNotFound:
                loginHandler?(Const.USER_NOT_FOUND);
                break;
                
            case .errorCodeInvalidEmail:
                loginHandler?(Const.INVALID_EMAIL);
                break;
                
            case .errorCodeWeakPassword:
                loginHandler?(Const.WEAK_PASSWORD);
                break;
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(Const.EMAIL_ALREADY_IN_USE);
                break;
            
            default:
                loginHandler?(Const.CONNECTING_PROBLEMS);
                break;
            }
        }
        
    }//error handler
}
