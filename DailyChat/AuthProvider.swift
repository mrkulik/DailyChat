//
//  AuthProvider.swift
//  DailyChat
//
//  Created by Gleb Kulik on 3/18/17.
//  Copyright © 2017 Gleb Kulik. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
}
