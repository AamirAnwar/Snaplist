//
//  SNObject.swift
//  SnapList
//
//  Created by Aamir  on 07/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation

class SNObject:SNAPIManagerDelegate {
    
    func didRecieveResponseSuccessfully(responseDictionary: [String : Any]) {
        assert(true, "Delegate not implemented")
    }
    
    func didFailToRecieveResponse() {
        assert(true, "Delegate not implemented")
    }
}

