//
//  ViewController.swift
//  SnapList
//
//  Created by Aamir  on 08/05/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit

let PADDING_13:CGFloat = 13.0

class ViewController: UIViewController {

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var addListButton:UIButton!
    @IBOutlet weak var joinListButton:UIButton!
    var joinListVC:SNJoinListViewController?
    
    @IBAction func didTapAddListButton() {
        // Make create API call here
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapJoinListButton() {
        joinListVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNJoinListViewController") as? SNJoinListViewController
        
        if let vc = joinListVC {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
}

