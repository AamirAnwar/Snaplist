//
//  SNHelpers.swift
//  SnapList
//
//  Created by Aamir  on 02/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation

// A namespace for storing common type methods specific to this program
enum SNHelpers {
    static func showFailureDropdown() {
        SNHelpers.showDropdownWith(message:KFailureMessage)
    }
    
    static func showDropdownWith(message msg:String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:NotificationDisplayDropdown), object: nil, userInfo: ["message":msg])
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: KeyListID)
        UserDefaults.standard.removeObject(forKey: KeyUserID)
    }
    
    static func isUserLoggedIn() -> Bool {
        let userID = UserDefaults.standard.object(forKey: KeyUserID)
        let listID = UserDefaults.standard.object(forKey: KeyListID)
        if (userID == nil || listID == nil) {
            return false
        }
        return true
    }
}

