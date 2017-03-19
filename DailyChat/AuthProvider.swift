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

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email.";
    static let WRONG_PASSWORD = "Wrong Password.";
    static let USER_NOT_FOUND = "User not found. Please, Register"
    static let WEAK_PASSWORD = "Weak Password. Password should be at least 6 characters long."
    static let EMAIL_ALREADY_IN_USE = "Invalid Email. This email already in use."
    static let CONNECTING_PROBLEMS = "Problems with connecting."
}

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    
    func logIn(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: {
            (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }
            else {
                loginHandler?(nil)
            }
        });
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            switch errCode {
             
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
                
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                break;
                
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
                
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
            
            default:
                loginHandler?(LoginErrorCode.CONNECTING_PROBLEMS);
                break;
            }
        }
        
    }
}
