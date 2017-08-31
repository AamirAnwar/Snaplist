//
//  SNInviteViewController.swift
//  SnapList
//
//  Created by Aamir  on 11/07/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

class SNInviteViewController: UIViewController {

    @IBOutlet weak var shareCodeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareCodeLabel.text = UserDefaults.standard.value(forKey: KeyShareCode) as? String
    }
}
