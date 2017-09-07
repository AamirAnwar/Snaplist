//
//  SignUpAPIObject.swift
//  SnapList
//
//  Created by Aamir  on 07/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
protocol SignUpAPIDelegate:class {
    func didSignupSuccessfully(withUser user:User)
    func didSignupFail()
}

class SignUpAPIObject:SNObject {
    private weak var delegate:SignUpAPIDelegate?
    
    static var endpoint: String {
        return  "\(basePath)/user"
    }

    func createUserWith(email:String, username name:String, password:String, delegate:SignUpAPIDelegate?) {
        guard email.isEmpty == false, name.isEmpty == false, password.isEmpty == false, let delegate = delegate else {
            return
        }
        self.delegate = delegate
        let params = ["name":name,"email":email,"password":password]
        SNAPIManager.sharedInstance.postRequest(withURL: SignUpAPIObject.endpoint, postParameters: params, delegate: self)
    }
    
    override func didRecieveResponseSuccessfully(responseDictionary: [String : Any]) {
        guard let userID = responseDictionary["id"] as? String else {
             let errorMessage = responseDictionary["err"] as? String
            SNHelpers.showDropdownWith(message: errorMessage ?? KFailureMessage)
            return
        }
        let user = User(withUserID: userID)
        delegate?.didSignupSuccessfully(withUser: user)
    }
    
    override func didFailToRecieveResponse() {
        delegate?.didSignupFail()
    }
}
