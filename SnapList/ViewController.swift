//
//  ViewController.swift
//  SnapList
//
//  Created by Aamir  on 08/05/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import UIKit
import Alamofire

let kpadding13:CGFloat = 13.0
let basePath = "https://snaplist-server.herokuapp.com/api"
class ViewController: UIViewController {

    @IBOutlet weak var headingLabel:UILabel!
    @IBOutlet weak var addListButton:UIButton!
    @IBOutlet weak var joinListButton:UIButton!
    var joinListVC:SNJoinListViewController?
    
    @IBAction func didTapAddListButton() {
        // Make create API call here
      createList()
        
    //    self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapJoinListButton() {
        joinListVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SNJoinListViewController") as? SNJoinListViewController
        
        if let vc = joinListVC {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ViewController {
    func createList() {
        let params:Parameters = ["name":"aamir","email":"aamir.anwar@gmail.com","password":"aamir"]
        Alamofire.request("\(basePath)/user", method: .post, parameters: params).responseJSON { (response) in
            print(response)
        }
        
        
    }
}


