//
//  SNJoinListViewController.swift
//  SnapList
//
//  Created by Aamir  on 11/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

class SNJoinListViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 4

    }
    
    @IBAction func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapJoinButton() {
        // Make API to join existing list
        guard var listID = codeTextField.text else {
            return
        }
        listID = listID.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let userID = UserDefaults.standard.object(forKey: KeyUserID) {
            let joinListEndpoint = "\(basePath)/list/\(listID)/user"
            let params = ["userId":userID];
            Alamofire.request(joinListEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                guard response.result.isSuccess else {
                    SNHelpers.showDropdownWith(message: KFailureMessage)
                    return
                }
                guard let responseObject = response.result.value as? [String:Any] else {
                    SNHelpers.showDropdownWith(message: "Invalid list ID!")
                    return;
                }
                
                if let listID = responseObject["_id"] {
                    UserDefaults.standard.setValue(listID, forKey: KeyListID)
                    // Dismiss both presented view controller and update list view here
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
                }
                else {
                    if let errorMessage = responseObject["err"] as? String {
                        SNHelpers.showDropdownWith(message:errorMessage)
                    }
                    else {
                        SNHelpers.showDropdownWith(message: "Invalid list ID!")
                    }
                }
                
            }
        }
        else {
            SNHelpers.showDropdownWith(message: "No UserID!")
        }

    }
}
