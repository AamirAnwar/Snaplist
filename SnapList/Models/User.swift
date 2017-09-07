//
//  User.swift
//  SnapList
//
//  Created by Aamir  on 07/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation

class User:SNObject {
    let userID:String
    init(withUserID userID:String) {
        self.userID = userID
    }
}
