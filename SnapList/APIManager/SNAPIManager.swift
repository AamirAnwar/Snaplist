//
//  SNAPIManager.swift
//  SnapList
//
//  Created by Aamir  on 07/09/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
import Alamofire
protocol SNAPIManagerDelegate:class {
    func didRecieveResponseSuccessfully(responseDictionary:[String:Any])
    func didFailToRecieveResponse()
}


final class SNAPIManager {
    static let sharedInstance = SNAPIManager()
    private init() {}
    
    func postRequest(withURL url:URLConvertible, postParameters params:[String:String]?, delegate:SNAPIManagerDelegate) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess, let responseObject = response.result.value as? [String:Any] else {
                delegate.didFailToRecieveResponse()
                return
            }
            delegate.didRecieveResponseSuccessfully(responseDictionary: responseObject)
        }
    }
}
