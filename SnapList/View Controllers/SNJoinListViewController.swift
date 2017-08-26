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
        let joinListEndpoint = "\(basePath)/list/\(listID)/user"
        Alamofire.request(joinListEndpoint, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            guard response.result.isSuccess else {
                return
            }
            
            // Dismiss both presented view controller and update list view here
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationUserLoggedSuccessfully), object: nil)
        }
    }
}
