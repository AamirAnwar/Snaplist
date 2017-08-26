//
//  SNJoinListViewController.swift
//  SnapList
//
//  Created by Aamir  on 11/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNJoinListViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapJoinButton() {
        // Make API to join existing list
    }
}
